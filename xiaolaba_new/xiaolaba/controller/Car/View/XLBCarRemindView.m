//
//  XLBCarRemindView.m
//  xiaolaba
//
//  Created by 斯陈 on 2019/3/14.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import "XLBCarRemindView.h"

@interface XLBCarRemindView ()

@property (nonatomic, strong) UIImageView *titleImg;
@property (nonatomic, strong) UIImageView *arrowsImg;
@property (nonatomic, strong) UIImageView *btnImg;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UIImageView *titleSubImg;
@property (nonatomic, strong) UIImageView *arrowsSubImg;
@property (nonatomic, strong) UIImageView *btnSubImg;\


@end

@implementation XLBCarRemindView

- (id)initWithFrame:(CGRect)frame type:(NSString *)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(1, 1, 1, 0.7);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [self setUpSubViewsWithType:type];
    }
    return self;
}

- (void)nextBtnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        self.btnImg.hidden = YES;
        self.titleImg.hidden = YES;
        self.arrowsImg.hidden = YES;
        self.btnSubImg.hidden = NO;
        self.titleSubImg.hidden = NO;
        self.arrowsSubImg.hidden = NO;
        sender.tag = 200;
    }else if(sender.tag == 200){
        [[NSUserDefaults  standardUserDefaults] setObject:@"MoveCarRemind" forKey:@"MoveCarRemind"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:0.5 animations:^{
            [self removeFromSuperview];
        }];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"ownerRemind" forKey:@"ownerRemind"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:0.5 animations:^{
            [self removeFromSuperview];
        }];
    }
}

- (void)setUpSubViewsWithType:(NSString *)type {
    
    self.titleImg = [UIImageView new];
    self.titleImg.image = [UIImage imageNamed:@"nc_xszy_msg_sm"];
    [self addSubview:self.titleImg];

    self.arrowsImg = [UIImageView new];
    self.arrowsImg.image = [UIImage imageNamed:@"nc_xszy_icon_smjt"];
    [self addSubview:self.arrowsImg];

    self.btnImg = [UIImageView new];
    self.btnImg.image = [UIImage imageNamed:@"nc_xszy_img_sm"];
    [self addSubview:self.btnImg];
    
    
    self.titleSubImg = [UIImageView new];
    self.titleSubImg.hidden = YES;
    self.titleSubImg.image = [UIImage imageNamed:@"nc_xszy_msg_bd"];
    [self addSubview:self.titleSubImg];
    
    self.arrowsSubImg = [UIImageView new];
    self.arrowsSubImg.hidden = YES;
    self.arrowsSubImg.image = [UIImage imageNamed:@"nc_xszy_icon_bdjt"];
    [self addSubview:self.arrowsSubImg];
    
    self.btnSubImg = [UIImageView new];
    self.btnSubImg.hidden = YES;
    self.btnSubImg.image = [UIImage imageNamed:@"nc_xszy_img_bd"];
    [self addSubview:self.btnSubImg];
    
    self.nextBtn = [UIButton new];
    self.nextBtn.tag = 100;
    if ([type isEqualToString:@"ownerRemind"]) {
        self.nextBtn.tag = 300;
    }
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextBtn];
    
    if ([type isEqualToString:@"ownerRemind"]) {
        self.btnImg.image = [UIImage imageNamed:@"nc_xszy_img_tznc"];
        self.arrowsImg.image = [UIImage imageNamed:@"nc_xszy_icon_tznc"];
        self.titleImg.image = [UIImage imageNamed:@"nc_xszy_msg_tznc"];
        
        [self.btnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-20);
            make.width.height.mas_equalTo(120);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        
        
        [self.arrowsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.btnImg.mas_top).with.offset(-10);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(50);
            make.left.mas_equalTo(self.btnImg.mas_centerX).with.offset(0);
        }];
        
        [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.arrowsImg.mas_right).with.offset(0);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(165);
            make.bottom.mas_equalTo(self.arrowsImg.mas_top).with.offset(-10);
        }];
    }else {
        [self.btnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.top.mas_equalTo(300*kiphone6_ScreenWidth + 120);
            }else {
                make.top.mas_equalTo(300*kiphone6_ScreenWidth + 110);
            }
            make.right.mas_equalTo(self.mas_centerX).with.offset(-2);
            make.width.height.mas_equalTo(176);
            make.height.mas_equalTo(88);
        }];
        
        
        
        [self.arrowsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.btnImg.mas_top).with.offset(-10);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(46);
            make.right.mas_equalTo(self.btnImg.mas_right).with.offset(-20);
        }];
        
        [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(217);
            make.bottom.mas_equalTo(self.arrowsImg.mas_top).with.offset(-10);
        }];
        
        [self.btnSubImg mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.top.mas_equalTo(300*kiphone6_ScreenWidth + 120);
            }else {
                make.top.mas_equalTo(300*kiphone6_ScreenWidth + 110);
            }
            make.left.mas_equalTo(self.mas_centerX).with.offset(2);
            make.width.height.mas_equalTo(176);
            make.height.mas_equalTo(88);
        }];
        
        [self.arrowsSubImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.btnSubImg.mas_left).with.offset(50);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(46);
            make.bottom.mas_equalTo(self.btnSubImg.mas_top).with.offset(-10);
        }];
        
        [self.titleSubImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self.arrowsSubImg.mas_top).with.offset(5);
            make.width.mas_equalTo(248);
            make.height.mas_equalTo(42);
        }];
        
    }
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}




@end
