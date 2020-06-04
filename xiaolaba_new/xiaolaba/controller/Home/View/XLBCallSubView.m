//
//  XLBCallSubView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBCallSubView.h"
@interface XLBCallSubView ()
@property (nonatomic, strong) UIImageView *userBg;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *contentSub;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *closeB;

@end


@implementation XLBCallSubView

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        self.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.userBg = [UIImageView new];
    self.userBg.image = [UIImage imageNamed:@"weitouxiang"];
    self.userBg.layer.masksToBounds = YES;
    self.userBg.layer.cornerRadius = 45;
//    self.userBg.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.userBg];
    
    self.userImg = [UIImageView new];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 40;
    self.userImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self.contentView addSubview:self.userImg];
    
    self.nickname = [UILabel new];
    self.nickname.textColor = [UIColor commonTextColor];
    self.nickname.text = @"姓名";
    self.nickname.textAlignment = NSTextAlignmentCenter;
    self.nickname.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.nickname];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = [UIColor minorTextColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"请先接听来电，随后将自动呼叫对方！双方电话均不泄漏，保证绝对隐私通话！";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
    
    self.contentSub = [UILabel new];
    self.contentSub.textColor = [UIColor shadeStartColor];
    self.contentSub.text = @"话费由平台支付";
    self.contentSub.textAlignment = NSTextAlignmentCenter;
    self.contentSub.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.contentView addSubview:self.contentSub];
    
    self.closeBtn = [UIButton new];
    [self.closeBtn setImage:[UIImage imageNamed:@"icon_ncgb"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.closeBtn];
    
    
    self.closeB = [UIButton new];
    [self.closeB addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.closeB];
}
- (void)closeBtnClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)layoutSubviews {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(-25);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
    }];
    
    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentLabel.mas_top).with.offset(-30);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.userBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.nickname.mas_top).with.offset(-20);
        make.width.height.mas_equalTo(90);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.userBg.mas_centerX);
        make.centerY.mas_equalTo(self.userBg.mas_centerY);
        make.width.height.mas_equalTo(80);
    }];
    
    [self.contentSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-35);
        make.height.width.mas_equalTo(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.closeB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-35);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.left.right.mas_equalTo(0);
    }];
}
@end
