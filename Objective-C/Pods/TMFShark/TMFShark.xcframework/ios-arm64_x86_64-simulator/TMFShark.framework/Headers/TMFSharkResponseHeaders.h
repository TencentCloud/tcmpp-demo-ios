//
//  TMFSharkResponseHeaders.h
//  TMDShark
//
//  Created by klaudz on 11/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMFSharkResponseHeaders : NSObject

+ (instancetype)headers;

@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;

@property (nonatomic, assign) NSInteger HTTPStatusCode;

@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *extendedInfo;

@end

NS_ASSUME_NONNULL_END
