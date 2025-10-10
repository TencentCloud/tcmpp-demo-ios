//
//  TCMPPDemoPayManager.h
//  TUIKitDemo
//
//  Created by xcode on 2025/1/21.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PayResponseData;
typedef void (^tcmppChcekOrderHandler)(NSError *_Nullable err,PayResponseData *_Nullable result);
typedef void (^tcmppPayConfirmHandler)(NSError *_Nullable err,NSDictionary *_Nullable result);

@interface PayModel : NSObject
@property (nonatomic, copy) NSString *payModel;
@property (nonatomic, copy) NSString *payModelName;
@property (nonatomic, copy) NSString *payModelIcon;
@property (nonatomic, copy) NSString *payModelId;
@property (nonatomic, assign) double balance;
@end


@interface PayResponseData : NSObject
@property (nonatomic, copy) NSString *payId;
@property (nonatomic, assign) double actualAmount;
@property (nonatomic, strong) NSArray<PayModel *> *payModelList;

/// error
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@end

@interface TCMPPDemoPayManager : NSObject
+ (instancetype)sharedInstance;
- (void)checkPreOrder:(NSDictionary *)data
    completionHandler:(tcmppChcekOrderHandler _Nullable)completionHandler;

- (void)checkPayConfirm:(NSDictionary *)data
      completionHandler:(tcmppPayConfirmHandler _Nullable)completionHandler;
- (void)checkMiniGamePreOrder:(NSDictionary *)data
            completionHandler:(tcmppChcekOrderHandler _Nullable)completionHandler;
@end

NS_ASSUME_NONNULL_END
