//
//  TCMPPSettingsVC.m
//  TCMPPDemo
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPSettingsVC.h"
#import "TCMPPUserInfoEditVC.h"
#import "TCMPPSubscribeInfoVC.h"
#import "TCMPPDemoLoginManager.h"
#import "ToastView.h"

@interface TCMPPSettingsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *settingsItems;

@end

@implementation TCMPPSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", nil);
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self setupTableView];
    [self setupData];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 13.0, *)) {
        self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)setupData {
    self.settingsItems = @[
        @{
            @"title": NSLocalizedString(@"User Information", nil),
            @"subtitle": NSLocalizedString(@"Edit profile, avatar, nickname and phone number", nil),
            @"icon": @"person.circle",
            @"type": @"user_info"
        },
        @{
            @"title": NSLocalizedString(@"Service Notice", nil),
            @"subtitle": NSLocalizedString(@"View service messages and notifications", nil),
            @"icon": @"bell",
            @"type": @"subscribe_info"
        }
    ];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *item = self.settingsItems[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    if (@available(iOS 13.0, *)) {
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    if (@available(iOS 13.0, *)) {
        cell.imageView.image = [UIImage systemImageNamed:item[@"icon"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.settingsItems[indexPath.row];
    NSString *type = item[@"type"];
    
    if ([type isEqualToString:@"user_info"]) {
        TCMPPUserInfoEditVC *editVC = [[TCMPPUserInfoEditVC alloc] init];
        [self.navigationController pushViewController:editVC animated:YES];
    } else if ([type isEqualToString:@"subscribe_info"]) {
        TCMPPSubscribeInfoVC *subscribeVC = [[TCMPPSubscribeInfoVC alloc] init];
        [self.navigationController pushViewController:subscribeVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

@end 
