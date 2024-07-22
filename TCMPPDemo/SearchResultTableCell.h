//
//  SearchResultTableCell.h
//  TCMPPDemo
//
//  Created by stonelshi on 2023/11/22.
//

#import <UIKit/UIKit.h>
#import <TCMPPSDK/TCMPPSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultTableCell : UITableViewCell
@property (nonatomic, strong) TMFAppletSearchInfo *appInfo;
@end

NS_ASSUME_NONNULL_END
