//
//  TCMPPCommonTools.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCMPPCommonTools : NSObject

+ (UIEdgeInsets)safeAreaInsets;

+ (void)getImageWith:(NSString *)path completion:(void(^)(UIImage *image,NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
