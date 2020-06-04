//
//  OwnerHeadView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "OwnerHeadView.h"

@interface OwnerHeadView ()


@property (nonatomic, strong) XLBDEvaluateView *sigsView;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *imgsLabel;
//@property (nonatomic, strong) UIImageView *sexImage;

@property (nonatomic, strong) UIImageView *smallUserImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *autoLogoImg;
@property (nonatomic, strong) UIButton *logoImg;
@end

@implementation OwnerHeadView

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

- (void)setModel:(XLBOwnerModel *)model {
    NSLog(@"%@ %@  %@ %@ %@",model.follows,model.friends,model.brandImg,model.nickname,model.img);
    self.nickName.text = model.nickname;
    if (kNotNil(model.pick)) {
        [self.ownerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.pick[0] Withtype:IMGPick_OW]] placeholderImage:[UIImage imageNamed:@"pic_m"]];
    }
    [self.smallUserImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    
    [self.autoLogoImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.brandImg Withtype:IMGNormal]]];

//    if ([model.sex isEqualToString:@"0"]) {
//        [self.sexImage setImage:[UIImage imageNamed:@"icon_woman"]];
//    }
//    if ([model.sex isEqualToString:@"1"]) {
//        [self.sexImage setImage:[UIImage imageNamed:@"icon_man"]];
//    }
    if ([model.liked isEqualToString:@"0"]) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz"] forState:UIControlStateNormal];
    }
    if ([model.liked isEqualToString:@"1"]) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz_m"] forState:UIControlStateNormal];
    }

    if (kNotNil(model.ID) && [@([model.ID integerValue])  isEqual: [XLBUser user].userModel.ID]) {
        self.friendBtn.hidden = YES;
        self.imgBtn.hidden = YES;
        self.followBtn.hidden = YES;
    }else {
        if ([model.friends isEqualToString:@"0"]) {
            self.friendBtn.hidden = NO;
            [self.imgBtn setTitle:@" 打招呼" forState:UIControlStateNormal];
        }else {
            self.friendBtn.hidden = YES;
            [self.imgBtn setTitle:@" 发消息" forState:UIControlStateNormal];
        }
        if ([model.follows isEqualToString:@"0"]) {
            [self.followBtn setTitle:@"  关注" forState:UIControlStateNormal];
            [self.followBtn setImage:[UIImage imageNamed:@"icon_own_gz"] forState:UIControlStateNormal];
        }else {
            [self.followBtn setTitle:@" 已关注" forState:UIControlStateNormal];
            [self.followBtn setImage:[UIImage imageNamed:@"icon_own_ygz"] forState:UIControlStateNormal];
        }
    }
    self.praiseCountLabel.text = model.likeSum;
    self.imgsLabel.text = [NSString stringWithFormat:@"1/%li",model.pick.count];
    [self.sigsView insertSign:model.tags];
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
    
//    self.sexImage = [UIImageView new];
//    [self addSubview:self.sexImage];
    
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
    self.imgsLabel.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.imgsLabel.clipsToBounds = YES;
    self.imgsLabel.textAlignment = NSTextAlignmentCenter;
    self.imgsLabel.layer.cornerRadius = 12;
    [self addSubview:self.imgsLabel];
    
    
    self.imgBtn = [UIButton new];
    [self.imgBtn setImage:[UIImage imageNamed:@"icon_dzh_owner"] forState:UIControlStateNormal];
    [self.imgBtn setTitle:@" 打招呼" forState:UIControlStateNormal];
    [self.imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.imgBtn setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    self.imgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.imgBtn.clipsToBounds = YES;
    self.imgBtn.layer.cornerRadius = 5;
    [self addSubview:self.imgBtn];
    
    self.friendBtn = [UIButton new];
    [self.friendBtn setImage:[UIImage imageNamed:@"icon_jhy_owner"] forState:UIControlStateNormal];
    [self.friendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.friendBtn setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    self.friendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.friendBtn.clipsToBounds = YES;
    self.friendBtn.layer.cornerRadius = 5;
    [self.friendBtn setTitle:@" 加好友" forState:UIControlStateNormal];
    [self addSubview:self.friendBtn];
    
    self.followBtn = [UIButton new];
    [self.followBtn setImage:[UIImage imageNamed:@"icon_jhy_owner"] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.followBtn setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.followBtn.clipsToBounds = YES;
    self.followBtn.layer.cornerRadius = 5;
    [self addSubview:self.followBtn];
    
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
    
    [weakSelf.portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.smallUserImg);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
        
    }];
    
//    [weakSelf.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.smallUserImg.mas_right).mas_offset(-15);
//        make.top.mas_equalTo(weakSelf.smallUserImg.mas_bottom).mas_offset(-15);
//        make.width.height.mas_equalTo(15);
//    }];
    
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
    
    [weakSelf.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-25*kiphone6_ScreenHeight);
    }];
    
    [weakSelf.imgsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
        if (iPhoneX) {
            make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-150);
        }else {
            make.bottom.mas_equalTo(weakSelf.ownerImg.mas_bottom).mas_offset(-170*kiphone6_ScreenHeight);
        }
    }];
    
    [weakSelf.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
    make.bottom.mas_equalTo(weakSelf.followBtn.mas_top).mas_offset(-15*kiphone6_ScreenHeight);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        
    }];
    [weakSelf.friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(weakSelf.imgBtn.mas_top).mas_offset(-15*kiphone6_ScreenHeight);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        
    }];
    
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
        make.right.mas_equalTo(weakSelf.followBtn.mas_left);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
    
    
}



@end
