//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;

@property (strong, nonatomic) NSNumber *originBounce;

@end

@implementation MJRefreshHeader
#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置key
    self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    
    // 设置高度
    self.mj_h = MJRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 正常情况下，bounces会在停止下拉刷新的时候还原（第三方业务调用）
    // 但是有可能因为网络问题，导致业务无法调用endpulldown，导致bounces无法还原
    // 所以这里还原下bounces
    if (self.originBounce) {
        self.scrollView.bounces = [self.originBounce boolValue];
    }
    
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        // 如果正在刷新状态，手动下滑-直接回到原始状态， 手动上滑-保持不变
        if (insetT >= self.mj_h + _scrollViewOriginalInset.top) { // 继续下拉
            insetT = self.mj_h + _scrollViewOriginalInset.top;
        } else if (insetT > 0) { // 下滑了
            self.state = MJRefreshStateIdle;
        }
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.mj_inset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
        
        
        // 恢复inset和offset。系统接口setContentOffset的animation太快，肉眼感受不到下拉刷新效果
        //  为了和微信的体验对齐，所以这里添加一个Delay, 显示一个下拉刷新效果。
        [self performSelector:@selector(resetContentOffset) withObject:nil afterDelay:MJRefreshFastAnimationDuration];
    } else if (state == MJRefreshStateRefreshing) {
        MJRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                    CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
                    
                    // 使用ContentInset这里的方案，会导致navigationBar和fixed元素跟着scrollview一起变化。
                    // 所以这里就不能更改ContentInset，只能设置ContentOffset。
                    // 只设置ContentOffset的话，当ContentOffset.y 是负值的时候，scrollview会自动回弹到(0, 0)
                    // 为了防止scrollview回弹，就设置bounces= NO，然后在停止刷新的时候，设置还原设置
                    self.originBounce = @(self.scrollView.bounces);
                    self.scrollView.bounces = NO;
                    
                    // 设置滚动位置
                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = -top;
                    // animated必须为YES，否则ContentOffset的时候navigationBar和fixed元素也是会跟着变化
                    [self.scrollView setContentOffset:offset animated:YES];
                }
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        })
    }
}

- (void)resetContentOffset
{
    // 下拉刷新的时候，bounces设置为NO了，刷新完成后，将bounces还原、将ContentOffse还原
    CGPoint offset = self.scrollView.contentOffset;
    offset.y = -self.scrollViewOriginalInset.top;
    [self.scrollView setContentOffset:offset animated:YES];
    
    if (self.originBounce) {
        self.scrollView.bounces = [self.originBounce boolValue];
    }
}

#pragma mark - 公共方法
- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

- (void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    
    self.mj_y = - self.mj_h - _ignoredScrollViewContentInsetTop;
}

@end
