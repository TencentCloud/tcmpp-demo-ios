//
//  TMAExternalJSPlugin.h
//  MiniAppSDK
//
//

#import <UIKit/UIKit.h>
#import <TCMPPSDK/TMFMiniAppInfo.h>

//nativePlugin回调基础库事件
//nativePlugin callback base library events
OBJC_EXTERN NSString *const kTMAOnExternalElementEvent;

@class MAAppInfo;

/**
 * @brief 自定义api返回的结果  The results returned by the customize api
 */
@interface TMAExternalJSPluginResult : NSObject

@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) NSError *error; // 无error为success，有error为fail

@end

/**
 * @brief 提供能力给外部plugin执行js Provides the ability to execute js to external plugins
 */
@protocol TMAExternalJSContextProtocol <NSObject>

//当前小程序的appInfo,内部使用
//appInfo of the current mini program, used internally
@property (nonatomic, strong, readonly) MAAppInfo *appInfo;

//当前小程序的appInfo,外部使用
//appInfo of the current mini program, for external use
@property (nonatomic, strong, readonly) TMFMiniAppInfo *tmfAppInfo;

@property (nonatomic, strong, readonly) UINavigationController *miniAppNavController;

/**
 * 转换为wxfilePath
 * Convert to wxfilePath
 */
- (NSString *)translateAnyPathToWxfilePath:(NSString *)filePath;

/**
 * 转换为绝对路径
 * Convert to absolute path
 */
- (NSString *)translateAnyPathToAbsolutePath:(NSString *)filePath;

/**
 * 异步执行api结果
 * Asynchronous execution of api results
 */
- (void)doCallback:(TMAExternalJSPluginResult *)pluginResult;

/**
 * 提供subscribeHandler能力
 * Provide subscribeHandler capability
 */
- (void)doSubscribe:(NSString *)eventName data:(NSString *)data;

/// 对所有参数进行ArrayBuffer编解码
- (NSDictionary *)arrayBufferUnpack:(NSDictionary *)data;
- (NSDictionary *)arrayBufferPack:(NSDictionary *)data;

@end

@protocol TMAExternalElementView <NSObject>

+ (UIView *)createWithParams:(NSDictionary *)params context:(id<TMAExternalJSContextProtocol>)context;

- (void)operateWithParams:(NSDictionary *)param context:(id<TMAExternalJSContextProtocol>)context;

@end

#define TMA_REGISTER_EXTENAL_JSPLUGIN \
OBJC_EXTERN void _TMARegisterExternalJSPlugin(Class); \
+ (void)load { \
    _TMARegisterExternalJSPlugin(self); \
}

#define TMAExternalJSAPI_IMP(APIName) \
- (TMAExternalJSPluginResult *)__tma_external_api__##APIName:(NSString *)api_name \
                                                      params:(NSDictionary *)params \
                                                     context:(id<TMAExternalJSContextProtocol>)context

#define TMARegisterExternalElement(elementName) \
OBJC_EXTERN void _TMARegisterExternalElement(NSString *, Class); \
+ (void)load { \
    _TMARegisterExternalElement(@( # elementName ), self); \
}
