//
//  XLBMyMoveCardCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLBMyMoveCardCell;
@protocol XLBMyMoveCardCellDelegate <NSObject>

- (void)moveCardCell:(XLBMyMoveCardCell *)cell didTouchBan:(BOOL )ban;

@end
@interface XLBMyMoveCardCell : UITableViewCell

@property (nonatomic, weak) id<XLBMyMoveCardCellDelegate>delegate;
@property (nonatomic, strong) NSDictionary *model;
 
@end
