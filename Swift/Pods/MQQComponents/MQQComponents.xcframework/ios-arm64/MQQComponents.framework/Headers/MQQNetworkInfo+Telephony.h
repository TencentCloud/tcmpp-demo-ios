//
//  MQQNetworkInfo+Telephony.h
//  MQQSecure
//
//  Created by klaudz on 3/28/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <MQQComponents/MQQNetworkInfo.h>

// 移动网络制式
typedef NS_ENUM(NSInteger, MQQRATType) {
    MQQRATTypeUnknown       = -1,
    MQQRATTypeGPRS          = 0,
    MQQRATTypeEdge          = 1,
    MQQRATTypeWCDMA         = 2,
    MQQRATTypeHSDPA         = 3,
    MQQRATTypeHSUPA         = 4,
    MQQRATTypeCDMA1x        = 5,
    MQQRATTypeCDMAEVDORev0  = 6,
    MQQRATTypeCDMAEVDORevA  = 7,
    MQQRATTypeCDMAEVDORevB  = 8,
    MQQRATTypeeHRPD         = 9,
    MQQRATTypeLTE           = 10
};

// 移动通信技术
typedef NS_ENUM(NSInteger, MQQCNTType) {
    MQQCNTTypeUnknown       = 0,
    MQQCNTType1G            = 1,
    MQQCNTType2G            = 2,
    MQQCNTType3G            = 3,
    MQQCNTType4G            = 4,
    MQQCNTType5G            = 5,
};

@interface MQQNetworkInfo (Telephony)

+ (BOOL)supportsCurrentRadioAccessTechnology;

/**
 * 获取当前移动网络制式
 */
+ (MQQRATType)currentRadioAccessTechnology API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(macos);

/**
 * 获取当前移动通信技术
 */
+ (MQQCNTType)currentCellularNetworkTechnology API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(macos);

@end
