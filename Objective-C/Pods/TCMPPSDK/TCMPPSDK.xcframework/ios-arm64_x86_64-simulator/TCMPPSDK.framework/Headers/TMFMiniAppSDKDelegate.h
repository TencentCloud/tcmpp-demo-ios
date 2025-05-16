//
//  TMFMiniAppSDKDelegate.h
//  Pods
//
//  Created by stonelshi on 2022/11/3.
//  Copyright © 2022 Tencent. All rights reserved.
//

#ifndef TMFMiniAppSDKDelegate_h
#define TMFMiniAppSDKDelegate_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TCMPPSDK/TMFMiniAppInfo.h>
#import <TCMPPSDK/TMADelegateDefine.h>
#import <TCMPPSDK/AlertActionInfo.h>
#import <TCMPPSDK/TMAAppUserInfo.h>
#import <TCMPPSDK/TMARealtimeLogItem.h>
#import <TCMPPSDK/TMAVideoPlayerProtocol.h>
#import <TCMPPSDK/TMAChooseMessageFileModel.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMANetWorkStatus) {
    // 未知类型网络 - Unknown type network
    TMANetWorkStatus_Unknown = -1,
    // 网络不可用 - Network Unavailable
    TMANetWorkStatus_NotReachable = 0,
    // wifi
    TMANetWorkStatus_ReachableViaWiFi = 1,
    // 2G
    TMANetWorkStatus_ReachableVia2G = 2,
    // 3G
    TMANetWorkStatus_ReachableVia3G = 3,
    // 4G
    TMANetWorkStatus_ReachableVia4G = 4,
    // 5G
    TMANetWorkStatus_ReachableVia5G = 5
};

// SDK宿主平台的用户账号来源 qq/微信/电话号码登录/匿名登录/其他方式
// The user account source of the SDK host platform is qq/WeChat/phone number login/anonymous login/other methods
typedef NS_ENUM(NSInteger, TMASourceUinPlatform) {
    TMASourceUinPlatformQQ = 1,
    TMASourceUinPlatformWechat,
    TMASourceUinPlatformPhone,
    TMASourceUinPlatformAnonymous,
    TMASourceUinPlatformOther,
};

// 小程序启动时转场动画
// Transition animation when the mini program starts
typedef NS_ENUM(NSInteger, TMFSlideAnimationType) {
    TMFSlideAnimationTypeDefault,
    TMFSlideAnimationTypeBottomToTop,
    TMFSlideAnimationTypeTopToBottom,
    TMFSlideAnimationTypeLeftToRight,
    TMFSlideAnimationTypeRightToLeft,
};

// 小程序生命周期状态
// Mini program life cycle status
typedef NS_ENUM(NSUInteger, TMAAppLifeCycleType) {
    TMAAppLifeCycleTypeNone,
    TMAAppLifeCycleTypeonColdOpen,
    TMAAppLifeCycleTypeonHotOpen,
    TMAAppLifeCycleTypeOnShow,
    TMAAppLifeCycleTypeOnHide,
    TMAAppLifeCycleTypeOnClose,
    TMAAppLifeCycleTypeTerminate,
};

typedef NS_ENUM(NSInteger, TMAReportEventID) {
    // 未定义,报报用户自定义事件
    // Undefined, report user-defined events
    TMAReportEventID_None = 0,
    // 打开小程序
    // Open the mini app
    TMAReportEventID_OPEN_MINIAPP = 1,
    // 更新小程序
    // Update the mini app
    TMAReportEventID_UPDATE_MINIAPP = 2,
    // 下载小程序
    // Download the mini app
    TMAReportEventID_DOWNLOAD_MINIAPP = 3,
    // 小程序页面浏览
    // Open the mini app page
    TMAReportEventID_MINIAPP_PAGE_VIEW = 4,
    // 退出小程序
    // Close the mini app
    TMAReportEventID_EXIT_MINIAPP = 5,
    // 小程序行为事件，atcion:0 后台；1 前台
    // Mini program action events, atcion: 0 onHide; 1 onShow
    TMAReportEventID_MINIAPP_ACTION = 6
};

typedef void (^TMAAppFetchUserInfoBlock)(TMAAppUserInfo * _Nullable userInfo);


@protocol TMANetImageViewProtocol <NSObject>
@property (nonatomic, strong) NSString *imageUrl;
@end

// @required 标记实现的协议必须实现，否则会有异常，甚至 Crash, SDK 不会兜底以符合语法规范 - The protocol implemented by the mark must be implemented, otherwise there will be exceptions or even crashes, and the SDK will not cover up to comply with the grammar specifications.
@protocol TMABarrageViewProtocol <NSObject>
@required
@property (nonatomic, assign) float currentTime;
@property (nonatomic, assign) NSInteger trackNumber; // 默认为两条轨道
- (void)setBarrageData:(NSArray *)data;
- (void)insertBarrageWithContent:(NSString *)content color:(NSString *)colorStr;
- (void)play;
- (void)reset;
// 播放器销毁时调用 - Called when the player is destroyed
- (void)clear;
@end


@protocol TMFMiniAppSDKDelegate <NSObject>

@optional

#pragma mark - Log -
// 打印Log - Print Log
// @param level log级别，参考MALogLevel -  log level, refer to MALogLevel
// @param msg log信息 - log information
- (void)log:(MALogLevel)level msg:(NSString *)msg;


#pragma mark - Host App Related
/**
 * @brief SDK宿主应用名称 - Host app name
 * 主要用于文案提示使用 - Mainly used for copywriting prompts
 */
- (NSString *)appName;

/**
 * @brief SDK宿主平台版本 - Host app version
 * @return 返回的是小写字符串，例如1.0.0 - returns a lowercase string, such as 1.0.0
 */
- (NSString *)getAppVersion;

/**
 * @brief SDK宿主平台的网络状态 - The network status of the host platform
 */
- (TMANetWorkStatus)getAppNetworkStatus;

/**
 * @brief SDK宿主平台的机型信息 - SDK host platform model information
 */
- (NSString *)getAppIPhoneModel;

/**
 * @brief SDK宿主平台设备信息 - SDK host platform device information
 * @return 格式 - format : {@"brand":@"iPhone",@"model":@"iPhone 11<iPhone12,1>",@"system":@"ios",@"platform":@"iOS 16.4.1"}
 */
- (NSDictionary *)getAppDeviceInfo;

/**
 * @brief 获取宿主APP基础信息 - Get basic information of the host APP
 * @return 格式 - format : {@"SDKVersion":@"2.32.2",@"model":@"iPhone 11<iPhone12,1>",@"system":@"ios",@"platform":@"iOS 16.4.1"}
 */
- (NSDictionary *)getAppBaseInfo;

/**
 * @brief 宿主设置的当前语言 - Get current language set by the app
 * @return 格式 - format : "zh-Hans"
 */
- (NSString *)getCurrentLocalLanguage;

/**
 * @brief 宿主设置的当前主题 如果不实现此方法 那么getAppBaseInfo中返回的theme为系统主题 - The current theme set by the app. If this method is not implemented, the theme returned in getAppBaseInfo will be the system theme.
 */
- (NSString *)getAppTheme;

/**
 *  @brief 剪贴板频控 - Clipboard frequency control
 */
- (NSNumber *)getClipboardInterval;


// 系统默认的UA，即不做任何定制时的UA - The system default UA, that is, the UA without any customization
// for web-view组件使用 - for web-view component use
// Please use `customUserAgent` instead.
- (NSString *)defaultUserAgent;


// 定制的UA - Customized UA
// @param defaultUserAgent 默认使用的 ua -  ua used by default
- (NSString *)customUserAgent:(NSString *)defaultUserAgent;


// 小程序最多保活的个数,默认是3
// The maximum number of mini programs that can be kept alive, the default is 3
- (NSInteger)maxMiniAppKeepAliveCount;

// 设置打开小程序宿主URL Scheme
// Set the host to open the applet URL Scheme
- (NSString *)getAppScheme;

#pragma mark - 用户相关 - user related

/**
 * @brief SDK宿主平台的用户昵称,默认返回"TCMPP" - The user nickname of the SDK host platform, which returns "TCMPP" by default
 */
- (NSString *)getAppNickName;

/**
 * @brief SDK宿主平台的用户头像,默认返回demo图片 - SDK host platform user avatar, returns demo image by default
 */
- (UIImage *)getAppAvatar;

/**
 * @brief 根据scope拉取SDK宿主平台的用户头像和昵称，头像返回UIView，block必须运行在主线程!!! - Pull the user avatar and nickname of the SDK host platform according to the scope. The avatar returns to UIView. The block must run on the main thread!!!
 */
- (void)fetchAppUserInfoWithScope:(NSString *)scope block:(TMAAppFetchUserInfoBlock)block;


/**
 * @brief 获取SDK宿主平台的当前用户账号标识，一般填uin或openid - Get the current user account ID of the SDK host platform, usually fill in uin or openid
 *
 * 注意：返回nil会导致SDK内某些缓存失效。如果没有登录，可以填个设备号id来避免缓存失效 - Note: Returning nil will cause some caches in the SDK to become invalid. If you are not logged in, you can fill in the device ID to avoid cache failure.
 */
- (NSString *_Nonnull)getAppUID;

/**
 * @brief 获取SDK宿主平台的当前用户票证，用于校验获取邮箱或手机号 - Get the current user ticket of the SDK host platform to verify the email or mobile phone number
 */
- (NSString *_Nonnull)getTicket;

#pragma mark - UI相关 - UI related
// 获取需要下载的imageView - Get the imageView that needs to be downloaded
// @param url 图片地址 - image address
- (nullable UIImageView *)imageViewWithURL:(NSString *)url;

// 展示loading - Display loading
// @param infos loading信息 - loading information
- (void)showLoading:(TMALoadingInfo * _Nullable)infos;


// 隐藏loading - Hide loading
- (void)hideLoading;


// 展示toast - Display toast
// @param infos toast信息
- (void)showToast:(TMAToastInfo *)infos;


// 隐藏toast - Hide toast
- (void)hideToast;


// 展示actionSheet - Display actionSheet
// @param title 标题 - title
// @param cancelButtonTitle 取消按钮标题 - Cancel button title
// @param cancelAction 点击取消按钮触发的动作 - The action triggered by clicking the cancel button
// @param otherButtonTitleAndActions 其他按钮及响应操作 - other buttons and response operations
// @param dismissBlock actionSheet收起后需要执行的操作（一定要调用以保证功能正确！！！） - The operation that needs to be performed after actionSheet is closed (must be called to ensure the function is correct!!!)
// @param presentingViewController 展示actionSheet的vc - displays the vc of actionSheet
- (void)showActionSheetWithTitle:(nullable NSString *)title
               cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    cancelAction:(nullable dispatch_block_t)cancelAction
      otherButtonTitleAndActions:(nullable NSArray *)otherButtonTitleAndActions
                    dismissBlock:(nullable dispatch_block_t)dismissBlock
        presentingViewController:(UIViewController *)presentingViewController;


// 分享面板 - Share panel
// 如果此方法不实现，则会调用showActionSheetWithTitle:cancelButtonTitle:cancelAction:otherButtonTitleAndActions:dismissBlock:presentingViewController: - If this method is not implemented, showActionSheetWithTitle:cancelButtonTitle:cancelAction:otherButtonTitleAndActions:dismissBlock:presentingViewController: will be called.
// @param title 标题 - title
// @param cancelAction 取消操作 - cancel the operation
// @param otherButtonTitleAndActions 其他按钮及响应操作 - other buttons and response operations
// @param dismissBlock 面板收起后需要执行的操作（一定要调用以保证功能正确！！！） - The operation that needs to be performed after the panel is closed (must be called to ensure correct function!!!)
// @param parentVC 呼起面板的vc - calls up the vc of the panel
- (void)showShareViewWithTitle:(nullable NSString *)title
                  cancelAction:(nullable dispatch_block_t)cancelAction
    otherButtonTitleAndActions:(nullable NSArray *)otherButtonTitleAndActions
                  dismissBlock:(nullable dispatch_block_t)dismissBlock
                      parentVC:(UIViewController *)parentVC;

// 点击胶囊按钮呼起的面板 - Click the capsule button to call up the panel
// 如果此方法不实现，则会调用showActionSheetWithTitle:cancelButtonTitle:cancelAction:otherButtonTitleAndActions:dismissBlock:presentingViewController: - If this method is not implemented, showActionSheetWithTitle:cancelButtonTitle:cancelAction:otherButtonTitleAndActions:dismissBlock:presentingViewController: will be called.
// @param app 小程序信息 - Mini program information
// @param cancelButtonTitle 取消标题 - cancel title
// @param cancelAction 取消操作 - cancel the operation
// @param otherButtonTitleAndActions 其他按钮及响应操作 - other buttons and response operations
// @param dismissBlock 面板收起后需要执行的操作（一定要调用以保证功能正确！！！）- The operation that needs to be performed after the panel is closed (must be called to ensure correct function!!!)
// @param parentVC 呼起面板的vc - calls up the vc of the panel
- (void)showMoreButtonActionSheetWithApp:(TMFMiniAppInfo *)app
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                cancelAction:(nullable dispatch_block_t)cancelAction
                  otherButtonTitleAndActions:(nullable NSArray *)otherButtonTitleAndActions
                                dismissBlock:(nullable dispatch_block_t)dismissBlock
                                parentVC:(UIViewController *)parentVC;

// 收起所有小程序/小游戏呼起的actionSheet - Collapse all actionSheets called by mini-programs/mini-games
- (void)clearAllActionSheet;


// 呼起alert弹框 - Call the alert pop-up box
// @param title 标题 - title
// @param message 信息 - information
// @param actionTitleAndblocks 按钮标题及响应操作 - button title and response operation
// @param presentingViewController 呼起alert弹框的vc - calls the vc of the alert pop-up box
- (void)showAlertWithTitle:(nullable NSString *)title
               withMessage:(nullable NSString *)message
              actionBlocks:(nullable NSArray<AlertActionInfo *> *)actionTitleAndblocks
  presentingViewController:(UIViewController *)presentingViewController;

/**
 * @brief 展示弹窗 - Display pop-up window
 *
 * @param title 标题 - title
 * @param message 信息 - Message
 * @param actionTitleAndblocks 按钮标题及响应操作 - button title and response operation
 * @param isDismissWhenBackground 当小程序退到后台时，弹窗是否消失 - When the mini program retreats to the background, whether the pop-up window disappears
 * @param dismissOnClickBlank 当点击空白背景区域时是否消失 - Whether to disappear when a blank background area is clicked
 * @param presentingViewController 呼起alert弹框的vc - calls the vc of the alert pop-up box
 */
- (void)showPopupWithTitle:(NSString *)title
                   message:(NSString *)message
              actionBlocks:(NSArray<AlertActionInfo *> *)actionTitleAndblocks
   isDismissWhenBackground:(BOOL)isDismissWhenBackground
       dismissOnClickBlank:(BOOL)dismissOnClickBlank
  presentingViewController:(UIViewController *)presentingViewController;

/**
 * @brief 从客户端会话选择文件 - Select files from client session
 *
 * @param count 最多可以选择的文件个数，可以 0～100 - The maximum number of files that can be selected, can be 0~100
 * @param type  所选的文件的类型 - The type of the selected file
 * @param extension 根据文件拓展名过滤，仅 type==file 时有效。每一项都不能是空字符串。默认不过滤。 - Filter based on file extension, only valid when type==file. Each item cannot be an empty string. No filtering by default.
 * @param appInfo 当前小程序信息 - The current mini program information
 * @param parentVC  呼起面板的vc - calls up the vc of the panel
 * @param completionBlock 回调 - callback
 */
- (void)chooseMessageFileWithCount:(NSInteger)count
                     type:(NSString *)type
                extension:(NSArray *)extension
                  appInfo:(TMFMiniAppInfo *)appInfo
                 parentVC:(UIViewController *)parentVC
          completionBlock:(void(^)(NSArray <TMAChooseMessageFileModel *> * _Nullable models,
                                   NSError * _Nullable error))completionBlock;


// 宿主App可以自定义分享途径、决定展示顺序，目前使用在点击更多按钮、button组件(open-type="share")呼起的ActionSheet中
// 1、默认渠道：QQ好友、QQ空间、微信、朋友圈（具体type参见MAUIDelegateShareViewType），由开发商决定，宿主App只能更改展示顺序
// 2、自定义分享渠道：宿主App自定义（type填MAUIDelegateShareViewTypeCustomizedShare，自定义MAShareTarget，建议大于100，在小程序页面中onShareAppMessage 回传分享内容，统一走shareMessageWithModel由宿主根据ShareTarget来分别处理）
// 3、自定义事件处理：宿主App自定义（type填MAUIDelegateShareViewTypeCustomizedAction）
// 以上三种渠道展示顺序支持混排
///
// The host App can customize the sharing path and determine the display order. It is currently used in the ActionSheet called up by clicking the more button or button component (open-type="share")
// 1. Default channels: QQ Friends, QQ Space, WeChat, Moments (for specific types, see MAUIDelegateShareViewType), decided by the developer, the host App can only change the display order
// 2. Customized sharing channel: Host App customization (type fills in MAUIDelegateShareViewTypeCustomizedShare, custom MAShareTarget, it is recommended to be greater than 100, in the mini program page, onShareAppMessage returns the sharing content, use shareMessageWithModel uniformly, and the host handles it separately according to ShareTarget)
// 3. Custom event processing: Host App customization (type fills in MAUIDelegateShareViewTypeCustomizedAction)
// The display order of the above three channels
- (NSArray<TMASheetItemInfo *> *)customizedConfigForShare;

// 宿主App可以自定义图片分享途径，API为showShareImageMenu
// The host App can customize the image sharing method, the API is showShareImageMenu
- (NSArray<TMASheetItemInfo *> *)customizedConfigForImageShare;

// 点击胶囊按钮后的默认分享渠道-MAShareTarget中的MAShareTargetQQ、MAShareTargetQzone、MAShareTargetWXFriends、MAShareTargetWXMoment（小程序配置的必须是App的子集）
// The default sharing channel after clicking the pill button - MAShareTarget （MAShareTargetQQ、MAShareTargetQzone、MAShareTargetWXFriends、MAShareTargetWXMoment）
// (The configuration of the mini program must be a subset of the App)
- (NSArray<NSNumber *> *)defaultSharingChannels;

// 定制点击胶囊按钮呼起的面板内容 - Customize the panel content that appears when clicking the more button
// @param otherButtonTitleAndActions 其他按钮及响应操作 - other buttons and response operations
// @param app 小程序信息 - Mini program information
- (void)customizedConfigForMoreButtonActions:(NSMutableArray *)moreButtonTitleAndActions withApp:(TMFMiniAppInfo *)app;

// 宿主App是否处于DarkMode模式
// Whether the host App is in DarkMode mode
// Deprecated
- (BOOL)isDarkMode __attribute__((deprecated("Use UIApplication.sharedApplication.keyWindow.overrideUserInterfaceStyle.")));

/**
 * @brief 创建自定义的授权窗口 - Create a custom authorization window
 *
 * @param frame 窗口大小 - The window size
 * @param scope 参考微信授权 scope - Refer to WeChat authorization scope
 * @param title 权限名称 - The permission name
 * @param desc 权限描述信息 - The permission description information
 * @param privacyApi 当前调用的api - The currently called api
 * @param appInfo 当前小程序信息 - The current mini program information
 * @param allowBlock 允许回调 - allows callbacks
 * @param denyBlock 拒绝回调 - deny callback
 */
- (UIView *)createAuthorizeAlertViewWithFrame:(CGRect)frame
                          scope:(NSString *)scope
                          title:(NSString *)title
                          desc:(NSString *)desc
                          privacyApi:(NSString *)privacyApi
                         appInfo:(TMFMiniAppInfo *_Nullable)appInfo
                          allowBlock:(void (^)(void))allowBlock
                           denyBlock:(void (^)(void))denyBlock;



// 通过AppInfo获取自定义的loading组件 - Get the custom loading component through AppInfo
// @param appInfo  小程序信息 -  Mini program Information
// @param frame  位置信息 - Frame information
- (nullable UIView *)customLoadingViewWithAppInfo:(TMFMiniAppInfo *_Nullable)appInfo
                                             frame:(CGRect)frame;

// 创建WebViewController - Create WebViewController
// @param model 参数model - Parameter model
- (UIViewController *)createWebViewController:(TMAWebViewVCModel *)model;

// 设置小程序打开时转场类型
// Set the transition type when the applet is opened
- (TMFSlideAnimationType )getTMFSlideAnimationType;

- (UIImageView *)createNetImageView;
- (UIView<TMABarrageViewProtocol>*)createBarrageView;

#pragma mark - 多媒体处理 - Multimedia
// 从选图器选择媒体 - Select media from the image picker
// @param model 配置 - configuration
// @param parentVC vc
// @param completionBlock 选择完毕后需要回传数据 根据所选类型接受 TMAPickerImageModel TMAPickerVideoModel - After the selection is completed, data needs to be returned. Accept TMAPickerImageModel TMAPickerVideoModel according to the selected type.
- (void)selectMediaFromPickerWithModel:(TMAMediaChooseConfigModel *)model
                              parentVC:(UIViewController *)parentVC
                       completionBlock:(void(^)(NSArray * _Nullable medias, NSError * _Nullable error))completionBlock;

// 拍摄媒体 - Shooting media
// @param model 配置 - configuration
// @param parentVC vc
// @param completionBlock 选择完毕后需要回传数据，根据所选类型接受TMACameraImageModel TMACameraVideoModel - After the selection is completed, data needs to be returned, and TMACameraImageModel TMACameraVideoModel is accepted according to the selected type.
- (void)selectMediaFromCameraWithModel:(TMAMediaChooseConfigModel *)model
                              parentVC:(UIViewController *)parentVC
                       completionBlock:(void(^)(id _Nullable media, NSError * _Nullable error))completionBlock;

// 从PHAsset中获取图片数据 - Get image data from PHAsset
// @param phAsset 媒体对象 - media object
// @param needCompress 是否需要压缩 - whether compression is required
- (NSData *)imageDataFromPhAsset:(PHAsset *)phAsset needCompress:(BOOL)needCompress;

// 图片预览 - Image Preview
// @param navigationController 呼起图片预览的导航栏 - calls up the navigation bar for image preview
// @param currentAbsoluteUrl 当前页面地址 - current page address
// @param absUrlsInPreviewArray 需要预览的图片 - Pictures to be previewed
- (void)navigationController:(UINavigationController *)navigationController
  presentImageWithCurrentUrl:(NSString *)currentAbsoluteUrl
               imageUrlArray:(NSArray *)absUrlsInPreviewArray;


// 打开文档预览 - Open document preview
// @param filePath 文档路径 - document path
// @param titleName 标题 - title
// @param appInfo 小程序appinfo - Mini program appinfo
- (void)openDocument:(NSString *)filePath
               title:(NSString *)titleName
             appInfo:(TMFMiniAppInfo *_Nonnull)appInfo;

#pragma mark - 分享相关 - Share
/**
 * @brief 分享的接口 - shared interface
 * @param shareModel 分享model - share model
 * @param appInfo 小程序appinfo - Mini program appinfo
 * @param completionBlock 回调 - callback
 */
- (void)shareMessageWithModel:(TMAShareModel *_Nonnull)shareModel
                  appInfo:(TMFMiniAppInfo *_Nonnull)appInfo
              completionBlock:(nullable void(^)(NSError * _Nullable error))completionBlock;

/**
 * @brief 分享在没有传imageURL情况下，获取默认的分享imageURL - When sharing without passing imageURL, get the default shared imageURL
 * @param appInfo 小程序appinfo - Mini program appinfo
 * @param shareTarget 分享类型 - share type
 */
- (NSString *_Nonnull)defaultImageURL:(TMFMiniAppInfo *_Nonnull)appInfo shareTarget:(MAShareTarget)shareTarget;

/**
 * @brief 开发者自定义组装的url链接 - The url link customized by the developer
 * @param appId 小程序id - The Mini program id
 * @param path 分享页面路径 - The share page path
 */
- (NSString *_Nonnull) customCopyUrl:(NSString *)appId path:(NSString *)path;


#pragma mark - 透传api处理 - Transparent API

// 扫码调用客户端的扫码模块scancode - Scan the code to call the client's scan code module scancode
// @param scanPrams 扫码参数字典 - scan code parameter dictionary
// @param navigationController 从那个页面呼起vc - calls vc from that page
// @param completionHandler 回调结果 - callback result
- (void)scanCode:(NSDictionary *)scanPrams
navigationController:(UINavigationController *)navigationController
completionHandler:(MACommonCallback)completionHandler;

// 发起支付 - Request payment
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)requestPayment:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;


// 发起小游戏道具直购支付 - Initiate direct purchase payment for mini-game props
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)requestMidasPaymentGameItem:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;

// login
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)login:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;


// checkSession
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)checkSession:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;

// getAccountInfoSync
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)getAccountInfoSync:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;


// getUserProfile
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)getUserProfile:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;

// getPhoneNumber
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)getPhoneNumber:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;

// getUserInfo
// @param app 小程序/小游戏实例 - Mini program/mini game instance
// @param params 参数 - parameters
// @param completionHandler 回调结果 - Result callback
- (void)getUserInfo:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler;

// 是否使用自定义OpenApi - whetherToUseCustomOpenApi 
// @param app 小程序/小游戏实例 - Mini program/mini game instance
- (BOOL)whetherToUseCustomOpenApi:(TMFMiniAppInfo *)app;
#pragma mark 截屏 录屏 水印 - Screen capture, screen recording, watermark
- (void)applet:(TMFMiniAppInfo *)appletInfo screenCaptureStatusChanged:(BOOL)isCapture atPagePath:(NSString *)pagePath;

- (void)appletDidTakeScreenshot:(TMFMiniAppInfo *)appletInfo atPagePath:(NSString *)pagePath;

- (nullable UIView *)appletCustomizeWatermarkView:(TMFMiniAppInfo *)appletInfo;

#pragma mark - wechat miniapp
// 使用微信ID、path打开接口 - Use WeChat ID and path to open the interface
// @param appID {String} 微信小程序ID，一般wx开头 - WeChat mini program ID, usually starting with wx
// @param path {String} 打开路径 - open path
// @param completion 回调函数 -  callback function
- (void)openWeAPPByAppID:(NSString *)appID
                    path:(NSString *)path
              completion:(void (^)(NSError *_Nullable error))completion;

#pragma mark - 退出挽留 - Exit retention
- (BOOL)shouldDetainUser:(TMFMiniAppInfo *)app;


#pragma mark - StartUp

// 处理启动过程中发生的错误
// Handle errors that occur during startup
- (void)handleStartUpError:(NSError *_Nonnull)error
                       app:(NSString *_Nullable)app
                  parentVC:(UIViewController *_Nonnull)parentVC;

// 小程序启动成功
// Mini program started successfully
- (void)handleStartUpSuccessWithApp:(TMFMiniAppInfo *_Nonnull)app;


// 将Application的生命周期处理透传出来，业务再去处理各自逻辑 - Transparently transmit the application life cycle processing, and the business will process its own logic.
// @param appInfo 小程序信息 - The mini program information
// @param type 状态 - The state
- (void)lifeCycleForApp:(TMFMiniAppInfo *)appInfo type:(TMAAppLifeCycleType)type;


// 解压zip - Unzip the zip
// @param sourcePath zip包路径 - The zip package path
// @param dstPath 目标路径 - The target path
// @param error 解压失败的error - Error for decompression failure
- (BOOL)unzipFileFromPath:(NSString *)sourcePath toDstPath:(NSString *)dstPath withError:(NSError **)error;

// 压缩zip - Compress zip
// @param path zip包路径 - The zip package path
// @param directoryPath 要压缩的目录路径 - The directory path to be compressed
// @param error 解压失败的error - Error for decompression failure
- (BOOL)zipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath withError:(NSError **)error;


#pragma mark -- 基础库 - Basic library
// 基础库更新控制 - Basic library update control
// @param libInfo 更新信息 包括version：版本号，url：下载地址，md5:下载文件 md5 - The update information including version: version number, url: download address, md5: download file md5
// @return 是否同意更新 - Whether agree to update
- (BOOL)canUpdateJSBaseLib:(NSDictionary *)libInfo;


#pragma mark - web-view组件相关 - web-view component related
// 宿主App可以返回一个自定义的WKWebView，目前用于
// 1. web-view组件：需要解决web-view组件中用xhr发送post请求body丢失问题
// 需要使用configuration初始化WKWebView，否则会导致 TCMPP 提供的 jssdk 失效
// The host App can return a customized WKWebView, currently used for
// 1. Web-view component: Need to solve the problem of body loss when sending post request using xhr in web-view component
// You need to use configuration to initialize WKWebView, otherwise the jssdk provided by TCMPP will become invalid.
- (WKWebView *)webViewWithConfiguration:(WKWebViewConfiguration *)configuration;


// web-view组件中跳转非http/https时触发，用于处理web-view组件中特殊url的情况，比如打开其它App - Triggered when redirecting to non-http/https in the web-view component. Used to handle special URLs in the web-view component, such as opening other apps.
// @param app {TMFMiniAppInfo} web-view组件所在的小程序信息 - Mini-program information where the web-view component is located
// @param url {NSURL} 要打开的url - The url to open
// @return 是否拦截处理 - Whether to intercept processing
- (BOOL)webViewCustomUrlLoading:(TMFMiniAppInfo *)app
                    url:(NSURL *)url;


#pragma mark -- 开发调试管理使用 - Development and debugging use

// ios16.4后是否开启inspectable，可以通过 safari 进行开发调试
// // Whether to enable inspectable after ios16.4, you can develop and debug through safari
- (BOOL)inspectableEnabled;

// 获取当前登录用户身份,saas版本不可用,仅供私有化版本使用，已弃用
// Get the current login user identity. The saas version is not available and is only available for the privatized version，has been deprecated
- (TMADevelopLoginMode)developLoginMode;

// 获取当前登录用户cookie信息,用于拉取预览/调试小程序包,saas版本不可用,仅供私有化版本使用，已弃用
// Get the cookie information of the currently logged in user, which is used to pull the preview/debug applet package. The saas version is not available and is only available for the privatized version，has been deprecated
- (NSDictionary *_Nullable)developLoginCookie;

// localserver 根目录和资源目录
// localserver root directory and resource directory
- (id)startLocalServerWithRoot:(NSString *)root resourceRoots:(NSArray *)resourceRoots;

#pragma mark - 上报 - Report
// 上报数据 - Report data
// @param event 事件,参考TMAReportEventID - Event Id，Reference TMAReportEventID
// @param eventName 事件名称 - Event Name
// @param params  参数 - params
// @param appInfo 小程序信息 - Mini program info
- (void)reportEvent:(int)eventId
          eventName:(NSString *)eventName
             params:(NSDictionary *)params
            appinfo:(TMFMiniAppInfo *)appInfo;

// 上报日志数据 - Report log data
// @param appId appID
// @param jsVersion 基础库版本 - The basic library version
// @param page 当前页面 - The current page
// @param filterMsgs  过滤内容 - The filter contents
// @param logs 日志事件 - Log events
// @param completionBlock  结果回调 - Callback result
// @return SDK内部是否上报 - Is the SDK internally reported?
- (BOOL)reportRealTimeLogWithAppId:(NSString *)appId
                         jsVersion:(NSString *)jsVersion
                              page:(NSString *)page
                        filterMsgs:(NSArray <NSString *>*)filterMsgs
                              logs:(NSArray <TMARealtimeLogItem *>*)logs
                   completionBlock:(void (^)(NSError * _Nullable error))completionBlock;

// 上传appID对应小程序的log - Upload the log of the applet corresponding to the appID
// 实现时，可以使用TMFMiniAppSDKManager的`sandBoxPathWithAppID:`接口获取沙箱路径，然后拼接`store/miniprogramLog/`获取 - When implementing, you can use the `sandBoxPathWithAppID:` interface of TMFMiniAppSDKManager to obtain the sandbox path, and then splice `store/miniprogramLog/` to obtain it.
// @param appID 小程序/小游戏的appID - The appID of mini program/mini game
// @return SDK内部是否上报 - Is the SDK internally reported?
- (BOOL)uploadLogFileWithAppID:(NSString *)appID;

#pragma mark - Live License
- (NSString *)setLiveLicenceURL;
- (NSString *)setLiveLicenceKey;


#pragma mark - App Config
// 处理当前app对于小程序引擎的一些配置项 - Process some configuration items of the current app for the mini program engine
// @param key 配置项key,参见TMAConfigDefine.h定义 - Configuration item key, see TMAConfigDefine.h definition
- (NSString*)stringWithConfigKey:(NSString *)key;

#pragma mark - 自定义播放器 - Custom player
- (id<TMAVideoPlayerDelegate>)app:(TMFMiniAppInfo *_Nonnull)app createVideoViewWithFrame:(CGRect)frame andVideoParams:(NSDictionary *)params;


#pragma mark - 暂未实现内容 - Content not implemented yet
// 置顶小程序 - Pin to top mini program
// @param appInfo 小程序appinfo - Mini program appinfo
// @param putTop 是否置顶  置顶(YES)  取消置顶(NO) - Whether to put it on top? Put it on top (YES) Cancel it (NO)
// @param completionHandler 置顶结果回调 -  Result callback

- (void)setMiniAppToTop:(TMFMiniAppInfo *)appInfo
                 putTop:(BOOL)putTop
      completionHandler:(MACommonCallback)completionHandler;

// 是否能够置顶小程序，最多只有10个置顶小程序(产品逻辑)
// Whether it is possible to pin mini programs to the top, there are only 10 pinned mini programs at most (product logic)
// @return BOOL
- (BOOL)canSetTopMiniApp;

// 判断某个 appInfo 是否为置顶 APP 要注意辨别开发版本和线上版本不是一样的
// To determine whether a certain appInfo is a pinned APP, pay attention to distinguish that the development version and the online version are not the same.
// @param  appInfo
// @return BOOL
- (BOOL)isTopMiniAppWithAppInfo:(TMFMiniAppInfo *)appInfo;


- (void)openChooseAddressWebVC:(NSString *)url
                 inApplication:(TMFMiniAppInfo *)app
               completionBlock:(void (^)(NSDictionary * _Nullable addressInfo, NSError * _Nullable error))completionBlock;


// 获取API上报list
// Get the API report list
- (BOOL)shouldReportAPICall:(NSString *)eventName;

- (void)openAppStoreWithURL:(NSURL *)url openBlock:(void(^)(void))openBlock;


#pragma mark - deprecated
// 调试是否开启
// Whether debugging is enabled
- (BOOL)vConsoleEnabled __deprecated;

@end


#endif /* TMFMiniAppSDKDelegate_h */

NS_ASSUME_NONNULL_END
