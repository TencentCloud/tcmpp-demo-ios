//
//  SearchResultViewController.h
//  TCMPPDemo
//
//  Created by 石磊 on 2023/11/22.
//

#import <UIKit/UIKit.h>
#import "TMFMiniAppSDKManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<TMFAppletSearchInfo *> *searchResults;
@end

NS_ASSUME_NONNULL_END
