//
//  SearchResultViewController.h
//  TCMPPDemo
//
//  Created by stonelshi on 2023/11/22.
//

#import <UIKit/UIKit.h>
#import <TCMPPSDK/TCMPPSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<TMFAppletSearchInfo *> *searchResults;
@end

NS_ASSUME_NONNULL_END
