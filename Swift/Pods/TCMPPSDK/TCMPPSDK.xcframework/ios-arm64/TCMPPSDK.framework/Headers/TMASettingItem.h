//
//  TMASettingItem.h
//  TMFMiniAppSDK
//
//  Created by stonelshi on 2022/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMASettingItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSArray *infos;
@end

NS_ASSUME_NONNULL_END
