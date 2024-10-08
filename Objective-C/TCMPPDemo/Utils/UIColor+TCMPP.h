//
//  UIColor+TCMPP.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (TCMPP)

+ (UIColor *)tcmpp_colorWithHex:(NSString *)hex;

+ (UIColor *)tcmpp_colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
