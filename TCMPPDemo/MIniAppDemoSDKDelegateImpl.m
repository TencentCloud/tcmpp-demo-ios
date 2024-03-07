//
//  MIniAppDemoSDKDelegateImpl.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "MIniAppDemoSDKDelegateImpl.h"
#import "TMFMiniAppSDKManager.h"
#import "TMAConfigDefine.h"
#import "DemoUserInfo.h"

@implementation MIniAppDemoSDKDelegateImpl

+ (instancetype)sharedInstance {
    static MIniAppDemoSDKDelegateImpl *_imp;
    static dispatch_once_t _token;
    dispatch_once(&_token, ^{
        _imp = [MIniAppDemoSDKDelegateImpl new];
    });
    return _imp;
}

- (void)log:(MALogLevel)level msg:(NSString *)msg {
    NSString *strLevel = nil;
    switch (level) {
        case MALogLevelError:
            strLevel = @"Error";
            break;
        case MALogLevelWarn:
            strLevel = @"Warn";
            break;
        case MALogLevelInfo:
            strLevel = @"Info";
            break;
        case MALogLevelDebug:
            strLevel = @"Debug";
            break;
        default:
            strLevel = @"Undef";
            break;
    }
    NSLog(@"TMFMiniApp %@|%@", strLevel, msg);
}

- (NSString *)getAppUID {
    return [DemoUserInfo sharedInstance].nickName;
}

- (void)handleStartUpSuccessWithApp:(TMFMiniAppInfo *)app {
    NSLog(@"start sucess %@", app);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.tencent.tcmpp.apps.change.notification" object:nil];
}

- (void)handleStartUpError:(NSError *)error app:(NSString *)app parentVC:(id)parentVC {
    NSLog(@"start fail %@ %@", app, error);
}

- (nonnull NSString *)appName {
    return @"TCMPP";
}

- (void)fetchAppUserInfoWithScope:(NSString *)scope block:(TMAAppFetchUserInfoBlock)block {
    if (block) {
        UIImage *defaultAvatar =
            [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"avatar.png"]];
        UIImageView *avatarView = [[UIImageView alloc] initWithImage:defaultAvatar];
        TMAAppUserInfo *userInfo = [TMAAppUserInfo new];
        userInfo.avatarView = avatarView;
        userInfo.nickName = [DemoUserInfo sharedInstance].nickName;
        block(userInfo);
    }
}

- (void)getUserInfo:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    //example code
    if (completionHandler) {
        completionHandler(@{
            @"nickName": [DemoUserInfo sharedInstance].nickName,
            @"avatarUrl": [DemoUserInfo sharedInstance].avatarUrl,
            @"gender": [NSNumber numberWithUnsignedInt:[DemoUserInfo sharedInstance].gender],
            @"country": [DemoUserInfo sharedInstance].country,
            @"province": [DemoUserInfo sharedInstance].province,
            @"city": [DemoUserInfo sharedInstance].city,
            @"language": @"zh_CN"
        },
            nil);
    }
}

- (void)getUserProfile:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    //example code
    if (completionHandler) {
        completionHandler(@{
            @"nickName": [DemoUserInfo sharedInstance].nickName,
            @"avatarUrl": [DemoUserInfo sharedInstance].avatarUrl,
            @"gender": [NSNumber numberWithUnsignedInt:[DemoUserInfo sharedInstance].gender],
            @"country": [DemoUserInfo sharedInstance].country,
            @"province": [DemoUserInfo sharedInstance].province,
            @"city": [DemoUserInfo sharedInstance].city,
            @"language": @"zh_CN"
        },
            nil);
    }
}

- (void)shareMessageWithModel:(TMAShareModel *)shareModel
                      appInfo:(TMFMiniAppInfo *)appInfo
              completionBlock:(void (^)(NSError *_Nullable))completionBlock {
    NSLog(@"shareMessageWithModel %lu", (unsigned long)shareModel.config.shareTarget);
}

- (void)uploadLogFileWithAppID:(NSString *)appID {
    NSString *path = [[TMFMiniAppSDKManager sharedInstance] sandBoxPathWithAppID:appID];

    path = [path stringByAppendingPathComponent:@"usr/miniprogramLog/"];

    NSLog(@"%@", path);
}

- (BOOL)inspectableEnabled {
    return YES;
}

@end
