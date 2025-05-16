//
//  UIImage+RTL.m
//  weapps
//
//  Created by stonelshi on 2022/6/3.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "UIImage+RTL.h"

@implementation UIImage (RTL)

- (UIImage *)checkOverturn {
    if (@available(iOS 9.0, *)) {
        if ([UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
            CGContextRef bitmap = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(bitmap, self.size.width / 2, self.size.height / 2);
            CGContextScaleCTM(bitmap, -1.0, -1.0);
            CGContextTranslateCTM(bitmap, -self.size.width / 2, -self.size.height / 2);
            CGContextDrawImage(bitmap, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            return image;
        }
    }
    return self;
}

@end
