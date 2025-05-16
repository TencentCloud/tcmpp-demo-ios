//
//  UIView+RTL.m
//  TMFCodeDetector
//
//  Created by 石磊 on 2022/11/24.
//

#import "UIView+RTL.h"

@implementation UIView  (RTL)

- (void)setRTLFrame:(CGRect)frame width:(CGFloat)width
{
    if (@available(iOS 9.0, *)) {
        if ([UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
            if (self.superview == nil) {
                NSAssert(0, @"must invoke after have superView");
            }
            CGFloat x = width - frame.origin.x - frame.size.width;
            frame.origin.x = x;
        }
    }
    self.frame = frame;
}
- (void)setRTLFrame:(CGRect)frame
{
    [self setRTLFrame:frame width:self.superview.frame.size.width];
}
- (void)resetFrameToFitRTL
{
    [self setRTLFrame:self.frame];
}
@end
