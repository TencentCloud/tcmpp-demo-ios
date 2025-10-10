//
//  TCMPPPaymentMethodsController.m
//  TUIKitDemo
//
//  Created by xcode on 2024/9/12.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPPaymentMethodsController.h"
#import "TCMPPPayMethodCell.h"
#import "TCMPPPayView.h"
#import "PaymentManager.h"
#import "TCMPPPaySucessVC.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "TCMPPAddCardController.h"
#import "TCMPPDemoPayManager.h"
#import "ToastView.h"

@interface TCMPPPaymentMethodsController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) BOOL wasNavigationBarHidden;
@property (nonatomic, strong) UIButton *payBtn;

@end

@implementation TCMPPPaymentMethodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.delegate = self;
    [self initSubviews];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat topH = self.view.safeAreaInsets.top;
    // priceLabel
    UILabel *priceLabel = nil;
    UILabel *payMethodLbl = nil;
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label.text isEqualToString:NSLocalizedString(@"SelectPaymentMethod", nil)]) continue;
            if ([label.text containsString:@"$"]) priceLabel = label;
            if ([label.text isEqualToString:NSLocalizedString(@"PaymentMethod", nil)]) payMethodLbl = label;
        }
    }
    if (priceLabel) {
        priceLabel.frame = CGRectMake((self.view.bounds.size.width - priceLabel.frame.size.width) / 2.0, topH + 20, priceLabel.frame.size.width, priceLabel.frame.size.height);
    }
    if (payMethodLbl && priceLabel) {
        payMethodLbl.frame = CGRectMake(10, CGRectGetMaxY(priceLabel.frame) + 10, payMethodLbl.frame.size.width, payMethodLbl.frame.size.height);
    }
    // tableView
    if (self.tableView && payMethodLbl) {
        self.tableView.frame = CGRectMake(0, topH + 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60 - topH - 80);
    }
    // payBtn
    if (self.payBtn) {
        self.payBtn.frame = CGRectMake(20, self.view.frame.size.height - 60 - self.view.frame.origin.y, self.view.frame.size.width - 40, 40);
    }
}

- (void)initSubviews{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = NSLocalizedString(@"SelectPaymentMethod", nil);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.navigationItem.titleView = titleLabel;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    CGFloat topH = self.view.safeAreaInsets.top;
    
    self.money = [NSString stringWithFormat:@"$ %.2f", self.totalFee/10000];
    NSAttributedString *attributedPriceText = [self createRichTextForPrice:self.money];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topH + 20, 0, 0)];
    priceLabel.attributedText = attributedPriceText;
    [priceLabel sizeToFit];
    CGFloat centerX = self.view.bounds.size.width / 2.0 - priceLabel.frame.size.width / 2.0;
    priceLabel.frame = CGRectMake(centerX, topH + 20, priceLabel.frame.size.width, priceLabel.frame.size.height);
    [self.view addSubview:priceLabel];
    
    UILabel *payMethodLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(priceLabel.frame) + 10, 0, 0)];
    payMethodLbl.font = [UIFont systemFontOfSize:14];
    payMethodLbl.text = NSLocalizedString(@"PaymentMethod", nil);
    payMethodLbl.textColor = [UIColor lightGrayColor];
    [payMethodLbl sizeToFit];
    [self.view addSubview:payMethodLbl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topH + 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60 - topH - 80)];
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [payBtn setTitle:NSLocalizedString(@"ConfirmPayment", nil) forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor redColor];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.layer.cornerRadius = 20;
    payBtn.layer.masksToBounds = YES;
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    payBtn.frame = CGRectMake(20, self.view.frame.size.height - 60 - self.view.frame.origin.y, self.view.frame.size.width - 40, 40);
    [self.view addSubview:payBtn];
    self.payBtn = payBtn;
    [self.tableView reloadData];
}

- (void)payBtnClick{
    if (self.selectedIndexPath == nil) {
        UIImage *icon = [UIImage imageNamed:@"error"];
        ToastView *toast = [[ToastView alloc] initWithIcon:icon title:@"Please select payment method"];
        [toast showWithDuration:1.0];
        return;
    }
    TCMPPPayView *payAlert = [[TCMPPPayView alloc] init];
    payAlert.title = NSLocalizedString(@"Please enter the payment password", nil);
    payAlert.detail = NSLocalizedString(@"Payment", nil);
    payAlert.money = self.totalFee;
    payAlert.defaultPass = NSLocalizedString(@"Default password:666666", nil);
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPassword) {
        if (inputPassword) {
            if ([inputPassword isEqualToString:@"666666"]) {
                PayModel *payModel = self.datas[self.selectedIndexPath.row];
                [[TCMPPDemoPayManager sharedInstance] checkPayConfirm:@{@"payId":self.prePayId,@"payAmount":@(self.totalFee),@"payModel":payModel.payModel,@"payModelId":payModel.payModelId} completionHandler:^(NSError * _Nullable err, NSDictionary * _Nullable result) {
                    if (!err) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            TCMPPPaySucessVC *vc = [[TCMPPPaySucessVC alloc] init];
                            vc.iconURL = self.app.appIcon;
                            vc.name = self.app.appTitle;
                            vc.price = self.totalFee;
                            vc.dismissBlock = ^{
                                [self.navigationController popViewControllerAnimated:NO];
                                if (self.completeHandle) {
                                    self.completeHandle(result,nil);
                                }
                            };
                            vc.modalPresentationStyle = UIModalPresentationFullScreen;
                            UIViewController *current = UIApplication.sharedApplication.keyWindow.rootViewController;
                            if ([current.presentedViewController isKindOfClass:UINavigationController.class]) {
                                UINavigationController *nav = (UINavigationController *)current.presentedViewController;
                                [nav.topViewController presentViewController:vc animated:YES completion:nil];
                            }
                        });
                        return;
                    } else {
                        NSString *errStr = err.localizedDescription;
                        if (result[@"returnMessage"]) {
                            errStr = result[@"returnMessage"];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *icon = [UIImage imageNamed:@"error"];
                            ToastView *toast = [[ToastView alloc] initWithIcon:icon title:errStr];
                            [toast showWithDuration:1.0];
                        });
                    }
                }];
                          
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *icon = [UIImage imageNamed:@"error"];
                    ToastView *toast = [[ToastView alloc] initWithIcon:icon title:@"Wrong password"];
                    [toast showWithDuration:1.0];
                });
            }
        }
    };
                 
    payAlert.cancelHandle = ^(void) {
        UIImage *icon = [UIImage imageNamed:@"error"];
        ToastView *toast = [[ToastView alloc] initWithIcon:icon title:@"cancel pay"];
        [toast showWithDuration:1.0];
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"pay cancel" forKey:@"errMsg"];
//        NSError *error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
//        if (self.completeHandle) {
//            self.completeHandle(@{@"retmsg":error.localizedDescription},error);
//        }
    };
}

- (NSAttributedString *)createRichTextForPrice:(NSString *)priceText {
    UIFont *largeFont = [UIFont boldSystemFontOfSize:24.0];
    UIFont *smallFont = [UIFont systemFontOfSize:14.0];
    UIColor *textColor = [UIColor redColor];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceText attributes:@{NSForegroundColorAttributeName: textColor}];

    NSRange decimalPointRange = [priceText rangeOfString:@"."];

    if (decimalPointRange.location != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(0, 1)];
        [attributedString addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(decimalPointRange.location + 1, priceText.length - decimalPointRange.location - 1)];
    }

    [attributedString addAttribute:NSFontAttributeName value:largeFont range:NSMakeRange(1, decimalPointRange.location - 1)];

    return attributedString;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TCMPPPayMethodCell *cell = [[TCMPPPayMethodCell alloc] init];
//    if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {
//        [cell setCellType:PayMethodCellTypeBottom];
//        cell.leftTextLabel.text = @"Add bank card";
//        cell.rightImageView.image = [UIImage imageNamed:@"rectangle"];
//        return cell;
//    }
    PayModel *model = self.datas[indexPath.row];
    cell.leftTextLabel.text = model.payModelName;
    NSString *imgName = [indexPath isEqual:self.selectedIndexPath] ? @"add_selected" : @"add_unselect";
    cell.rightImageView.image = [UIImage imageNamed:imgName];
    if (indexPath.row == 0) {
        [cell setCellType:PayMethodCellTypeTop];
    }
    
    NSString *url = [NSURL URLWithString:model.payModelIcon].absoluteString;
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(async, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(),^{
                [cell.leftImageView setImage: image];
                [cell layoutSubviews];
        });
        });
    } else {
        cell.leftImageView.image = [UIImage imageWithContentsOfFile:url];
        [cell layoutSubviews];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
//    return self.datas.count + 1;// 添加银行卡
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {
//        TCMPPAddCardController *vc = [[TCMPPAddCardController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.dismissBlock = ^(TCMPPPayMethodCellModel * _Nonnull model) {
//            [self.datas insertObject:model atIndex:self.datas.count - 1];
//            [self.tableView reloadData];
//        };
//        return;
//    }
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
}

- (void)setPayResponseData:(PayResponseData *)payResponseData{
    _payResponseData = payResponseData;
    self.totalFee = payResponseData.actualAmount;
    self.prePayId = payResponseData.payId;
    self.datas = [NSMutableArray arrayWithArray:payResponseData.payModelList];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]) {
        return NO;
    }
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[NSClassFromString(@"MAWebViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"MagicBrushViewController") class]]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"pay cancel" forKey:@"errMsg"];
        NSError *error = [NSError errorWithDomain:@"KPayRequestDomain" code:-1003 userInfo:userInfo];
        if (self.completeHandle) {
            self.completeHandle(@{@"retmsg":error.localizedDescription},error);
        }
    }
}
@end
