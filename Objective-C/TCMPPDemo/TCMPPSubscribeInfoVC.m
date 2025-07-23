//
//  TCMPPSubscribeInfoVC.m
//  TCMPPDemo
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import "TCMPPSubscribeInfoVC.h"
#import "TCMPPDemoLoginManager.h"
#import <TCMPPSDK/TCMPPSDK.h>
#import "ToastView.h"

#define kAppIconViewWidth 25.0f
#define kAppIconViewHeight 25.0
#define kAppNameLblLeftMargin 10.0f
#define kTitleLblTopMargin 10.0f
#define kContentLblTopMargin 5.0f
#define kCheckDetailsLblHeight 20.0f
#define kSeparatorLineHeight 0.5f
#define kContentLblFontSize 14.0f

@interface SubscribeInfoModel : NSObject

@property (nonatomic, copy) NSString *TmplID;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, assign) NSInteger DataTime;
@property (nonatomic, copy) NSString *MessageID;
@property (nonatomic, copy) NSString *TmplTitle;
@property (nonatomic, copy) NSString *MnpName;
@property (nonatomic, copy) NSString *MnpId;
@property (nonatomic, copy) NSString *Page;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, assign) CGFloat cellH;

- (SubscribeInfoModel *)initWithJsonDatas:(NSDictionary *)jsonDatas;

@end

@implementation SubscribeInfoModel

- (SubscribeInfoModel *)initWithJsonDatas:(NSDictionary *)jsonDatas {
    if (self = [super init]) {
        self.TmplID = jsonDatas[@"TmplID"];
        self.Content = jsonDatas[@"Content"];
        self.DataTime = [jsonDatas[@"DataTime"] integerValue];
        self.MessageID = jsonDatas[@"MessageID"];
        self.TmplTitle = jsonDatas[@"TmplTitle"];
        self.MnpName = jsonDatas[@"MnpName"];
        self.MnpId = jsonDatas[@"MnpId"];
        self.Page = jsonDatas[@"Page"];
        self.State = jsonDatas[@"State"];
    }
    return self;
}

@end

@interface SubscribeInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIImageView *appIconView;
@property (nonatomic, strong) UILabel *appNameLbl;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *checkDetailsLbl;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *separatorLine1;
@property (nonatomic, assign) CGFloat contentLblH;
@property (nonatomic, strong) UIImageView *topRightImg;
@property (nonatomic, strong) UIImageView *bottomRightImg;

- (void)setCellDatas:(SubscribeInfoModel *)subscribeInfoModel;

@end

@implementation SubscribeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.timeLbl = [[UILabel alloc] init];
    self.timeLbl.font = [UIFont boldSystemFontOfSize:14];
    self.timeLbl.textColor = [UIColor lightGrayColor];
    self.timeLbl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLbl];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 5.0;
    self.cardView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.cardView];
    
    self.appIconView = [[UIImageView alloc] init];
    self.appIconView.image = [UIImage imageNamed:@"tcmpp_share_icon"];
    [self.cardView addSubview:self.appIconView];
    
    self.topRightImg = [[UIImageView alloc] init];
    self.topRightImg.image = [UIImage imageNamed:@"white_more"];
    [self.cardView addSubview:self.topRightImg];

    self.appNameLbl = [[UILabel alloc] init];
    self.appNameLbl.font = [UIFont boldSystemFontOfSize:16];
    self.appNameLbl.textColor = [UIColor blackColor];
    [self.cardView addSubview:self.appNameLbl];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.cardView addSubview:self.separatorLine];

    self.titleLbl = [[UILabel alloc] init];
    [self.cardView addSubview:self.titleLbl];

    self.contentLbl = [[UILabel alloc] init];
    self.contentLbl.numberOfLines = 0;
    self.contentLbl.textColor = [UIColor blackColor];
    self.contentLbl.font = [UIFont systemFontOfSize:kContentLblFontSize];
    [self.cardView addSubview:self.contentLbl];
    
    self.separatorLine1 = [[UIView alloc] init];
    self.separatorLine1.backgroundColor = [UIColor lightGrayColor];
    [self.cardView addSubview:self.separatorLine1];

    self.checkDetailsLbl = [[UILabel alloc] init];
    self.checkDetailsLbl.font = [UIFont systemFontOfSize:14];
    self.checkDetailsLbl.text = NSLocalizedString(@"Check the details", nil);
    self.checkDetailsLbl.textColor = [UIColor blackColor];
    [self.cardView addSubview:self.checkDetailsLbl];
    
    self.bottomRightImg = [[UIImageView alloc] init];
    self.bottomRightImg.image = [UIImage imageNamed:@"miniApp_tousu_icon"];
    [self.cardView addSubview:self.bottomRightImg];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLbl.frame = CGRectMake(0, 20, CGRectGetWidth(self.frame) - 20, 20);
    self.cardView.frame = CGRectMake(10, 50, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 50);
    self.appIconView.frame = CGRectMake(10, 10, kAppIconViewWidth, kAppIconViewHeight);
    self.appNameLbl.frame = CGRectMake(CGRectGetMaxX(self.appIconView.frame) + kAppNameLblLeftMargin, 13, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.appIconView.frame) - kAppNameLblLeftMargin * 2, 20);
    self.topRightImg.frame = CGRectMake(self.frame.size.width - 70, 15, 35, 8);

    self.separatorLine.frame = CGRectMake(0, CGRectGetMaxY(self.appIconView.frame) + 10, CGRectGetWidth(self.cardView.frame), kSeparatorLineHeight);
    self.titleLbl.frame = CGRectMake(10, CGRectGetMaxY(self.separatorLine.frame) + kTitleLblTopMargin, CGRectGetWidth(self.frame) - 20, 20);
    self.contentLbl.frame = CGRectMake(10, CGRectGetMaxY(self.titleLbl.frame) + kContentLblTopMargin, CGRectGetWidth(self.frame) - 20, self.contentLblH);
    self.separatorLine1.frame = CGRectMake(10, CGRectGetMaxY(self.contentLbl.frame) + 10, CGRectGetWidth(self.cardView.frame) - 20, kSeparatorLineHeight);
    self.checkDetailsLbl.frame = CGRectMake(10, CGRectGetMaxY(self.separatorLine1.frame) + 10, 200, kCheckDetailsLblHeight);
    self.bottomRightImg.frame = CGRectMake(self.frame.size.width - 50, CGRectGetMaxY(self.separatorLine1.frame) + 10, 10, 15);
}

- (void)setCellDatas:(SubscribeInfoModel *)subscribeInfoModel {
    self.appNameLbl.text = subscribeInfoModel.MnpName;
    self.titleLbl.text = subscribeInfoModel.TmplTitle;
    self.contentLbl.text = subscribeInfoModel.Content;
    self.contentLblH = [self calculateContentLblHeight:subscribeInfoModel.Content];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:subscribeInfoModel.DataTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLbl.text = [formatter stringFromDate:date];
}

- (CGFloat)calculateContentLblHeight:(NSString *)content {
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.frame) - 40, MAXFLOAT);
    CGSize contentSize = [content boundingRectWithSize:maxSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kContentLblFontSize]}
                                              context:nil].size;
    return contentSize.height;
}

@end

@interface TCMPPSubscribeInfoVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <SubscribeInfoModel *> *modelDatas;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TCMPPSubscribeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Service Notice", nil);
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self setupTableView];
    [self requestDatas];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.tableView registerClass:[SubscribeInfoCell class] forCellReuseIdentifier:@"SubscribeInfoCellID"];
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

- (void)refreshData {
    [self requestDatas];
}

- (void)requestDatas {
    NSString *token = [TCMPPUserInfo sharedInstance].token;
    NSString *appId = [[TMFMiniAppSDKManager sharedInstance] getConfigAppKey];
    
    if (!token || !appId) {
        [self showToast:NSLocalizedString(@"Please login first", nil)];
        [self.refreshControl endRefreshing];
        return;
    }
    
    [[TCMPPDemoLoginManager sharedInstance] getMessage:token appId:appId offset:0 success:^(NSArray * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            
            if (![message isKindOfClass:[NSArray class]]) {
                [self showToast:NSLocalizedString(@"No messages", nil)];
                return;
            }
            
            if (!message.count) {
                [self showToast:NSLocalizedString(@"No messages", nil)];
                return;
            }
            
            NSMutableArray *arrayDatas = [NSMutableArray array];
            for (NSDictionary *json in message) {
                SubscribeInfoModel *model = [[SubscribeInfoModel alloc] initWithJsonDatas:json];
                [arrayDatas addObject:model];
            }
            self.modelDatas = [NSArray arrayWithArray:arrayDatas];
            [self.tableView reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self showToast:error.localizedDescription ?: NSLocalizedString(@"Failed to load messages", nil)];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscribeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeInfoCellID" forIndexPath:indexPath];
    [cell setCellDatas:self.modelDatas[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = self.modelDatas[indexPath.row].Content;
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                               context:nil].size;
    
    return contentSize.height + 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubscribeInfoModel *model = self.modelDatas[indexPath.row];
    TMAVersionType vertype = TMAVersionOnline;
    if ([model.State isEqualToString:@"developer"]) {
        vertype = TMAVersionDevelop;
    } else if ([model.State isEqualToString:@"trial"]) {
        vertype = TMAVersionPreview;
    }
    
    [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:model.MnpId verType:vertype scene:0 firstPage:model.Page paramsStr:nil parentVC:self completion:^(NSError * _Nullable error) {
        if (error) {
            [self showErrorInfo:error];
            return;
        }
    }];
}

#pragma mark - Helper Methods
- (void)showErrorInfo:(NSError *)err {
    if (err == nil) {
        return;
    }
    NSString *errMsg = nil;
    NSString *localizedDescription = err.userInfo[NSLocalizedDescriptionKey];
    if (localizedDescription != nil) {
        errMsg = [NSString stringWithFormat:@"%@\n%ld\n%@", err.domain, (long)err.code, localizedDescription];
    } else {
        errMsg = [NSString stringWithFormat:@"%@\n%ld", err.domain, (long)err.code];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)showToast:(NSString *)message {
    UIImage *icon = [UIImage imageNamed:@"success"];
    ToastView *toast = [[ToastView alloc] initWithIcon:icon title:message];
    [toast showWithDuration:2.0];
}

@end 
