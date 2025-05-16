//
//  TMARealtimeLogItem.h
//  TMFMiniAppSDK
//
//  Created by stonelshi on 2022/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMARealtimeLogItem : NSObject

@property (nonatomic, assign) long log_time;
@property (nonatomic, assign) int log_level;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *key;

@end

NS_ASSUME_NONNULL_END
