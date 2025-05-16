//
//  NSURLComponents+MQQExtended.h
//  MQQComponents
//
//  Created by klaudz on 24/10/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLComponents (MQQExtended)

@property (nullable, copy) NSArray<NSURLQueryItem *> *mqqPercentEncodedQueryItems;

@end

NS_ASSUME_NONNULL_END
