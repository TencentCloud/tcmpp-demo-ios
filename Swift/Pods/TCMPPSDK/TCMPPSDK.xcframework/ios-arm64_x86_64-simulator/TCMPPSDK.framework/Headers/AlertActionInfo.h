//
//  AlertActionInfo.h
//  Kiwi
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertActionInfo : NSObject

@property (nonatomic, strong) NSString *labelInfo;
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, copy) void(^actionCheckBlock)(BOOL checkBoxSelected);

@end

NS_ASSUME_NONNULL_END
