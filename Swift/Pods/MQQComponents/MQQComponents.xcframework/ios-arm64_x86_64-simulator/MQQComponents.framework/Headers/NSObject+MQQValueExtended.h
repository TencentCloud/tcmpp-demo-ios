//
//  NSObject+MQQValueExtended.h
//  MQQSecure
//
//  Created by klaudz on 4/29/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * NSObject的取值扩展，
 * 当(id)self可以取得指定类型值时，返回指定类型值，
 * 否则返回defaultValue。
 *
 * 在以下场景中，保证值类型安全和取值安全：
 * 1. 读取Database数据
 * 2. 反序列化Data数据
 *      (如Plist、NSKeyedArchiver等)
 * 3. 反序列化JSON数据
 *      (如Push解析、JSBridge数据解析等)
 * 4. 反序列化XML数据
 * 5. ...
 */

FOUNDATION_EXPORT
NSNumber *MQQNumberValue(id object, NSNumber *defaultValue);
FOUNDATION_EXPORT
NSString *MQQStringValue(id object, NSString *defaultValue);
FOUNDATION_EXPORT
NSDictionary *MQQDictionaryValue(id object, NSDictionary *defaultValue);
FOUNDATION_EXPORT
NSArray *MQQArrayValue(id object, NSArray *defaultValue);
FOUNDATION_EXPORT
NSData *MQQDataValue(id object, NSData *defaultValue);

FOUNDATION_EXPORT
double MQQDoubleValue(id object, double defaultValue);
FOUNDATION_EXPORT
float MQQFloatValue(id object, float defaultValue);
FOUNDATION_EXPORT
int MQQIntValue(id object, int defaultValue);
FOUNDATION_EXPORT
NSInteger MQQIntegerValue(id object, NSInteger defaultValue);
FOUNDATION_EXPORT
long long MQQLongLongValue(id object, long long defaultValue);
FOUNDATION_EXPORT
BOOL MQQBoolValue(id object, BOOL defaultValue);

