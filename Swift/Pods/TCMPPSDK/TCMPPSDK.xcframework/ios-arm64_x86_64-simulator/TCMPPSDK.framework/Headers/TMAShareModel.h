//
//  TMAShareModel.h
//  TMFMiniAppSDK
//

#import <Foundation/Foundation.h>
#import <TCMPPSDK/TMAModelUtils.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSInteger const TMAShareUserCancelErrorCode;

// 分享配置
// Share configuration
@interface TMAShareConfig : NSObject
// 分享ARK模版数据
// Share ARK template data
@property(nonatomic, assign, readonly) BOOL isFromShareButton;
@property(nonatomic, assign, readonly) MAShareTarget shareTarget;
// 分享类型，比如picture图片分享
// Sharing type, such as picture sharing
@property(nonatomic, strong, readonly) NSString *shareType;
// 是否从详情页点击过来的分享
// Whether to share clicked from the details page
@property(nonatomic, assign, readonly) BOOL isFromDetailPage;
// 是否需要带shareTicket
// Whether to bring shareTicket
@property(nonatomic, assign, readonly) NSInteger shareWithTicket;

// 通过jsplugin params构造
// Constructed through jsplugin params
- (instancetype)initWithParams:(NSDictionary *)params;

@end


// 分享数据
// Share data
@interface TMAShareModel : NSObject
// 分享标题
// share title
@property(nonatomic, strong, readonly) NSString *title;
// 分享图片，可以是http(s)或者本地图片
// Share pictures, which can be http(s) or local pictures
@property(nonatomic, strong, readonly) NSString *imageUrl;
// 分享页面路径
// Share page path
@property(nonatomic, strong, readonly) NSString *path;
// 分享路径参数
// Share path parameters
@property(nonatomic, strong, readonly) NSString *query;
// 昵称
// Nick name
@property(nonatomic, strong, readonly) NSString *nickName;
// 视频分享
// Video sharing
@property(nonatomic, strong, readonly) NSString *vidUrl;
// 如果对应设备不支持小程序，兜底webpage
// If the corresponding device does not support mini programs, use the webpage
@property(nonatomic, strong, readonly) NSString *generalWebpageUrl;
// openid分享，用于小游戏开放数据域
// openid sharing, used in the open data domain of mini games
@property(nonatomic, strong, readonly) NSString *openId;
// 分享ARK模版ID
// Share ARK template ID
@property(nonatomic, strong, readonly) NSString *shareTemplateId;
// 分享ARK模版数据
// Share ARK template data
@property(nonatomic, strong, readonly) NSDictionary *shareTemplateData;
// 分享配置
// Share configuration
@property(nonatomic, strong, readonly) TMAShareConfig *config;
// 哪个api调用的 for数据上报
// Which api calls for data reporting?
@property(nonatomic, strong) NSString *eventName;

// 给宿主格式为 {"jump_url":"https://m.q.qq.com/minisdk/s/30d1b3d0f2b28741c477f47b8910f0e3"}
// The format for the host is {"jump_url":"https://m.q.qq.com/minisdk/s/30d1b3d0f2b28741c477f47b8910f0e3"}
@property(nonatomic, strong) NSString *dataToShare;                      // 分享数据

// 通过jsplugin params构造
// Constructed through jsplugin params
- (instancetype)initWithParams:(NSDictionary *)params;

// 从详情页分享的构造方法
// Construction method shared from details page
- (instancetype)initWithTitle:(NSString *)title imageURL:(NSString *)imageURL isFromDetailPage:(BOOL)isFromDetailPage;

@end



NS_ASSUME_NONNULL_END
