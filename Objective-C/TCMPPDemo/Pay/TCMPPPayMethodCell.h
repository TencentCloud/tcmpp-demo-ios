//
//  TCMPPPayMethodCell.h
//  TUIKitDemo
//
//  Created by xcode on 2024/9/12.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, PayMethodCellType) {
    PayMethodCellTypeTop,
    PayMethodCellTypeBottom
};

@interface TCMPPPayMethodCellModel : NSObject
@property (copy, nonatomic) NSString *imgName;
@property (copy, nonatomic) NSString *payName;

@end

@interface TCMPPPayMethodCell : UITableViewCell

@property (strong, nonatomic) UIView *whiteBackgroundView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *leftTextLabel;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (nonatomic, assign) PayMethodCellType cellType;
@end

NS_ASSUME_NONNULL_END
