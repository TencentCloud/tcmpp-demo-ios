//
//  TCMPPAppCell.m
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/1.
//

#import "TCMPPAppCell.h"
#import "UIView+TZLayout.h"
#import "UIView+TCMPP.h"
#import "UIColor+TCMPP.h"
#import "TCMPPCommonTools.h"

@interface TCMPPAppCell ()

@property (strong, nonatomic) UIButton *more;

@end

@implementation TCMPPAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 48, 48)];
    [self.icon roundingCorners:UIRectCornerAllCorners cornerRadius:24];
//    self.icon.backgroundColor = UIColor.lightGrayColor;
    [self.icon setImage:[UIImage imageNamed:@"tmf_weapp_icon_default"]];
    [self.contentView addSubview:self.icon];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.tz_right + 15, self.icon.tz_top, 250, 22)];
    self.name.textColor = UIColor.blackColor;
    self.name.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.name];
    
    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.tz_right + 15, self.name.tz_bottom + 5, width - self.icon.tz_width - 15 * 3 - 45, 20)];
    self.detail.textColor = UIColor.lightGrayColor;
    self.detail.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.detail];
    
    self.category = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.tz_right + 15, self.detail.tz_bottom + 5, self.detail.tz_width, 18)];
    self.category.textColor = [UIColor tcmpp_colorWithHex:@"#FA9C45"];
    self.category.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.category];
    
    self.more = [[UIButton alloc] initWithFrame:CGRectMake(width - 45, 0, 45, 100)];
    [self.more setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [self.more setImage:[UIImage imageNamed:@"more_click"] forState:UIControlStateNormal];
    [self.more addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.more];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.category.tz_left, 100 - 0.5, width - self.icon.tz_width - 15 * 3, 0.5)];
    line.backgroundColor = [UIColor tcmpp_colorWithHex:@"#EEEEEE"];
    [self.contentView addSubview:line];
}

- (void)setAppInfo:(TMFMiniAppInfo *)appInfo {
    _appInfo = appInfo;
    if (!appInfo) {
        return;
    }
    [self.icon setImage:[UIImage imageNamed:@"tmf_weapp_icon_default"]];
    if(appInfo.appIcon) {
        [TCMPPCommonTools getImageWith:appInfo.appIcon completion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
            if (image) {
                self.icon.image = image;
            }
        }];
    }
    _name.text = appInfo.appTitle;
    if (appInfo.appDescription.length > 0) {
        _detail.hidden = NO;
        _detail.text = appInfo.appDescription;
        _category.tz_top = self.detail.tz_bottom + 5;
    } else {
        _detail.hidden = YES;
        _category.tz_top = self.name.tz_bottom + 5;
    }
    _category.textColor = [UIColor tcmpp_colorWithHex:@"#FA9C45"];
    if(appInfo.verType == TMAVersionDevelop) {
        _category.text = NSLocalizedString(@"Develop",nil);
    } else if(appInfo.verType == TMAVersionAudit) {
        _category.text = NSLocalizedString(@"Reviewed",nil);
    } else if(appInfo.verType == TMAVersionPreview) {
        _category.text = NSLocalizedString(@"Preview",nil);
    } else if(appInfo.verType == TMAVersionOnline) {
        _category.text = NSLocalizedString(@"Online",nil);
        _category.textColor = [UIColor tcmpp_colorWithHex:@"#0ABF5B"];
    } else if(appInfo.verType == TMAVersionLocal) {
        _category.text = NSLocalizedString(@"Local",nil);
    }
}

- (void)setSearchInfo:(TMFAppletSearchInfo *)searchInfo {
    _searchInfo = searchInfo;
    if (!searchInfo) {
        return;
    }
    [self.icon setImage:[UIImage imageNamed:@"tmf_weapp_icon_default"]];
    if(searchInfo.appIcon) {
        [TCMPPCommonTools getImageWith:searchInfo.appIcon completion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
            if (image) {
                self.icon.image = image;
            }
        }];
    }
    _name.text = searchInfo.appTitle;
    if (searchInfo.appIntro.length > 0) {
        _detail.hidden = NO;
        _detail.text = searchInfo.appIntro;
        _category.tz_top = self.detail.tz_bottom + 5;
    } else {
        _detail.hidden = YES;
        _category.tz_top = self.name.tz_bottom + 5;
    }
    _category.textColor = [UIColor tcmpp_colorWithHex:@"#FA9C45"];
    // appCategory  Logistics Services->Pickup/Delivery,Logistics Services->Search
    _category.text = [[searchInfo.appCategory componentsSeparatedByString:@","].firstObject componentsSeparatedByString:@"->"].firstObject;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMore:)]) {
        [self.delegate didClickMore:self.appInfo.appId?:self.searchInfo.appId];
    }
}

@end
