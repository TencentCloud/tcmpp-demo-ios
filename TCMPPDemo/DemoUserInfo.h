//
//  DemoUserInfo.h
//  TCMPPDemo
//
//  Created by 石磊 on 2023/5/5.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UserGenderType) {
    UserGenderTypeUnknown,
    UserGenderTypeMale,
    UserGenderTypeFemale
};

@interface DemoUserInfo : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic,strong) NSString *nickName;

@property(nonatomic,strong) NSString *country;

@property(nonatomic,strong) NSString *province;

@property(nonatomic,strong) NSString *avatarUrl;

@property(nonatomic,strong) NSString *city;

@property(nonatomic,assign) int gender;

@end

NS_ASSUME_NONNULL_END
