//
//  TCMPPDemoLoginManager.h
//  TUIKitDemo
//
//  Created by 石磊 on 2024/5/8.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, UserGenderType) {
    UserGenderTypeUnknown,
    UserGenderTypeMale,
    UserGenderTypeFemale
};

typedef void (^loginRequestHandler)(NSError* _Nullable err,
                                    NSString* _Nullable token,
                                    NSDictionary* _Nullable datas);
typedef void (^UpdateUserInfoSuccessBlock)(BOOL success, NSString * _Nullable message);
typedef void (^UpdateUserInfoFailureBlock)(NSError * _Nullable error);
typedef void (^getSubscribeSuccessBlock)(NSArray *_Nullable message);

@interface TCMPPUserInfo : NSObject
+ (instancetype _Nonnull )sharedInstance;

@property(nonatomic,strong) NSString * _Nullable token;
@property(nonatomic,strong) NSString * _Nullable email;
@property(nonatomic,strong) NSString * _Nullable userId;
@property(nonatomic,strong) NSString * _Nullable avatarUrl;
@property(nonatomic,strong) NSString * _Nullable nickName;
@property(nonatomic,strong) NSString * _Nullable phoneNumber;

@property(nonatomic,strong) NSString * _Nullable country;
@property(nonatomic,strong) NSString * _Nullable province;
@property(nonatomic,strong) NSString * _Nullable city;
@property(nonatomic,assign) int gender;
- (void)saveUserInfoToUserDefaults;
@end
@interface TCMPPDemoLoginManager : NSObject
+ (instancetype _Nonnull)sharedInstance;

- (NSString *_Nullable)getUserId;
- (void)loginWithAccout:(NSString *_Nullable)accout
      completionHandler:(loginRequestHandler _Nullable)completionHandler;

- (void)updateUserInfoWithEmail:(NSString *_Nullable)email
                         avatar:(NSData *_Nullable)avatarData
                       nickName:(NSString *_Nullable)nickName
                    phoneNumber:(NSString *_Nullable)phoneNumber
                        success:(UpdateUserInfoSuccessBlock _Nullable )success
                        failure:(UpdateUserInfoFailureBlock _Nullable )failure;
- (void)clearLoginInfo;

- (void)getMessage:(NSString *_Nullable)token
             appId:(NSString *_Nullable)appId
            offset:(NSInteger)offset
           success:(getSubscribeSuccessBlock _Nullable)success
           failure:(UpdateUserInfoFailureBlock _Nullable)failure;
@end

