//
//  LittleDetilTwoTableViewCell.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleTwoModel.h"

@class LittltDetailTwoModel;
@class LittleDetilTwoTableViewCell;

@protocol LittleDetilTwoTableViewCellDelegate <NSObject>

@optional


- (void)clickDetailReport:(LittleDetilTwoTableViewCell*)clickDetailReport withID:(NSString *)cellID;//举报
- (void)clickDetailDel:(LittleDetilTwoTableViewCell*)clickDetailDel withID:(NSString *)cellID;//删除


@end




@interface LittleDetilTwoTableViewCell : UITableViewCell<UIActionSheetDelegate>


@property (nonatomic,weak)  id<LittleDetilTwoTableViewCellDelegate> detailDelegate;

@property (nonatomic,strong) UIButton *headImageBu;
@property (nonatomic,strong) UILabel *nameLabel;//昵称
@property (nonatomic,strong) UILabel *timeLable;//时间
@property (nonatomic,strong) UIButton *followBu;//关注
@property (nonatomic,strong) UILabel *contentLable;//内容
@property (nonatomic,strong) UIImageView *cellImageView;//内容图片
@property (nonatomic,strong) UILabel *adressLable;//地址
@property (nonatomic,strong) UIButton *zanBu;//点赞功能
@property (nonatomic,strong) UILabel *replyLable;//回复
@property (nonatomic,strong) UILabel *lookLable;//查看
@property (nonatomic,strong) UIImageView *adressImage;//地址图片
@property (nonatomic,strong) UIImageView *nameImage;//图片
@property (nonatomic,strong) UIImageView *shareImage;//分享图片
@property (nonatomic) CGFloat cellHeight;//

@property (strong,nonatomic) LittleTwoModel *detaiTwoModel;
@property (strong,nonatomic) NSMutableArray *detaiTwoModelArr;


@property (nonatomic,strong) LittleTwoDetailModel *littltDetailTwoModel;

@property (nonatomic,strong) UILabel *line;//

@property (strong,nonatomic) UIButton *detailReport;
@property (strong,nonatomic) UIButton *detailReportBu;
@property (copy,nonatomic) NSString *creatUser;
@property (copy,nonatomic) NSString *cellReStr;


@property (copy,nonatomic) NSString *cellID;

@end
