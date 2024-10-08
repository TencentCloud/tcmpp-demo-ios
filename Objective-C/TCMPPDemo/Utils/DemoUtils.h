//
//  DemoUtils.h
//  TCMPPDemo
//
//  Created by stonelshi on 2023/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoUtils : NSObject

+(NSString *)convertToJsonData:(NSDictionary *)dict;

+ (void)executeOnMainThread:(dispatch_block_t)block;

+(NSString *)validNSString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
