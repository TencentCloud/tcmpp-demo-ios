//
//  MQQNetworkInfo+WiFi.h
//  MQQSecure
//
//  Created by klaudz on 3/28/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <MQQComponents/MQQNetworkInfo.h>

typedef NS_ENUM(NSInteger, MQQWiFiStatus) {
    MQQWiFiStatusDisconnected = 0, // Disconnected
    MQQWiFiStatusConnecting = 1, // Connecting
    MQQWiFiStatusConnected = 2, // Connected
};

@interface MQQWiFiInfo : NSObject

@property(nonatomic,copy)   NSString *SSID;
@property(nonatomic,copy)   NSString *BSSID;

@end


@interface MQQNetworkInfo (WiFi)

+ (MQQWiFiInfo *)currentWiFiInfo;

+ (MQQWiFiStatus)currentWiFiStatus;

+ (NSString *)localIPAddress;

+ (NSString *)broadcastIPAddress;

@end
