//
//  PayRequestJsApi.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/24.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "PayRequestJsApi.h"
#import "TMAExternalJSPlugin.h"
#import "TMFMiniAppInfo.h"
#import "TCMPPPayView.h"

@implementation PayRequestJsApi

TMA_REGISTER_EXTENAL_JSPLUGIN;

TMAExternalJSAPI_IMP(requestPayment) {
    TMFMiniAppInfo *appInfo = context.tmfAppInfo;
    NSDictionary *data = params[@"data"];

    NSLog(@"************ invokeNativePlugin test,appId:%@,data is %@", appInfo.appId, data);

    //    UINavigationController *navigationController = context.miniAppNavController;
    dispatch_async(dispatch_get_main_queue(), ^{
        float money = [data[@"money"] floatValue];
        if (money <= 0) {
            TMAExternalJSPluginResult *pluginResult = [TMAExternalJSPluginResult new];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"parameter error" forKey:NSLocalizedDescriptionKey];
            pluginResult.error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1001 userInfo:userInfo];
            [context doCallback:pluginResult];
        } else {
            TCMPPPayView *payAlert = [[TCMPPPayView alloc] init];
            payAlert.title = NSLocalizedString(@"Please enter the payment password", nil);
            payAlert.detail = NSLocalizedString(@"Payment", nil);
            payAlert.money = money;
            payAlert.defaultPass = NSLocalizedString(@"Default password:666666", nil);
            [payAlert show];
            payAlert.completeHandle = ^(NSString *inputPassword) {
                if (inputPassword) {
                    if ([inputPassword isEqualToString:@"666666"]) {
                        TMAExternalJSPluginResult *pluginResult = [TMAExternalJSPluginResult new];
                        pluginResult.result = @ { @"result": @"pay sucess" };
                        [context doCallback:pluginResult];
                    } else {
                        TMAExternalJSPluginResult *pluginResult = [TMAExternalJSPluginResult new];
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"password error" forKey:NSLocalizedDescriptionKey];
                        pluginResult.error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1002 userInfo:userInfo];
                        [context doCallback:pluginResult];
                    }
                }
            };
            payAlert.cancelHandle = ^(void) {
                TMAExternalJSPluginResult *pluginResult = [TMAExternalJSPluginResult new];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"pay cancel" forKey:NSLocalizedDescriptionKey];
                pluginResult.error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
                [context doCallback:pluginResult];
            };
        }
    });

    return nil;
}

@end
