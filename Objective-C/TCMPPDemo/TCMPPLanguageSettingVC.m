//
//  TCMPPLanguageSettingVC.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/2.
//

#import "TCMPPLanguageSettingVC.h"
#import "UIColor+TCMPP.h"
#import "LanguageManager.h"
#import "TCMPPMainVC.h"
#import <TCMPPSDK/TCMPPSDK.h>

@interface TCMPPLanguageSettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *array;
@property (assign,nonatomic) NSInteger current;

@end

@implementation TCMPPLanguageSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backItem.title = @"";
    self.title = NSLocalizedString(@"Language",nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor tcmpp_colorWithHex:@"#F4F4F4"];
    self.array = @[@"中文",@"English",@"Français",@"Indonesia"];
    NSString *language = [[LanguageManager shared] currentLanguage];
    if ([language isEqualToString:@"zh-Hans"]) {
        _current = 0;
    } else if ([language isEqualToString:@"en"]) {
        _current = 1;
    } else if ([language isEqualToString:@"fr"]) {
        _current = 2;
    } else if ([language isEqualToString:@"id"]) {
        _current = 3;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.scrollEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.array[indexPath.row];
    if (indexPath.row == self.current) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *language = @"en";
    if (indexPath.row == 0) {
        language = @"zh-Hans";
    } else if (indexPath.row == 1) {
        language = @"en";
    } else if (indexPath.row == 2) {
        language = @"fr";
    } else if (indexPath.row == 3) {
        language = @"id";
    }
    [[LanguageManager shared] setCurrentLanguage:language];
    
    [[TMFMiniAppSDKManager sharedInstance] terminateAllApplications];
    
    TCMPPMainVC *rootViewController = [[TCMPPMainVC alloc] init];
    UINavigationController * navGationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    UIApplication.sharedApplication.keyWindow.rootViewController = navGationController;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = UIColor.whiteColor;
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        appearance.shadowColor = [UIColor clearColor];
        navGationController.navigationBar.standardAppearance = appearance;
        navGationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        navGationController.navigationBar.barTintColor = UIColor.whiteColor;
        [navGationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    }
    
    TCMPPLanguageSettingVC *vc = [[TCMPPLanguageSettingVC alloc] init];
    [navGationController pushViewController:vc animated:NO];
}

@end
