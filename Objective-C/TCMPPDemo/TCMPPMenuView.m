//
//  TCMPPMenuView.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/1.
//

#import "TCMPPMenuView.h"
#import "UIView+TZLayout.h"
#import "UIView+TCMPP.h"
#import "UIColor+TCMPP.h"

@interface TCMPPMenuView ()

@property (strong,nonatomic) NSArray<TCMPPMenuItem *> *menuItems;

@end

@implementation TCMPPMenuView

- (instancetype)initWithMenuItems:(NSArray<TCMPPMenuItem *> *)menuItems {
    if (self  = [super initWithFrame:CGRectZero]) {
        _menuItems = menuItems;
        self.backgroundColor = [UIColor tcmpp_colorWithHex:@"#4C4C4C"];
        [menuItems enumerateObjectsUsingBlock:^(TCMPPMenuItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * idx, 130, 50)];
            content.tag = idx;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            [content addGestureRecognizer:tap];
            [self addSubview:content];
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 24, 24)];
            iv.image = obj.icon;
            [content addSubview:iv];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(iv.tz_right + 10, 13, 130 - 13 - 10 - 24, 24)];
            title.font = [UIFont systemFontOfSize:15];
            title.textColor = UIColor.whiteColor;
            title.text = obj.title;
            [content addSubview:title];
        }];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    self.menuItems[tap.view.tag].block();
    [self dismiss];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end

@implementation TCMPPMenuItem

@end
