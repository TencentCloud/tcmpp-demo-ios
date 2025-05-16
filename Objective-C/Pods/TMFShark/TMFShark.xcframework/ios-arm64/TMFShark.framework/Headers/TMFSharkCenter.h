//
//  TMFSharkCenter.h
//  TMFShark
//
//  Created by klaudz on 20/4/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TMFShark/TMFSharkCenterConfiguration.h>

#import <TMFShark/TMFOCSharkCmdSettings.h>
#import <TMFShark/TMFSharkRequestHeaders.h>
#import <TMFShark/TMFSharkResponseHeaders.h>

#import <TMFShark/TMFSharkLogger.h>

#import <TMFShark/TMFSharkErrors.h>

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXPORT NSString *const TMFSharkCenterDidRegisterGUIDNotification;

@interface TMFSharkCenter : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithConfiguration:(TMFSharkCenterConfiguration *)configuration;

@property (nonatomic, retain, readonly) TMFSharkCenterConfiguration *configuration;

- (void)initialize;

- (NSString *)getStoreDirectory;

- (NSString *)getVersion;

#pragma mark GUID

@property (nonatomic, readonly, nullable) NSString *GUID;

typedef void (^TMFSharkGUIDCompletion)(NSString * _Nullable GUID, NSError * _Nullable error);

- (void)fetchGUID:(TMFSharkGUIDCompletion)completion;

- (void)updateGUID:(TMFSharkGUIDCompletion)completion;

#pragma mark VID

typedef void (^TMFSharkVIDCompletion)(NSString * _Nullable VID, NSError * _Nullable error);

- (void)fetchVID:(TMFSharkVIDCompletion)completion;

@end


@interface TMFSharkCenter (MasterCenter)

/*!
 * MasterCenter 单例，用于 App 的 Shark 主通道通信。
 *
 * @b【配置】
 *
 * 如果需要设置 MasterCenter 的配置，请在 App 进程启动后、首次调用 `+[TMFSharkCenter masterCenter]` 前，设置 `+[TMFSharkCenterConfiguration masterConfiguration]` 单例的相关配置属性。
 *
 * @b e.g.
 * @code
 *  // Initialize master configuration.
 *  TMFSharkCenterConfiguration *masterConfiguration = [TMFSharkCenterConfiguration masterConfiguration];
 *  masterConfiguration.productID = 1001;
 *  masterConfiguration.buildVersion = @"9.9";
 *  masterConfiguration.buildNumber = @"9999";
 *  masterConfiguration.LCString = @"ABCDEFGHIJKLMNOP";
 *  masterConfiguration.channelID = @"101006";
 *
 *  // Use master shark center to request data.
 *  [[TMFSharkCenter masterCenter] requestWithCmdID:cmdID requestObject:requestObject completionHandler:completionHandler];
 * @endcode
 *
 * @b【注意】
 *
 * 如果 SDK 需要使用 Shark 通道进行通信，请不要使用 MasterCenter，因为 SDK 有独立的 ProductID。
 * 此时，你需要自行配置 SDK 的 Configuration，并使用 `-[TMFSharkCenter initWithConfiguration:]` 初始化相应的 SharkCenter 实例。
 */
+ (instancetype)masterCenter;


- (BOOL)isNewMasterEnv;

- (void)resetGuid;
- (void)resetVid;

@end

typedef NSUInteger TMFSharkRequestIdentifier;
static const TMFSharkRequestIdentifier TMFSharkRequestIdentifierInvalid = 0;

@interface TMFSharkCenter (Operations)

#pragma mark Request

typedef void (^TMFSharkRequestMiniCompletionHandler) (__kindof TarsObject * _Nullable scObject, NSError * _Nullable error);
typedef void (^TMFSharkRequestTarsCompletionHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, __kindof TarsObject * _Nullable scObject, NSError * _Nullable error);
typedef void (^TMFSharkRequestDataCompletionHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, NSData * _Nullable responseData, NSError * _Nullable error);

- (TMFSharkRequestIdentifier)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings csObject:(nullable TarsObject *)csObject completionHandler:(nullable TMFSharkRequestMiniCompletionHandler)completionHandler;

- (TMFSharkRequestIdentifier)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings requestHeaders:(nullable TMFSharkRequestHeaders *)requestHeaders csObject:(nullable TarsObject *)csObject completionHandler:(nullable TMFSharkRequestTarsCompletionHandler)completionHandler;

- (TMFSharkRequestIdentifier)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings requestHeaders:(nullable TMFSharkRequestHeaders *)requestHeaders requestData:(nullable NSData *)requestData completionHandler:(nullable TMFSharkRequestDataCompletionHandler)completionHandler;

- (void)cancelRequest:(TMFSharkRequestIdentifier)requestIdentifier;

#pragma mark Push

typedef void (^TMFSharkObserveTarsHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, __kindof TarsObject * _Nullable scObject);
typedef void (^TMFSharkObserveDataHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, NSData * _Nullable responseData);

- (void)observePushWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings scObjectHandler:(TMFSharkObserveTarsHandler)scObjectHandler;

- (void)observePushWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings responseDataHandler:(TMFSharkObserveDataHandler)responseDataHandler;

@end

@class JceObject;

@interface TMFSharkCenter (Operations_Jce)

#pragma mark Request

typedef void (^TMFSharkRequestMiniJceCompletionHandler) (__kindof JceObject * _Nullable scObject, NSError * _Nullable error);

- (TMFSharkRequestIdentifier)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings csJceObject:(nullable JceObject *)csObject completionHandler:(nullable TMFSharkRequestMiniJceCompletionHandler)completionHandler;

#pragma mark Push

typedef void (^TMFSharkObserveJceHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, __kindof JceObject * _Nullable scObject);

- (void)observePushWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings scJceObjectHandler:(TMFSharkObserveJceHandler)scObjectHandler;

@end

NS_ASSUME_NONNULL_END
