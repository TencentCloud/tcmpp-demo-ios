//
//  DemoTableCell.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "DemoTableCell.h"
#import "DemoCollectionCell.h"
#import "TMFMiniAppSDKManager.h"

#define K_CELL @"cell"
@interface DemoTableCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat heightED;

@end

@implementation DemoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.heightED = 0;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height);
    }
    return self;
}

#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataAry.count == 0) {
        return 1;
    } else {
        return self.dataAry.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_CELL forIndexPath:indexPath];
    cell.appInfo = self.dataAry[indexPath.row];
    [self updateCollectionViewHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:withContent:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath withContent:((TMFMiniAppInfo *)self.dataAry[indexPath.row]).appId];
    }
}

- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.heightED != height) {
        self.heightED = height;
        self.collectionView.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, height);
        
        if (_delegate && [_delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:andIndexPath:)]) {
            [self.delegate updateTableViewCellHeight:self andheight:height andIndexPath:self.indexPath];
        }
    }
}

#pragma mark ====== init ======
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 50) / 4;
        layout.itemSize = CGSizeMake(width, 80);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[DemoCollectionCell class] forCellWithReuseIdentifier:K_CELL];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (void)setDataAry:(NSArray *)dataAry {
    [self.collectionView reloadData];
    self.heightED = 0;
    _dataAry = dataAry;
}

@end
