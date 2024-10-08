//
//  LanguageManager.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageManager : NSObject

+ (instancetype)shared;

- (NSString *)currentLanguage;
- (void)setCurrentLanguage:(NSString *)language;
- (NSBundle *)getBundle;

@end

NS_ASSUME_NONNULL_END
