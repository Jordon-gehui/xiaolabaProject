//
//  VoiceCallView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceCallView.h"

@interface VoiceCallView ()

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIView *balanceV;
@property (nonatomic, strong) UIImageView *balanceImg;
@property (nonatomic, strong) UILabel *balance;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *lineImg;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation VoiceCallView

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self setSubViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self setSubViews];
    }
    return self;
}

- (void)setMoney:(NSString *)money {
    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
    NSString *coiSum = [userDefa objectForKey:@"coinSum"];
    self.balance.text = [NSString stringWithFormat:@"%.2f",[coiSum floatValue]];
    int coiSumint = [coiSum intValue];
    int moneyInt = [money intValue];
    self.price.text = [NSString stringWithFormat:@"%@车币/分钟",money];
    if (kNotNil(money)) {
        self.price.text = [NSString stringWithFormat:@"%@车币/分钟",money];
        if (coiSumint < (moneyInt * 2)) {
            [self.startBtn setTitle:@"去充值" forState:0];
            self.timeLabel.text = @"余额不足";
            self.timeLabel.textColor = [UIColor redColor];
        }else {
            NSLog(@"%d",coiSumint/moneyInt);
            self.timeLabel.text = [NSString stringWithFormat:@"您的余额可通话%d分钟",coiSumint/moneyInt];
            [self.startBtn setTitle:@"立即发起" forState:0];
        }
    }
    _money = money;
}
- (void)closeBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.topV = [UIView new];
    [self.bgView addSubview:self.topV];
    
    self.bgImg = [UIImageView new];
    self.bgImg.image = [UIImage imageNamed:@"pic_bg"];
    [self.topV addSubview:self.bgImg];
    
    self.balanceV = [UIView new];
    self.balanceV.backgroundColor = [UIColor whiteColor];
    self.balanceV.layer.masksToBounds = YES;
    self.balanceV.layer.cornerRadius = 11;
    self.balanceV.layer.borderWidth = 1;
    self.balanceV.layer.borderColor = [UIColor shadeStartColor].CGColor;
    [self.topV addSubview:self.balanceV];
    
    NSString *accountCo = @"98";
    
    self.balanceImg = [UIImageView new];
    self.balanceImg.image = [UIImage imageNamed:@"pin_jb"];
    [self.topV addSubview:self.balanceImg];

    self.balance = [UILabel new];
    self.balance.text = accountCo;
    self.balance.textColor = [UIColor shadeStartColor];
    self.balance.font = [UIFont systemFontOfSize:9];
    [self.topV addSubview:self.balance];
    
    self.closeBtn = [UIButton new];

    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:[UIImage imageNamed:@"icon_gb_v"] forState:UIControlStateNormal];
    [self.topV addSubview:self.closeBtn];
    [self.closeBtn setEnlargeEdge:8];

    
    self.remindLabel = [UILabel new];
    self.remindLabel.text = @"您将向对方发起通话";
    self.remindLabel.textColor = [UIColor textBlackColor];
    self.remindLabel.font = [UIFont systemFontOfSize:16];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.topV addSubview:self.remindLabel];
    
    self.lineImg = [UIImageView new];
//    self.lineImg.backgroundColor = [UIColor whiteColor];
    [self.topV addSubview:self.lineImg];
    
    self.price = [UILabel new];
    self.price.text = @"45车币/分钟";
    self.price.textColor = [UIColor shadeStartColor];
    self.price.font = [UIFont systemFontOfSize:20];
    self.price.textAlignment = NSTextAlignmentCenter;
    [self.topV addSubview:self.price];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.text = @"您的余额可通话2分钟";
    self.timeLabel.textColor = [UIColor colorWithR:174 g:181 b:194];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    [self.topV addSubview:self.timeLabel];
    
    self.startBtn = [UIButton new];
    [self.startBtn setTitle:@"立即发起" forState:0];
    [self.startBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn setBackgroundColor:[UIColor assistColor]];
//    self.startBtn.layer.masksToBounds = YES;
//    self.startBtn.layer.cornerRadius = 5;
//    self.startBtn.layer.borderWidth = 1;
//    self.startBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.bgView addSubview:self.startBtn];
    
}
- (void)startBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if ([sender.titleLabel.text isEqualToString:@"去充值"]) {
        if ([self.delegate respondsToSelector:@selector(goRecharge)]) {
            [self.delegate goRecharge];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(startBtnClick)]) {
            [self.delegate startBtnClick];
        }
    }
}
- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.mas_equalTo(255);
        make.height.mas_equalTo(222);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
        make.width.mas_equalTo(self.bgView.mas_width).with.offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(0);
        make.width.mas_equalTo(self.bgView.mas_width).with.offset(0);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
        make.bottom.mas_equalTo(self.startBtn.mas_top).with.offset(0);
    }];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.balanceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceV.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.balanceV.mas_centerY);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceImg.mas_right).with.offset(5);
        make.right.mas_equalTo(self.balanceV.mas_right).with.offset(-5);
        make.centerY.mas_equalTo(self.balanceV.mas_centerY).with.offset(0);
    }];
    
    [self.balanceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topV.mas_top).with.offset(17);
        make.left.mas_equalTo(self.topV.mas_left).with.offset(15);
        make.right.mas_equalTo(self.balance.mas_right).with.offset(5);
        make.height.mas_equalTo(22);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topV.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(self.balanceV.mas_centerY).with.offset(0);
    }];
    
    [self.lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topV.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.topV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineImg.mas_top).with.offset(-16);
        make.centerX.mas_equalTo(self.topV.mas_centerX).with.offset(0);
    }];
    
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineImg.mas_bottom).with.offset(16);
        make.centerX.mas_equalTo(self.remindLabel.mas_centerX).with.offset(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.price.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.topV.mas_centerX).with.offset(0);
    }];
    
}
- (void)changeStatus{
    //    UIView *showView = [self viewWithTag:1];
    //    [showView removeFromSuperview];

    UIView *backv1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 252, 20)];
    backv1.backgroundColor = self.bgView.backgroundColor;
    [self.bgView addSubview:backv1];
    UIView *backv2 = [[UIView alloc]initWithFrame:CGRectMake(0, 112, 252, 22)];
    backv2.backgroundColor = self.bgView.backgroundColor;
    [self.bgView addSubview:backv2];
    UIView *backv3 = [[UIView alloc]initWithFrame:CGRectMake(0, 136, 252, 18)];
    backv3.backgroundColor = self.bgView.backgroundColor;
    [self.bgView addSubview:backv3];
    [self textShow:backv1];
    [self performSelector:@selector(textShow:)withObject:backv2 afterDelay:0.4];
    [self performSelector:@selector(textShow:)withObject:backv3 afterDelay:0.4];
    
}
-(void)textShow:(UIView*)view{
    [UIView animateWithDuration:0.8 animations:^{
        view.frame = CGRectMake(view.width, view.y, 0, view.height);
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}
@end
