//
//  TMFSharkCenter+Push.h
//  TMDShark
//
//  Created by klaudz on 25/5/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <TMFShark/TMFSharkCenter.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMFSharkCenter (Push)

- (void)observePushWithCmdID:(NSInteger)cmdID handler:(dispatch_block_t)handler;

- (void)observePushWithCmd:(NSString *)cmd handler:(dispatch_block_t)handler;

@end

NS_ASSUME_NONNULL_END
