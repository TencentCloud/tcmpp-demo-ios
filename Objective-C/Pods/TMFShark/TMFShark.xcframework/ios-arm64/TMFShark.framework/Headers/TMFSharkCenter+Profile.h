//
//  TMFSharkCenter+Profile.h
//  TMDShark
//
//  Created by klaudz on 14/5/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <TMFShark/TMFSharkCenter.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMFSharkCenter (Profile)

@property (atomic, copy, readonly, nullable) NSString *remoteNotificationToken;

- (void)updateRemoteNotificationToken:(NSString *)deviceToken;

@property (atomic, copy, readonly, nullable) NSString *customizedUserID;

- (void)updateCustomizedUserID:(NSString *)customizedUserID;

@end

NS_ASSUME_NONNULL_END
