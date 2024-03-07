//
//  PayRequestJsApi.h
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/24.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMAExternalJSPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayRequestJsApi : NSObject
@property (nonatomic,strong) id<TMAExternalJSContextProtocol>  jsContext;
@end

NS_ASSUME_NONNULL_END
