//
//  DebugInfo.m
//  TCMPPDemo
//
//  Created by 石磊 on 2025/1/6.
//

#import "DebugInfo.h"

#define MACurrentSearchType @"MACurrentSearchType"
#define TCMPPEnvironments @"TCMPPEnvironments"


@implementation DebugInfo


+ (instancetype)sharedInstance {
    static DebugInfo* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DebugInfo alloc] init];
    });
    return manager;
}


- (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


- (NSArray <NSDictionary *>*)defaultEnvironments{
    return @[@{@"title":@"Development",@"domain":@"http://superapp-dev.tcmppcloud.com/superapp/"},
             @{@"title":@"Test",@"domain":@"http://superapp-staging.tcmppcloud.com/superapp/"},
             @{@"title":@"Pre-release",@"domain":@"https://openapi-prerelease-hk.tcmppcloud.com/superapp/"},
             @{@"title":@"Singapore",@"domain":@"https://openapi-sg.tcmpp.com/superappv2/"},
             @{@"title":@"Hongkong",@"domain":@"https://openapi-hk.tcmpp.com/superapp/"},
             @{@"title":@"Frankfurt",@"domain":@"https://openapi-fk.tcmpp.com/superapp/"},
             @{@"title":@"Sao Paulo",@"domain":@"https://openapi-spl.tcmpp.com/superapp/"},
             @{@"title":@"Jakarta",@"domain":@"https://openapi-jkt.tcmpp.com/superapp/"},
             @{@"title":@"Telkomsel",@"domain":@"https://openapi-ts.tcmpp.com/superapp/"}
    ];
}

- (void)setEnvironmentWithTitle:(NSString *)title domain:(NSString *)domain{
    if (!title) {
        return;
    }
    if (!domain) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *environments = [[defaults objectForKey:TCMPPEnvironments] mutableCopy];
    if (!environments) {
        environments = [NSMutableArray array];
    }

    BOOL titleExists = NO;
    for (NSDictionary *environment in environments) {
        if ([environment[@"title"] isEqualToString:title]) {
            titleExists = YES;
            break;
        }
    }

    if (!titleExists) {
        NSDictionary *newEnvironment = @{@"title": title, @"domain": domain};
        [environments addObject:newEnvironment];
        [defaults setObject:environments forKey:TCMPPEnvironments];
        [defaults synchronize];
    }
}
- (NSArray *)getAllCustomEnvironments {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TCMPPEnvironments];
}
- (NSString *)currentEnvironments{
    if (!_currentEnvironments) {
        _currentEnvironments = @"https://openapi-sg.tcmpp.com/superappv2/";
    }
    return _currentEnvironments;
}
@end
