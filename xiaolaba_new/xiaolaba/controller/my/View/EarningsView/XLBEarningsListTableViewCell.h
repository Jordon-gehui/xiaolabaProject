//
//  XLBEarningsListTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EarningsListModel.h"

@interface XLBEarningsListTableViewCell : UITableViewCell

@property (nonatomic, strong) EarningsListModel *model;

@property (nonatomic, assign) BOOL isPay;
+ (NSString *)earningsCellID;
@end
