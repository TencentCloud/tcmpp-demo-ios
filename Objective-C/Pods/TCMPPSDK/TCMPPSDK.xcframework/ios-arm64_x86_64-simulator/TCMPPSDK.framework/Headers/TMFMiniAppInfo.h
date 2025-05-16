//
//  TMFMiniAppInfo.h
//  TMFApplet
//
//  Created by stonelshi on 2022/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int32_t, TMAEntryScene) {
    // 初始化值
    // initialization value
    TMAEntrySceneNone                                = 0,
    // 主入口
    // main entrance
    TMAEntrySceneAIOEntry                            = 1001,
    // 搜索
    // search
    TMAEntrySceneSearch                              = 1005,
    // 扫二维码
    //Scan QR code
    TMAEntrySceneScanQRCode                          = 1011,
};

/*
 * 小程序版本类型
 */
typedef NS_ENUM(int32_t, TMAVersionType) {
    // 开发版本
    // Development version
    TMAVersionDevelop = 0,
    // 预览版本
    // Preview version
    TMAVersionPreview = 1,
    // 审核版本
    // Audit version
    TMAVersionAudit = 2,
    // 线上版本（发布版本）
    // Online version (release version)
    TMAVersionOnline = 3,
    
    // 本地预置版本，不会进行更新（暂未使用）
    // Local preset version will not be updated (not used yet)
    TMAVersionLocal = 10,
};

/**
 类型,小程序或者小游戏

- TMAAppTypeApp: 小程序
- TMAAppTypeGame: 小游戏
*/
typedef NS_ENUM(int32_t, TMAAppType) {
    TMAAppTypeApp = 0,
    TMAAppTypeGame = 1,
};

@class TMFCategoryList;
@class TMFCategoryItem;
@interface TMFAppletSearchInfo : NSObject

// 小程序id
// Mini program id
@property (nonatomic, copy) NSString *appId;

// 小程序图标
// Mini program icon
@property (nonatomic, copy) NSString *appIcon;

// 小程序名称
// Mini program title
@property (nonatomic, copy) NSString *appTitle;

// 小程序简介
// Introduction to mini program
@property (nonatomic, copy) NSString *appIntro;

// 小程序开发者名称
// Mini program developer name
@property (nonatomic, copy) NSString *appDeveloper;

// 小程序分类
// Mini Program Classification
@property (nonatomic, copy) NSString *appCategory;

// 小程序线上版本
// Mini Program Online Version
@property (nonatomic, copy) NSString *appOnlineVersion;

// 小程序一级分类
// Mini Programs First-Level Classification
@property (nonatomic, copy) NSArray <TMFCategoryList *>*ctList;

// 小程序类型，小程序/小游戏
// Mini Program type,App/Game
@property (nonatomic, assign) TMAAppType appType;

@end

@interface TMFMiniAppInfo : NSObject <NSCoding>

// 小程序id
// Mini program id
@property (nonatomic, copy) NSString *appId;

// 小程序开发者userId
// Mini program developer userId
@property (nonatomic, copy) NSString *userId;

// 小程序版本类型
// Mini program version type
@property (nonatomic, assign) TMAVersionType verType;

// 小程序的机构id
//Organization ID of the mini program
@property long groupId;

// 小程序图标
// Mini program icon
@property (nonatomic, copy) NSString *appIcon;

// 小程序名称
// Mini program title
@property (nonatomic, copy) NSString *appTitle;

// 小程序描述
// Mini program description
@property (nonatomic, copy) NSString *appDescription;

// 小程序版本号
// Mini program version number
@property (nonatomic, copy) NSString *appVersion;

// 小程序版本信息
// Mini program version information
@property (nonatomic, copy) NSString *versionDescription;

// 小程序上次打开时间
// The last time the mini program was opened
@property (nonatomic, copy) NSDate *lastDate;

// 微信小程序ID
// WeChat mini program ID
@property (nonatomic, copy) NSString *wxAppId;


// 跳过域名检查
//Skip domain name check
@property (nonatomic, assign) BOOL skipDomainCheck;

// api黑白名单
// api black and white list
@property (nonatomic, strong) NSArray *whiteList;
@property (nonatomic, strong) NSArray *blackList;

// 域名控制
// Domain name control
@property (nonatomic, strong) NSArray<NSString *> *requestDomain;
@property (nonatomic, strong) NSArray<NSString *> *businessDomain;

// 小程序包路径
// Mini program package path
@property (nonatomic, strong) NSString *apkgPath;

// 小程序跳转透传字段
// Mini program jumps to transparent transmission field
@property (nonatomic, strong) NSString *extraData;

// 小程序打开路径,只要用于打开指定小程序包文件的处理
// The path to open the mini program is as long as it is used to open the specified applet package file.
@property (nonatomic, copy) NSString *firstPage;

// 小程序当前版本更新时间
// The Mini program current version update time.
@property (nonatomic, assign) NSUInteger versionUpdateTime;

// 小程序一级分类
// Mini Programs First-Level Classification
@property (nonatomic, copy) NSArray <TMFCategoryList *>*ctList;

// 小程序类型，小程序/小游戏
// Mini Program type,App/Game
@property (nonatomic, assign) TMAAppType appType;
@end


@interface TMFCategoryList : NSObject <NSCoding>

// 一级分类ID
// First-level category ID
@property (nonatomic, copy) NSString *ID;

// 一级分类名称
// First-level classification name
@property (nonatomic, copy) NSString *name;

// 小程序二级分类
// Mini Program Secondary Classification
@property (nonatomic, copy) NSArray <TMFCategoryItem *>*subItems;

@end

@interface TMFCategoryItem : NSObject <NSCoding>

// 二级分类ID
// Secondary Category ID
@property (nonatomic, copy) NSString *ID;

// 二级分类名称
// Secondary classification name
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
