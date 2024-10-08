//
//  MiniAppDemoSDKDelegateImpl.h
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TCMPPSDK/TCMPPSDK.h>

NS_ASSUME_NONNULL_BEGIN
@interface MiniAppDemoSDKDelegateImpl : NSObject <TMFMiniAppSDKDelegate>

+ (instancetype)sharedInstance;

- (BOOL)noServer;

@end

NS_ASSUME_NONNULL_END
