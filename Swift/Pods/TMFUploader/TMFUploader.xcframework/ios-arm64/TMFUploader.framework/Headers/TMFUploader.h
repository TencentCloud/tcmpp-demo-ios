//
//  TMFUpload.h
//  TMFUpload
//
//  Created by hauzhong on 2019/7/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define TMFUPLOAD_VERSION @"$Build_Version"

@class TMFSharkCenter;

#pragma mark - TMFUploadConfiguration

/**
 @brief 管理上传配置的业务标识，超时，网络等配置
 */
@interface TMFUploadConfiguration : NSObject <NSCopying>

/**
 @brief 获取默认上传配置的实例对象（内置特定的业务标识）
 
 @return 配置实例对象
 */
+ (TMFUploadConfiguration *)configuration;

/**
 @brief 上传请求的超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest;

/**
 @brief 是否允许通过蜂窝网络进行文件上传，默认允许(YES)
 */
@property (nonatomic, assign) BOOL allowsCellularAccess;

@end


#pragma mark - TMFUploadTask

/**
 @brief 上传任务状态
 
 - TMFUploadTaskStateRunning: 上传任务开启
 - TMFUploadTaskStateSuspended: 上传任务未完成被挂起
 - TMFUploadTaskStateCancelled: 上传任务已经被取消
 - TMFUploadTaskStateCompleted: 上传任务已经完成
 */
typedef NS_ENUM(NSInteger, TMFUploadTaskState) {
    TMFUploadTaskStateRunning = 0,
    TMFUploadTaskStateSuspended = 1,
    TMFUploadTaskStateCancelled = 2,
    TMFUploadTaskStateCompleted = 3,
};

/**
 @brief 上传任务操作对象，管理任务的运行和取消
 */
@interface TMFUploadTask : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief 上传任务对应的文件本地路径
 */
@property (nonatomic, copy, readonly) NSString *filePath;

/**
 @brief 上传任务运行状态
 */
@property (nonatomic, readonly) TMFUploadTaskState state;

/**
 @brief 取消上传
 */
- (void)cancel;

/**
 @brief 续传
 */
- (void)resume;

@end


#pragma mark - TMFUploadFileURI

/**
 @brief 文件资源标识
 */
@interface TMFUploadFileURI : NSObject

/**
 @brief 本地文件沙盒路径
 */
@property (nonatomic, copy, readonly) NSString *filePath;

/**
 @brief 上传业务标识，用来区分不同业务的上传操作，比如证件照，银行卡照片等
 */
@property (nonatomic, copy, readonly) NSString *businessId;

/**
 @brief 上传业务的自自定义参数，用来透传自定义数据
 */
@property (nonatomic, strong, readonly) NSDictionary *params;

/**
 @brief 生成文件资源标识
 
 @param filePath 本地文件沙盒路径
 @param businessId 上传业务标识
 @return 文件资源标识对象
 */
+ (TMFUploadFileURI *)URIWithFilePath:(NSString *)filePath businessId:(NSString *)businessId;
/**
 @param params  自定义参数
*/
+ (TMFUploadFileURI *)URIWithFilePath:(NSString *)filePath businessId:(NSString *)businessId params:(NSDictionary *)params;

- (instancetype)init NS_UNAVAILABLE;

@end


#pragma mark - TMFUploadManager

/**
 @brief 管理上传任务的对象，包括任务的配置，分配，取消以及网络会话管理等
 */
@interface TMFUploadManager : NSObject

/**
 @brief 当前上传配置对象
 */
@property (nonatomic, copy, readonly) TMFUploadConfiguration *configuration;

/**
 @brief 获取默认上传任务管理的单例对象
 
 @return 任务管理对象
 */
+ (TMFUploadManager *)defaultManager;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTMFSharkCenter:(TMFSharkCenter *)usedSharkCenter;

/**
 @brief 自定义上传任务管理对象
 
 @param configuration 配置对象
 @return 任务管理对象
 */
+ (TMFUploadManager *)managerWithConfiguration:(TMFUploadConfiguration *)configuration;

/**
 @brief 取消全部的上传任务
 */
- (void)cancel;

/**
 @brief 为本地文件分配一个上传任务的实例
 
 @param fileURI 本地文件资源标识
 @param progressHandler 上传进度回调
 @param completionHandler 上传结果回调
 @return 上传任务实例对象
 */
- (nullable TMFUploadTask *)uploadTaskWithFileURI:(TMFUploadFileURI *)fileURI
                                  progressHandler:(nullable void (^)(NSProgress * _Nullable progress))progressHandler
                                completionHandler:(nullable void (^)(NSString * _Nullable URL, NSError * _Nullable error))completionHandler;

/**
 @brief 为本地文件分配一个上传任务的实例
 @param completionHandler 上传结果回调

 */
- (nullable TMFUploadTask *)uploadTaskWithFileURI:(TMFUploadFileURI *)fileURI
                                  progressHandler:(nullable void (^)(NSProgress * _Nullable progress))progressHandler
                        completionOriginalHandler:(nullable void (^)(NSData * _Nullable result, NSError * _Nullable error))completionHandler;


@end

NS_ASSUME_NONNULL_END
