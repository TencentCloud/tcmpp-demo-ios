//
//  AppDelegate.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "DemoUserInfo.h"
#import "TMFAppletConfigManager.h"
#import "MiniAppDemoSDKDelegateImpl.h"
#import "TCMPPLoginVC.h"
#import "TCMPPMainVC.h"
#import "TCMPPDemoLoginManager.h"
#import "ToastView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self prepareApplet];
    
    [self autoLogin];
    
    return YES;
}

- (void)autoLogin {
    NSString *currentUser = [DemoUserInfo sharedInstance].nickName;
    if (currentUser.length > 0) {
        TCMPPMainVC *rootViewController = [[TCMPPMainVC alloc] init];
        UINavigationController * navGationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        self.window.rootViewController = navGationController;
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            appearance.backgroundColor = UIColor.whiteColor;
            [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
            appearance.shadowColor = [UIColor clearColor];
            navGationController.navigationBar.standardAppearance = appearance;
            navGationController.navigationBar.scrollEdgeAppearance = appearance;
        } else {
            navGationController.navigationBar.barTintColor = UIColor.whiteColor;
            [navGationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        }
        [[TCMPPDemoLoginManager sharedInstance] loginUser:currentUser completeion:^(NSError * _Nullable err, NSString * _Nullable value) {
            if (!err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *icon = [UIImage imageNamed:@"success"];
                    ToastView *toast = [[ToastView alloc] initWithIcon:icon title:NSLocalizedString(@"Logged in successfully",nil)];
                    [toast showWithDuration:2];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
                    TCMPPLoginVC *loginVC = [[TCMPPLoginVC alloc] init];
                    self.window.rootViewController = loginVC;
                });
            }
        }];
    } else {
        TCMPPLoginVC *loginVC = [[TCMPPLoginVC alloc] init];
        self.window.rootViewController = loginVC;
    }
    [self.window makeKeyAndVisible];
}

- (void)prepareApplet {
    [TMFMiniAppSDKManager sharedInstance].miniAppSdkDelegate = [MiniAppDemoSDKDelegateImpl sharedInstance];

    TMFAppletConfigItem *item  = [[TMFAppletConfigManager sharedInstance] getCurrentConfigItem];
    if(item) {
        TMAServerConfig *config  = [[TMAServerConfig alloc] initWithSting:item.content];
        [[TMFMiniAppSDKManager sharedInstance] setConfiguration:config];
    } else {
        //配置使用环境
        //Configure usage environment
       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tcsas-ios-configurations" ofType:@"json"];
       if(filePath) {
           TMAServerConfig *config  = [[TMAServerConfig alloc] initWithFile:filePath];
           [[TMFMiniAppSDKManager sharedInstance] setConfiguration:config];
       }
        
        NSString *customApiFile = [[NSBundle mainBundle] pathForResource:@"api-custom-config" ofType:@"json"];
        if(customApiFile) {
            [[TMFMiniAppSDKManager sharedInstance] setCustomApiConfigFile:customApiFile];
        }
    }
}



@end
