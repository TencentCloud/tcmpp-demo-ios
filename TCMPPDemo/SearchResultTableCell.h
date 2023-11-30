//
//  SearchResultTableCell.h
//  TCMPPDemo
//
//  Created by 石磊 on 2023/11/22.
//

#import <UIKit/UIKit.h>
#import "TMFMiniAppSDKManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultTableCell : UITableViewCell
@property (nonatomic, strong) TMFAppletSearchInfo *appInfo;
@end

NS_ASSUME_NONNULL_END
