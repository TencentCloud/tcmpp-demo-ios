//
//  TCMPPCommonTools.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/7/31.
//

#import "TCMPPCommonTools.h"

@implementation TCMPPCommonTools

+ (UIEdgeInsets)safeAreaInsets {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    if (![window isKeyWindow]) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (CGRectEqualToRect(keyWindow.bounds, [UIScreen mainScreen].bounds)) {
            window = keyWindow;
        }
    }
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = [window safeAreaInsets];
        return insets;
    }
    return UIEdgeInsetsZero;
}

+ (void)getImageWith:(NSString *)path completion:(void(^)(UIImage *image,NSError *error))completion {
    if (!path || path.length == 0) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"path is nil" forKey:NSLocalizedDescriptionKey];
        completion(nil,[[NSError alloc] initWithDomain:@"get image error" code:-1 userInfo:userInfo]);
        return;
    }
    dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(async, ^{
        NSString *tempPath = NSTemporaryDirectory();
        NSString *localFilePath = [tempPath stringByAppendingPathComponent:path.lastPathComponent];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:localFilePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:localFilePath];
            dispatch_async(dispatch_get_main_queue(),^{
                completion(image,nil);
            });
        } else {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            UIImage *image = [UIImage imageWithData:data];
            [data writeToFile:localFilePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(),^{
                completion(image,nil);
            });
        }
    });
}

@end
