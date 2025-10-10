//
//  TCMPPPayMethodCell.m
//  TUIKitDemo
//
//  Created by xcode on 2024/9/12.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPPayMethodCell.h"

@implementation TCMPPPayMethodCellModel
@end

@interface TCMPPPayMethodCell ()
@property (nonatomic, assign) BOOL cellTypeHasBeenSet;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation TCMPPPayMethodCell

- (instancetype)init{
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}
- (void)setupViews {
    self.whiteBackgroundView = [[UIView alloc] init];
    self.whiteBackgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.contentView addSubview:self.whiteBackgroundView];

    self.leftImageView = [[UIImageView alloc] init];
    [self.whiteBackgroundView addSubview:self.leftImageView];

    self.leftTextLabel = [[UILabel alloc] init];
    self.leftTextLabel.font = [UIFont systemFontOfSize:14];
    self.leftTextLabel.textColor = [UIColor blackColor];
    [self.whiteBackgroundView addSubview:self.leftTextLabel];

    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.whiteBackgroundView addSubview:self.rightImageView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.whiteBackgroundView addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    self.whiteBackgroundView.frame = CGRectMake(10, 0, bounds.size.width - 20, bounds.size.height);
    UIImage *lftImg = self.leftImageView.image;
    self.leftImageView.frame = CGRectMake(10, (self.whiteBackgroundView.bounds.size.height - 20) / 2 + 5, lftImg.size.width * 0.5, lftImg.size.height * 0.5);
    self.leftTextLabel.frame = CGRectMake(50, 0, self.whiteBackgroundView.bounds.size.width - 70, self.whiteBackgroundView.bounds.size.height);
    self.rightImageView.frame = CGRectMake(self.whiteBackgroundView.bounds.size.width - 50, (self.whiteBackgroundView.bounds.size.height - 20) / 2, 20, 20);
    self.lineView.frame = CGRectMake(50, self.whiteBackgroundView.bounds.size.height - 1, self.whiteBackgroundView.bounds.size.width - 60, 0.5);
    
    if (_cellTypeHasBeenSet) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.whiteBackgroundView.bounds byRoundingCorners:(self.cellType == PayMethodCellTypeTop) ? (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10, 10)];

        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.whiteBackgroundView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.whiteBackgroundView.layer.mask = maskLayer;
        if (PayMethodCellTypeBottom == self.cellType) {
            self.lineView.hidden = YES;
        }
    }
}

- (void)setCellType:(PayMethodCellType)cellType {
    _cellType = cellType; 
    _cellTypeHasBeenSet = YES;
}

@end
