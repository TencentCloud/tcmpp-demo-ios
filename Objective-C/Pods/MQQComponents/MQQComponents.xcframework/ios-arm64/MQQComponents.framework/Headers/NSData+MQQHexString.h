//
//  NSData+MQQHexString.h
//  MQQComponents
//
//  Created by klaudz on 15/7/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (MQQHexString)

+ (nullable instancetype)mqqDataWithHexString:(NSString *)hexString;

- (NSString *)mqqHexString;

@end

NS_ASSUME_NONNULL_END
