//
//  XLBInviteFriendsView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/28.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteFriendsView.h"

@interface XLBInviteFriendsView ()


@property (nonatomic, strong) UIView *topBgV;
@property (nonatomic, strong) UILabel *invitationCode;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *circle;
@property (nonatomic, strong) UILabel *circleTwo;
@property (nonatomic, strong) UIImageView *imaginaryLine;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIImageView *centerLine;
@property (nonatomic, strong) UIImageView *centerLineTwo;
@property (nonatomic, strong) UILabel *ranking;
@property (nonatomic, strong) UILabel *invitaCount;
@property (nonatomic, strong) UILabel *rankingLabel;
@property (nonatomic, strong) UILabel *invitaCountLabel;

@property (nonatomic, strong) UIView *qrBgV;
@property (nonatomic, strong) UIImageView *qrBgImg;
@property (nonatomic, strong) UILabel *qrlabel;
@property (nonatomic, strong) UILabel *qrCenterLabel;
@property (nonatomic, strong) UILabel *qrBottomLabel;

@property (nonatomic, strong) UILabel *bottomLabel;


@property (nonatomic, strong) UIButton *rankingBtn;
@property (nonatomic, strong) UIButton *inviteCountBtn;
@property (nonatomic, strong) UIButton *qrCodeBtn;
@end

@implementation XLBInviteFriendsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        
    }
    return self;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    if (kNotNil(dataDic) && kNotNil([dataDic objectForKey:@"ranking"])) {
        self.rankingLabel.text = dataDic[@"ranking"];
    }
    if (kNotNil([dataDic objectForKey:@"countsum"])) {
        self.invitaCountLabel.text = dataDic[@"countsum"];
    }
    self.invitationCode.text = dataDic[@"ucode"];

    _dataDic = dataDic;
}

- (void)setSubViews {
    
    kWeakSelf(self);
    weakSelf.bgImg = [UIImageView new];
    weakSelf.bgImg.image = [UIImage imageNamed:@"bg_yq"];
    [weakSelf addSubview:weakSelf.bgImg];
    
    
    weakSelf.topBgV = [UIView new];
    weakSelf.topBgV.backgroundColor = [UIColor whiteColor];
    weakSelf.topBgV.layer.masksToBounds = YES;
    weakSelf.topBgV.layer.cornerRadius = 15;
    [weakSelf addSubview:weakSelf.topBgV];
    
    
    weakSelf.topLabel = [UILabel new];
    weakSelf.topLabel.textColor = [UIColor textBlackColor];
    weakSelf.topLabel.text = @"专属邀请码";
    weakSelf.topLabel.font = [UIFont systemFontOfSize:15];
    weakSelf.topLabel.textAlignment = NSTextAlignmentCenter;
    [weakSelf.topBgV addSubview:weakSelf.topLabel];
    
    weakSelf.invitationCode = [UILabel new];
    weakSelf.invitationCode.textColor = [UIColor textBlackColor];
//    weakSelf.invitationCode.text = @"NF8K9F";
    weakSelf.invitationCode.font = [UIFont fontWithName:@"Helvetica-Bold" size:45];
    weakSelf.invitationCode.textAlignment = NSTextAlignmentCenter;
    [weakSelf.topBgV addSubview:weakSelf.invitationCode];
    
    weakSelf.circle = [UILabel new];
    weakSelf.circle.backgroundColor = [UIColor lightColor];
    weakSelf.circle.layer.masksToBounds = YES;
    weakSelf.circle.layer.cornerRadius = 10;
    [weakSelf.topBgV addSubview:weakSelf.circle];
    
    weakSelf.circleTwo = [UILabel new];
    weakSelf.circleTwo.layer.masksToBounds = YES;
    weakSelf.circleTwo.layer.cornerRadius = 10;
    weakSelf.circleTwo.backgroundColor = [UIColor lightColor];
    [weakSelf.topBgV addSubview:weakSelf.circleTwo];
    
    weakSelf.imaginaryLine = [UIImageView new];
    weakSelf.imaginaryLine.image = [UIImage imageNamed:@"pic_fgx_l"];
    [weakSelf.topBgV addSubview:weakSelf.imaginaryLine];
    
    
    weakSelf.centerLabel = [UILabel new];
    weakSelf.centerLabel.text = @"我的邀请";
    weakSelf.centerLabel.textColor = [UIColor commonTextColor];
    if (iPhone5s) {
        weakSelf.centerLabel.font = [UIFont systemFontOfSize:13];
    }else {
        weakSelf.centerLabel.font = [UIFont systemFontOfSize:15];
    }
    weakSelf.centerLabel.textAlignment = NSTextAlignmentCenter;
    [weakSelf.topBgV addSubview:weakSelf.centerLabel];
    
    weakSelf.centerLine = [UIImageView new];
    weakSelf.centerLine.image = [UIImage imageNamed:@"pic_zjb"];
    [weakSelf.topBgV addSubview:weakSelf.centerLine];
    
    weakSelf.centerLineTwo = [UIImageView new];
    weakSelf.centerLineTwo.image = [UIImage imageNamed:@"pic_yjb"];
    [weakSelf.topBgV addSubview:weakSelf.centerLineTwo];
    
    
    weakSelf.ranking = [UILabel new];
    weakSelf.ranking.text = @"排名（位）";
    weakSelf.ranking.textAlignment = NSTextAlignmentLeft;
    weakSelf.ranking.textColor = [UIColor commonTextColor];
    weakSelf.ranking.font = [UIFont systemFontOfSize:12];
    [weakSelf.topBgV addSubview:weakSelf.ranking];
    
    weakSelf.invitaCount = [UILabel new];
    weakSelf.invitaCount.text = @"邀请好友（人）";
    weakSelf.invitaCount.textAlignment = NSTextAlignmentRight;
    weakSelf.invitaCount.textColor = [UIColor commonTextColor];
    weakSelf.invitaCount.font = [UIFont systemFontOfSize:12];
    [weakSelf.topBgV addSubview:weakSelf.invitaCount];
    
    weakSelf.rankingLabel = [UILabel new];
    weakSelf.rankingLabel.text = @"_";
    weakSelf.rankingLabel.textColor = [UIColor commonTextColor];
    weakSelf.rankingLabel.textAlignment = NSTextAlignmentRight;
    weakSelf.rankingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    [weakSelf.topBgV addSubview:weakSelf.rankingLabel];
    
    weakSelf.invitaCountLabel = [UILabel new];
    weakSelf.invitaCountLabel.text = @"_";
    weakSelf.invitaCountLabel.textColor = [UIColor commonTextColor];
    weakSelf.invitaCountLabel.textAlignment = NSTextAlignmentLeft;
    weakSelf.invitaCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    [weakSelf.topBgV addSubview:weakSelf.invitaCountLabel];
    
    weakSelf.rankingBtn = [UIButton new];
    [weakSelf.topBgV addSubview:weakSelf.rankingBtn];
    
    
    weakSelf.inviteCountBtn = [UIButton new];
    [weakSelf.topBgV addSubview:weakSelf.inviteCountBtn];
    
    weakSelf.weChatBtn = [UIButton new];
    weakSelf.weChatBtn.tag = WeChatBtnTag;
    [weakSelf.weChatBtn setBackgroundImage:[UIImage imageNamed:@"icon_wx_yq"] forState:UIControlStateNormal];
    [weakSelf.topBgV addSubview:weakSelf.weChatBtn];
    
    weakSelf.friendsBtn = [UIButton new];
    weakSelf.friendsBtn.tag = FriendsShareTag;
    [weakSelf.friendsBtn setBackgroundImage:[UIImage imageNamed:@"icon_pyq"] forState:UIControlStateNormal];
    [weakSelf.topBgV addSubview:weakSelf.friendsBtn];
    
    weakSelf.qqBtn = [UIButton new];
    weakSelf.qqBtn.tag = QQShareTag;
    [weakSelf.qqBtn setBackgroundImage:[UIImage imageNamed:@"icon_wb_yq"] forState:UIControlStateNormal];
    [weakSelf.topBgV addSubview:weakSelf.qqBtn];
    
    weakSelf.qrBgV = [UIView new];
    weakSelf.qrBgV.backgroundColor = [UIColor whiteColor];
    weakSelf.qrBgV.layer.masksToBounds = YES;
    weakSelf.qrBgV.layer.cornerRadius = 15;
    [weakSelf addSubview:weakSelf.qrBgV];
    
    weakSelf.qrBgImg = [UIImageView new];
    weakSelf.qrBgImg.image = [UIImage imageNamed:@"pic_my"];
    weakSelf.qrBgImg.backgroundColor = [UIColor whiteColor];
    [weakSelf.qrBgV addSubview:weakSelf.qrBgImg];
    
    weakSelf.qrlabel = [UILabel new];
    weakSelf.qrlabel.text = @"生成邀请二维码";
    weakSelf.qrlabel.textColor = [UIColor commonTextColor];
    weakSelf.qrlabel.font = [UIFont systemFontOfSize:15];
    [weakSelf.qrBgV addSubview:weakSelf.qrlabel];
    
    weakSelf.qrCenterLabel = [UILabel new];
    weakSelf.qrCenterLabel.text = @"面对面邀请好友";
    weakSelf.qrCenterLabel.textColor = [UIColor commonTextColor];
    weakSelf.qrCenterLabel.font = [UIFont systemFontOfSize:18];
    [weakSelf.qrBgV addSubview:weakSelf.qrCenterLabel];
    
    weakSelf.qrBottomLabel = [UILabel new];
    weakSelf.qrBottomLabel.text = @"邀请好友";
    weakSelf.qrBottomLabel.textColor = [UIColor commonTextColor];
    weakSelf.qrBottomLabel.font = [UIFont systemFontOfSize:12];
    [weakSelf.qrBottomLabel setHidden:YES];
    [weakSelf.qrBgV addSubview:weakSelf.qrBottomLabel];
    
    weakSelf.qrCodeBtn = [UIButton new];
    
    [weakSelf.qrBgV addSubview:weakSelf.qrCodeBtn];
    
    weakSelf.bottomLabel = [UILabel new];
    weakSelf.bottomLabel.textAlignment = NSTextAlignmentLeft;
    weakSelf.bottomLabel.numberOfLines = 0;
    weakSelf.bottomLabel.font = [UIFont systemFontOfSize:15];
    [weakSelf addSubview:weakSelf.bottomLabel];

    NSString *string = @"邀请规则：\n1.您的专属邀请码只属于您个人；\n2.好友在身边，随手下载小喇叭，完成注册输入邀请码后，您和好友均能获取3车币；\n3.好友不在身边？只需手指点一下，将小喇叭邀请链接或者截图发送到朋友圈，共邀好友前来下载。";
    // Adjust the spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.f;
    paragraphStyle.alignment = weakSelf.bottomLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(5, string.length - 5)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(5, string.length - 5)];
    
    weakSelf.bottomLabel.attributedText = attributedString;
    
    weakSelf.inviteCountBtn.tag = InviteCountBtnTag;
    weakSelf.rankingBtn.tag = RangkingBtnTag;
    weakSelf.qrCodeBtn.tag = QrCodeBtnTag;
    
    [weakSelf.friendsBtn addTarget:self action:@selector(btnClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [weakSelf.qqBtn addTarget:self action:@selector(btnClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [weakSelf.weChatBtn addTarget:self action:@selector(btnClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [weakSelf.inviteCountBtn addTarget:self action:@selector(btnClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [weakSelf.rankingBtn addTarget:self action:@selector(btnClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [weakSelf.qrCodeBtn addTarget:self action:@selector(btnClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClickWithTag:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(inviteFriendsViewBtnWithTag:)]) {
        [self.delegate inviteFriendsViewBtnWithTag:sender];
    }
}

- (void)layoutSubviews {
    kWeakSelf(self);
    [weakSelf.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [weakSelf.topBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(10*kiphone6_ScreenHeight);
        if (iPhone5s) {
            make.left.mas_equalTo(48*kiphone6_ScreenWidth);
            make.right.mas_equalTo(-48*kiphone6_ScreenWidth);
        }else {
            make.left.mas_equalTo(58*kiphone6_ScreenWidth);
            make.right.mas_equalTo(-58*kiphone6_ScreenWidth);
        }
        make.height.mas_equalTo(260*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topBgV.mas_top).with.offset(10*kiphone6_ScreenHeight);
        make.left.right.mas_equalTo(weakSelf.topBgV).with.offset(0);
        make.height.mas_equalTo(18*kiphone6_ScreenHeight);
        
    }];
    
    [weakSelf.invitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.topBgV).with.offset(0);
        make.top.mas_equalTo(weakSelf.topLabel.mas_bottom).with.offset(10*kiphone6_ScreenHeight);
    }];
    
    
    [weakSelf.imaginaryLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.circle.mas_right).with.offset(10);
        make.right.mas_equalTo(weakSelf.circleTwo.mas_left).with.offset(-10);
        make.top.mas_equalTo(weakSelf.invitationCode.mas_bottom).with.offset(5);
        make.height.mas_equalTo(1);
    }];
    
    [weakSelf.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.imaginaryLine.mas_centerY);
        
        make.left.mas_equalTo(weakSelf.topBgV.mas_left).with.offset(-10);
        make.width.height.mas_equalTo(20);
        
    }];
    
    [weakSelf.circleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(weakSelf.circle);
        
        make.right.mas_equalTo(weakSelf.topBgV.mas_right).with.offset(10);
        make.centerY.mas_equalTo(weakSelf.imaginaryLine.mas_centerY);
    }];
    
    [weakSelf.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imaginaryLine.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(weakSelf.imaginaryLine.mas_centerX);
        make.height.mas_equalTo(20*kiphone6_ScreenHeight);
        make.width.mas_equalTo(110*kiphone6_ScreenWidth);

    }];
    
    [weakSelf.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.centerLabel.mas_centerY);
        make.left.mas_equalTo(weakSelf.imaginaryLine.mas_left).with.offset(0);
        make.right.mas_equalTo(weakSelf.centerLabel.mas_left).with.offset(-5);
        make.height.mas_equalTo(1);
    }];
    
    [weakSelf.centerLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.centerLabel.mas_centerY);
        make.left.mas_equalTo(weakSelf.centerLabel.mas_right).with.offset(5);
        make.right.mas_equalTo(weakSelf.imaginaryLine.mas_right).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [weakSelf.ranking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.centerLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(weakSelf.centerLine.mas_left).with.offset(5);
        make.height.mas_equalTo(20*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.invitaCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.centerLabel.mas_bottom).with.offset(10);
        make.right.mas_equalTo(weakSelf.centerLineTwo.mas_right).with.offset(5);
        make.height.mas_equalTo(20*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.ranking.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(weakSelf.ranking.mas_centerX).with.offset(-5);
        make.height.mas_equalTo(30*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.invitaCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.invitaCount.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(weakSelf.invitaCount.mas_centerX).with.offset(0);
        make.height.mas_equalTo(30*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.rankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.ranking.mas_top).with.offset(0);
        make.centerX.mas_equalTo(weakSelf.rankingLabel.mas_centerX);
        make.width.mas_equalTo(50*kiphone6_ScreenWidth);
        make.bottom.mas_equalTo(weakSelf.rankingLabel.mas_bottom).with.offset(0);
        
    }];
    
    [weakSelf.inviteCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.invitaCount.mas_top).with.offset(0);
        make.centerX.mas_equalTo(weakSelf.invitaCountLabel.mas_centerX);
        make.width.mas_equalTo(50*kiphone6_ScreenWidth);
        make.bottom.mas_equalTo(weakSelf.invitaCountLabel.mas_bottom).with.offset(0);
        
    }];
    

    
    [weakSelf.friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.rankingBtn.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(weakSelf.topBgV.mas_centerX);
        make.width.height.mas_equalTo(50*kiphone6_ScreenHeight);
        make.bottom.mas_equalTo(weakSelf.topBgV.mas_bottom).with.offset(-10);

    }];
    
    [weakSelf.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.friendsBtn.mas_centerY);
    make.left.mas_equalTo(weakSelf.friendsBtn.mas_right).with.offset(25*kiphone6_ScreenWidth);
        make.width.height.mas_equalTo(weakSelf.friendsBtn);

    }];
    
    [weakSelf.weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.friendsBtn.mas_centerY);
        make.right.mas_equalTo(weakSelf.friendsBtn.mas_left).with.offset(-25*kiphone6_ScreenWidth);
        make.width.height.mas_equalTo(weakSelf.friendsBtn);
        
    }];
    
    
    [weakSelf.qrBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topBgV.mas_bottom).with.offset(20*kiphone6_ScreenHeight);
        make.width.mas_equalTo(weakSelf.topBgV);
        make.centerX.mas_equalTo(weakSelf.topBgV.mas_centerX);
        make.height.mas_equalTo(110*kiphone6_ScreenHeight);
        
    }];
    
    [weakSelf.qrBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [weakSelf.qrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.qrBgV.mas_left).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.qrBgV.mas_centerY).with.offset(-18*kiphone6_ScreenHeight);
        make.height.mas_equalTo(18*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.qrCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.qrBgV.mas_left).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.qrBgV.mas_centerY).with.offset(18*kiphone6_ScreenHeight);
        make.height.mas_equalTo(18*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.qrBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.qrlabel.mas_left);
        make.height.mas_equalTo(18*kiphone6_ScreenHeight);
        make.bottom.mas_equalTo(weakSelf.qrBgV.mas_bottom).with.offset(-15);
    }];
    
    [weakSelf.qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(weakSelf.qrBgV).with.offset(0);
    }];
    
    
    [weakSelf.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.qrBgV.mas_bottom).with.offset(20*kiphone6_ScreenHeight);
        make.left.mas_equalTo(weakSelf.qrBgV.mas_left);
        make.right.mas_equalTo(weakSelf.qrBgV.mas_right);
    }];
    
}


@end
