//
//  LittleTwoHeadView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface LittleTwoHeadView : UIView

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

@property (strong,nonatomic) DetailModel *detaiTwoModel;


@end
