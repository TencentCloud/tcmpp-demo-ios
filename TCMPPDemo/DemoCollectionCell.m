//
//  TestCollectionCell.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "DemoCollectionCell.h"

@interface DemoCollectionCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *image;

@end

@implementation DemoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 48, 48)];
        [self addSubview:self.image];
        
        self.label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 2;
        _label.frame = CGRectMake(0, 50, 60, 40);
        _label.textColor = UIColor.blackColor;
        _label.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setAppInfo:(TMFMiniAppInfo *)appInfo {
    if(_appInfo != appInfo) {
        _appInfo = appInfo;
        self.label.text = appInfo.appTitle;
        
        if(appInfo.appIcon && appInfo.appIcon.length>0) {
            dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(async, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:appInfo.appIcon]];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.image setImage: image];
                });
            });
        } else {
            [self.image setImage: [UIImage imageNamed:@"tmf_weapp_icon_default"]];
        }
    }
}

@end
