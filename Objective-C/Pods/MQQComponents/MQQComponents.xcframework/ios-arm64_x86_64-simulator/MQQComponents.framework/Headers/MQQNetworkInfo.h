//
//  MQQNetworkInfo.h
//  MQQSecure
//
//  Created by SparkChen on 13-4-17. (MQQNetworkManager)
//  Updated by klaudz on 3/28/16.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

// 网络类型
typedef NS_ENUM(NSInteger, MQQNetworkType) {
    MQQNetworkTypeNone = 0,  // 无网络
    MQQNetworkTypeWWAN = 1,  // 移动网络
    MQQNetworkTypeWiFi = 2,  // Wifi网络
};

extern NSString *const MQQNetworkInfoDidChangeNotification; // 网络变化通知

@interface MQQNetworkInfo : NSObject

/**
 * 获取当前网络类型
 */
+ (MQQNetworkType)currentNetworkType;

/**
 * 手动检查网络变化
 */
+ (void)checkNetworkIfChanged; // Manually

@end
