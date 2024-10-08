//
//  TCMPPMenuView.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MenuClickBlock)(void);

@interface TCMPPMenuItem : NSObject

@property (copy,  nonatomic) NSString *title;
@property (strong,nonatomic) UIImage *icon;
@property (copy,  nonatomic) MenuClickBlock block;

@end

@interface TCMPPMenuView : UIView

- (instancetype)initWithMenuItems:(NSArray<TCMPPMenuItem *> *)menuItems;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
