//
//  TCMPPLoginVC.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/7/31.
//

#import "TCMPPLoginVC.h"
#import "UIView+TZLayout.h"
#import "UIColor+TCMPP.h"
#import "TCMPPDemoLoginManager.h"
#import "ToastView.h"
#import "TCMPPMainVC.h"
#import "DemoUserInfo.h"

@interface TCMPPLoginVC ()

@property (strong, nonatomic) UITextField *tf;

@end

@implementation TCMPPLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = UIColor.whiteColor;
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.tz_width - 218)/2, 150, 50, 50)];
    logoIV.image = [UIImage imageNamed:@"tcmpp_logo"];
    [self.view addSubview:logoIV];
    
    UILabel *logoLab = [[UILabel alloc] initWithFrame:CGRectMake(logoIV.tz_right + 10, 150, 155, 50)];
    logoLab.textColor = UIColor.blackColor;
//    logoLab.backgroundColor = UIColor.grayColor;
    logoLab.font = [UIFont systemFontOfSize:45];
    logoLab.text = @"TCMPP";
    [self.view addSubview:logoLab];
    
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.tz_width - 325)/2, logoIV.tz_bottom + 15, 325, 20)];
    detailLab.textColor = UIColor.blackColor;
//    logoLab.backgroundColor = UIColor.grayColor;
    detailLab.font = [UIFont italicSystemFontOfSize:14];
    detailLab.text = @"A platform that takes your App to the next level";
    [self.view addSubview:detailLab];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((self.view.tz_width - 320)/2, detailLab.tz_bottom + 50, 320, 54)];
    bgView.backgroundColor = [UIColor tcmpp_colorWithHex:@"#F4F4F4"];
    bgView.layer.cornerRadius = 8.f;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, 320 - 15 * 2, 54 - 15 * 2)];
    tf.textColor = UIColor.blackColor;
    tf.font = [UIFont systemFontOfSize:14];
    tf.placeholder = NSLocalizedString(@"Please enter the username",nil);
    [bgView addSubview:tf];
    _tf = tf;
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.tz_width - 320)/2, bgView.tz_bottom + 30, 320, 54)];
    loginBtn.backgroundColor = [UIColor tcmpp_colorWithHex:@"#006EFF"];
    loginBtn.layer.cornerRadius = 8.f;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:NSLocalizedString(@"Log in",nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)login {
    [_tf resignFirstResponder];
    if (_tf.text.length == 0) {
        return;
    }
    // App calls the login interface, saves the token after the call is successful, and then jumps to the home page.
    [[TCMPPDemoLoginManager sharedInstance] loginUser:_tf.text completeion:^(NSError * _Nullable err, NSString * _Nullable value) {
        if (!err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DemoUserInfo sharedInstance].nickName = self.tf.text;
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
                UIImage *icon = [UIImage imageNamed:@"success"];
                ToastView *toast = [[ToastView alloc] initWithIcon:icon title:NSLocalizedString(@"Logged in successfully",nil)];
                [toast showWithDuration:2];
            });
        }
    }];
}

@end
