//
//  ToastView.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastView : UIView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title;
- (void)show;
- (void)dismiss;
- (void)showWithDuration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
