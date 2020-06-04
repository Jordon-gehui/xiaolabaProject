//
//  GroupListTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>
#import "XLBGroupModel.h"
@interface GroupListTableViewCell : UITableViewCell

@property (nonatomic, strong) EMGroup *group;
@property (nonatomic, strong) XLBGroupListModel *model;
+ (NSString *)groupListTableViewCellID;
@end
