//
//  TMFAppletConfigManager.m
//  TMFDemo
//
//  Created by StoneShi on 2022/4/18.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFAppletConfigManager.h"

@implementation TMFAppletConfigItem

- (instancetype)initWithFile:(NSString *)file {
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:[[TMFAppletConfigManager homeDirectory] stringByAppendingPathComponent:file]];;
    self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (self) {
        self.filePath = file;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_title forKey:@"_title"];
    [coder encodeObject:_subTitle forKey:@"_subTitle"];
    [coder encodeObject:_content forKey:@"_content"];
    [coder encodeBool:_checkmark forKey:@"_checkmark"];
    [coder encodeObject:_updateTime forKey:@"_updateTime"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super init]) {
        _title = [coder decodeObjectForKey:@"_title"];
        _subTitle = [coder decodeObjectForKey:@"_subTitle"];
        _content = [coder decodeObjectForKey:@"_content"];
        _checkmark = [coder decodeBoolForKey:@"_checkmark"];
        _updateTime = [coder decodeObjectForKey:@"_updateTime"];
    }
    return self;
}

- (void)writefile {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToFile:[[TMFAppletConfigManager homeDirectory] stringByAppendingPathComponent:_filePath] atomically:YES];
}

- (void)readfile:(NSString *)filename {
    
}

- (void)changeCheckmark:(BOOL)checkmark {
    if(self.checkmark != checkmark) {
        self.checkmark = checkmark;
        if(_filePath) {
            [self writefile];
        }
    }
}

@end

@implementation TMFAppletConfigManager {
    NSMutableArray<TMFAppletConfigItem *> *_configList;
}

+ (instancetype)sharedInstance {
    static TMFAppletConfigManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TMFAppletConfigManager alloc] init];
        [manager loadLocalConfig];
    });
    return manager;
}

+ (NSString*)homeDirectory {
    static NSString* directoryPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        directoryPath =  [[docPath stringByAppendingPathComponent:@".TMFApplet"] stringByAppendingPathComponent:@"configfiles"];
        NSLog(@"configfiles:%@",directoryPath);
        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory] || !isDirectory) {
            [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            [[NSURL fileURLWithPath:directoryPath] setResourceValue:[NSNumber numberWithBool:YES]
                                                             forKey:NSURLIsExcludedFromBackupKey
                                                              error:nil];
        }
    });
    return directoryPath;
}

- (void)loadLocalConfig {
    _configList = [NSMutableArray new];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath: [TMFAppletConfigManager homeDirectory]];
    for (NSString *file in files) {
        TMFAppletConfigItem *item = [[TMFAppletConfigItem alloc] initWithFile:file];
        BOOL exist = NO;
        for (int i = 0; i<_configList.count; ++i) {
            if(_configList[i].updateTime < item.updateTime) {
                [_configList insertObject:item atIndex:i];
                exist = YES;
                break;
            }
        }
        if(!exist)
            [_configList addObject:item];
    }
}

- (NSMutableArray<TMFAppletConfigItem *> *)getAppletConfigList {
    return  _configList;
}

- (TMFAppletConfigItem *)getCurrentConfigItem {
    for (TMFAppletConfigItem *item in _configList) {
        if(item.checkmark) {
            return item;
        }
    }
    
    return nil;
}


- (BOOL)addAppletConfig:(NSString *)title andContent:(NSString *)content {
    if (content == nil) {
        return NO;
    }
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];

    if (err) {
        return NO;
    } else if (!dic || dic.count == 0) {
        return NO;
    }

    TMFAppletConfigItem *item = [TMFAppletConfigItem new];
    item.subTitle = [NSString stringWithFormat:@"%@ %@",dic[@"productId"],dic[@"shark"][@"httpUrl"]];

    if(item.subTitle.length<=0) {
        return  NO;
    }
    
    //保存文件
    NSString *filename = [NSString stringWithFormat:@"%f.json",[NSDate timeIntervalSinceReferenceDate]];
    item.title = title;
    item.checkmark = _configList.count == 0?YES:NO;
    item.content = content;
    item.filePath = filename;
    item.updateTime = [NSDate date];
    [item writefile];
    [_configList insertObject:item atIndex:0];
    
    return YES;
}

- (void)removeAppletConfigItem:(NSString *)path {
    for (TMFAppletConfigItem *item in _configList) {
        if([item.filePath isEqualToString:path]) {
            [_configList removeObject:item];
            break;
        }
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:[[TMFAppletConfigManager homeDirectory] stringByAppendingPathComponent:path] error:nil];
}

- (BOOL)checkAppletConfigTitle:(NSString *)title {
    for (TMFAppletConfigItem *item in _configList) {
        if([item.title isEqualToString:title]) {
            return YES;
        }
    }
    
    return NO;
}

@end
