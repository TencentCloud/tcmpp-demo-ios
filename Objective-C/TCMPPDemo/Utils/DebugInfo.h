//
//  DebugInfo.h
//  TCMPPDemo
//
//  Created by 石磊 on 2025/1/6.
//

#import <UIKit//UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebugInfo : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, copy) NSString *currentEnvironments;
- (UIViewController *)topViewController;
- (NSArray <NSDictionary *>*)defaultEnvironments;
- (void)setEnvironmentWithTitle:(NSString *)title domain:(NSString *)domain;
- (NSArray *)getAllCustomEnvironments;
@end

NS_ASSUME_NONNULL_END
