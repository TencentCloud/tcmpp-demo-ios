//
//  TCMPPPayView.h
//  TCMPPDemo
//
//  Created by 石磊 on 2023/4/24.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMPPPayView : UIView
@property (nonatomic, copy) NSString *title, *detail, *defaultPass;
@property (nonatomic, assign) CGFloat money;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);
@property (nonatomic,copy) void (^cancelHandle)(void);
- (void)show;
@end

NS_ASSUME_NONNULL_END
