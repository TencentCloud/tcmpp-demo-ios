//
//  CustomBundle.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/2.
//

#import "CustomBundle.h"
#import "LanguageManager.h"

@implementation CustomBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *customBundle = [[LanguageManager shared] getBundle];
    return [customBundle localizedStringForKey:key value:value table:tableName];
}

@end
