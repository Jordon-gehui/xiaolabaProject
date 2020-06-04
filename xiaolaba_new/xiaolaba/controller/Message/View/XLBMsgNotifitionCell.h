//
//  XLBMsgNotifitionCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgNoticeModel.h"

typedef void (^RetrunBlock)(id messageid);

@interface XLBMsgNotifitionCell : UITableViewCell
@property (nonatomic,retain) UIView *lineV;

@property (nonatomic, strong) MsgNoticeModel *model;

@property (nonatomic, copy)RetrunBlock returnBlock;

@end
