//
//  TCMPPPaySucessVC.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/12.
//

#import "TCMPPPaySucessVC.h"
#import "UIView+TZLayout.h"
#import "TCMPPCommonTools.h"

@implementation TCMPPPaySucessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self initUI];
}

- (void)initUI {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + [TCMPPCommonTools safeAreaInsets].top, 200, 20)];
    title.textColor = [UIColor colorWithRed:96.f/255 green:193.f/255 blue:116.f/255 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    title.tz_centerX = self.view.tz_centerX;
    title.font = [UIFont boldSystemFontOfSize:18];
    title.text = NSLocalizedString(@"Pay Successfully", nil);
    [self.view addSubview:title];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, title.tz_bottom + 100, 60, 60)];
    icon.tz_centerX = title.tz_centerX;
    icon.layer.cornerRadius = 30.f;
    icon.layer.masksToBounds = YES;
    [icon setImage:[UIImage imageNamed:@"tmf_weapp_icon_default"]];
    [TCMPPCommonTools getImageWith:self.iconURL completion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
        if (image) {
            icon.image = image;
        }
    }];
    [self.view addSubview:icon];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.tz_bottom + 20, self.view.tz_width, 20)];
    name.textColor = [UIColor blackColor];
    name.textAlignment = NSTextAlignmentCenter;
    name.tz_centerX = self.view.tz_centerX;
    name.font = [UIFont systemFontOfSize:18];
    name.text = self.name;
    [self.view addSubview:name];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, name.tz_bottom + 50, self.view.tz_width, 40)];
    price.textColor = [UIColor blackColor];
    price.textAlignment = NSTextAlignmentCenter;
    price.tz_centerX = self.view.tz_centerX;
    price.font = [UIFont systemFontOfSize:38];
    price.text = [NSString stringWithFormat:@"$ %.2f", self.price/100.f];
    [self.view addSubview:price];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.tz_bottom - 200, 200, 50)];
    doneBtn.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
    doneBtn.titleLabel.textColor = UIColor.blackColor;
    [doneBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [doneBtn setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.tz_centerX = self.view.tz_centerX;
    doneBtn.layer.cornerRadius = 8.f;
    doneBtn.layer.masksToBounds = YES;
    [self.view addSubview:doneBtn];
}

- (void)doneClick {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.dismissBlock) {
            strongSelf.dismissBlock();
        }
    }];
}

@end
