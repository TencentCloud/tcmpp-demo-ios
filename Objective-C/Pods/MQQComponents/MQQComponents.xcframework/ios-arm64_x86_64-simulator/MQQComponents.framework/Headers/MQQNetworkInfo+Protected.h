//
//  MQQNetworkInfo+Protected.h
//  MQQSecure
//
//  Created by klaudz on 3/28/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <MQQComponents/MQQNetworkInfo.h>
#import <MQQComponents/MQQNetworkInfo+WiFi.h>
#import <MQQComponents/MQQSecureReachability.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface MQQNetworkInfo (/* Protected */)
{
    MQQSecureReachability *_reachability;
#if TARGET_OS_IOS
    CTTelephonyNetworkInfo *_telephonyNetworkInfo;
#endif
}

@property(nonatomic,assign) MQQNetworkType cachedNetworkType;
@property(nonatomic,retain) MQQWiFiInfo *cachedWiFiInfo;

+ (instancetype)sharedInfo; // Protected
- (MQQSecureReachability *)reachability;

@end

@interface MQQNetworkInfo (Telephony_Protected)

- (CTTelephonyNetworkInfo *)telephonyNetworkInfo API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(macos);

@end
