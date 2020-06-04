//
//  DetailHeadView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleHornTableViewModel.h"
#import "XLBDEvaluateView.h"
#import "UserTagsModel.h"

@class DetailHeadView;
@protocol DetailHeadViewDelegate <NSObject>

- (void)imageBu:(DetailHeadView*)imageBu withURL:(NSURL *)URL withIndex:(NSInteger )index ;//查看更多
- (void)headImageBu:(DetailHeadView*)headImageBu withId:(NSString *)userID;//头像

@optional
-(void) headImageHeadSize:(CGFloat)height;

@end

@interface DetailHeadView : UIView

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

@property (nonatomic,strong) LittleHornTableViewModel *littleModel;

@property (nonatomic) CGFloat cellHeight;//
@property (nonatomic,weak)  id<DetailHeadViewDelegate> imageDelegate;
@property (nonatomic,strong) UILabel *shareLable;//分享字体
@property (nonatomic,strong) UIImageView *lookImage;//浏览量


@property (nonatomic,strong) NSMutableArray *imageArr;//分享图片

@property (nonatomic,strong) XLBDEvaluateView *tagView;//首页标签
@property (nonatomic,strong) UIButton *topButton;//切换页面

@property (nonatomic,strong) NSMutableArray *tagsArr;//标签

@property (nonatomic,strong) UserTagsModel *tags;//标签





@end
