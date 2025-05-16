//
//  TMAErrorDefine.h
//  MiniAppSDK
//
//

#pragma mark Need to follow the format
/*  自动生成 localizedDescription 需要遵循的格式：
 *      1. 创建 Domain 必须为 FOUNDATION_EXPORT NSErrorDomain const;
 *      2. 创建 Code 必须以 NS_ERROR_ENUM(xxx){}; 包裹;
 *      3. Code 枚举值需以 xxx 去除 Domian 后的字符串为前缀;
 *      4. 需生成的 NSError localizedDescription 需要在相应的 Code 的枚举值上面以 // 开启注释。
 *  The format that needs to be followed to automatically generate localizedDescription:
 *      1. The created Domain must be FOUNDATION_EXPORT NSErrorDomain const;
 *      2. The created Code must be wrapped with NS_ERROR_ENUM(xxx){};;
 *      3. The Code enumeration value must be prefixed by the string xxx minus Domian;
 *      4. The NSError localizedDescription to be generated needs to be commented with // on the corresponding Code enumeration value.
*/

#ifndef TMAErrorDefine_h
#define TMAErrorDefine_h
#import <TCMPPSDK/NSError+MiniAppSDK.h>

#define TMALocalError(errorDomian, errorCode)  ([NSError tmaErrorWithDomain:errorDomian code:errorCode userInfo:nil])
#define TMALocalErrorWithTraceId(errorDomian, errorCode, traceId)  ([NSError tmaErrorWithDomain:errorDomian code:errorCode userInfo:nil withTraceId:traceId])

#define TMALocalErrorNumber(errorDomian, errorCode, errorNumber)  ([NSError tmaErrorWithDomain:errorDomian code:errorCode number:errorNumber] )
#define TMALocalErrorNumberWithTraceId(errorDomian, errorCode, errorNumber, traceId)  ([NSError tmaErrorWithDomain:errorDomian code:errorCode number:errorNumber withTraceId:traceId] )
#define TMASharkError(errorInfo,traceId)  ([NSError tmaErrorFromSharkError:errorInfo withTraceId:traceId])

#define TMALocalErrorMsg(errorDomian, errorCode, errMsg)  ([NSError tmaErrorWithDomain:errorDomian code:errorCode userInfo:@{NSLocalizedDescriptionKey: errMsg}])
#define TMALocalErrorMsgWithTraceId(errorDomian, errorCode, errMsg, traceId)  ([NSError tmaErrorWithDomain:errorDomian code:errorCode userInfo:@{NSLocalizedDescriptionKey: errMsg} withTraceId:traceId])


FOUNDATION_EXPORT NSErrorDomain const TMAMiniAppErrorDomain;
NS_ERROR_ENUM(TMAMiniAppErrorDomain)
{
    // 初始化信息错误或者未初始化
    // Initialization information is incorrect or not initialized
    TMAMiniAppErrorConfigInitError                   = -21000,
    
    // 网络请求错误
    // The network  error
    TMAMiniAppErrorNetworkError                   = -21001,
    
    // 服务端返回code错误
    // The server returns an error code
    TMAMiniAppErrorResponseCodeError                  = -21002,
    
    // 服务端返回response为空
    // The server returns an empty response
    TMAMiniAppErrorResponseDataNull               = -21003,
    
    // 小程序版本不存在
    // The mini program version does not exist
    TMAMiniAppErrorVersionNotExist                = -21005,
    
    // 小程序已下架
    // The mini program has been removed from the shelves
    TMAMiniAppErrorForbidden                = -21006,
    
    // 小程序搜索指定页面数据为空
    // The mini program search specified page data is empty
    TMAMiniAppSearchPageDataNull               = -21009,
    
    //特定接口调用频率过高
    //The frequency of specific interface calls is too high
    TMAMiniAppCmdIDRequestFrequent               = -21011,
    
    //接口调用频率过高
    //Interface calls are too frequent
    TMAMiniAppRequestFrequent               = -21012,
    
    // 不支持的链接
    // Unsupported link
    TMAMiniAppErrorErrorLink                 = -21101,
    
    // 未集成TCMPPExtScanCode扩展库
    // Unsupported link
    TMAMiniAppErrorNoScanCodeSDK                = -21102,
    
    // delegate没有实现
    // delegate is not implemented
    TMAMiniAppErrorNotImplemented                 = -21103,
    
    // 用户取消扫码
    // User canceled code scanning
    TMAMiniAppErrorScanCodeCancel               = -21104,
    
    // 小程序基础库下载失败
    // Mini program base library download failed
    TMAMiniAppErrorJSSDKDownloadFail              = -22001,
    // 小程序基础库解压失败
    // Mini program base library decompression failed
    TMAMiniAppErrorJSSDKUnzipFail                 = -22002,
    // 小程序基础库不需要升级
    // Mini program base library does not need to be upgraded
    TMAMiniAppErrorJSSDKNeedUpgrade               = -22003,
    // 小程序基础库验证失败
    // Mini program basic library verification failed
    TMAMiniAppErrorJSSDKVerifyFail                = -22004,
    
    // 下载小程序apkg包的网络响应错误
    TMAMiniAppErrorDownloadApkgFail                = -22012,
    
    // 解压小程序Apkg包失败
    // UnPack mini program Apkg package failed
    TMAMiniAppErrorUnpackApkgFail                 = -22013,

    // 小程序Apkg包下载存储路径错误
    // The download storage path of the mini program Apkg package is wrong
    TMAMiniAppErrorCreatePathFail                 = -22014,
    // 验证小程序Apkg包失败
    // The download storage path of the mini program Apkg package is wrong
    TMAMiniAppErrorValidateFileFail               = -22015,
    
    // 下载文件的网络响应错误
    TMAMiniAppErrorDownloadFileFail                = -22016,
    
    // 设备系统不支持小程序
    // The device system does not support mini programs
    TMAMiniAppErrorSystemNotSupport               = -22017,
    // 启动小程序的AppInfo错误
    // AppInfo error when starting the mini program
    TMAMiniAppErrorAppInfoError                   = -22018,
    // 小程序已经在显示中
    // The mini program is already being displayed
    TMAMiniAppErrorMiniAppIsShowing               = -22019,
    // 小程序视图是无效视图
    // The mini program view is an invalid view
    TMAMiniAppErrorParentVCInvalid                = -22020,
    // 启动小程序的 Application 错误
    // Application error when starting the mini program
    TMAMiniAppErrorApplicationError               = -22021,
    // 启动小程序的代理没有实现
    // The agent for starting the mini program is not implemented
    TMAMiniAppErrorDelegateError                  = -22022,
    TMAMiniAppErrorNilApplication                 = -22023,
    TMAMiniAppErrorUserNotLoggedIn                = -22024,
    TMAMiniAppErrorFlutterResourceInvalid         = -22025,
    // 不支持小游戏
    // Does not support mini games
    TMAMiniAppErrorNotSupportMiniGame             = -22026,
    // 服务下发不允许运行小游戏
    // The server does not allow the running of mini games
    TMAMiniAppErrorNotAllowMiniGame                = -22027,
    // 小程序读取资源文件发生异常(如小游戏读取不到game.json)
    // An exception occurs when the mini program reads the resource file (for example, the mini game cannot read game.json)
    TMAMiniAppErrorReadPackageFail                = -22028,
    
    // 下载文件md5验证失败
    // Download file md5 verification failed
    TMAMiniAppErrorFileMd5VerifyFail     = -22029,
    // 复制域名配置文件到目标位置失败
    // Failed to copy domain name configuration file to target location
    TMAMiniAppErrorFCopyDomainsFileFail     = -22030,
    
    // MAWebView 的白屏错误
    // MAWebView white screen error
    TMAMiniAppErrorWebViewNoCompositingView       = -23001,
    TMAMiniAppErrorWebViewJSError                 = -23002,
    TMAMiniAppErrorWebViewDidTerminate            = -23003,
    TMAMiniAppErrorWebViewScriptAgainError        = -23004,
    
    TMAMiniAppErrorWebViewPageNotFound            = -23005,
    TMAMiniAppErrorWebViewApplicationNotFound     = -23006,
    
    TMAMiniAppErrorHotlaunchParamInvalid          = -23007,
    TMAMiniAppErrorWebViewRenderBlank             = -23008,
    
    
    
    // 无可用的云资源使用
    // No available cloud resources to use
    TMAMiniAppErrorResourceLimited             = -25001,
    TMAMiniAppErrorResourceOverflow             = -25002
};

#endif /* TMAErrorDefine_h */
