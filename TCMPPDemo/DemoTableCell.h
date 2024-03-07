//
//  DemoTableCell.h
//  TCMPPDemo
//
//  Created by stonelshi on 2023/4/19.
//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoTableCell;
@protocol DemoTableCellDelegate <NSObject>

/**
  * Dynamically change the height of UITableViewCell
  */
- (void)updateTableViewCellHeight:(DemoTableCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;


/**
  * Click on the proxy method of UICollectionViewCell
  */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content;
@end

@interface DemoTableCell : UITableViewCell

@property (nonatomic, weak) id<DemoTableCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *dataAry;

@end
