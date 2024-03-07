//
//  ViewController.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "TMFCodeScannerController.h"
#import "TMFMiniAppSDKManager.h"
#import "DemoTableCell.h"
#import "MiniAppTableCell.h"
#import "DebugInfoController.h"
#import "SearchResultViewController.h"

#import "TCMPPPayView.h"

#define UIColorFromHex(s) \
    [UIColor colorWithRed:(((s & 0xFF0000) >> 16)) / 255.0 green:(((s & 0xFF00) >> 8)) / 255.0 blue:((s & 0xFF)) / 255.0 alpha:1.0]
#define K_T_CELL @"t_cell"
#define K_C_CELL @"c_cell"

NSNotificationName const TMF_APPLET_LIST_CHANGE_NOTIFICATION = @"com.tencent.tcmpp.apps.change.notification";

@interface ViewController () <TMFCodeScannerControllerDelegate, UITableViewDelegate, UITableViewDataSource, DemoTableCellDelegate,UISearchResultsUpdating,UISearchBarDelegate>
// list of preset applet demos
@property (nonatomic, strong) NSMutableArray<TMFMiniAppInfo *> *demoList;
// List of recently used applets
@property (nonatomic, strong) NSMutableArray<TMFMiniAppInfo *> *recentList;
// Display the list of applets
@property (nonatomic, strong) UITableView *tableView;
// store tableCell height
@property (nonatomic, strong) NSMutableDictionary *dicH;

// scan code button
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ViewController {
    UIButton *navButton;
}

- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColorFromHex(0xE3EDFD);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    // for debug,show the debug info
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[self createImageWithColor:[UIColor clearColor] size:CGSizeMake(48, 48)
                                                                                           radius:0]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(openDebugInfoController)];
    [self.navigationItem setLeftBarButtonItem:leftItem animated:YES];

    self.navigationItem.title = NSLocalizedString(@"MiniApp Assistant", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 80)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromHex(0xE3EDFD);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createScanButton];

    [self initDataSource];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[[SearchResultViewController alloc] init]];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appletListChange) name:TMF_APPLET_LIST_CHANGE_NOTIFICATION object:nil];
}

- (void)createScanButton {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Scan the QR code of the miniapp", nil);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];

    CGSize labelSize = [titleLabel sizeThatFits:CGSizeMake(self.view.frame.size.width - 120, 50)];

    CGFloat buttonWidth = labelSize.width + 100;

    self.scanButton = [[UIButton alloc]
        initWithFrame:CGRectMake((self.view.frame.size.width - buttonWidth) / 2, self.view.frame.size.height - 80, buttonWidth, 50)];

    // create gradient layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.scanButton.bounds;
    // Set gradient color direction
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.colors =
        @[(id)[UIColor colorWithRed:0 green:0.431 blue:1 alpha:1].CGColor, (id)[UIColor colorWithRed:0 green:0.431 blue:1 alpha:0.4].CGColor];
    // Add the gradient layer to the button's layer
    [self.scanButton.layer addSublayer:gradientLayer];
    self.scanButton.layer.cornerRadius = 20;
    self.scanButton.layer.masksToBounds = YES;

    titleLabel.frame = CGRectMake((buttonWidth - labelSize.width - 25) / 2 + 25, (50 - labelSize.height) / 2, labelSize.width, labelSize.height);

    [self.scanButton addSubview:titleLabel];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x - 25, 15, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"tmf_scan_icon_default"]];
    [self.scanButton addSubview:imageView];

    [self.scanButton addTarget:self action:@selector(openQRCodeController) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.scanButton];
}

- (void)appletListChange {
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)initDataSource {
    NSArray *list = [[TMFMiniAppSDKManager sharedInstance] loadAppletsFromCache];
    if (list && list.count > 0) {
        self.recentList = [NSMutableArray arrayWithArray:list];
    } else {
        self.recentList = [[NSMutableArray alloc] initWithCapacity:2];
    }

    if (self.demoList) {
        [self.demoList removeAllObjects];
    }

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"default_mini_apps" ofType:@"json"];
    if (filePath) {
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        NSArray *apps = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:&error];
        if (apps) {
            for (NSDictionary *app in apps) {
                NSString *appId = app[@"appId"];
                if (appId && appId.length > 0) {
                    TMFMiniAppInfo *mp1 = [[TMFMiniAppInfo alloc] init];
                    mp1.appTitle = app[@"name"];
                    mp1.appId = appId;
                    mp1.appIcon = app[@"iconurl"];
                    mp1.verType = TMAVersionOnline;

                    [self addDemoListWithInfo:mp1];
                }
            }
        }
    }
}

- (void)addDemoListWithInfo:(TMFMiniAppInfo *)appInfo {
    if (!self.demoList) {
        self.demoList = [[NSMutableArray alloc] initWithCapacity:3];
    }

    for (TMFMiniAppInfo *app in self.recentList) {
        if ([app.appId isEqualToString:appInfo.appId] && app.verType == appInfo.verType) {
            [self.demoList addObject:app];
            return;
        }
    }

    [self.demoList addObject:appInfo];
}

- (void)openQRCodeController {
    TMFCodeScannerController *viewController = [[TMFCodeScannerController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openDebugInfoController {
    DebugInfoController *viewController = [[DebugInfoController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)showErrorInfo:(NSError *)err {
    NSString *errMsg = nil;
    NSString *localizedDescription = err.userInfo[NSLocalizedDescriptionKey];
    if (localizedDescription != nil) {
        errMsg = [NSString stringWithFormat:@"%@\n%ld\n%@",err.domain,(long)err.code,localizedDescription];
    } else {
        errMsg = [NSString stringWithFormat:@"%@\n%ld",err.domain,(long)err.code];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 更新搜索结果的显示
    
    NSString *inputStr = searchController.searchBar.text ;

    if(inputStr.length>=2) {
        [[TMFMiniAppSDKManager sharedInstance] searchAppletsWithName:inputStr completion:^(NSArray<TMFAppletSearchInfo *> * _Nonnull result, NSError * _Nonnull aError) {
            if(aError) {
                [self showErrorInfo:aError];
                return;
            }
            
            SearchResultViewController *resultVC = (SearchResultViewController*)self.searchController.searchResultsController;
            
            [resultVC.searchResults removeAllObjects];
            if(result && result.count>0) {
                [resultVC.searchResults addObjectsFromArray:result];
            }
            [resultVC.tableView reloadData];
        }];
    }
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // 处理搜索框的取消操作
    
    
}

#pragma TMFCodeScannerControllerDelegate

- (void)codeScannerControllerDidCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)codeScannerController:(TMFCodeScannerResource)type didScanResult:(NSArray<TMFCodeDetectorResult *> *)result {
    if (result.count <= 0) {
        return;
    }

    NSString *qrData = result[0].data;

    NSMutableArray *tempVCA = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *tempVC in tempVCA) {
        if ([tempVC isKindOfClass:[TMFCodeScannerController class]]) {
            [tempVCA removeObject:tempVC];
            break;
        }
    }
    self.navigationController.viewControllers = tempVCA;

    [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithQrData:qrData parentVC:self completion:^(NSError *_Nonnull error) {
        if(error) {
            [self showErrorInfo:error];
        }
    }];
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.recentList.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dicH[indexPath]) {
        NSNumber *num = self.dicH[indexPath];
        return [num floatValue];
    } else {
        return 88;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView registerClass:[DemoTableCell class] forCellReuseIdentifier:K_C_CELL];
        DemoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:K_C_CELL forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.dataAry = self.demoList;
        return cell;
    } else {
        [tableView registerClass:[MiniAppTableCell class] forCellReuseIdentifier:K_T_CELL];
        MiniAppTableCell *cell = [tableView dequeueReusableCellWithIdentifier:K_T_CELL forIndexPath:indexPath];
        cell.appInfo = self.recentList[indexPath.row];

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(10, 0, self.view.bounds.size.width - 20, 20);
    view.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, view.frame.size.width - 10, 20);
    NSArray *titles = @[NSLocalizedString(@"MiniApp demo", nil), NSLocalizedString(@"Recently used", nil)];
    label.text = titles[section];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorFromHex(0x334C6A);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section && self.recentList.count<=0) {
        return 300;
    } else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section && self.recentList.count<=0) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(10, 0, self.view.bounds.size.width - 20, 300);
        view.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width-79)/2, 80, 79, 92)];
        [imageView setImage:[UIImage imageNamed:@"no_recent_info"]];
        [view addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, view.frame.size.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        titleLabel.text = NSLocalizedString(@"No recently used miniapps", nil);
        [view addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, view.frame.size.width, 20)];
        subTitleLabel.font = [UIFont systemFontOfSize:14];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = [UIColor colorWithRed:0.502 green:0.546 blue:0.6 alpha:1];
        subTitleLabel.text = NSLocalizedString(@"Please scan the QR code of the miniapp to experience", nil);
        [view addSubview:subTitleLabel];

        return view;
    }

    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger row = indexPath.row;

        [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:self.recentList[row].appId verType:self.recentList[row].verType
                                                                 scene:TMAEntrySceneAIOEntry
                                                             firstPage:nil
                                                             paramsStr:nil
                                                              parentVC:self completion:^(NSError *_Nullable error) {
            [self showErrorInfo:error];
                                                              }];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ====== DemoTableCellDelegate ======
- (void)updateTableViewCellHeight:(DemoTableCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.dicH[indexPath] isEqualToNumber:@(height)]) {
        self.dicH[indexPath] = @(height);
        [self.tableView reloadData];
    }
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content {
    [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:content verType:TMAVersionOnline scene:TMAEntrySceneAIOEntry firstPage:nil
                                                         paramsStr:nil
                                                          parentVC:self completion:^(NSError *_Nullable error) {
        [self showErrorInfo:error];
                                                          }];
}

- (NSMutableDictionary *)dicH {
    if (!_dicH) {
        _dicH = [[NSMutableDictionary alloc] init];
    }
    return _dicH;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor clearColor];
        return;
    }

    // round rate
    CGFloat cornerRadius = 8;
    // size
    CGRect bounds = cell.bounds;

    UIView *headerView;
    if ([self respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        headerView = [self tableView:tableView viewForHeaderInSection:indexPath.section];
    }

    // draw the curve
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    // Create a new layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    // layer border path
    layer.path = bezierPath.CGPath;
    cell.layer.mask = layer;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // round rate
    CGFloat cornerRadius = 8;
    // size
    CGRect bounds = view.bounds;

    // draw the curve
    UIBezierPath *bezierPath = nil;
    // When it is the first row of the group, the upper left and upper right corners are rounded
    bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                             cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    // Create a new layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    // layer border path
    layer.path = bezierPath.CGPath;
    view.layer.mask = layer;
}

@end
