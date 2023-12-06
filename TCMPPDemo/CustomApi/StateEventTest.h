//
//  StateEventTest.h
//  MiniAppDemo
//
//  Created by 石磊 on 2023/10/30.
//  Copyright © 2023 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^StateEventHandler)(int state);
typedef void (^StateOverHandler)(void);

@interface StateEventTest : NSObject

@property(nullable, nonatomic, copy) StateEventHandler stateEventHandler;
@property(nullable, nonatomic, copy) StateOverHandler stateOverHandler;

-(void)start;

@end

NS_ASSUME_NONNULL_END
