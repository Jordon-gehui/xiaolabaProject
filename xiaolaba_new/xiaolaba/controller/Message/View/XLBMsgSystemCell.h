//
//  XLBMsgSystemCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBSystemMsgModel.h"

@interface XLBMsgSystemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineV;

@property (nonatomic, strong) XLBSystemMsgModel *model;

@end
