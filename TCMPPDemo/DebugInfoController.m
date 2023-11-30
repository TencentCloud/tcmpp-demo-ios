//
//  DebugInfoController.m
//  TCMPPDemo
//
//  Created by 石磊 on 2023/4/28.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "DebugInfoController.h"
#import "TMFAppletConfigListViewController.h"
#import "TMFMiniAppSDKManager.h"

#import <sys/sysctl.h>


@interface DebugInfoController ()
@property(nonatomic,strong) NSDictionary *dataSourceWithDetailText;
@end

@implementation DebugInfoController

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSRange range3 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\\/\\/" withString:@"//" options:NSLiteralSearch range:range3];
    
    return mutStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)initDataSource {
    NSMutableDictionary<NSString *, NSString *> *dataSourceWithDetailText = [[NSMutableDictionary alloc] init];
    
    [dataSourceWithDetailText setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"BundleID"];
    
    NSDictionary *debugInfo = [[TMFMiniAppSDKManager sharedInstance] getDebugInfo];
    
    for (NSString *key in debugInfo)
    {
        if([key isEqualToString:@"domains"] || [key isEqualToString:@"privacy_apis"]) {
            [dataSourceWithDetailText setObject:[self convertToJsonData:debugInfo[key]] forKey:key];
        } else {
            [dataSourceWithDetailText setObject:debugInfo[key] forKey:key];
        }
    }
    
    [dataSourceWithDetailText setObject:[self _UIDevice_mqqIdentifier] forKey:@"DeviceModel"];
    
    [dataSourceWithDetailText setObject:[self firmware] forKey:@"Firmware"];
    
    [dataSourceWithDetailText setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"AppVersion"];

    [dataSourceWithDetailText setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] forKey:@"AppBuildNo"];

    self.dataSourceWithDetailText = dataSourceWithDetailText;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID=@"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSString *keyName = self.dataSourceWithDetailText.allKeys[indexPath.row];
    cell.textLabel.text = keyName;
    cell.detailTextLabel.text = (NSString *)[self.dataSourceWithDetailText objectForKey:keyName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataSourceWithDetailText.allKeys[indexPath.row];
    [self didSelectCellWithTitle:title];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceWithDetailText.count;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self copyInfo:title];
}

- (void)copyInfo:(NSString *)title {
    NSString *info = self.dataSourceWithDetailText[title];
    if (info) {
        [[UIPasteboard generalPasteboard] setString:info];
//        [QMUITips showSucceed:[NSString stringWithFormat:@"%@ Copied to clipboard",title] inView:self.view hideAfterDelay:2.0];
    }
}

- (void)openServerConfigList {
    TMFAppletConfigListViewController *viewController = [[TMFAppletConfigListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)setupNavigationItems {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openServerConfigList)];
    self.title = @"DebugInfo";
}

// 从 `UIDevice (MQQExtension)` 迁移
- (NSString *)_UIDevice_mqqIdentifier
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *identifier = [NSString stringWithUTF8String:machine];
    free(machine);
    return identifier;
}

- (NSString *)firmware
{
#if TARGET_OS_IPHONE
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
#else
    NSOperatingSystemVersion operatingSystemVersion = [NSProcessInfo processInfo].operatingSystemVersion;
    return [NSString stringWithFormat:@"%ld.%ld.%ld",
            (long)operatingSystemVersion.majorVersion,
            (long)operatingSystemVersion.minorVersion,
            (long)operatingSystemVersion.patchVersion];
#endif
}
@end
