//
//  TCMPPDemoLoginManager.h
//  TUIKitDemo
//
//  Created by 石磊 on 2024/5/8.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^tcmppLoginRequestHandler)(NSError* _Nullable err,NSString* _Nullable value);


@interface TCMPPDemoLoginManager : NSObject
+ (instancetype)sharedInstance;

- (NSString *_Nullable)getToken;

- (void)login:(tcmppLoginRequestHandler _Nullable)completionHandler;

- (void)loginUser:(NSString *)userId completeion:(tcmppLoginRequestHandler _Nullable)completionHandler;

- (void)wxLogin:(NSString *)miniAppId completionHandler:(tcmppLoginRequestHandler _Nullable)completionHandler;

- (void)clearLoginInfo;
@end

NS_ASSUME_NONNULL_END
