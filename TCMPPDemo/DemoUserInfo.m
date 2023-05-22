//
//  DemoUserInfo.m
//  TCMPPDemo
//
//  Created by 石磊 on 2023/5/5.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "DemoUserInfo.h"

#define DEV_LOGIN_NAME @"dev_login_name"

@implementation DemoUserInfo


+ (instancetype)sharedInstance {
    static DemoUserInfo* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DemoUserInfo alloc] init];
        [manager readLoginInfo];
    });
    return manager;
}


- (void)readLoginInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *username = [userDefaults objectForKey:DEV_LOGIN_NAME];
    if(username && username.length>0) {
        self.nickName = username;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HHmmss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        self.nickName = [NSString stringWithFormat:@"user%@",currentDateStr];
        [self writeInfoFile:self.nickName];
    }
    
    self.avatarUrl = @"https://upload.shejihz.com/2019/04/25704c14def5257a157f2d0f4b7ae581.jpg";
    self.country = @"中国";
    self.province = @"北京市";
    self.gender = UserGenderTypeMale;
    self.city = @"朝阳区";
}


- (void)writeInfoFile:(NSString *)username {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:username forKey:DEV_LOGIN_NAME];
}

@end
