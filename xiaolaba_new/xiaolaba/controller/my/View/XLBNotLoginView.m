//
//  XLBNotLoginView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/6.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBNotLoginView.h"
@interface XLBNotLoginView ()

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation XLBNotLoginView

- (id)initWithFrame:(CGRect)frame type:(NSString *)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViewsWithType:type];
        self.type = type;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSubViewsWithType:(NSString *)type {
    
    if ([type isEqualToString:@"1"]) {
        _bgImg = [UIImageView new];
        _bgImg.image = [UIImage imageNamed:@"myBack"];
        [self addSubview:_bgImg];
        
        _lineV = [UIView new];
        _lineV.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineV];
    }
    _img = [UIImageView new];
    if ([type isEqualToString:@"0"] || [type isEqualToString:@"2"]) {
        _img.image = [UIImage imageNamed:@"pic_news_tx"];
    }else {
        _img.image = [UIImage imageNamed:@"img_wd_mrtx"];
    }
    [self addSubview:_img];
    
    if ([type isEqualToString:@"0"] || [type isEqualToString:@"2"]) {
        _remindLabel = [UILabel new];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = [UIColor minorTextColor];
        _remindLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_remindLabel];
    }
    if ([type isEqualToString:@"0"]) {
        _remindLabel.text = @"登录后和朋友聊天吧~";
    }
    if ([type isEqualToString:@"2"]) {
        _remindLabel.text = @"登录后查看点赞榜~";
    }
    _loginBtn = [UIButton new];
    [_loginBtn setTitle:@"登录/注册" forState:0];
    if ([type isEqualToString:@"1"]) {
        [_loginBtn setBackgroundColor:[UIColor clearColor]];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    }else {
        [_loginBtn setBackgroundColor:[UIColor lightColor]];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitleColor:[UIColor commonTextColor] forState:0];
    }
    [self addSubview:_loginBtn];
}

- (void)layoutSubviews {
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.type isEqualToString:@"1"]) {
            make.left.mas_equalTo(25);
            if (iPhoneX) {
                make.top.mas_equalTo(88);
            }else {
                make.top.mas_equalTo(66);
            }
            make.width.height.mas_equalTo(64);
        }else {
            make.centerY.mas_equalTo(self.mas_centerY).with.offset(-120);
            make.width.height.mas_equalTo(82);
            make.centerX.mas_equalTo(self.mas_centerX);
        }
        
    }];
    
    if ([self.type isEqualToString:@"0"] || [self.type isEqualToString:@"2"]) {
        [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_img.mas_bottom).with.offset(15);
            make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        }];
    }
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.type isEqualToString:@"1"]) {
            make.centerY.mas_equalTo(self.img.mas_centerY);
            make.left.mas_equalTo(self.img.mas_right).with.offset(5);
            make.width.mas_equalTo(90 * kiphone6_ScreenWidth);
            make.height.mas_equalTo(35*kiphone6_ScreenHeight);
        }else {
            make.top.mas_equalTo(_remindLabel.mas_bottom).with.offset(13);
            make.width.mas_equalTo(110*kiphone6_ScreenWidth);
            make.height.mas_equalTo(35*kiphone6_ScreenHeight);
            make.centerX.mas_equalTo(_img.mas_centerX);
        }
    }];
    
    if ([self.type isEqualToString:@"1"]) {
        [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    

}
@end
