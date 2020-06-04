//
//  XLBAddGroupMemberTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBFriendModel.h"
@interface XLBAddGroupMemberTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UILabel *nickName;
@property (nonatomic, strong)UIImageView *seleImage;

+ (NSString *)addGroupMemberCellID;
@end
