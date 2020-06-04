//
//  XLBInviteTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/30.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBInviteModel.h"
@interface XLBInviteTableViewCell : UITableViewCell

@property (nonatomic, strong)XLBInviteModel *model;
@property (nonatomic, strong) UILabel *ranking;

+ (NSString *)inviteCellID;

@end
