//
//  MiniAppDemoSDKDelegateImpl.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "MIniAppDemoSDKDelegateImpl.h"
#import "TCMPPDemoLoginManager.h"
#import "ToastView.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "PaymentManager.h"
#import "LanguageManager.h"
#import "TCMPPPaySucessVC.h"
#import <objc/runtime.h>
#import "TCMPPPayView.h"

@implementation MiniAppDemoSDKDelegateImpl

+ (instancetype)sharedInstance {
    static MiniAppDemoSDKDelegateImpl *_imp;
    static dispatch_once_t _token;
    dispatch_once(&_token, ^{
        _imp = [MiniAppDemoSDKDelegateImpl new];
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
    return [[TCMPPDemoLoginManager sharedInstance] getUserId];
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
        userInfo.nickName = [TCMPPUserInfo sharedInstance].nickName;
        block(userInfo);
    }
}

- (void)getUserInfo:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    //example code
    if (completionHandler) {
        completionHandler(@{
            @"nickName": [TCMPPUserInfo sharedInstance].nickName,
            @"avatarUrl": [TCMPPUserInfo sharedInstance].avatarUrl,
            @"gender": [NSNumber numberWithUnsignedInt:[TCMPPUserInfo sharedInstance].gender],
            @"country": [TCMPPUserInfo sharedInstance].country,
            @"province": [TCMPPUserInfo sharedInstance].province,
            @"city": [TCMPPUserInfo sharedInstance].city,
            @"language": @"zh_CN"
        },
            nil);
    }
}

- (void)getUserProfile:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    //example code
    if (completionHandler) {
        completionHandler(@{
            @"nickName": [TCMPPUserInfo sharedInstance].nickName,
            @"avatarUrl": [TCMPPUserInfo sharedInstance].avatarUrl,
            @"gender": [NSNumber numberWithUnsignedInt:[TCMPPUserInfo sharedInstance].gender],
            @"country": [TCMPPUserInfo sharedInstance].country,
            @"province": [TCMPPUserInfo sharedInstance].province,
            @"city": [TCMPPUserInfo sharedInstance].city,
            @"language": @"zh_CN"
        },
            nil);
    }
}

// After receiving the payment request from the mini program, the App uses the prepayId parameter in params to first call the order query interface to obtain detailed order information.
// Then a pop-up window will pop up requesting the user to enter the payment password.
// After the user successfully enters the password, the payment interface will be called. After success, the corresponding result will be returned to the mini program.
- (void)requestPayment:(TMFMiniAppInfo *)app params:(NSDictionary *)params completionHandler:(MACommonCallback)completionHandler {
    
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
- (BOOL)whetherToUseCustomOpenApi:(TMFMiniAppInfo *)app{
    return YES;
}
- (UIView *)createAuthorizeAlertViewWithFrame:(CGRect)frame scope:(NSString *)scope title:(NSString *)title desc:(NSString *)desc privacyApi:(NSString *)privacyApi appInfo:(TMFMiniAppInfo *)appInfo allowBlock:(void (^)(void))allowBlock denyBlock:(void (^)(void))denyBlock {
    // Create the main view
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // Creating a Background View
    CGFloat backgroundWidth = MIN(frame.size.width, frame.size.height) * 0.8;
    CGFloat backgroundHeight = 300; // Adjust height according to content
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - backgroundWidth) / 2,
                                                                     (frame.size.height - backgroundHeight) / 2,
                                                                     backgroundWidth,
                                                                     backgroundHeight)];
    backgroundView.layer.cornerRadius = 12;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backgroundView];
    
    // Add a title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, backgroundWidth - 40, 30)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [backgroundView addSubview:titleLabel];
    
    // Add a description
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, backgroundWidth - 40, 100)];
    descLabel.text = desc;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.textColor = [UIColor darkGrayColor];
    descLabel.numberOfLines = 0;
    [backgroundView addSubview:descLabel];
    
    // Add a button
    CGFloat buttonWidth = (backgroundWidth - 60) / 2;
    CGFloat buttonHeight = 44;
    CGFloat buttonY = backgroundHeight - buttonHeight - 20;
    
    // Reject Button
    UIButton *denyButton = [[UIButton alloc] initWithFrame:CGRectMake(20, buttonY, buttonWidth, buttonHeight)];
    [denyButton setTitle:@"Reject" forState:UIControlStateNormal];
    [denyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    denyButton.layer.cornerRadius = 8;
    denyButton.layer.borderWidth = 1;
    denyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [denyButton addTarget:self action:@selector(handleDenyButton:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(denyButton, "denyBlock", denyBlock, OBJC_ASSOCIATION_COPY);
    [backgroundView addSubview:denyButton];
    
    // 允许按钮
    UIButton *allowButton = [[UIButton alloc] initWithFrame:CGRectMake(backgroundWidth - buttonWidth - 20, buttonY, buttonWidth, buttonHeight)];
    [allowButton setTitle:@"Allow" forState:UIControlStateNormal];
    [allowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    allowButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0]; // 使用蓝色主题
    allowButton.layer.cornerRadius = 8;
    [allowButton addTarget:self action:@selector(handleAllowButton:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(allowButton, "allowBlock", allowBlock, OBJC_ASSOCIATION_COPY);
    [backgroundView addSubview:allowButton];
    
    
    return view;
}

// Handling Allow Button Click
- (void)handleAllowButton:(UIButton *)button {
    void (^allowBlock)(void) = objc_getAssociatedObject(button, "allowBlock");
    if (allowBlock) {
        allowBlock();
    }
    [button.superview.superview removeFromSuperview];
}

// Handling the Reject Button Click
- (void)handleDenyButton:(UIButton *)button {
    void (^denyBlock)(void) = objc_getAssociatedObject(button, "denyBlock");
    if (denyBlock) {
        denyBlock();
    }
    [button.superview.superview removeFromSuperview];
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
