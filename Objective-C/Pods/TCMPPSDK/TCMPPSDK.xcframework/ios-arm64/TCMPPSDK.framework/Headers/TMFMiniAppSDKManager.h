//
//  TMFMiniAppSDKManager.h
//  TMFMiniAppSDK
//
//

#import <Foundation/Foundation.h>

#import <TCMPPSDK/TMAErrorDefine.h>
#import <TCMPPSDK/TMFMiniAppInfo.h>
#import <TCMPPSDK/TMFMiniAppSDKDelegate.h>
#import <TCMPPSDK/TMAServerConfig.h>
#import <TCMPPSDK/TMAFileManager.h>

NS_ASSUME_NONNULL_BEGIN

@class TMFSharkCenter;

OBJC_EXPORT NSErrorDomain const TMASDKProtoCodecErrorDomain;

NS_ERROR_ENUM(TMASDKProtoCodecErrorDomain) {
    TMASDKProtoCodecErrorUnknown = -1,
    
    TMASDKProtoCodecErrorDecodeQWebRsp = -104,
    TMASDKProtoCodecErrorSeqNotMatch = -105,
    TMASDKProtoCodecErrorInvalidRspClsss = -106,
};


/**
 类型,小程序或者小游戏

- TMAAppTypeApp: 小程序
- TMAAppTypeGame: 小游戏
*/
typedef NS_ENUM(int32_t, TMASearchAppType) {
    TMASearchAppTypeAll = 0,
    TMASearchAppTypeApp = 1,
    TMASearchAppTypeGame = 2,
};

@interface TMFMiniAppSDKManager : NSObject

@property (nonatomic, weak) id<TMFMiniAppSDKDelegate> miniAppSdkDelegate;

+ (instancetype)sharedInstance;


// 获取小程序sdk 版本信息
// Get the TCMPP sdk version information
+ (NSString *)sdkVersion;

// 通过小程序id快速打开小程序 - Quickly open the mini program through the mini program id
// @param appID 小程序ID - Mini program ID
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调  - error callback
- (void)startUpMiniAppWithAppID:(NSString *)appID
                       parentVC:(UIViewController *)parentVC
                     completion:(void (^)(NSError * _Nullable))completion;

// 通过扫码拉起小程序 - Quickly open the mini program through QRCode
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调  - error callback
- (void)startUpMiniAppWithQRCodeWithParentVC:(UIViewController *)parentVC
                                  completion:(void (^)(NSError * _Nullable))completion;

// 通过扫码拉起小程序 - Quickly open the mini program through QRCode
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param paramsStr 带入参数 -  brings in parameters
// @param completion 错误回调  - error callback
- (void)startUpMiniAppWithQRCodeWithParentVC:(UIViewController *)parentVC
                                   paramsStr:(NSString * _Nullable)paramsStr
                                  completion:(void (^)(NSError * _Nullable))completion;

// 通过小程序id打开小程序
// Open the mini program through the mini program id
// @param appID 小程序ID - Mini program ID
// @param scene 场景值 - scene value
// @param firstPage 打开页面 - open the page
// @param paramsStr 带入参数 -  brings in parameters
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithAppID:(NSString *)appID
                          scene:(TMAEntryScene)scene
                      firstPage:(NSString * _Nullable)firstPage
                         paramsStr:(NSString * _Nullable)paramsStr
                       parentVC:(UIViewController *)parentVC
                     completion:(void (^)(NSError * _Nullable))completion;


// 通过小程序id打开小程序
// Open the mini program through the mini program id
// @param appID 小程序ID - Mini program ID
// @param verType 指定打开的小程序类型 - The version type of mini program to open
// @param scene 场景值 - scene value
// @param firstPage 打开页面 - open the page
// @param paramsStr 带入参数 -  brings in parameters
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithAppID:(NSString *)appID
                        verType:(TMAVersionType)verType
                          scene:(TMAEntryScene)scene
                      firstPage:(NSString * _Nullable)firstPage
                         paramsStr:(NSString * _Nullable)paramsStr
                       parentVC:(UIViewController *)parentVC
                     completion:(void (^)(NSError * _Nullable))completion;


// 通过链接呼起小程序
// Open the mini program through the url
// @param link 伪链 - url
// @param scene 场景值 - scene value
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithLink:(NSString *)link
                          scene:(TMAEntryScene)scene
                       parentVC:(UIViewController *)parentVC
                    completion:(void (^)(NSError * _Nullable))completion;


// 通过链接呼起小程序
// Open the mini program through the url
// @param link 伪链 - url
// @param scene 场景值 - scene value
// @param firstPage 打开页面 - open the page
// @param paramsStr 带入参数 -  brings in parameters
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithLink:(NSString *)link
                          scene:(TMAEntryScene)scene
                     firstPage:(NSString * _Nullable)firstPage
                        paramsStr:(NSString * _Nullable)paramsStr
                       parentVC:(UIViewController *)parentVC
                    completion:(void (^)(NSError * _Nullable))completion;

// 通过二维码呼起小程序
// Open the mini program through the QR code
// @param qrData 二维码内容 - QR code content
// @param firstPage 打开页面 - open the page
// @param paramsStr 带入参数 -  brings in parameters
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithQrData:(NSString *)qrData
                       firstPage:(NSString * _Nullable)firstPage
                       paramsStr:(NSString * _Nullable)paramsStr
                       parentVC:(UIViewController *)parentVC
                      completion:(void (^)(NSError * _Nullable error))completion;


// 通过二维码呼起小程序
// Open the mini program through the QR code
// @param qrData 二维码内容 - QR code content
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithQrData:(NSString *)qrData
                       parentVC:(UIViewController *)parentVC
                      completion:(void (^)(NSError * _Nullable error))completion;


// 通过小程序信息呼起小程序,主要用于启动预置的小程序包
// Open the mini program through the mini program information, mainly used to start the preset mini program package
// @param appInfo 小程序信息 - The mini program info
// @param scene 场景值 - scene value
// @param parentVC 从哪个vc呼起 - Which vc to call from
// @param completion 错误回调 - error callback
- (void)startUpMiniAppWithAppInfo:(TMFMiniAppInfo *)appInfo
                          scene:(TMAEntryScene)scene
                       parentVC:(UIViewController *)parentVC
                       completion:(void (^)(NSError * _Nullable))completion;


// 移除小程序/小游戏所有相关缓存 包含资源包、基础库、小程序/小游戏沙箱数据
// Remove all caches related to mini programs/mini games, including resource packages, basic libraries, mini programs/mini games sandbox data
- (void)clearMiniAppCache;


// 获取当前正在运行的小程序对象
// Get the currently running mini program object
// @return TMFMiniAppInfo 小程序信息  - mini program information
- (TMFMiniAppInfo *)currentApplet;


// 获取最近打开的所有小程序信息
// Get information about all recently opened mini programs
// @return 小程序数组<TMFMiniAppInfo> - Mini program array<TMFMiniAppInfo>
- (NSArray *)loadAppletsFromCache;


// 搜索小程序
// Search mini program
// @param name 搜索名称关键词 - search name keyword
// @param completion 搜索结果 - search results
- (void)searchAppletsWithName:(NSString *)name
                      completion:(void (^)(NSArray<TMFAppletSearchInfo *> * _Nullable, NSError * _Nullable))completion;

// 搜索小程序
// Search mini program
// @param name 搜索名称关键词 - search name keyword
// @param firstType 一级分类名称 - first level classification name
// @param secondType 二级分类名称 - second level classification name
// @param completion 搜索结果 - search results
- (void)searchAppletsWithName:(NSString * _Nullable )name
                    firstType:(NSString * _Nullable)firstType
                   secondType:(NSString * _Nullable)secondType
                   completion:(void (^)(NSArray<TMFAppletSearchInfo *> * _Nullable, NSError * _Nullable))completion;

// 搜索小程序
// Search mini program
// @param name 搜索名称关键词 - search name keyword
// @param searchType 搜索范围,小程序/小游戏 - search type miniapp or minigame
// @param firstType 一级分类名称 - first level classification name
// @param secondType 二级分类名称 - second level classification name
// @param completion 搜索结果 - search results
- (void)searchAppletsWithName:(NSString * _Nullable )name
                    searchType:(TMASearchAppType)searchType
                    firstType:(NSString * _Nullable)firstType
                   secondType:(NSString * _Nullable)secondType
                   completion:(void (^)(NSArray<TMFAppletSearchInfo *> * _Nullable, NSError * _Nullable))completion;

// 搜索小程序
// Search mini program
// @param name 搜索名称关键词 - search name keyword
// @param searchType 搜索范围,小程序/小游戏 - search type miniapp or minigame
// @param firstType 一级分类名称 - first level classification name
// @param secondType 二级分类名称 - second level classification name
// @param pageIndex 页码 - page index
// @param pageSize 分页大小 - page size
// @param completion 搜索结果 - search results
- (void)searchAppletsWithName:(NSString * _Nullable )name
                    searchType:(TMASearchAppType)searchType
                    firstType:(NSString * _Nullable)firstType
                   secondType:(NSString * _Nullable)secondType
                    pageIndex:(int)pageIndex
                     pageSize:(int)pageSize
                   completion:(void (^)(NSArray<TMFAppletSearchInfo *> * _Nullable, int totalNum, NSError * _Nullable))completion;


// 获取小程序分类信息
// Get mini program classification information
// @param existMnpOnly 是否只返回有小程序的分类 - search name keyword
// @param completion 获取的分类结果 - typeInfo results
- (void)getTypeInfoExistMnpOnly:(BOOL)existMnpOnly
                 WithCompletion:(void (^)(NSArray<NSDictionary <NSString *,NSArray *>*> * _Nullable, NSError * _Nullable))completion;


// 获取小程序分类信息
// Get mini program classification information
// @param existMnpOnly 是否只返回有小程序的分类 - search name keyword
// @param searchType 搜索范围,小程序/小游戏 - search type miniapp or minigame
// @param completion 获取的分类结果 - typeInfo results
- (void)getTypeInfoExistMnpOnly:(BOOL)existMnpOnly
                     searchType:(TMASearchAppType)searchType
                 WithCompletion:(void (^)(NSArray<NSDictionary <NSString *,NSArray *>*> * _Nullable, NSError * _Nullable))completion;

// 删除本地缓存小程序
// Delete local cache mini programs
// @param appID 要删除的 appID，默认删除所有版本 - The appID to be deleted, all versions will be deleted by default
- (void)clearCacheWithAppID:(NSString *)appID;


// 删除本地缓存小程序
// Delete local cache mini programs
// @param appID 要删除的 appID，默认删除所有版本  - The appID to be deleted, all versions will be deleted by default
// @param verType 要删除的本地缓存小程序类型  - The version type of mini program to delete
- (void)clearCacheWithAppID:(NSString *)appID verType:(TMAVersionType)verType;


// 获取小程序对应的 FileManager
// Get the FileManager corresponding to the mini program
// @param appID  指定的小程序 ID - The mini program ID
- (nullable TMAFileManager *)getFileManagerWithAppID:(NSString *)appID;


// 关闭当前正在运行的小程序对象
// Close the currently running mini program object
- (void)closeCurrentApplet;

// 关闭指定的小程序对象
// Close the specified mini program object
// @param appID 要关闭的 appID
- (void)closeMiniAppWithAppID:(NSString *)appID;

// 关闭所有栈上与保活中的小程序和小游戏
// Close all mini-programs and mini-games on the stack and kept alive
- (void)closeAllApplications;


// 终止当前正在运行的小程序对象
// Terminate the currently running mini program object
- (void)terminateCurrentApplet;

// 终止指定的小程序对象
// Terminate the specified applet object
// @param appID 要终止的 appID，默认删除所有版本 - The appID to be terminated, all versions will be deleted by default
- (void)terminateMiniAppWithAppID:(NSString *)appID;

// 终止栈上与保活中的小程序和小游戏
// Terminate mini-programs and mini-games on the stack and in keep-alive mode
- (void)terminateAllApplications;



#pragma mark - config set
// **** It is no longer recommended to use, use setConfiguration instead
// 准备小程序配置信息内容,并不进行初始化,需要初始化时，显示调用initServer,或者打开小程序时会自动进行初始化
// Prepare the configuration information content of the mini program and do not initialize it. When initialization is required, initServer will be called explicitly, or initialization will be performed automatically when the mini program is opened.
// @param configuration 指定小程序配置 - The mini program configuration
- (void)prepareConfig:(TMAServerConfig *)configuration;

// 根据prepareConfigString 配置的小程序配置信息进行初始化
// Initialize according to the applet configuration information configured by prepareConfigString
- (void)initServer;

// 准备小程序配置信息内容,并不进行初始化,需要初始化时，显示调用initServer,或者打开小程序时会自动进行初始化
// Prepare the configuration information content of the mini program and do not initialize it. When initialization is required, initServer will be called explicitly, or initialization will be performed automatically when the mini program is opened.
// @param configuration 指定小程序配置- The mini program configuration
- (void)setConfiguration:(TMAServerConfig *)configuration;

// 设置使用宿主程序的tmf环境
// 当主程序使用TMF系统搭建时使用该方法
// Set the tmf environment using the host program
// Use this method when the main program is built using the TMF system
- (void)setAppConfiguration;

// 设置网络通道
// Set network channel
- (void)setSharkCenter:(TMFSharkCenter *)sharkCenter;

// 预准备小程序信息
// Prepare mini program information
// @param appIds  要准备小程序信息 - to prepare mini program information
// @param isDownload 是否直接下载 - whether to download directly
// @param complete 批量更新小程序回调 - batch update applet callback
- (void)preloadMiniApps:(NSArray *)appIds isDownload:(BOOL)isDownload complete:(void (^)(NSArray * _Nullable results, NSError *_Nullable error))complete;


// 设置存入离线小程序包的目录
// Set the directory where offline mini program packages are stored
// @param path 预置离线小程序包目录 - Preset offline applet package directory
- (void)setOffLineApkgsPath:(NSString *)path;


// 处理openUrl调用时传入的URL
// Handle the URL passed in when calling openUrl
// @param url scheme拉起时传入的URL - The URL passed in when the scheme is pulled up
- (BOOL)handleOpenUrl:(NSURL *)url;

// 设置自定义api配置文件
// Setting up custom api profiles
// @param path 自定义api配置文件 - Customizing the api configuration file
- (void)setCustomApiConfigFile:(NSString *)path;

#pragma mark - profile set
- (void)setAppletScheme:(NSString *)scheme;

- (NSString *)getAppletScheme;

// 获取当前设备的guid信息
// Get the GUID information of the current device
- (NSString *)getGuid;

// 上报用户ID,如果参数为空 则视为解绑
// Report  user ID,If the parameter is empty, it will be regarded as unbinding
// @param customizedUserID 用户自定义 user ID - customized user ID
- (void)updateCustomizedUserID:(nullable NSString *)customizedUserID;


// 上报位置信息
// Report location information
// @deprecated 接口已经不提供服务/The interface is no longer providing service
// @param country  国家 - country
// @param province 省 - province
// @param city  市 - city
- (void)updateAreaInfoWithCountry:(nullable NSString *)country Province:(nullable NSString *)province City:(NSString *)city;

#pragma mark - MiniApp Setting

// 获取当前正在运行的小程序的授权信息列表
// Get the authorization information list of the currently running mini program
- (NSArray *)getCurrentAppAuthorizeList;


// 改变当前正在运行的小程序的授权状态
// Change the authorization status of the currently running mini program
// @param status 授权状态 - authorization status
// @param scope scope名称 - scope name
// @param completionHandler 请求结果回调 - request result callback
- (void)setCurrentAppAuthStatus:(BOOL)status
             forScope:(NSString *)scope
    completionHandler:(MACommonCallback _Nullable)completionHandler;


#pragma mark - debug test
- (NSDictionary *)getDebugInfo;

// 设置jssdkpath，供开发阶段调试时使用
// Set jssdkpath for use during debugging during the development phas
- (void)setJsSDKPathForDebug:(NSString *)jsSdkPath;


// 开放平台或者运营平台用户登录,saas版本不可用,仅供私有化版本使用,已弃用
// Open platform or operation platform user login, saas version is not available, only for privatized version, has been deprecated
- (void)loginWithName:(NSString *)username andPassword:(NSString *)password inMode:(TMADevelopLoginMode)mode callbackHandler:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))handler;

// 根据appId获取小程序沙箱路径，清理缓存时使用
// Get the mini program sandbox path based on the appId and use it when clearing the cache
- (NSString *)sandBoxPathWithAppID:(NSString *)appId;

// 获取当前配置信息的 appkey
// Get the appkey of the current configuration information
- (NSString *)getConfigAppKey;

- (void)playBgAudio;

- (void)pauseBgAudio;

@end

NS_ASSUME_NONNULL_END
