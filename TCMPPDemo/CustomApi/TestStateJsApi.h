//
//  TestStateJsApi.h
//  TCMPPDemo
//
//  Created by 石磊 on 2023/12/6.
//

#import <Foundation/Foundation.h>
#import "TMAExternalJSPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestStateJsApi : NSObject
@property (nonatomic,strong) id<TMAExternalJSContextProtocol>  jsContext;
@end

NS_ASSUME_NONNULL_END
