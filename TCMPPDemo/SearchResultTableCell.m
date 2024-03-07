//
//  SearchResultTableCell.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/11/22.
//

#import "SearchResultTableCell.h"

@interface SearchResultTableCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@end


@implementation SearchResultTableCell

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
    }
    return self;
}

- (void)setAppInfo:(TMFAppletSearchInfo *)appInfo {
    if(_appInfo != appInfo) {
        _appInfo = appInfo;
        self.titleLabel.text = appInfo.appTitle;
        
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
}

@end
