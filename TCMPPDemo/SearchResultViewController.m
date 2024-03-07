//
//  SearchResultViewController.m
//  TCMPPDemo
//
//  Created by stonelshi on 2023/11/22.
//

#import "SearchResultViewController.h"
#import "SearchResultTableCell.h"

#define UIColorFromHex(s) \
    [UIColor colorWithRed:(((s & 0xFF0000) >> 16)) / 255.0 green:(((s & 0xFF00) >> 8)) / 255.0 blue:((s & 0xFF)) / 255.0 alpha:1.0]


@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColorFromHex(0xE3EDFD);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height - 80)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromHex(0xE3EDFD);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSMutableArray<TMFAppletSearchInfo *> *)searchResults {
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [[TMFMiniAppSDKManager sharedInstance] startUpMiniAppWithAppID:self.searchResults[row].appId
                                                             scene:TMAEntrySceneSearch
                                                         firstPage:nil
                                                         paramsStr:nil
                                                          parentVC:self completion:^(NSError *_Nullable error) {
        [self showErrorInfo:error];
                                                          }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    [tableView registerClass:[SearchResultTableCell class] forCellReuseIdentifier:identifier];
    SearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.appInfo = self.searchResults[indexPath.row];

    return cell;
}

- (void)showErrorInfo:(NSError *)err {
    NSString *errMsg = nil;
    NSString *localizedDescription = err.userInfo[NSLocalizedDescriptionKey];
    if (localizedDescription != nil) {
        errMsg = [NSString stringWithFormat:@"%@\n%ld\n%@",err.domain,(long)err.code,localizedDescription];
    } else {
        errMsg = [NSString stringWithFormat:@"%@\n%ld",err.domain,(long)err.code];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
