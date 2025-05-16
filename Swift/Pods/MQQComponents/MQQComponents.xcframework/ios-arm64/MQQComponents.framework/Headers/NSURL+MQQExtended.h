//
//  NSURL+MQQExtended.h
//  MQQSecure
//
//  Created by klaudz on 4/16/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (MQQExtended)

- (NSArray<NSString *> *)mqqQueryComponents;
- (NSDictionary<NSString *, NSString *> *)mqqQueryDictionary;

- (NSURL *)mqqURLByAppendingQuery:(NSString *)query API_AVAILABLE(ios(7.0));
- (NSURL *)mqqURLByAppendingQueryComponents:(NSArray<NSString *> *)queryComponents API_AVAILABLE(ios(7.0));
- (NSURL *)mqqURLByAppendingQueryComponentDictionary:(NSDictionary<NSString *, NSString *> *)queryComponentDictionary API_AVAILABLE(ios(7.0));

- (NSURL *)mqqURLByDeletingQueryNames:(NSArray<NSString *> *)queryNames API_AVAILABLE(ios(7.0));

@end
