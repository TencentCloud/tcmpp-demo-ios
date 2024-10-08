//
//  UIView+TCMPP.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/1.
//

#import "UIView+TCMPP.h"

@implementation UIView (TCMPP)

- (void)roundingCorners:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius
{
    CGSize radio = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = self.bounds;
    masklayer.path = path.CGPath;
    self.layer.mask = masklayer;
    [self.layer layoutIfNeeded];
}

@end
