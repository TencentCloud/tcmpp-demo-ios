//
//  TCMPPMainVC.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/1.
//

#import "TCMPPMainVC.h"
#import "UIView+TCMPP.h"
#import "UIColor+TCMPP.h"
#import "TCMPPAppCell.h"
#import "TCMPPMenuView.h"
#import "UIView+TZLayout.h"
#import "TCMPPLoginVC.h"
#import "TCMPPLanguageSettingVC.h"
#import "ToastView.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "PaymentManager.h"
#import "DemoUserInfo.h"
#import "MiniAppDemoSDKDelegateImpl.h"
#import <TCMPPExtScanCode/TCMPPScanCodeController.h>
#import <TCMPPExtScanCode/TCMPPScanCodeResult.h>
@interface TCMPPMainVC ()<UITableViewDelegate,UITableViewDataSource,AppCellDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TCMPPMenuView *menu;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

// list of preset applet demos
@property (nonatomic, strong) NSMutableArray<TMFAppletSearchInfo *> *demoList;
// List of recently used applets
@property (nonatomic, strong) NSMutableArray<TMFMiniAppInfo *> *recentList;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger selectIndex;

@end

static NSString *cellIdentifier = @"cellIdentifier";

@implementation TCMPPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"MiniApp Assistant", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *itemBtn = [[UIButton alloc] init];
    [itemBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [itemBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    self.navigationItem.rightBarButtonItem = item;
    [self initUI];
    [self appletListChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appletListChange) name:@"com.tencent.tcmpp.apps.change.notification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clickMore {
    [self.view addSubview:self.menu];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:self.tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    [self.menu dismiss];
    [self.view removeGestureRecognizer:self.tap];
}

- (TCMPPMenuView *)menu {
    if (!_menu) {
        TCMPPMenuItem *scan = [[TCMPPMenuItem alloc] init];
        scan.icon = [UIImage imageNamed:@"scanner"];
        scan.title = NSLocalizedString(@"Scan",nil);
        scan.block = ^{
            __block TCMPPScanCodeController *scanVC = [[TCMPPScanCodeController alloc]init];
            __weak typeof(scanVC) weakVC = scanVC;
            scanVC.scanResultHandler = ^(NSArray *_Nullable result){
                [weakVC dismissViewControllerAnimated:NO completion:nil];
                if(scanVC) {
                    [self dismissViewControllerAnimated:NO completion:^{
                        if (result) {
                            if(result.count>0) {
                                TCMPPScanCodeResult* r = result[0];
                                [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithQrData:r.stringValue firstPage:nil paramsStr:[NSString stringWithFormat:@"noServer=%@",[MiniAppDemoSDKDelegateImpl sharedInstance].noServer ? @"1":@"0"] parentVC:self completion:^(NSError * _Nullable error) {
                                    [self showErrorInfo:error];
                                }];
                            }
                        } else {
                            NSLog(@"scan api return success but result is nil");
                        }
                    }];
                    scanVC = nil;
                }
            };
            scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:scanVC animated:YES completion:nil];
        };
        
        TCMPPMenuItem *language = [[TCMPPMenuItem alloc] init];
        language.icon = [UIImage imageNamed:@"language"];
        language.title = NSLocalizedString(@"Language",nil);
        language.block = ^{
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"";
            self.navigationItem.backBarButtonItem = backItem;
            TCMPPLanguageSettingVC *vc = [[TCMPPLanguageSettingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        TCMPPMenuItem *logout = [[TCMPPMenuItem alloc] init];
        logout.icon = [UIImage imageNamed:@"logout"];
        logout.title = NSLocalizedString(@"Log out",nil);
        logout.block = ^{
            [[TMFMiniAppSDKManager sharedInstance] terminateAllApplications];
            [DemoUserInfo sharedInstance].nickName = @"unknown";
            TCMPPLoginVC *vc = [[TCMPPLoginVC alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        };
        
        NSArray<TCMPPMenuItem *> *items = @[scan,language,logout];
        TCMPPMenuView *menu = [[TCMPPMenuView alloc] initWithMenuItems:items];
        menu.frame = CGRectMake(self.view.tz_width - 10 - 130, 10, 130, items.count * 50);
        [menu roundingCorners:UIRectCornerAllCorners cornerRadius:8.f];
        _menu = menu;
    }
    return _menu;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor tcmpp_colorWithHex:@"#F4F4F4"];
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:header];
    self.header = header;
    
    UIImageView *logoIV = [[UIImageView alloc] init];
    logoIV.image = [UIImage imageNamed:@"tcmpp_logo"];
    [header addSubview:logoIV];
    
    UILabel *logoLab = [[UILabel alloc] init];
    logoLab.textColor = UIColor.blackColor;
    //    logoLab.backgroundColor = UIColor.grayColor;
    logoLab.font = [UIFont systemFontOfSize:25];
    logoLab.text = @"TCMPP";
    [header addSubview:logoLab];
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = UIColor.blackColor;
    detailLab.font = [UIFont italicSystemFontOfSize:12];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.text = @"A platform that takes your App to the next level";
    [header addSubview:detailLab];
    
    header.translatesAutoresizingMaskIntoConstraints = NO;
    logoIV.translatesAutoresizingMaskIntoConstraints = NO;
    logoLab.translatesAutoresizingMaskIntoConstraints = NO;
    detailLab.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [header.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [header.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [header.heightAnchor constraintEqualToConstant:100],
        
        [logoIV.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:(self.view.frame.size.width - 135)/2],
        [logoIV.topAnchor constraintEqualToAnchor:header.topAnchor constant:10],
        [logoIV.widthAnchor constraintEqualToConstant:30],
        [logoIV.heightAnchor constraintEqualToConstant:30],
        
        [logoLab.leadingAnchor constraintEqualToAnchor:logoIV.trailingAnchor constant:10],
        [logoLab.topAnchor constraintEqualToAnchor:logoIV.topAnchor],
        [logoLab.widthAnchor constraintEqualToConstant:95],
        [logoLab.heightAnchor constraintEqualToConstant:30],
        
        [detailLab.leadingAnchor constraintEqualToAnchor:header.leadingAnchor],
        [detailLab.trailingAnchor constraintEqualToAnchor:header.trailingAnchor],
        [detailLab.topAnchor constraintEqualToAnchor:logoLab.bottomAnchor constant:20],
        [detailLab.heightAnchor constraintEqualToConstant:15],
    ]];
    
    UIView *bottom = [[UIView alloc] init];
    bottom.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottom];
    self.bottom = bottom;
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.tag = 0;
    [leftBtn setTitle:NSLocalizedString(@"My mini programs",nil) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:leftBtn];
    self.leftBtn = leftBtn;
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor tcmpp_colorWithHex:@"#006EFF"];
    [bottom addSubview:leftLine];
    self.leftLine = leftLine;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.tag = 1;
    [rightBtn setTitle:NSLocalizedString(@"Recently used", nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:rightBtn];
    self.rightBtn = rightBtn;
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor tcmpp_colorWithHex:@"#006EFF"];
    rightLine.alpha = 0.f;
    [bottom addSubview:rightLine];
    self.rightLine = rightLine;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.backgroundColor = UIColor.orangeColor;
    [tableView registerClass:[TCMPPAppCell class] forCellReuseIdentifier:cellIdentifier];
    [bottom addSubview:tableView];
    self.tableView = tableView;
    
    bottom.translatesAutoresizingMaskIntoConstraints = NO;
    leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
    rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
    leftLine.translatesAutoresizingMaskIntoConstraints = NO;
    rightLine.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [bottom.topAnchor constraintEqualToAnchor:header.bottomAnchor constant:15],
        [bottom.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bottom.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bottom.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [leftBtn.topAnchor constraintEqualToAnchor:bottom.topAnchor constant:20],
        [leftBtn.widthAnchor constraintEqualToConstant:180],
        [leftBtn.centerXAnchor constraintEqualToAnchor:bottom.centerXAnchor constant:-180/2],
        [leftBtn.heightAnchor constraintEqualToConstant:22],
        
        [leftLine.topAnchor constraintEqualToAnchor:leftBtn.bottomAnchor constant:10],
        [leftLine.widthAnchor constraintEqualToConstant:20],
        [leftLine.centerXAnchor constraintEqualToAnchor:leftBtn.centerXAnchor],
        [leftLine.heightAnchor constraintEqualToConstant:4],
        
        [rightBtn.topAnchor constraintEqualToAnchor:bottom.topAnchor constant:20],
        [rightBtn.widthAnchor constraintEqualToConstant:180],
        [rightBtn.centerXAnchor constraintEqualToAnchor:bottom.centerXAnchor constant:180/2],
        [rightBtn.heightAnchor constraintEqualToConstant:22],
        
        [rightLine.topAnchor constraintEqualToAnchor:rightBtn.bottomAnchor constant:10],
        [rightLine.widthAnchor constraintEqualToConstant:20],
        [rightLine.centerXAnchor constraintEqualToAnchor:rightBtn.centerXAnchor],
        [rightLine.heightAnchor constraintEqualToConstant:4],
        
        [tableView.topAnchor constraintEqualToAnchor:leftLine.bottomAnchor],
        [tableView.widthAnchor constraintEqualToAnchor:bottom.widthAnchor],
        [tableView.bottomAnchor constraintEqualToAnchor:bottom.bottomAnchor],
        [tableView.centerXAnchor constraintEqualToAnchor:bottom.centerXAnchor],
    ]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.header roundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:10.f];
    [self.bottom roundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadius:10.f];
    
    [self.leftLine roundingCorners:UIRectCornerAllCorners cornerRadius:2];
    [self.rightLine roundingCorners:UIRectCornerAllCorners cornerRadius:2];
}

- (void)clickBtn:(UIButton *)sender {
    if (sender.tag == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.leftBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.leftLine.alpha = 1.f;
            self.rightLine.alpha = 0.f;
        } completion:nil];
        self.dataSource = self.demoList;
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            self.leftLine.alpha = 0.f;
            self.rightLine.alpha = 1.f;
        } completion:nil];
        self.dataSource = self.recentList;
    }
    self.selectIndex = sender.tag;
    [self.tableView reloadData];
}

- (void)appletListChange {
    [self initDataSource];
    if (self.selectIndex == 0) {
        self.dataSource = self.demoList;
    } else {
        self.dataSource = self.recentList;
    }
    [self.tableView reloadData];
}

- (void)initDataSource {
    NSArray *list = [[TMFMiniAppSDKManager sharedInstance] loadAppletsFromCache];
    self.recentList = [NSMutableArray arrayWithArray:list];

    if (self.demoList) {
        [self.demoList removeAllObjects];
    } else {
        self.demoList = [[NSMutableArray alloc] init];
    }

    [[TMFMiniAppSDKManager sharedInstance] searchAppletsWithName:@"" completion:^(NSArray<TMFAppletSearchInfo *> * _Nullable datas, NSError * _Nullable error) {
        [self.demoList addObjectsFromArray:datas];
        if (self.selectIndex == 0) {
            self.dataSource = self.demoList;
        }
        [self.tableView reloadData];
    }];
}

- (void)showErrorInfo:(NSError *)err {
    if(err==nil) {
        return;
    }
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

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMPPAppCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TCMPPAppCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    if (self.selectIndex == 0) {
        TMFAppletSearchInfo *info = self.dataSource[indexPath.row];
        cell.searchInfo = info;
        cell.appInfo = nil;
    } else {
        TMFMiniAppInfo *info = self.dataSource[indexPath.row];
        cell.searchInfo = nil;
        cell.appInfo = info;
    }
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *noServerStr = [MiniAppDemoSDKDelegateImpl sharedInstance].noServer ? @"1":@"0";
    if (self.selectIndex == 0) {
        TMFAppletSearchInfo *info = self.dataSource[indexPath.row];
        [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:info.appId 
                                                               verType:3
                                                                 scene:TMAEntrySceneAIOEntry
                                                             firstPage:nil
                                                             paramsStr:[NSString stringWithFormat:@"noServer=%@",noServerStr]
                                                              parentVC:self
                                                            completion:^(NSError * _Nullable error) {
            [self showErrorInfo:error];
        }];
    } else {
        TMFMiniAppInfo *info = self.dataSource[indexPath.row];
        [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:info.appId verType:info.verType
                                                                 scene:TMAEntrySceneAIOEntry
                                                             firstPage:nil
                                                             paramsStr:[NSString stringWithFormat:@"noServer=%@",noServerStr]
                                                              parentVC:self completion:^(NSError *_Nullable error) {
            [self showErrorInfo:error];
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didClickMore:(NSString *)appId {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"Preload", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[TMFMiniAppSDKManager sharedInstance] preloadMiniApps:@[appId] isDownload:YES complete:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if (!error) {
                UIImage *icon = [UIImage imageNamed:@"success"];
                ToastView *toast = [[ToastView alloc] initWithIcon:icon title:NSLocalizedString(@"Preloaded successfully",nil)];
                [toast showWithDuration:2];
            }
        }];
    }];
    [alertVC addAction:alertA];
    
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:NSLocalizedString(@"Clear cache", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[TMFMiniAppSDKManager sharedInstance] clearCacheWithAppID:appId];
        UIImage *icon = [UIImage imageNamed:@"success"];
        ToastView *toast = [[ToastView alloc] initWithIcon:icon title:NSLocalizedString(@"Cache cleared successfully",nil)];
        [toast showWithDuration:2];
    }];
    [alertVC addAction:alertB];
    
    UIAlertAction *alertC = [UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[TMFMiniAppSDKManager sharedInstance] closeMiniAppWithAppID:appId];
        UIImage *icon = [UIImage imageNamed:@"success"];
        ToastView *toast = [[ToastView alloc] initWithIcon:icon title:NSLocalizedString(@"Reset successfully",nil)];
        [toast showWithDuration:2];
    }];
    [alertVC addAction:alertC];
    
    UIAlertAction *alertD = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:nil];
    [alertVC addAction:alertD];
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
