//
//  TCMPPDemoPayManager.m
//  TUIKitDemo
//
//  Created by xcode on 2025/1/21.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import "TCMPPDemoPayManager.h"
#import "DebugInfo.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "TCMPPDemoLoginManager.h"

#define TCMPP_PAY_CHECKOUT_OPEN  @"checkout-counter/open"
#define TCMPP_PAY_CHECKOUT_GAME_OPEN  @"checkout-counter/game/open"
#define TCMPP_PAY_CHECKOUT_CONFIRM  @"checkout-counter/pay/confirm"
@implementation PayModel
@end

@implementation PayResponseData
@end

@implementation TCMPPDemoPayManager{
    NSURLSession *_urlSession;
    NSString *_userId;
}
+ (instancetype)sharedInstance {
    static TCMPPDemoPayManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TCMPPDemoPayManager alloc] init];
    });
    return manager;
}

- (void)checkPayConfirm:(NSDictionary *)data
      completionHandler:(tcmppPayConfirmHandler _Nullable)completionHandler {
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DebugInfo sharedInstance].currentEnvironments,TCMPP_PAY_CHECKOUT_CONFIRM]];
    NSLog(@"checkPayConfirm url = %@",url);

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if (error) {
        NSLog(@"Error converting to JSON: %@", error);
        if (completionHandler) {
            completionHandler(error,nil);
        }
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error parsing JSON: %@", jsonError);
            if (completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        
        NSString *returnCode = json[@"returnCode"];
        if (returnCode && [returnCode isEqualToString:@"0"]) {
            if (completionHandler) {
                completionHandler(nil,json[@"data"]);
            }
        } else {
            if (completionHandler) {
                completionHandler([NSError errorWithDomain:@"KTCMPPPayRequestDomain" code:returnCode.intValue userInfo:@{}],@{@"returnCode":returnCode,@"returnMessage":json[@"returnMessage"]});
            }
        }
        
        
    }];
    [dataTask resume];
}

- (void)checkPreOrder:(NSDictionary *)data
    completionHandler:(tcmppChcekOrderHandler _Nullable)completionHandler {
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DebugInfo sharedInstance].currentEnvironments,TCMPP_PAY_CHECKOUT_OPEN]];
    
    NSLog(@"checkPreOrder url = %@",url);
    NSError *error;
//    data = @{@"timeStamp":@"1737602817",@"nonceStr":@"85275483541565945663",@"package":@"prepay_id=pi1737602798895altj06r0gg5imuomiurpo",@"signType":@"",@"paySign":@"rWj1XHq7p9YtlRiRnx8KKJHSyOoqbT2CqMQ8LP2ksSPOZiXvQmyxWIHJ4mhAnKVM4k2YXpBYLFhhDAXF0vEVCiMbvla7M8iLF6nOFWcDZiO1SA6AVYqhr4uSdDvSCFEWopZO5lXVzhRzQ5AjZw5pbHazHcj7YsHUV5Lv/ZLjen2SvKTxx2rBjsQLL/jYPBj3QZBmOMV+MeQvTcMK311JwwPqeo0uEw4krxoV22jQIQ3AP6Hp/5a/zvbIqpcVACQuWvE83+RcdKuruO/L00X1TWDhIxAs0IM/+5QNcyoIf+Hu/qsvJn5PFoqwkZMX1O/YIOY5b9Hls9TYXnk3Vp9umg=="};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if (error) {
        NSLog(@"Error converting to JSON: %@", error);
        if (completionHandler) {
            completionHandler(error,nil);
        }
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
        
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error parsing JSON: %@", jsonError);
            if (completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        
        NSDictionary *dataDict = json[@"data"];
        NSString *returnCode = json[@"returnCode"];
        if (returnCode && [returnCode isEqualToString:@"0"]){
            PayResponseData *responseData = [[PayResponseData alloc] init];
            responseData.payId = dataDict[@"payId"];
            responseData.actualAmount = [dataDict[@"actualAmount"] doubleValue];
            NSArray *payModelListArray = dataDict[@"payModelList"];
            NSMutableArray *payModelList = [[NSMutableArray alloc] init];
            for (NSDictionary *payModelDict in payModelListArray) {
                PayModel *payModel = [[PayModel alloc] init];
                payModel.payModel = payModelDict[@"payModel"];
                payModel.payModelName = payModelDict[@"payModelName"];
                payModel.payModelIcon = payModelDict[@"payModelIcon"];
                payModel.payModelId = payModelDict[@"payModelId"];
                payModel.balance = [payModelDict[@"balance"] doubleValue];
                [payModelList addObject:payModel];
            }
            responseData.payModelList = payModelList;
            if (completionHandler) {
                completionHandler(nil,responseData);
            }
        } else {
            if (completionHandler) {
                NSString *msg = @"PayRequest error";
                if (json[@"returnMessage"]) {
                    msg = json[@"returnMessage"];
                }
                NSString *code = @"";
                if (json[@"returnCode"]) {
                    code = json[@"returnCode"];
                }
                PayResponseData *responseData = [[PayResponseData alloc] init];
                responseData.returnMessage = msg;
                responseData.returnCode = code;
                completionHandler([NSError errorWithDomain:@"KTCMPPPayRequestDomain" code:-1001 userInfo:@{NSLocalizedDescriptionKey : msg}],responseData);
            }
        }
        
        
    }];
    [dataTask resume];
}

- (void)checkMiniGamePreOrder:(NSDictionary *)data
            completionHandler:(tcmppChcekOrderHandler _Nullable)completionHandler{
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DebugInfo sharedInstance].currentEnvironments,TCMPP_PAY_CHECKOUT_GAME_OPEN]];
    NSLog(@"checkMiniGamePreOrder url = %@",url);
    NSError *error;
    NSMutableDictionary *jsonBody = [NSMutableDictionary new];

    [jsonBody setObject:[[TMFMiniAppSDKManager sharedInstance] getConfigAppKey] forKey:@"appId"];
    [jsonBody setObject:[TCMPPUserInfo sharedInstance].token forKey:@"token"];
    [jsonBody setObject:data[@"prepayId"] forKey:@"prepayId"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];
    if (error) {
        NSLog(@"Error converting to JSON: %@", error);
        if (completionHandler) {
            completionHandler(error,nil);
        }
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
        
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if (completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error parsing JSON: %@", jsonError);
            if (completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        
        NSDictionary *dataDict = json[@"data"];
        NSString *returnCode = json[@"returnCode"];
        if (returnCode && [returnCode isEqualToString:@"0"]){
            PayResponseData *responseData = [[PayResponseData alloc] init];
            responseData.payId = dataDict[@"payId"];
            responseData.actualAmount = [dataDict[@"actualAmount"] doubleValue];
            NSArray *payModelListArray = dataDict[@"payModelList"];
            NSMutableArray *payModelList = [[NSMutableArray alloc] init];
            for (NSDictionary *payModelDict in payModelListArray) {
                PayModel *payModel = [[PayModel alloc] init];
                payModel.payModel = payModelDict[@"payModel"];
                payModel.payModelName = payModelDict[@"payModelName"];
                payModel.payModelIcon = payModelDict[@"payModelIcon"];
                payModel.payModelId = payModelDict[@"payModelId"];
                payModel.balance = [payModelDict[@"balance"] doubleValue];
                [payModelList addObject:payModel];
            }
            responseData.payModelList = payModelList;
            if (completionHandler) {
                completionHandler(nil,responseData);
            }
        } else {
            if (completionHandler) {
                NSString *msg = @"PayRequest error";
                if (json[@"returnMessage"]) {
                    msg = json[@"returnMessage"];
                }
                NSString *code = @"";
                if (json[@"returnCode"]) {
                    code = json[@"returnCode"];
                }
                PayResponseData *responseData = [[PayResponseData alloc] init];
                responseData.returnMessage = msg;
                responseData.returnCode = code;
                completionHandler([NSError errorWithDomain:@"KTCMPPPayRequestDomain" code:-1001 userInfo:@{NSLocalizedDescriptionKey : msg}],responseData);
            }
        }
        
        
    }];
    [dataTask resume];
}
@end
