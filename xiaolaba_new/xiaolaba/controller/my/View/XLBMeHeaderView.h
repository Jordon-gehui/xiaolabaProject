//
//  XLBMeHeaderView.h
//  xiaolaba
//
//  Created by lin on 2017/7/19.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBUser.h"
@class XLBMeHeaderView;
@protocol XLBMeHeaderViewDelegate <NSObject>

/**
 修改个人信息
 */
- (void)headerViewUpdateInfoClick;

/**
 关注
 */
- (void)headerViewFollowClick;

/**
 粉丝
 */
- (void)headerViewFollowerClick;

/**
 动态
 */
- (void)headerViewMomentClick;

/**
 认证
 */
- (void)headerViewCertiClick;

/**
 修改个人头像
 */
- (void)headerUserImageUpdateClick;

- (void)headerViewRightItemClick;
@end

@interface XLBMeHeaderView : UIView

@property (nonatomic, weak) id<XLBMeHeaderViewDelegate>delegate;
@property (nonatomic, strong) UIImageView *avatar_image;

- (instancetype)initWithUser:(XLBUser *)user complete:(BOOL )complete;

- (void)updateUser:(XLBUser *)user;

@end
