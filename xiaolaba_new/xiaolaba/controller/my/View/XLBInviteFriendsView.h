//
//  XLBInviteFriendsView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/28.
//  Copyright © 2017年 jackzhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XLBInviteModel.h"

typedef NS_ENUM(NSUInteger, ShareBtnTag) {
    WeChatBtnTag = 0,
    QQShareTag,
    FriendsShareTag,
    RangkingBtnTag,
    InviteCountBtnTag,
    QrCodeBtnTag,
};

@protocol XLBInviteFriendsViewDelegate <NSObject>

- (void)inviteFriendsViewBtnWithTag:(UIButton *)sender;

@end

@interface XLBInviteFriendsView : UIView
@property (nonatomic, strong) id <XLBInviteFriendsViewDelegate>delegate;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *friendsBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@end
