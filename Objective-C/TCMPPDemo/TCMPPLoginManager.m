//
//  TCMPPLoginManager.m
//  TUIKitDemo
//
//  Created by 石磊 on 2024/5/8.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPLoginManager.h"
#import <TCMPPSDK/TCMPPSDK.h>
//#import "TUILogin.h"


#define TCMPP_LOGIN_URL  @"https://openapi-sg.tcmpp.com/superapp/"
#define TCMPP_API_AUTH  @"login"
#define TCMPP_API_MINIAPP_GETCODE  @"getMiniProgramAuthCode"

@implementation TCMPPLoginManager{
    NSString *_token;
    NSURLSession *_urlSession;
    NSString *_appId;
    NSString *_userId;
}


+ (instancetype)sharedInstance {
    static TCMPPLoginManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TCMPPLoginManager alloc] init];
    });
    return manager;
}

- (NSString *)getAppId {
    if(_appId == nil) {
        NSDictionary *debugInfo = [[TMFMiniAppSDKManager sharedInstance] getDebugInfo];
        _appId = debugInfo[@"AppKey"];
    }
    
    return _appId;
}

- (void)writeInfoFile:(NSString *)username expires:(NSInteger)expires{
    if(username == nil || username.length<=0) {
        _token = nil;
    } else {
        _token = username;
    }
}

- (NSString *)getToken {
    return _token;
}

- (NSString *)getUserId {
    if(_userId.length > 0) {
        return _userId;
    }
    return nil;
}

- (void)loginUser:(NSString *)userId completeion:(tcmppLoginRequestHandler)completionHandler {
    _userId = userId;
    [self login:completionHandler];
}

- (void)login:(tcmppLoginRequestHandler)completionHandler {
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TCMPP_LOGIN_URL,TCMPP_API_AUTH]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *appId = [self getAppId];
    NSString *userId = [self getUserId];
    NSString *password = @"";
    
    if(appId.length<=0) {
        return;
    }
    
    NSMutableDictionary *jsonBody = [NSMutableDictionary new];
    
    [jsonBody setObject:appId forKey:@"appId"];
    [jsonBody setObject:userId forKey:@"userAccount"];
    [jsonBody setObject:password forKey:@"userPassword"];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];
    if (!jsonData) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Error: %@ while creating JSON data", error] forKey:NSLocalizedDescriptionKey];

        if(completionHandler) {
            completionHandler([NSError errorWithDomain:@"KWeiMengRequestDomain" code:-1000 userInfo:userInfo],nil);
        }
        return;
    }
    [request setHTTPBody:jsonData];
  
    
    __weak typeof(self) weakSelf = self;

    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"tcmpp login request error: %@", error);
            if(completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"tcmpp login request error code: %ld", (long)httpResponse.statusCode);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request error code: %ld", (long)httpResponse.statusCode] forKey:NSLocalizedDescriptionKey];
            if(completionHandler) {
                completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:-1001 userInfo:userInfo],nil);
            }
            return;
        }
        
        NSString *errMsg = @"received response data error";
        NSInteger errCode = -1002;
        
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"TCMPP login response jsonDict:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                NSString *returnCode = jsonDict[@"returnCode"];
                errCode = [returnCode intValue];
                if(errCode == 0) {
                    NSDictionary *dataJson = jsonDict[@"data"];
                    if(dataJson) {
                        NSString *token = dataJson[@"token"];
                        if(token) {
                            __strong typeof(self) strongSelf = weakSelf;
                            if(strongSelf) {
                                [strongSelf writeInfoFile:token expires:0];
                            }
                            if(completionHandler) {
                                completionHandler(nil,nil);
                            }
                            return;
                        }
                    }
                } else {
                    errMsg = jsonDict[@"returnMessage"];
                }
            }
        }
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
        if(completionHandler) {
            completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:errCode userInfo:userInfo],nil);
        }
        return;
    }];
    
    [dataTask resume];
}

- (void)getToken:(NSString *)miniAppId completionHandler:(tcmppLoginRequestHandler)completionHandler {
    
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TCMPP_LOGIN_URL,TCMPP_API_MINIAPP_GETCODE]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *jsonBody = [NSMutableDictionary new];
    [jsonBody setObject:[self getAppId] forKey:@"appId"];
    [jsonBody setObject:_token forKey:@"token"];
    [jsonBody setObject:miniAppId forKey:@"miniAppId"];

    __weak typeof(self) weakSelf = self;
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];
    if (!jsonData) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Error: %@ while creating JSON data", error] forKey:NSLocalizedDescriptionKey];

        if(completionHandler) {
            completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:-1000 userInfo:userInfo],nil);
        }
        return;
    }
    [request setHTTPBody:jsonData];
  
    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"tcmpp login request error: %@", error);
            if(completionHandler) {
                completionHandler(error,nil);
            }
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"tcmpp login request error code: %ld", (long)httpResponse.statusCode);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request error code: %ld", (long)httpResponse.statusCode] forKey:NSLocalizedDescriptionKey];
            if(completionHandler) {
                completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:-1001 userInfo:userInfo],nil);
            }
            return;
        }
        
        NSString *errMsg = @"received response data error";
        NSInteger errCode = -1002;
        
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"tcmpp login response jsonDict:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                NSString *returnCode = jsonDict[@"returnCode"];
                errCode = [returnCode intValue];
                if(errCode == 0) {
                    NSDictionary *codeData = jsonDict[@"data"];
                    if(codeData) {
                        NSString *code = codeData[@"code"];
                        if(code && code.length>0) {
                            if(completionHandler) {
                                completionHandler(nil,code);
                            }
                            return;
                        }
                    }
                } else {
                    if(errCode == 100006) {
                        __strong typeof(self) strongSelf = weakSelf;
                        if(strongSelf) {
                            [strongSelf writeInfoFile:nil expires:0];
                        }
                    }
                    errMsg = jsonDict[@"returnMessage"];
                }
            }
        }
            
        NSLog(@"tcmpp login received response data error");
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
        if(completionHandler) {
            completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:errCode userInfo:userInfo],nil);
        }
    }];
    
    [dataTask resume];
}

- (void)wxLogin:(NSString *)miniAppId completionHandler:(tcmppLoginRequestHandler)completionHandler {
    if(_token) {
        [self getToken:miniAppId completionHandler:^(NSError * _Nullable err, NSString * _Nullable value) {
            if(err) {
                if(err.code == 100006) {
                    [self login:^(NSError * _Nullable err, NSString * _Nullable value) {
                        if(err) {
                            completionHandler(err,nil);
                        } else {
                            [self getToken:miniAppId completionHandler:^(NSError * _Nullable err, NSString * _Nullable value) {
                                completionHandler(err,value);
                            }];
                        }
                    }];
                }
            } else {
                completionHandler(nil,value);
            }
        }];
    } else {
        [self login:^(NSError * _Nullable err, NSString * _Nullable value) {
            if(err) {
                completionHandler(err,nil);
            } else {
                [self getToken:miniAppId completionHandler:^(NSError * _Nullable err, NSString * _Nullable value) {
                    completionHandler(err,value);
                }];
            }
        }];
    }
}


- (void)clearLoginInfo {
    _token = nil;
    _appId = nil;
}

@end
