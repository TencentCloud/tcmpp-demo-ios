//
//  TMFAppletConfigListViewController.m
//  TMFDemo
//
//  Created by stonelshi on 2022/4/18.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "TMFAppletConfigListViewController.h"
#import "TMFAppletConfigInputViewController.h"
#import "TMFAppletConfigManager.h"
#import <TCMPPSDK/TCMPPSDK.h>

@interface TMFAppletConfigListViewController() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation TMFAppletConfigListViewController {
    NSMutableArray<TMFAppletConfigItem *> *_configList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _configList = [[TMFAppletConfigManager sharedInstance] getAppletConfigList];
    
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    self.title = NSLocalizedString(@"configure server",nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleExitEvent)];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _configList.count>0?NSLocalizedString(@"Please select from the list below or add through the upper right corner",nil):NSLocalizedString(@"There is no configuration information at present, please add it in the upper right corner",nil);
}

- (void)handleExitEvent {
    TMFAppletConfigInputViewController* inputViewController = [TMFAppletConfigInputViewController new];
    inputViewController.addHandler = ^(NSError * _Nullable err) {
        [self.tableView reloadData];
        
        if(self->_configList.count == 1) {
            [self updateSelConfig];
        }
        
    };
    [self presentViewController:inputViewController animated:YES completion:nil];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _configList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
//    [cell updateCellAppearanceWithIndexPath:indexPath];
    NSInteger row = indexPath.row;
  
    cell.textLabel.text = _configList[row].title;
   
    cell.detailTextLabel.text = _configList[row].subTitle;
    
    cell.accessoryType = _configList[row].checkmark?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if(_configList[row].checkmark) {
        return;
    }
    
    [_configList[row] changeCheckmark:YES];
    
    // 刷新除了被点击的那个 cell 外的其他单选 cell
    // Refresh other radio-selected cells except the clicked cell
    NSMutableArray<NSIndexPath *> *indexPathsAnimated = [[NSMutableArray alloc] init];
    for (NSInteger i = 0, l = [self.tableView numberOfRowsInSection:0]; i < l; i++) {
        if (i != row) {
            [indexPathsAnimated addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [_configList[i] changeCheckmark:NO];
        }
    }

    [self.tableView reloadRowsAtIndexPaths:indexPathsAnimated withRowAnimation:UITableViewRowAnimationNone];

    // 直接拿到 cell 去修改 accessoryType，保证动画不受 reload 的影响
    // Get the cell directly to modify the accessoryType to ensure that the animation is not affected by reload
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self updateSelConfig];
}

//先要设Cell可编辑
//First make the Cell editable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !_configList[indexPath.row].checkmark;
}
//定义编辑样式
//Define editing styles
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
//Enter the edit mode and press the edit button that appears to perform the delete operation.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[TMFAppletConfigManager sharedInstance] removeAppletConfigItem:_configList[indexPath.row].filePath];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//修改编辑按钮文字
//Modify edit button text
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"delete";
}

- (NSString *)getUDID {
    //获取NSUserDefaults的单例模式
    //Get the singleton mode of NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *udid = [userDefaults objectForKey:@"udid"];
    if(udid)
        return udid;
    else {
        udid = [NSString stringWithFormat:@"test%.0f",[[NSDate date] timeIntervalSince1970]];
        
        [userDefaults setObject:udid forKey:@"udid"];
        return udid;
    }
}

- (void)updateSelConfig{
    TMFAppletConfigItem *item  = [[TMFAppletConfigManager sharedInstance] getCurrentConfigItem];
    if(item) {
        TMAServerConfig *config  = [[TMAServerConfig alloc] initWithSting:item.content];
        config.customizedUDID = [self getUDID];
        [[TMFMiniAppSDKManager sharedInstance] setConfiguration:config];
    }
}

@end
