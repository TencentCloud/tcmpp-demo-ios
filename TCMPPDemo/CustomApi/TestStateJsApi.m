//
//  TestStateJsApi.m
//  TCMPPDemo
//
//  Created by 石磊 on 2023/12/6.
//

#import "TestStateJsApi.h"
#import "StateEventTest.h"


@implementation TestStateJsApi{
    int _state;
}

TMA_REGISTER_EXTENAL_JSPLUGIN

TMAExternalJSAPI_IMP(testState) {
    NSString *stateEvent = params[@"stateEvent"];

    StateEventTest *stateEventTest = [[StateEventTest alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(stateEvent && stateEvent.length>0) {
            stateEventTest.stateEventHandler = ^(int state) {
                [context doSubscribe:stateEvent data:[NSString stringWithFormat:@"%d",state]];
            };
        }
        
        stateEventTest.stateOverHandler = ^{
            TMAExternalJSPluginResult *pluginResult = [TMAExternalJSPluginResult new];
            pluginResult.result = @{@"result" : @"event over"};
            [context doCallback:pluginResult];
        };
        
        [stateEventTest start];

    });
    
    return nil;
}

@end
