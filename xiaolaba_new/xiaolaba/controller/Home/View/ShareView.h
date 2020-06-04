//
//  ShareView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShareView;

@protocol ShareViewDelegate <NSObject>

@optional
- (void)shareWXpro:(ShareView*)shareWXpro ;//批量管理
- (void)shareWXpyq:(ShareView*)shareWXpyq ;//创建任务
- (void)shareWB:(ShareView*)shareWB ;//创建提醒


@end



@interface ShareView : UIView

@property (nonatomic, strong) UIView   *bgView;

@property (strong ,nonatomic) UIButton *shareWXpeo;//微信好友
@property (strong ,nonatomic) UIButton *shareWXpyq;//朋友圈
@property (strong ,nonatomic) UIButton *shareWB;//微博

@property (strong ,nonatomic) UIButton *closeBu;//

@property (strong ,nonatomic) UILabel *shareWXpeoLa;//微信好友
@property (strong ,nonatomic) UILabel *shareWXpyqLa;//朋友圈
@property (strong ,nonatomic) UILabel *shareWBLa;//微博

- (void)show;

- (void)close;
@property(nonatomic,weak)  id<ShareViewDelegate> addDelegate;



@end
