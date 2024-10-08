//
//  MiniAppDemoSDKDelegateImpl.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "MiniAppDemoSDKDelegateImpl.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "TCMPPPayView.h"
#import "DemoUserInfo.h"
#import "PaymentManager.h"
#import "TCMPPLoginManager.h"
#import "LanguageManager.h"
#import "TCMPPPaySucessVC.h"

static BOOL noServer = YES;

@implementation MiniAppDemoSDKDelegateImpl

+ (instancetype)sharedInstance {
    static MiniAppDemoSDKDelegateImpl *_imp;
    static dispatch_once_t _token;
    dispatch_once(&_token, ^{
        _imp = [MiniAppDemoSDKDelegateImpl new];
    });
    return _imp;
}

- (BOOL)noServer{
    return noServer;
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

- (NSString *)getCurrentLocalLanguage {
    return [[LanguageManager shared] currentLanguage];
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

// After the App receives the login request from the mini program, it first determines whether the App is logged in based on whether the token exists.
// If it is not logged in, log in first; if it is logged in, it calls the getToken interface to obtain the code and sends it back to the mini program.
- (void)login:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    if (noServer) {
        if(completionHandler) {
            completionHandler(@{@"code":@"KQGGAY"},nil);
        }
        return;
    }
    
    
    [[TCMPPLoginManager sharedInstance] wxLogin:app.appId completionHandler:^(NSError * _Nullable err, NSString * _Nullable value) {
        if(completionHandler) {
            if(err) {
                completionHandler(nil,err);
            } else {
                completionHandler(@{@"code":value},nil);
            }
        }
    }];
}

// After receiving the payment request from the mini program, the App uses the prepayId parameter in params to first call the order query interface to obtain detailed order information.
// Then a pop-up window will pop up requesting the user to enter the payment password.
// After the user successfully enters the password, the payment interface will be called. After success, the corresponding result will be returned to the mini program.
- (void)requestPayment:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    if (noServer) {
        TCMPPPayView *payAlert = [[TCMPPPayView alloc] init];
        payAlert.title = NSLocalizedString(@"Please enter the payment password", nil);
        payAlert.detail = NSLocalizedString(@"Payment", nil);
        payAlert.money = 1274.88;
        payAlert.defaultPass = NSLocalizedString(@"Default password:666666", nil);
        [payAlert show];
        payAlert.completeHandle = ^(NSString *inputPassword) {
            if (inputPassword) {
                if ([inputPassword isEqualToString:@"666666"]) {
                    TCMPPPaySucessVC *vc = [[TCMPPPaySucessVC alloc] init];
                    vc.iconURL = app.appIcon;
                    vc.name = app.appTitle;
                    vc.price = 1274.88;
                    vc.dismissBlock = ^{
                        completionHandler(@{@"pay_time":@([[NSDate date] timeIntervalSince1970]),@"order_no":@"10086"},nil);
                    };
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    UIViewController *current = UIApplication.sharedApplication.keyWindow.rootViewController;
                    if ([current.presentedViewController isKindOfClass:UINavigationController.class]) {
                        UINavigationController *nav = (UINavigationController *)current.presentedViewController;
                        [nav.topViewController presentViewController:vc animated:YES completion:nil];
                    }
                    return;
                } else {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"wrong password" forKey:@"errMsg"];
                    NSError *error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
                    completionHandler(@{@"retmsg":error.localizedDescription},error);
                }
            }
        };
        payAlert.cancelHandle = ^(void) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"pay cancel" forKey:@"errMsg"];
            NSError *error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
            completionHandler(@{@"retmsg":error.localizedDescription},error);
        };
        return;
    }
    
    NSString *prePayId = params[@"prepayId"];
    [PaymentManager checkPreOrder:prePayId completion:^(NSError * _Nullable err, NSDictionary * _Nullable result) {
        if (!err) {
            NSString *tradeNo = result[@"out_trade_no"];
            NSString *prePayId = result[@"prepay_id"];
            NSInteger totalFee = [result[@"total_fee"] integerValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Note: This is just a simple demo, so there is a default password
                TCMPPPayView *payAlert = [[TCMPPPayView alloc] init];
                payAlert.title = NSLocalizedString(@"Please enter the payment password", nil);
                payAlert.detail = NSLocalizedString(@"Payment", nil);
                payAlert.money = totalFee;
                payAlert.defaultPass = NSLocalizedString(@"Default password:666666", nil);
                [payAlert show];
                payAlert.completeHandle = ^(NSString *inputPassword) {
                    if (inputPassword) {
                        if ([inputPassword isEqualToString:@"666666"]) {
                            // Note: The payment interface is only a simple example. Both the client's signature and the server's signature verification are omitted.
                            // For the signature algorithm, please refer to WeChat Pay’s signature algorithm:
                            // https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=4_3
                            [PaymentManager payOrder:tradeNo prePayId:prePayId totalFee:totalFee completion:^(NSError * _Nullable err, NSDictionary * _Nullable result) {
                                if (!err) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        TCMPPPaySucessVC *vc = [[TCMPPPaySucessVC alloc] init];
                                        vc.iconURL = app.appIcon;
                                        vc.name = app.appTitle;
                                        vc.price = totalFee;
                                        vc.dismissBlock = ^{
                                            completionHandler(@{@"pay_time":@([[NSDate date] timeIntervalSince1970]),@"order_no":tradeNo},nil);
                                        };
                                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                        UIViewController *current = UIApplication.sharedApplication.keyWindow.rootViewController;
                                        if ([current.presentedViewController isKindOfClass:UINavigationController.class]) {
                                            UINavigationController *nav = (UINavigationController *)current.presentedViewController;
                                            [nav.topViewController presentViewController:vc animated:YES completion:nil];
                                        }
                                    });
                                    return;
                                } else {
                                    completionHandler(@{@"retmsg":err.localizedDescription},err);
                                }
                            }];
                        } else {
                            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"wrong password" forKey:@"errMsg"];
                            NSError *error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
                            completionHandler(@{@"retmsg":error.localizedDescription},error);
                        }
                    }
                };
                payAlert.cancelHandle = ^(void) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"pay cancel" forKey:@"errMsg"];
                    NSError *error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
                    completionHandler(@{@"retmsg":error.localizedDescription},error);
                };
                
            });
        } else {
            completionHandler(@{@"retmsg":err.localizedDescription},err);
        }
    }];
}

- (void)shareMessageWithModel:(TMAShareModel *)shareModel
                      appInfo:(TMFMiniAppInfo *)appInfo
              completionBlock:(void (^)(NSError *_Nullable))completionBlock {
    NSLog(@"shareMessageWithModel %lu", (unsigned long)shareModel.config.shareTarget);
}

- (BOOL)uploadLogFileWithAppID:(NSString *)appID {
    NSString *path = [[TMFMiniAppSDKManager sharedInstance] sandBoxPathWithAppID:appID];

    path = [path stringByAppendingPathComponent:@"usr/miniprogramLog/"];

    NSLog(@"%@", path);
    return NO;
}

- (BOOL)inspectableEnabled {
    return YES;
}

@end
