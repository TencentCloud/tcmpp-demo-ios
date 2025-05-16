//
//  NSString+HexInteger.h
//  MQQSecure
//
//  Created by 徐森圣 on 2018/1/9.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface NSString (HexInteger)

#if TARGET_OS_IPHONE
- (UIColor *)hexColor;
#else
- (NSColor *)hexColor;
#endif

@end
