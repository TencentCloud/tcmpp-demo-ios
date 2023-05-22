//
//  MIniAppDemoSDKDelegateImpl.h
//  TCMPPDemo
//
//  Created by 石磊 on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMFMiniAppSDKDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@interface MIniAppDemoSDKDelegateImpl : NSObject <TMFMiniAppSDKDelegate>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
