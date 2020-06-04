//
//  FindCard.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBDEvaluateView.h"

@class FindCard;
@protocol FindCardDelegate <NSObject>
/**
 当前所选卡片
 
 @param cardView 所选卡片
 @param model    对应模型
 @param index    索引
 */
- (void)cardView:(FindCard *)cardView card:(XLBFindUserModel *)model;

/**
 点击图片查看大图
 
 @param cardView 所选卡片
 @param images   大图地址数组
 */
- (void)cardView:(FindCard *)cardView didTouchCardImages:(NSArray <NSString *>*)images;

@end
@interface FindCard : UIView

@property (nonatomic, weak) id<FindCardDelegate>delegate;

@property (nonatomic, strong) XLBFindUserModel *model;

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UIView *whiteBackV;

@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) XLBDEvaluateView *tagV;
@property (nonatomic, strong) UIImageView *carImgV;
@property (nonatomic, strong) UIImageView *brandImg;
@property (nonatomic, strong) UIImageView *pickerCountV;
@property (nonatomic, strong) UILabel *pickerCountL;
@property (nonatomic, strong) UIView *backV;

@end
