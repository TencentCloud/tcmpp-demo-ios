//
//  DemoUtils.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/12/6.
//

#import "DemoUtils.h"

@implementation DemoUtils


+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSRange range3 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\\/\\/" withString:@"//" options:NSLiteralSearch range:range3];
    
    return mutStr;
}


+ (void)executeOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
}


+(NSString *)validNSString:(NSString *)str {
    return str ?: @"";
}

@end
