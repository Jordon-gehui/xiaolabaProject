//
//  MomentsCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/10/21.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleHornTableViewModel.h"
@class MomentsCell;
@protocol MomentsCellDelegate <NSObject>

- (void)cellReLoadDelegate:(NSIndexPath *)index;

@optional
//删除
- (void)deleteCell:(LittleHornTableViewModel *)model;
//头像
- (void)headImageClick:(MomentsCell*)cell withId:(NSString *)userID;
//关注
- (void)followClick:(MomentsCell*)cell withId:(NSString *)userID;
//点赞
- (void)zanBuAddClick:(MomentsCell*)cell withId:(NSString *)currentID withLike:(NSString *)like;
//回复
- (void)reportClick:(MomentsCell*)cell;
@optional

@end
@interface MomentsCell : UITableViewCell
@property(nonatomic,retain)UIButton *headerView;
@property(nonatomic,retain)UIButton *followBtn;
@property(nonatomic,retain)UIButton *likeBtn;

@property (nonatomic,copy)NSIndexPath *indexPath;
@property(nonatomic,assign)BOOL isSelf;
@property(nonatomic,copy)LittleHornTableViewModel *cellModel;

@property (nonatomic,weak)  id<MomentsCellDelegate> delegate;

-(void)setModel:(LittleHornTableViewModel*)model;

-(CGFloat) cellHeight;
@end
