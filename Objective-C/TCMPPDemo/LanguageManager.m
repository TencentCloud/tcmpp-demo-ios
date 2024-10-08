//
//  LanguageManager.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/2.
//

#import "LanguageManager.h"
#import "CustomBundle.h"
#import <objc/runtime.h>

@implementation LanguageManager

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [CustomBundle class]);
    });
}

+ (instancetype)shared {
    static LanguageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)currentLanguage {
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentLanguage"];
    if (language) {
        return language;
    }
    language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
    } else if ([language hasPrefix:@"zh"]) {
        language = @"zh-Hans";
    } else if ([language hasPrefix:@"fr"]) {
        language = @"fr";
    } else if ([language hasPrefix:@"id"]) {
        language = @"id";
    }
    return language;
}

- (void)setCurrentLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"currentLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LanguageChanged" object:nil];
}

- (NSBundle *)getBundle {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[self currentLanguage] ofType:@"lproj"];
    return [NSBundle bundleWithPath:bundlePath];
}

@end
