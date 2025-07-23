//
//  ToastView.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/7/31.
//

#import "ToastView.h"
#import "TCMPPCommonTools.h"

@interface ToastView()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIWindow *toastWindow;

@end

@implementation ToastView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title {
    self = [super initWithFrame:CGRectMake(15, -64, [UIScreen mainScreen].bounds.size.width - 15 * 2, 64)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 4;
        
        _iconImageView = [[UIImageView alloc] initWithImage:icon];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor blackColor];
        
        [self addSubview:_iconImageView];
        [self addSubview:_titleLabel];
        
        // 设置布局
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [_iconImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
            [_iconImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_iconImageView.widthAnchor constraintEqualToConstant:30],
            [_iconImageView.heightAnchor constraintEqualToConstant:30],
            
            [_titleLabel.leadingAnchor constraintEqualToAnchor:_iconImageView.trailingAnchor constant:10],
            [_titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
            [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        ]];
    }
    return self;
}

- (void)showWithDuration:(CGFloat)duration {
    [self show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)show {
//    self.toastWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.toastWindow.windowLevel = UIWindowLevelStatusBar + 1;
//    self.toastWindow.backgroundColor = [UIColor clearColor];
    [UIApplication.sharedApplication.keyWindow.rootViewController.view addSubview:self];
//    [self.toastWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(15, 20 + [TCMPPCommonTools safeAreaInsets].top, [UIScreen mainScreen].bounds.size.width - 15 * 2, 64);
                     } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(15, -64, [UIScreen mainScreen].bounds.size.width - 15 * 2, 64);
                     } completion:^(BOOL finished) {
                         self.toastWindow.hidden = YES;
                         self.toastWindow = nil;
                     }];
}


@end
