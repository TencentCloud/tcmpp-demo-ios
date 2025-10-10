//
//  TCMPPPaymentMethodsController.h
//  TUIKitDemo
//
//  Created by xcode on 2024/9/12.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TMFMiniAppInfo;
@class PayResponseData;
@interface TCMPPPaymentMethodsController : UIViewController
@property (nonatomic, assign) CGFloat totalFee;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, copy) NSString *prePayId;
@property (nonatomic, strong) TMFMiniAppInfo *app;
@property (nonatomic, strong) PayResponseData *payResponseData;
@property (nonatomic,copy) void (^completeHandle)(NSDictionary * _Nullable result, NSError * _Nullable error);
@end

NS_ASSUME_NONNULL_END
