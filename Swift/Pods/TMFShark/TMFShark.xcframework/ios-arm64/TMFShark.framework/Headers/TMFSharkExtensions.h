//
//  TMFSharkExtensions.h
//  TMFShark
//
//  Created by klaudz on 10/9/2020.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Request/Response Headers - Extended Info

FOUNDATION_EXPORT
NSString *const TMFSharkTraceID;

FOUNDATION_EXPORT
NSString * TMFSharkGenerateTraceID(void);

NS_ASSUME_NONNULL_END
