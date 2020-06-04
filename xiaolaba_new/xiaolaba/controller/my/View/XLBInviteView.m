//
//  XLBInviteView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteView.h"

@interface XLBInviteView ()
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation XLBInviteView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    if (self) {
        [self setSubViews];
        self.backgroundColor = [UIColor commonTextColor];
    }
    return self;
}

- (void)setSubViews {
    
    _bgImg = [UIImageView new];
    _bgImg.image = [UIImage imageNamed:@""];
    [self addSubview:_bgImg];
    
    _screenShotImg = [UIImageView new];
    
    [self addSubview:_screenShotImg];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    _friendsBtn = [UIButton new];
    _friendsBtn.tag = FriendsBtnTag;
    [_friendsBtn setBackgroundImage:[UIImage imageNamed:@"icon_pyq"] forState:UIControlStateNormal];
    [_bgView addSubview:_friendsBtn];
    
    _weChatBtn = [UIButton new];
    _weChatBtn.tag = WeChatBtnTag;
    [_weChatBtn setBackgroundImage:[UIImage imageNamed:@"icon_wx_yq"] forState:UIControlStateNormal];
    [_bgView addSubview:_weChatBtn];
    
    _qqBtn = [UIButton new];
    _qqBtn.tag = QQBtnTag;
    [_qqBtn setBackgroundImage:[UIImage imageNamed:@"icon_wb_yq"] forState:UIControlStateNormal];
    [_bgView addSubview:_qqBtn];
    
    _lineLabel = [UILabel new];
    _lineLabel.backgroundColor = RGB(238, 238, 238);
    [_bgView addSubview:_lineLabel];
    
    
    _cancleBtn = [UIButton new];
    _cancleBtn.tag = CancleBtnTag;
    [_cancleBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_bgView addSubview:_cancleBtn];
    
    [_weChatBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qqBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [_friendsBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [_cancleBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)inviteBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(inviteViewBtnClickWithTag:)]) {
        [self.delegate inviteViewBtnClickWithTag:sender];
    }
}

- (void)layoutSubviews {
    
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_screenShotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSCREEN_WIDTH*0.6);
        make.height.mas_equalTo(kSCREEN_HEIGHT*0.6);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).with.offset(64);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (iPhoneX) {
            make.bottom.mas_equalTo(-15);
        }else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(120*kiphone6_ScreenHeight);
    }];
    
    [_friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(8*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.width.height.mas_equalTo(50*kiphone6_ScreenHeight);
    }];
    
    [_weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_friendsBtn.mas_centerY);
        make.width.height.mas_equalTo(_friendsBtn);
        make.right.mas_equalTo(_friendsBtn.mas_left).with.offset(-53*kiphone6_ScreenWidth);
    }];
    
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_friendsBtn.mas_centerY);
        make.width.height.mas_equalTo(_friendsBtn);
        make.left.mas_equalTo(_friendsBtn.mas_right).with.offset(53*kiphone6_ScreenWidth);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_friendsBtn.mas_bottom).with.offset(10*kiphone6_ScreenHeight);
        make.left.right.mas_equalTo(self.bgView).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(_lineLabel.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(self.bgView).with.offset(0);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).with.offset(0);
    }];
    
}

@end
