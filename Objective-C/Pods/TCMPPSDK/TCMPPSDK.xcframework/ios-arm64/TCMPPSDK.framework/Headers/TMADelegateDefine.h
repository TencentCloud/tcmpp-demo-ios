//
//  TMADelegateDefine.h
//  Pods
//

#import <Foundation/Foundation.h>
#import <TCMPPSDK/TMALocationModel.h>
#import <TCMPPSDK/TMAShareModel.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM (NSInteger, MALogLevel) {
    MALogLevelError,
    MALogLevelWarn,
    MALogLevelInfo,
    MALogLevelDebug,
};

/*
 MALinkTypeUrlLink = 0,  // 假链接url  - Fake link url
 MALinkTypeMiniCode = 1,  // 扫描小程序码得到的字符串 - String obtained by scanning the mini program code
 MALinkTypeSchemaLink = 2, // 用scheme打开小程序 - Open the mini program with scheme
 */
typedef NS_ENUM (NSInteger, MALinkType) {
    MALinkTypeUrlLink = 0,
    MALinkTypeMiniCode = 1,
    MALinkTypeSchemaLink = 2,
};


//用于标识用户身份,主要用于预览调试工具,拉取开发调试和管理员预览时鉴权
//Used to identify user identity, mainly used for preview debugging tools, pull development debugging and administrator preview authentication
typedef NS_ENUM(NSInteger, TMADevelopLoginMode) {
    TMADevelopLoginModeOpenUser,//开放平台用户登录 - Open platform user login
    TMADevelopLoginModeManager //运营平台登录用户 - Operation platform login user
};


typedef void (^ MACommonCallback)(NSDictionary * _Nullable result, NSError * _Nullable error);

typedef void (^ MALocationCompletionBlock)(BOOL success, NSError * _Nullable error, TMALocationModel * _Nullable locationModel);

NS_ASSUME_NONNULL_END
