//
//  TCMPPAddCardController.h
//  TUIKitDemo
//
//  Created by xcode on 2024/9/18.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TCMPPPayMethodCellModel;
@interface TCMPPAddCardController : UIViewController

@property (copy,nonatomic) void(^dismissBlock)(TCMPPPayMethodCellModel *model);
@end

NS_ASSUME_NONNULL_END
