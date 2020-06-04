//
//  FriendCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/12.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBFindUserModel.h"
#import "FriendModel.h"
typedef NS_ENUM(NSInteger, FriendCellModel)
{
    FriendCellContent = 0,
    FriendCellNone = 1,
    /// 非实时搜索(只有当点击键盘上面的搜索按钮时，才进行搜索)
    FriendCellNoneGuanZhu
};
@class FriendCell;
@protocol FriendCellDelegate <NSObject>

- (void)friendCell:(FriendCell *)cell addFriendDic:(FriendModel*)userDic;
@end
@interface FriendCell : UITableViewCell

@property (assign,nonatomic)FriendCellModel cellModel;
@property (nonatomic ,strong)UIButton *rightBtn;

@property (nonatomic, weak) id<FriendCellDelegate>delegate;

-(void)setFriendDic:(FriendModel*)dic status:(FriendCellModel)model;

-(void)setFriendweiboDic:(FriendModel*)dic status:(FriendCellModel)model;

-(void)setFriendModel:(XLBFindUserModel*)model  status:(FriendCellModel)cellModel;
@end
