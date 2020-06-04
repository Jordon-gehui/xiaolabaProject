//
//  XLBEarningsView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBEarningsView.h"
@interface XLBEarningsView ()

@property (nonatomic, strong) UIView *balanceV;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UIView *remindV;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *withdrawLabel;
@property (nonatomic, strong) UILabel *currentWL;
@property (nonatomic, strong) UILabel *withdrawCount;
@property (nonatomic, strong) UILabel *currentCount;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIButton *withdrawBtn;
@property (nonatomic, strong) UIButton *conversionBtn;
@property (nonatomic, strong) UIButton *questionBtn;

@end
@implementation XLBEarningsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.balanceV = [UIView new];
    self.balanceV.backgroundColor = [UIColor viewBackColor];
    [self addSubview:self.balanceV];
    
    self.topLabel = [UILabel new];
    self.topLabel.text = @"车票";
    self.topLabel.font = [UIFont systemFontOfSize:15];
    self.topLabel.textAlignment = NSTextAlignmentLeft;

    [self.balanceV addSubview:self.topLabel];
    
    self.balanceLabel = [UILabel new];
    self.balanceLabel.text = @"200";
    self.balanceLabel.font = [UIFont systemFontOfSize:20];
    self.balanceLabel.textColor = [UIColor textBlackColor];
    self.balanceLabel.textAlignment = NSTextAlignmentLeft;
    [self.balanceV addSubview:self.balanceLabel];
    
    self.remindV = [UIView new];
    self.remindV.backgroundColor = [UIColor textBlackColor];
    [self.balanceV addSubview:self.remindV];
    
    self.remindLabel = [UILabel new];
    self.remindLabel.text = @"每日最多提现3次，每次提现限额 20000";
    self.remindLabel.textAlignment = NSTextAlignmentLeft;
    self.remindLabel.font = [UIFont systemFontOfSize:12];
    self.remindLabel.textColor = [UIColor whiteColor];
    [self.remindV addSubview:self.remindLabel];
    
    self.withdrawLabel = [UILabel new];
    self.withdrawLabel.text = @"可提现金额(元)";
    self.withdrawLabel.font = [UIFont systemFontOfSize:15];
    self.withdrawLabel.textColor = [UIColor blackColor];
    [self addSubview:self.withdrawLabel];
    
    self.currentWL = [UILabel new];
    self.currentWL.text = @"今日可提现金额(元)";
    self.currentWL.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.currentWL];
    
    self.withdrawCount = [UILabel new];
    self.withdrawCount.text = @"1000";
    self.withdrawCount.textColor = [UIColor blackColor];
    self.withdrawCount.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.withdrawCount];
    
    
    self.currentCount = [UILabel new];
    self.currentCount.text = @"1000";
    self.currentCount.textColor = [UIColor blackColor];
    self.currentCount.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.currentCount];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineV];
    
    self.questionBtn = [UIButton new];
    [self.questionBtn setTitle:@"常见问题？" forState:0];
    self.questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.questionBtn setTitleColor:[UIColor textBlackColor] forState:0];
    self.questionBtn.tag = EarningsQuestionTag;
    [self.questionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.questionBtn];
    
    self.withdrawBtn = [UIButton new];
    [self.withdrawBtn setTitle:@"支付宝提现" forState:0];
    self.withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.withdrawBtn.layer.masksToBounds = YES;
    self.withdrawBtn.layer.cornerRadius = 20;
    self.withdrawBtn.tag = EarningsWithDrawTag;
    self.withdrawBtn.backgroundColor = [UIColor shadeEndColor];
    [self.withdrawBtn setTitleColor:[UIColor textBlackColor] forState:0];
    [self.withdrawBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.withdrawBtn];
    
    self.conversionBtn = [UIButton new];
    [self.conversionBtn setTitle:@"兑换" forState:0];
    self.conversionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.conversionBtn.layer.masksToBounds = YES;
    self.conversionBtn.layer.cornerRadius = 20;
    self.conversionBtn.tag = EarningsConversionTag;
    self.conversionBtn.backgroundColor = [UIColor shadeEndColor];
    [self.conversionBtn setTitleColor:[UIColor textBlackColor] forState:0];
    [self.conversionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.conversionBtn];
}

- (void)btnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(earningsBtnClick:)]) {
        [self.delegate earningsBtnClick:sender];
    }
}

- (void)layoutSubviews {
    [self.balanceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(self.balanceV.mas_left).with.offset(15);
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.balanceV.mas_left).with.offset(15);
    }];
    
    [self.remindV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remindV.mas_left).with.offset(15);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [self.withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindV.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(15);
        make.height.mas_equalTo(18);
    }];
    
    [self.currentWL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(self.withdrawLabel.mas_centerY);
    }];
    
    [self.withdrawCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.withdrawLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.mas_left).with.offset(15);
    }];
    
    [self.currentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentWL.mas_left).with.offset(0);
        make.centerY.mas_equalTo(self.withdrawCount.mas_centerY);
        make.right.mas_equalTo(self.currentWL.mas_right).with.offset(0);
    }];
    
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.withdrawCount.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-80);
        make.left.right.mas_equalTo(0);
    }];

    
    [self.conversionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.questionBtn.mas_top).with.offset(-10);
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.conversionBtn.mas_top).with.offset(-30);
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(40);
    }];
    
    
}

@end
