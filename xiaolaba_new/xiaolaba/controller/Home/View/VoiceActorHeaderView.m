//
//  VoiceActorHeaderView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceActorHeaderView.h"
@interface VoiceActorHeaderView ()

@property (nonatomic, strong) XLBDEvaluateView *sigsView;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *imgsLabel;
//@property (nonatomic, strong) UIImageView *sexImage;

@property (nonatomic, strong) UIImageView *smallUserImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *autoLogoImg;
@property (nonatomic, strong) UIButton *logoImg;

@property (nonatomic, strong) UIView *videoV;
@property (nonatomic, strong) UILabel *videoLabel;
@end
@implementation VoiceActorHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSLog(@"%f",self.frame.size.height);
        [self setUpSubViews];
    }
    return self;
}

- (void)setModel:(XLBVoiceActorModel *)model {
    NSLog(@"%@ %@  %@",model.user.follows,model.user.friends,model.user.brandImg);
    self.nickName.text = model.user.nickname;
    if (kNotNil(model.user.pick)) {
        [self.ownerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.user.pick[0] Withtype:IMGPick_OW]] placeholderImage:[UIImage imageNamed:@"pic_m"]];
    }
    [self.smallUserImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.user.img Withtype:IMGAvatar]] placeholderImage:nil];
    
    [self.autoLogoImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.user.brandImg Withtype:IMGNormal]]];
    if ([model.user.liked isEqualToString:@"0"]) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz"] forState:UIControlStateNormal];
    }
    if ([model.user.liked isEqualToString:@"1"]) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz_m"] forState:UIControlStateNormal];
    }
    self.praiseCountLabel.text = model.user.likeSum;
    self.imgsLabel.text = [NSString stringWithFormat:@"1/%li",model.user.pick.count];
    self.videoLabel.text = [NSString stringWithFormat:@"%@''",model.akiraModel.voiceTime];
    [self.sigsView insertSign:model.user.tags];
    
    _model = model;
}


- (void)setUpSubViews {
    
    self.ownerImg = [UIImageView new];
    self.ownerImg.contentMode = UIViewContentModeScaleAspectFill;
    self.ownerImg.userInteractionEnabled = YES;
    [self addSubview:self.ownerImg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    [tap addTarget:self action:@selector(ownerImageTapClick:)];
    [self.ownerImg addGestureRecognizer:tap];
    
    self.smallUserImg = [UIImageView new];
    
    self.smallUserImg.clipsToBounds = YES;
    self.smallUserImg.layer.cornerRadius = 30;
    [self addSubview:self.smallUserImg];
    
    self.videoV = [UIView new];
    self.videoV.layer.masksToBounds = YES;
    self.videoV.layer.cornerRadius = 13;
    self.videoV.backgroundColor = [[UIColor textBlackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.videoV];
    
    self.videoImg = [UIImageView new];
    self.videoImg.layer.masksToBounds = YES;
    self.videoImg.layer.cornerRadius = 13;
    self.videoImg.image = [UIImage imageNamed:@"btn_zy_bf"];
    [self.videoV addSubview:self.videoImg];
    
    self.videoLabel = [UILabel new];
//    self.videoLabel.text = @"19'";
    self.videoLabel.textColor = [UIColor whiteColor];
    self.videoLabel.font = [UIFont systemFontOfSize:12];
    self.videoLabel.textAlignment = NSTextAlignmentCenter;
    [self.videoV addSubview:self.videoLabel];
    
    self.videoBtn = [UIButton new];
    [self.videoV addSubview:self.videoBtn];
    
    self.portraitBtn = [UIButton new];
    self.portraitBtn.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.portraitBtn];
    
    self.nickName = [UILabel new];
    self.nickName.textColor = RGB(46, 48, 51);
    self.nickName.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nickName];
    
    self.autoLogoImg = [UIImageView new];
    [self addSubview:self.autoLogoImg];
    
    self.imgsLabel = [UILabel new];
    self.imgsLabel.font = [UIFont systemFontOfSize:12];
    self.imgsLabel.textColor = [UIColor whiteColor];
    self.imgsLabel.backgroundColor = [[UIColor textBlackColor] colorWithAlphaComponent:0.7];
    self.imgsLabel.clipsToBounds = YES;
    self.imgsLabel.textAlignment = NSTextAlignmentCenter;
    self.imgsLabel.layer.cornerRadius = 12;
    [self addSubview:self.imgsLabel];
    
    
//    self.imgBtn = [UIButton new];
//    [self.imgBtn setImage:[UIImage imageNamed:@"icon_dzh_owner"] forState:UIControlStateNormal];
//    [self.imgBtn setTitle:@" 打招呼" forState:UIControlStateNormal];
//    [self.imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.imgBtn setBackgroundColor:RGBA(0, 0, 0, 0.5)];
//    self.imgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.imgBtn.clipsToBounds = YES;
//    self.imgBtn.layer.cornerRadius = 5;
//    [self addSubview:self.imgBtn];
//
//    self.friendBtn = [UIButton new];
//    [self.friendBtn setImage:[UIImage imageNamed:@"icon_jhy_owner"] forState:UIControlStateNormal];
//    [self.friendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.friendBtn setBackgroundColor:RGBA(0, 0, 0, 0.5)];
//    self.friendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.friendBtn.clipsToBounds = YES;
//    self.friendBtn.layer.cornerRadius = 5;
//    [self.friendBtn setTitle:@" 加好友" forState:UIControlStateNormal];
//    [self addSubview:self.friendBtn];
//
//    self.followBtn = [UIButton new];
//    [self.followBtn setImage:[UIImage imageNamed:@"icon_jhy_owner"] forState:UIControlStateNormal];
//    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.followBtn setBackgroundColor:RGBA(0, 0, 0, 0.5)];
//    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.followBtn.clipsToBounds = YES;
//    self.followBtn.layer.cornerRadius = 5;
//    [self addSubview:self.followBtn];
    
    self.praiseBtn = [UIButton new];
    [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz"] forState:UIControlStateNormal];
    [self.praiseBtn setEnlargeEdge:10];
    [self addSubview:self.praiseBtn];
    
    self.praiseCountLabel = [UILabel new];
    self.praiseCountLabel.text = @"666";
    self.praiseCountLabel.textColor = [UIColor commonTextColor];
    self.praiseCountLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.praiseCountLabel];
    
    self.sigsView = [XLBDEvaluateView new];
    self.sigsView.backgroundColor = [UIColor clearColor];
    [self.sigsView setFont:11];
    [self.sigsView setlHeight:18];
    [self.sigsView setLwidth:15];
    [self.sigsView setRadius:3];
    [self addSubview:self.sigsView];
    
}

- (void)ownerImageTapClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(showImage)]) {
        [self.delegate showImage];
    }
}

- (void)layoutSubviews {
    kWeakSelf(self);
    [weakSelf.ownerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(0);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.height.mas_equalTo(kSCREEN_WIDTH);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).mas_offset(-70);
    }];
    
    
    [weakSelf.smallUserImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(30);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
        
    }];
    
    [weakSelf.videoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ownerImg.mas_bottom).with.offset(-160);
        make.right.mas_equalTo(self.mas_right).with.offset(-15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(26);
    }];
    
    [weakSelf.videoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.videoV.mas_left).with.offset(0);
        make.width.height.mas_equalTo(26);
        make.centerY.mas_equalTo(self.videoV.mas_centerY).with.offset(0);
    }];
    
    [weakSelf.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.videoImg.mas_right).with.offset(0);
        make.right.mas_equalTo(self.videoV.mas_right).with.offset(0);
        make.centerY.mas_equalTo(self.videoV.mas_centerY).with.offset(0);
    }];
    
    
    
    [weakSelf.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.smallUserImg);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
        
    }];
    
    [weakSelf.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.videoV);
        make.centerX.mas_equalTo(self.videoV.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.videoV.mas_centerY).with.offset(0);

    }];
    
    [weakSelf.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.smallUserImg.mas_right).mas_offset(10);
        make.bottom.mas_equalTo(weakSelf.smallUserImg.mas_bottom).mas_offset(-5);
        make.height.mas_equalTo(18);
        
    }];
    [weakSelf.autoLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickName.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(weakSelf.nickName.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(25);
        
    }];
    
    [weakSelf.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickName.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(weakSelf.nickName.mas_centerY);
        make.height.mas_equalTo(20);
        
    }];
    
//    [weakSelf.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(30);
//        make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-25*kiphone6_ScreenHeight);
//    }];
    [weakSelf.imgsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
        make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-20);

//        if (iPhoneX) {
//            make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-150);
//        }else {
//            make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-170*kiphone6_ScreenHeight);
//        }
    }];
    
//    [weakSelf.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.bottom.mas_equalTo(weakSelf.followBtn.mas_top).mas_offset(-15*kiphone6_ScreenHeight);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(30);
//
//    }];
//    [weakSelf.friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.bottom.mas_equalTo(weakSelf.imgBtn.mas_top).mas_offset(-15*kiphone6_ScreenHeight);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(30);
//
//    }];
    
    [weakSelf.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.bottom.mas_equalTo(-35);
        make.width.height.mas_equalTo(20);
    }];
    
    [weakSelf.praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.praiseBtn.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(weakSelf.praiseBtn.mas_centerX);
    }];
    
    
    [weakSelf.sigsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.smallUserImg.mas_left).mas_offset(5);
//        make.right.mas_equalTo(weakSelf.followBtn.mas_left);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
    
    
}

@end
