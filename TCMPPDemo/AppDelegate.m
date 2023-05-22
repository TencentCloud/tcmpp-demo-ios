//
//  AppDelegate.m
//  TCMPPDemo
//
//  Created by 石磊 on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "TMFMiniAppSDKManager.h"
#import "MIniAppDemoSDKDelegateImpl.h"
#import "ViewController.h"
#import "DemoUserInfo.h"

#import "TMFAppletQMapComponent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self prepareApplet];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController * rootViewController = [[ViewController alloc] init];
    UINavigationController * navGationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navGationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)prepareApplet {
    [TMFMiniAppSDKManager sharedInstance].miniAppSdkDelegate = [MIniAppDemoSDKDelegateImpl sharedInstance];

    //配置使用环境
   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tcmpp-ios-configurations" ofType:@"json"];
   if(filePath) {
       TMAServerConfig *config  = [[TMAServerConfig alloc] initWithFile:filePath];
       [[TMFMiniAppSDKManager sharedInstance] setConfiguration:config];
   }
    
    [TMFAppletQMapComponent setQMapApiKey:@"QAZBZ-2HCKW-SWAR4-ORKF2-JDHL3-IAFBO"];
}



@end
