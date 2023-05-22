//
//  MiniAppTableCell.m
//  TCMPPDemo
//
//  Created by 石磊 on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "MiniAppTableCell.h"


@interface MiniAppTableCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *verTypeLabel;
@end


@implementation MiniAppTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        self.titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        self.verTypeLabel = [UILabel new];
        _verTypeLabel.backgroundColor = [UIColor colorWithRed:0.9176 green:0.9451 blue:0.9922 alpha:1];
        _verTypeLabel.font = [UIFont systemFontOfSize:12];
        _verTypeLabel.textColor = [UIColor colorWithRed:0.157 green:0.443 blue:0.965 alpha:1];
        _verTypeLabel.textAlignment = NSTextAlignmentCenter;
        _verTypeLabel.layer.cornerRadius = 10;
        _verTypeLabel.layer.masksToBounds = YES;
        _verTypeLabel.hidden = YES;
        [self.contentView addSubview:_verTypeLabel];
    }
    return self;
}

- (void)setAppInfo:(TMFMiniAppInfo *)appInfo {
    if(_appInfo != appInfo) {
        _appInfo = appInfo;
        self.titleLabel.text = appInfo.appTitle;
        
        if(appInfo.verType == TMAVersionDevelop) {
            _verTypeLabel.hidden = NO;
            _verTypeLabel.text = NSLocalizedString(@"Develop",nil);
        } else if(appInfo.verType == TMAVersionAudit) {
            _verTypeLabel.hidden = NO;
            _verTypeLabel.text = NSLocalizedString(@"Reviewed",nil);
        }  else if(appInfo.verType == TMAVersionPreview) {
            _verTypeLabel.hidden = NO;
            _verTypeLabel.text = NSLocalizedString(@"Preview",nil);
        }else {
            _verTypeLabel.hidden = YES;
        }
        
        if(appInfo.appIcon) {
            dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(async, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:appInfo.appIcon]];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.iconView setImage: image];
                });
            });
        } else {
            [self.iconView setImage:[UIImage imageNamed:@"tmf_weapp_icon_default"]];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _iconView.frame = CGRectMake(10, 15, 48, 48);
    _titleLabel.frame = CGRectMake(70, 0, self.frame.size.width -130, 78);
    _verTypeLabel.frame =  CGRectMake(self.frame.size.width - 80, 27, 60, 24);
}

@end
