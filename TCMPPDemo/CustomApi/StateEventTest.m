//
//  StateEventTest.m
//  MiniAppDemo
//
//  Created by 石磊 on 2023/10/30.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "StateEventTest.h"

@implementation StateEventTest {
    int _state;
}

- (void)start {
    _state = 0;
    NSTimeInterval timeInterval = 1;
    [self performSelector:@selector(stateChange) withObject:nil afterDelay:timeInterval];
}

- (void)stateChange {
    if(++_state>=10) {
        if(self.stateOverHandler) {
            self.stateOverHandler();
        }
    } else {
        if(self.stateEventHandler) {
            self.stateEventHandler(_state);
        }
        
        NSTimeInterval timeInterval = 1;
        [self performSelector:@selector(stateChange) withObject:nil afterDelay:timeInterval];
    }
}


@end
