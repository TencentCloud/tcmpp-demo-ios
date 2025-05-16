//
//  TMFProfileReporter.h
//  TMFDemo
//
//  Created by  bentonxiu on 2019/7/1.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMFProfile/TMFProfileDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class TMFProfileItem;
@class TMFSharkCenter;

/**
 *  Profile 上报中心 用于处理更新 + 上报
 */
@interface TMFProfileReporter : NSObject

@property (nonatomic, weak, readonly) TMFSharkCenter *usedSharkCenter;

+ (instancetype)defaultReporter;
- (instancetype)initWithTMFSharkCenter:(TMFSharkCenter *)sharkCenter;
- (void)initialize;

- (void)clearCacheData;
/**
 *  上报全部 Profile 内容
 *  
 *  @note 此上报是增量上报 根据对比状态来上报需要更新的内容
 */
- (void)reportIfNeeded;

@end

@interface TMFProfileReporter (Common)

- (void)updateProfileWithID:(TMFProfileID)profileID boolValue:(BOOL)boolValue;
- (void)updateProfileWithID:(TMFProfileID)profileID dataValue:(nullable NSData *)dataValue;
- (void)updateProfileWithID:(TMFProfileID)profileID stringValue:(nullable NSString *)stringValue;
- (void)updateProfileWithID:(TMFProfileID)profileID integerValue:(NSInteger)integerValue;
- (void)updateProfileWithID:(TMFProfileID)profileID intValue:(int)intValue;

@end

/**
 *  Profile 上报中心用户信息上报扩展 用于上报用户信息
 */
@interface TMFProfileReporter (UserInfo)

/**
 *  上报用户 user ID
 *
 *  @note  如果参数为空 则视为解绑
 *  @param customizedUserID 用户自定义 user ID
 */
- (void)updateCustomizedUserID:(nullable NSString *)customizedUserID;

/**
 *  上报用户远程推送 Token
 *
 *  @param deviceToken 用户远程推送 Token
 */
- (void)updateRemoteNotificationToken:(NSString *)deviceToken;

@end

/**
 *  Profile 上报中心自定义标签上报扩展 用于修改自定义标签
 */
@interface TMFProfileReporter (Tag)

/**
 *  实时上报回调
 *
 *  @param  error 本次上报错误信息 如果成功 则为 nil
 */
typedef void(^TMFProfileResponseHandler)(NSError * _Nullable error);

/**
 *  上报修改自定义标签
 *
 *  @note  `tagValue` 为空 则是删除当前标签
 *  @note  此接口是延迟上报 不会立刻回调 可以通过 `TMFProfileDidReportNotification` 捕获结果
 *  @note  如果选择此接口 则默认 SDK 自动管理上报重试流程
 *  @param tagKey   标签名
 *  @param tagValue 标签值
 */
- (void)updateCustomizedTagWithKey:(NSString *)tagKey value:(nullable NSString *)tagValue;

/**
 *  立刻上报自定义标签
 *
 *  @note  `tagValue` 为空 则是删除当前标签
 *  @note  由于此接口是立刻上报并回调 因此与 `-updateCustomizedTagWithKey:value:` 不通用 并不建议二者混用
 *  @note  如果选择此接口 则默认自行管理上报重试流程
 *  @param tagKey   标签名
 *  @param tagValue 标签值
 *  @param responseHandler  上报回调
 */
- (void)updateCustomizedTagWithKey:(NSString *)tagKey
                             value:(NSString *)tagValue
                   responseHandler:(TMFProfileResponseHandler)responseHandler;

@end


@interface TMFProfileReporter (Retrieve)

/**
 *  获取本地保存的全部 Profile 条目
 *  上报key会带有前缀，“tag_”标识标识自定义标签
 *  value如果是NSData类型，返回UTF8EncodingString
 *  @return 全部条目
 */
- (nullable NSDictionary<NSString *, NSString *> *)allProfileItemsDirectory;

/**
 *  获取全部已经上报的更新 Profile 条目
 *  @return 全部标记为已经上报的 Profile 条目
 */
- (nullable NSDictionary<NSString *, NSString *> *)updatedProfileItemsDirectory;

/**
 *  获取全部待上报的更新 Profile 条目
 *  @return 全部标记为待上报的 Profile 条目
 */
- (nullable NSDictionary<NSString *, NSString *> *)needProfileItemsDirectory;
@end


@interface TMFProfileReporter (Debug)

- (void)registerLogger:(TMFProfile_Logger)logger;

- (void)addLog:(TMFProfileLogLevel)logLevel fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message;

+ (NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END

