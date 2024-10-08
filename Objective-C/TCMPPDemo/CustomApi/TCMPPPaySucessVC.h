//
//  TCMPPPaySucessVC.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMPPPaySucessVC : UIViewController

@property (copy,nonatomic) NSString *iconURL;
@property (copy,nonatomic) NSString *name;
@property (assign,nonatomic) NSInteger price;
@property (copy,nonatomic,nullable) void(^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
