//
//  TMFAppletConfigManager.h
//  TMFDemo
//
//  Created by StoneShi on 2022/4/18.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TMFAppletConfigItem : NSObject<NSCoding>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic) BOOL checkmark;

- (nullable instancetype)initWithFile:(NSString *)file;

- (void)writefile;

- (void)changeCheckmark:(BOOL)checkmark;
@end


@interface TMFAppletConfigManager : NSObject
+ (instancetype)sharedInstance;

- (NSMutableArray<TMFAppletConfigItem*> *)getAppletConfigList;

- (TMFAppletConfigItem *)getCurrentConfigItem;

- (BOOL)addAppletConfig:(NSString*)item andContent:(NSString *)content;

- (BOOL)checkAppletConfigTitle:(NSString *)title;

- (void)removeAppletConfigItem:(NSString*)path;

+ (NSString*)homeDirectory;

@end

NS_ASSUME_NONNULL_END

