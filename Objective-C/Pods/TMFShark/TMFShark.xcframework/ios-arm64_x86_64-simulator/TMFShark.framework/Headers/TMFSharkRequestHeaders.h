//
//  TMFSharkRequestHeaders.h
//  TMDShark
//
//  Created by klaudz on 11/4/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMFSharkRequestHeaders : NSObject

+ (instancetype)headers;

@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, NSString *> *headers;
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, NSString *> *cookies;
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, NSString *> *queries;

@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, NSString *> *extendedInfo;

@end

NS_ASSUME_NONNULL_END
