//
//  TMAModelUtils.h
//  MiniAppSDK
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <TCMPPSDK/TMAEntryModel.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MAUIDelegateShareViewType) {
    MAUIDelegateShareViewTypeNone,
    // Debug
    MAUIDelegateShareViewTypeDebug,
    // 导出vConsole log
    // Export vConsole log
    MAUIDelegateShareViewTypevConsoleLog,
    // 关闭性能窗口
    // Close performance window
    MAUIDelegateShareViewTypePerformanceClose,
    // 打开性能窗口
    // Open performance window
    MAUIDelegateShareViewTypePerformanceOpen,
    // 关闭调试
    // Turn off debugging
    MAUIDelegateShareViewTypevConsoleClose,
    // 打开调试
    // Turn on debugging
    MAUIDelegateShareViewTypevConsoleOpen,
    // 举报、投诉与反馈
    // Report, Complaint and Feedback
    MAUIDelegateShareViewTypeComplaint,
    // 打开设置页
    // Open the settings page
    MAUIDelegateShareViewTypeSetting,
    // 关于
    // About
    MAUIDelegateShareViewTypeAbout,
    // 添加到收藏
    // add to collection
    MAUIDelegateShareViewTypeFavorites,
    // 回到首页
    // Back to the homepage
    MAUIDelegateShareViewTypeHomePage,
    // 桌面快捷方式
    // Desktop shortcut
    MAUIDelegateShareViewTypeShortcut,
    
    // 分享
    // share
    // 宿主App自定义分享
    // Host App custom sharing
    MAUIDelegateShareViewTypeCustomizedShare,
    // 微信朋友圈
    // WeChat Moments
    MAUIDelegateShareViewTypeWechatMoment,
    // 微信
    // WeChat
    MAUIDelegateShareViewTypeWechatFriend,
    // QQ空间
    // QQ zone
    MAUIDelegateShareViewTypeQZone,
    // QQ频道
    // QQ guild
    MAUIDelegateShareViewTypeGuild,
    // QQ好友
    // QQ friends
    MAUIDelegateShareViewTypeFriend,

    // 录屏
    // Record screen
    // 开始录屏
    // Start recording screen
    MAUIDelegateShareViewTypeScreenRecorderStart,
    // 停止录屏
    // Stop recording screen
    MAUIDelegateShareViewTypeScreenRecorderStop,
    
    //自定义动作
    //Custom action
    // 宿主App自定义
    // Host App customization
    MAUIDelegateShareViewTypeCustomizedAction,
    
    // 复制链接
    // copy Link
    MAUIDelegateShareViewTypeCopyLink,
    
    // 相册分享
    // Album sharing
    // 发送给朋友
    // Send to friend
    MAUIDelegateShareViewTypeSendWXFriends,
    // 保存到相册
    // Save into the album
    MAUIDelegateShareViewTypeSavePhotosAlbum,
};

// 分享目标
typedef NS_ENUM(NSUInteger, MAShareTarget) {
    // 分享到QQ
    // Share to QQ
    MAShareTargetQQ = 0,
    // 分享到Qzone
    // Share to Qzone
    MAShareTargetQzone,
    // 分享到QQ，快速分享到当前聊天窗口
    // Share to QQ, quickly share to the current chat window
    MAShareTargetQQFastForward,
    // 微信好友
    // WeChat friends
    MAShareTargetWXFriends,
    // 微信朋友圈
    // WeChat Moments
    MAShareTargetWXMoment,
    // 最近联系人快速分享，从分享面板点击触发
    // Quick sharing of recent contacts, triggered by clicking on the sharing panel
    MAShareTargetChatFastShare,
    // 快捷分享好友列表
    //Quickly share friends list
    MAShareTargetFastShareTable,
    // openId分享，来源小游戏的开放数据域点后后分享
    // openId sharing, click and share the open data domain of the source mini game
    MAShareTargetOpenIdShare,
    MAShareTargetGuild,
    
    
    //客户可自定义ShareTarget，建议大于100
    //Customers can customize ShareTarget, it is recommended to be greater than 100
    
};

typedef NS_ENUM(NSInteger, TMAToastIconType) {
    TMAToastIconTypeNone,
    TMAToastIconTypeSuccess,
    TMAToastIconTypeLoading,
    TMAToastIconTypeWarn,
};

@interface TMAToastInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *image;
@property (nonatomic, assign) TMAToastIconType iconType;
// 显示时长，毫秒单位
//Display duration in milliseconds
@property (nonatomic, assign) CGFloat duration;
// 是否显示透明蒙层，防止触摸穿透
// Whether to display a transparent mask to prevent touch penetration
@property (nonatomic, assign) BOOL mask;

// 在parentView居中展示，为空的话toast会展示在主window上
// Display in the center of parentView. If it is empty, toast will be displayed on the main window.
@property (nonatomic, strong, nullable) UIView *parentView;

@property (nonatomic, assign) NSInteger webviewID;

- (instancetype)initWithTitle:(NSString *)title icon:(TMAToastIconType)icon duration:(CGFloat)duration;

@end

@interface TMALoadingInfo : NSObject

@property (nonatomic, copy, nullable) NSString *title;
// 是否显示透明蒙层，防止触摸穿透
// Whether to display a transparent mask to prevent touch penetration
@property (nonatomic, assign) BOOL mask;
// 是否走自定义的loading
// Whether to use custom loading
@property (nonatomic, assign) BOOL custom;
// 是否走容器化
// Whether to use containerization
@property (nonatomic, assign) BOOL inWebContainer;
// 容器化webviewId
// Containerized webviewId
@property (nonatomic, assign) NSInteger webviewID;
// 在parentView居中展示，为空的话loading会展示在主window上
// Display in the center of parentView. If it is empty, loading will be displayed on the main window.
@property (nonatomic, strong, nullable) UIView *parentView;

@end

@interface TMASheetActionParams : NSObject

@property (nonatomic, copy) NSString *menuId;

@end

@interface TMASheetItemInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^action)(TMASheetActionParams * _Nullable params);
@property (nonatomic, assign) MAUIDelegateShareViewType type;
//用于type == MAUIDelegateShareViewTypeCustomizedShare时，自定义的shareTarget
//Used for type == MAUIDelegateShareViewTypeCustomizedShare, customized shareTarget
@property (nonatomic, assign) NSUInteger shareTarget;
//用于type == MAUIDelegateShareViewTypeCustomizedShare时，自定义的shareKey
//Used for type == MAUIDelegateShareViewTypeCustomizedShare, customized shareKey
@property (nonatomic, copy) NSString *shareKey;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *menuId;
@property (nonatomic, assign) BOOL isHidden;

- (instancetype)initWithTitle:(NSString *)title action:(void (^  _Nullable)(TMASheetActionParams * _Nullable params))action;
- (instancetype)initWithTitle:(NSString *)title
                         type:(MAUIDelegateShareViewType)type
                       action:(void (^  _Nullable)(TMASheetActionParams * _Nullable params))action;
- (instancetype)initWithTitle:(NSString *)title
                         type:(MAUIDelegateShareViewType)type
                         shareTarget:(NSUInteger)shareTarget;
- (instancetype)initWithTitle:(NSString *)title
                         type:(MAUIDelegateShareViewType)type
                         shareTarget:(NSUInteger)shareTarget
                         shareKey:(NSString *)shareKey;


@end


#pragma mark - chooseImage chooseVideo

typedef NS_ENUM(NSInteger, TMAMediaChooseType) {
    TMAMediaChooseTypeImage,
    TMAMediaChooseTypeVideo,
};

typedef NS_OPTIONS(NSUInteger, TMAMediaChooseTypeMask) {
    TMAMediaChooseTypeMaskImage = 1 << TMAMediaChooseTypeImage,
    TMAMediaChooseTypeMaskVideo = 1 << TMAMediaChooseTypeVideo,
    TMAMediaChooseTypeMaskAll = TMAMediaChooseTypeMaskImage | TMAMediaChooseTypeMaskVideo,
};

typedef NS_ENUM(NSInteger, TMAMediaCompressType) {
    TMAMediaCompressTypeOriginal,
    TMAMediaCompressTypeCompress,
};

typedef NS_OPTIONS(NSUInteger, TMAMediaCompressTypeMask) {
    TMAMediaCompressTypeMaskOriginal = 1 << TMAMediaCompressTypeOriginal,
    TMAMediaCompressTypeMaskCompress = 1 << TMAMediaCompressTypeCompress,
};

@interface TMAMediaChooseVideoConfig : NSObject
// 针对视频
// for video
@property (nonatomic, assign) NSInteger maxVideoDuration;
// 最大文件大小
//Maximum file size
@property (nonatomic, assign) NSInteger maxVideoFileSize;

@property (nonatomic, assign) BOOL isFront;
// 视频处理完毕后会执行的block
//The block that will be executed after the video processing is completed
@property (nonatomic, copy) void(^processCompletionBlock)(void);

@end

@interface TMAMediaChooseConfigModel : NSObject

@property (nonatomic, assign) TMAMediaChooseTypeMask chooseTypeMask;
@property (nonatomic, assign) TMAMediaCompressTypeMask compressTypeMask;
@property (nonatomic, assign) NSInteger maxCount;
// 视频参数
//Video parameters
@property (nonatomic, strong) TMAMediaChooseVideoConfig *videoConfig;

@end

@interface TMAPickerImageModel : NSObject
// 用户是否勾选了原图按钮
// Whether the user checked the original image button
@property (nonatomic, assign) BOOL isOriginal;
@property (nonatomic, strong) PHAsset *asset;
// 如果有会优先使用image
// If available, image will be used first
@property (nonatomic, strong) UIImage *image;

@end

@interface TMAPickerVideoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@end

@interface TMACameraImageModel : NSObject

@property (nonatomic, strong) UIImage *image;

@end

@interface TMACameraVideoModel : NSObject

@property (nonatomic, strong) AVURLAsset *asset;

@end

@interface TMAWebViewVCModel : NSObject

// 跳转的 url
// Jump url
@property (nonatomic, copy) NSString *url;
// HTTP Request Referer 
@property (nonatomic, copy) NSString *referrer;
// 跳转检查
// Jump check
@property (nonatomic, copy) BOOL(^decidePolicy)(NSURL *url, void (^decisionHandler)(WKNavigationActionPolicy));
// 是否强制竖屏展示
// Whether to force vertical screen display
@property (nonatomic, assign) BOOL forcePortrait;

@end

NS_ASSUME_NONNULL_END
