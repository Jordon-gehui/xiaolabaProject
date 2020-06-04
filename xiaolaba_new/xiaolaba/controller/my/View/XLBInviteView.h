//
//  XLBInviteView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InviteBtnTag) {
    
    WeChatBtnTag = 0,
    FriendsBtnTag,
    CancleBtnTag,
    QQBtnTag,

};

@protocol XLBInviteViewDelegate <NSObject>

- (void)inviteViewBtnClickWithTag:(UIButton *)sender;

@end

@interface XLBInviteView : UIView

@property (nonatomic, weak) id <XLBInviteViewDelegate>delegate;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UIButton *friendsBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIImageView *screenShotImg;

@end
