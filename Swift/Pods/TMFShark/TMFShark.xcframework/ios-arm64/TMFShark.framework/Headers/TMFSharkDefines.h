//
//  TMFSharkDefines.h
//  TMFShark
//
//  Created by klaudz on 12/12/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMFSharkPlatform) {
    TMFSharkPlatformNone = 0,
    TMFSharkPlatformIOS = 3,
    TMFSharkPlatformMacOS = 11,
};

typedef NS_ENUM(NSInteger, TMFSharkSubplatform) {
    TMFSharkSubplatformNone = 0,
    TMFSharkSubplatformIPhone = 301,
    TMFSharkSubplatformIPad = 302,
    TMFSharkSubplatformIPod = 303,
    TMFSharkSubplatformMacOS = 1101,
};


///
///
/**
 *  组件内部调试日志等级
 */
typedef NS_OPTIONS(NSUInteger, TMFSharkLogLevel) {
    TMFSharkLogLevelNone  = 0,        ///< 无日志
    TMFSharkLogLevelDebug = 1,        ///< 调试日志
    TMFSharkLogLevelInfo  = 2,   ///< 普通日志
    TMFSharkLogLevelWarn  = 3,   ///< 警告日志
    TMFSharkLogLevelError = 4,   ///< 错误日志
};


/**
 @brief 用于输出SDK调试log的回调
 */
typedef void(*TMFShark_Logger)(int level, const char* fileName, int lineNumber, const char* funcName, NSString *message);


NS_ASSUME_NONNULL_END
