//
//  TMAEntryModel.h
//  MiniAppSDK
//

#import <Foundation/Foundation.h>
#import <TCMPPSDK/TMAHostModel.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMAEntryModelType) {
    TMAEntryModelTypeNone,
    TMAEntryModelTypeC2C,
    TMAEntryModelTypeDiscuss,
    TMAEntryModelTypeHost,
};

// 小程序的弹出样式
// Pop-up style of mini program
typedef NS_ENUM(NSUInteger, TMAPresentModelType) {
    TMAPresentModelTypeNormal, // 常规  normal
    TMAPresentModelTypeHalfScreen // 半屏 half screen
};

@interface TMAC2CModel : NSObject

@property (nonatomic, strong) NSString *uin;
@property (nonatomic, strong) NSString *name;

@end

typedef NS_ENUM(NSUInteger, TMAEntryIdentity) {
    TMAEntryIdentityNone,
    TMAEntryIdentityGroupMemeber = 1,
    TMAEntryIdentityGroupManager = 2,
    TMAEntryIdentityGroupAdmin = 3,
    TMAEntryIdentityGroupOther,
};

@protocol TMANavigationItemProtocol;

@interface TMAEntryModel : NSObject
// 小程序展示模式
// Mini program display mode
@property (nonatomic, assign) TMAPresentModelType presentModelType;
@property (nonatomic, assign) TMAEntryModelType entryType;
@property (nonatomic, nullable, strong) TMAC2CModel *c2cModel; // TMAEntryModelTypeC2C
@property (nonatomic, nullable, strong) TMAHostModel *hostModel; // TMAEntryModelTypeHost
// 导航栏样式的是实现实例
// The navigation bar style is an implementation example
@property (nonatomic, nullable, strong) id<TMANavigationItemProtocol> navigationItem;
// 携带的额外参数
//Extra parameters carried
@property (nonatomic, nullable, strong) NSString *extraData;
// 关闭时是否强制杀掉应用
// Whether to force kill the application when closing
@property (nonatomic, assign) BOOL isTerminateOnClose;

- (NSString *_Nullable)entryDataHash;

@end

NS_ASSUME_NONNULL_END
