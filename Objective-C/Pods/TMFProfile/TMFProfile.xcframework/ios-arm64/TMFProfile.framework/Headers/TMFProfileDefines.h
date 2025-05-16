//
//  TMFProfileDefines.h
//  TMF
//
//  Created by  bentonxiu on 2019/7/1.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TMFProfileDefination_h
#define TMFProfileDefination_h

extern NSString *const TMFProfileDidReportNotification; ///< Profile 上报结束通知
extern NSString *const TMFProfileDidReportItemsKey;     ///< 通知 userInfo key 用于获取当前上报的所有 Profile 条目 【字典】
extern NSString *const TMFProfileDidReportErrorKey;     ///< 通知 userInfo key 用于获取当前上报失败的错误信息 【字典】
extern NSString *const TMFProfileResetReportNotification; ///profile重置上报通知

/**
 *  Profile ID
 */
typedef NS_ENUM(NSInteger, TMFProfileID) {
    
    TMFProfileIDNone          = 0,      ///< 未知
    
    TMFProfileIDCountry       = 5001,   ///< 国家
    TMFProfileIDProvince      = 5002,   ///< 省份
    TMFProfileIDCity          = 5003,   ///< 城市
    
    TMFProfileIDDepartment    = 5004,   ///< 部门
    
    TMFProfileIDUserID        = 1033,   ///< 用户 UserID
    TMFProfileIDToken         = 10014,  ///< 远程推送 Token
};

/**
 *  组件内部调试日志等级
 */
typedef NS_OPTIONS(NSUInteger, TMFProfileLogLevel) {
    TMFProfileLogLevelNone  = 0,        ///< 无日志
    TMFProfileLogLevelDebug = 1,        ///< 调试日志
    TMFProfileLogLevelInfo  = 2,   ///< 普通日志
    TMFProfileLogLevelWarn  = 3,   ///< 警告日志
    TMFProfileLogLevelError = 4,   ///< 错误日志
};


/**
 @brief 用于输出SDK调试log的回调
 */
typedef void(*TMFProfile_Logger)(int level, const char* fileName, int lineNumber, const char* funcName, NSString *message);



#endif /* TMFProfileDefination_h */
