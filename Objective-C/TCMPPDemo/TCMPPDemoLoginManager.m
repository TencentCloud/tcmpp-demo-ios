//
//  TCMPPDemoLoginManager.m
//  TUIKitDemo
//
//  Created by 石磊 on 2024/5/8.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPDemoLoginManager.h"
#import <TCMPPSDK/TCMPPSDK.h>

#define TCMPP_LOGIN_URL  @"https://openapi-sg.tcmpp.com/superappv2/"
#define TCMPP_API_AUTH  @"login"
#define TCMPP_API_UPDATE_USERINFO  @"user/updateUserInfo"
#define TCMPP_API_MESSAGE  @"user/message"

@implementation TCMPPUserInfo

+ (instancetype)sharedInstance {
    static TCMPPUserInfo* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TCMPPUserInfo alloc] init];
        [manager loadUserInfoFromUserDefaults];
    });
    return manager;
}

- (void)setUserInfo:(NSDictionary *)userInfo{
    self.avatarUrl = userInfo[@"iconUrl"];
    self.token = userInfo[@"token"];
    self.userId = userInfo[@"userId"];
    self.nickName = userInfo[@"userName"];
    self.email = userInfo[@"email"];
    self.phoneNumber = userInfo[@"phoneNumber"];
    
    self.country = userInfo[@"country"];
    self.province = userInfo[@"province"];
    self.city = userInfo[@"city"];
    if (userInfo[@"gender"]) {
        self.gender = [userInfo[@"gender"] intValue];
    }
    
    [self saveUserInfoToUserDefaults];
}

- (void)saveUserInfoToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.avatarUrl) {
        [userDefaults setObject:self.avatarUrl forKey:@"TCMPPUserInfo_avatarUrl"];
    }
    if (self.token) {
        [userDefaults setObject:self.token forKey:@"TCMPPUserInfo_token"];
    }
    if (self.userId) {
        [userDefaults setObject:self.userId forKey:@"TCMPPUserInfo_userId"];
    }
    if (self.nickName) {
        [userDefaults setObject:self.nickName forKey:@"TCMPPUserInfo_nickName"];
    }
    if (self.email) {
        [userDefaults setObject:self.email forKey:@"TCMPPUserInfo_email"];
    }
    if (self.phoneNumber) {
        [userDefaults setObject:self.phoneNumber forKey:@"TCMPPUserInfo_phoneNumber"];
    }
    if (self.country) {
        [userDefaults setObject:self.country forKey:@"TCMPPUserInfo_country"];
    }
    if (self.province) {
        [userDefaults setObject:self.province forKey:@"TCMPPUserInfo_province"];
    }
    if (self.city) {
        [userDefaults setObject:self.city forKey:@"TCMPPUserInfo_city"];
    }
    
    [userDefaults setInteger:self.gender forKey:@"TCMPPUserInfo_gender"];
    [userDefaults synchronize];
}

- (void)loadUserInfoFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.avatarUrl = [userDefaults objectForKey:@"TCMPPUserInfo_avatarUrl"];
    self.token = [userDefaults objectForKey:@"TCMPPUserInfo_token"];
    self.userId = [userDefaults objectForKey:@"TCMPPUserInfo_userId"];
    self.nickName = [userDefaults objectForKey:@"TCMPPUserInfo_nickName"];
    self.email = [userDefaults objectForKey:@"TCMPPUserInfo_email"];
    self.phoneNumber = [userDefaults objectForKey:@"TCMPPUserInfo_phoneNumber"];
    self.country = [userDefaults objectForKey:@"TCMPPUserInfo_country"];
    self.province = [userDefaults objectForKey:@"TCMPPUserInfo_province"];
    self.city = [userDefaults objectForKey:@"TCMPPUserInfo_city"];
    self.gender = (int)[userDefaults integerForKey:@"TCMPPUserInfo_gender"];
}

- (void)clearUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_avatarUrl"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_token"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_userId"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_nickName"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_email"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_phoneNumber"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_country"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_province"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_city"];
    [userDefaults removeObjectForKey:@"TCMPPUserInfo_gender"];
    
    [userDefaults synchronize];
    
    self.avatarUrl = nil;
    self.token = nil;
    self.userId = nil;
    self.nickName = nil;
    self.email = nil;
    self.phoneNumber = nil;
    self.country = nil;
    self.province = nil;
    self.city = nil;
    self.gender = 0;
}

@end

@implementation TCMPPDemoLoginManager{
    NSURLSession *_urlSession;
    NSString *_userId;
}

+ (instancetype)sharedInstance {
    static TCMPPDemoLoginManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TCMPPDemoLoginManager alloc] init];
    });
    return manager;
}

- (NSString *)getUserId {
    return _userId;
}
- (void)clearLoginInfo{
    _userId = nil;
    [[TCMPPUserInfo sharedInstance] clearUserInfo];
}
- (void)loginWithAccout:(NSString *)accout
      completionHandler:(loginRequestHandler _Nullable)completionHandler {
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TCMPP_LOGIN_URL,TCMPP_API_AUTH]];
    NSLog(@"loginWithAccout url = %@",url);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *appId = [[TMFMiniAppSDKManager sharedInstance] getConfigAppKey];
    NSString *password = @"123456";
    if(appId.length<=0) {
        NSLog(@"appID is nil");
        return;
    }
    
    NSMutableDictionary *jsonBody = [NSMutableDictionary new];
    
    [jsonBody setObject:appId forKey:@"appId"];
    [jsonBody setObject:accout forKey:@"userAccount"];
    [jsonBody setObject:password forKey:@"userPassword"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];
    if (!jsonData) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Error: %@ while creating JSON data", error] forKey:NSLocalizedDescriptionKey];

        if(completionHandler) {
            completionHandler([NSError errorWithDomain:@"KWeiMengRequestDomain" code:-1000 userInfo:userInfo],nil,nil);
        }
        return;
    }
    [request setHTTPBody:jsonData];
  
    __weak typeof(self) weakSelf = self;

    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"tcmpp login request error: %@", error);
            if(completionHandler) {
                completionHandler(error,nil,nil);
            }
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"tcmpp login request error code: %ld", (long)httpResponse.statusCode);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request error code: %ld", (long)httpResponse.statusCode] forKey:NSLocalizedDescriptionKey];
            if(completionHandler) {
                completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:-1001 userInfo:userInfo],nil,nil);
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
                        [[TCMPPUserInfo sharedInstance] setUserInfo:dataJson];
                        NSString *userId = dataJson[@"userId"];
                        if(userId) {
                            __strong typeof(self) strongSelf = weakSelf;
                            if(strongSelf) {
                                self->_userId = userId;
                            }
                            if(completionHandler) {
                                completionHandler(nil,userId,dataJson);
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
            completionHandler([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:errCode userInfo:userInfo],nil,nil);
        }
        return;
    }];
    [dataTask resume];
}
- (void)updateUserInfoWithEmail:(NSString *_Nullable)email
                         avatar:(NSData *_Nullable)avatarData
                       nickName:(NSString *_Nullable)nickName
                    phoneNumber:(NSString *_Nullable)phoneNumber
                        success:(UpdateUserInfoSuccessBlock)success
                        failure:(UpdateUserInfoFailureBlock)failure {
    

    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    NSString *token = [TCMPPUserInfo sharedInstance].token;
    NSString *appId = [[TMFMiniAppSDKManager sharedInstance] getConfigAppKey];
    if (!token || !appId) {
        NSError *error = [NSError errorWithDomain:@"com.tcmpp.app" code:-1001 userInfo:@{NSLocalizedDescriptionKey: @"Missing required parameters"}];
        if (failure) {
            failure(error);
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TCMPP_LOGIN_URL,TCMPP_API_UPDATE_USERINFO]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", token] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"appId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", appId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (email) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", email] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (avatarData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:avatarData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (nickName) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"nickName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", nickName] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (phoneNumber) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"phoneNumber\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", phoneNumber] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *task = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        
        NSError *jsonError;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError) {
            if (failure) {
                failure(jsonError);
            }
            return;
        }
        
        NSInteger returnCode = [jsonDict[@"returnCode"] integerValue];
        NSString *returnMessage = jsonDict[@"returnMessage"];
        NSDictionary *dataDic = jsonDict[@"data"];
        BOOL result = NO;
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            result = [dataDic[@"result"] boolValue];
        }
        if (result) {
            if (success) {
                success(result, returnMessage);
            }
        } else {
            NSError *customError = [NSError errorWithDomain:@"com.tcmpp.app" code:returnCode userInfo:@{NSLocalizedDescriptionKey: returnMessage}];
            if (failure) {
                failure(customError);
            }
        }
    }];
    
    [task resume];
}

- (void)getMessage:(NSString *)token
             appId:(NSString *)appId
            offset:(NSInteger)offset
           success:(getSubscribeSuccessBlock)success
           failure:(UpdateUserInfoFailureBlock)failure{
    if(_urlSession == nil) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TCMPP_LOGIN_URL,TCMPP_API_MESSAGE]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if(appId.length<=0) {
        NSLog(@"appId is nil");
        return;
    }
    
    if(token.length<=0) {
        NSLog(@"token is nil");
        return;
    }
    
    NSMutableDictionary *jsonBody = [NSMutableDictionary new];
    
    [jsonBody setObject:appId forKey:@"appId"];
    [jsonBody setObject:token forKey:@"token"];
    [jsonBody setObject:@(offset) forKey:@"offset"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:&error];
    if (!jsonData) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Error: %@ while creating JSON data", error] forKey:NSLocalizedDescriptionKey];

        if(failure) {
            failure([NSError errorWithDomain:@"KWeiMengRequestDomain" code:-1000 userInfo:userInfo]);
        }
        return;
    }
    [request setHTTPBody:jsonData];
    

    NSURLSessionDataTask *dataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"tcmpp getMessage error: %@", error);
            if(failure) {
                failure(error);
            }
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"tcmpp getMessage request error code: %ld", (long)httpResponse.statusCode);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"request error code: %ld", (long)httpResponse.statusCode] forKey:NSLocalizedDescriptionKey];
            if(failure) {
                failure([NSError errorWithDomain:@"KTCMPPLoginRequestGetMessage" code:-1001 userInfo:userInfo]);
            }
            return;
        }
        
        NSString *errMsg = @"received response data error";
        NSInteger errCode = -1002;
        
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"TCMPP getMessage response jsonDict:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                NSString *returnCode = jsonDict[@"returnCode"];
                errCode = [returnCode intValue];
                if(errCode == 0) {
                    NSArray *dataJson = jsonDict[@"data"];
                    if(dataJson) {
                        if (success) {
                            success(dataJson);
                            return;
                        }
                    }
                } else {
                    errMsg = jsonDict[@"returnMessage"];
                }
            }
        }
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
        if(failure) {
            failure([NSError errorWithDomain:@"KTCMPPLoginRequestDomain" code:errCode userInfo:userInfo]);
        }
        return;
    }];
    
    [dataTask resume];
}
@end
