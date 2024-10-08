//
//  TCMPPAppCell.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/1.
//

#import <UIKit/UIKit.h>
#import <TCMPPSDK/TCMPPSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AppCellDelegate <NSObject>

- (void)didClickMore:(NSString *)appId;

@end

@interface TCMPPAppCell : UITableViewCell

@property (nonatomic, strong, nullable)  TMFAppletSearchInfo *searchInfo;
@property (nonatomic, strong, nullable)  TMFMiniAppInfo *appInfo;
@property (strong, nonatomic)  UIImageView *icon;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UILabel *detail;
@property (strong, nonatomic)  UILabel *category;
@property (weak,   nonatomic)  id<AppCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
