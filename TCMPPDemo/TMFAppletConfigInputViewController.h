//
//  TMFAppletConfigInputViewController.h
//  TMFDemo
//
//  Created by StoneShi on 2022/4/18.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^addConfigHandler)(NSError* _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface TMFAppletConfigInputViewController : UIViewController
@property (nonatomic) addConfigHandler addHandler;
@end

NS_ASSUME_NONNULL_END
