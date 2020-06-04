//
//  XLBEarningsListView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBEarningsListView.h"

@interface XLBEarningsListView ()

@property (nonatomic, strong) UIView *topV;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@end


@implementation XLBEarningsListView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = [UIColor blackColor];
        self.backgroundColor = [color colorWithAlphaComponent:0.5];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.topV = [UIView new];
    self.topV.backgroundColor = [UIColor whiteColor];
    self.topV.layer.masksToBounds = YES;
    self.topV.layer.cornerRadius = 10;
    [self addSubview:self.topV];
    
    self.rechargeBtn = [UIButton new];
    [self.rechargeBtn setTitle:@"充值明细" forState:0];
    [self.rechargeBtn setTitleColor:[UIColor commonTextColor] forState:0];
    self.rechargeBtn.tag = BillDetailRechargeBtnTag;
    self.rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rechargeBtn addTarget:self action:@selector(billDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.rechargeBtn];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [UIColor colorWithR:204 g:204 b:204];
    [self.topV addSubview:self.line1];
    
    self.withdrawBtn = [UIButton new];
    [self.withdrawBtn setTitle:@"提现明细" forState:0];
    [self.withdrawBtn setTitleColor:[UIColor commonTextColor] forState:0];
    self.withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.withdrawBtn.tag = BillDetailWithdrawBtnTag;
    [self.withdrawBtn addTarget:self action:@selector(billDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.withdrawBtn];
    
    self.line2 = [UIView new];
    self.line2.backgroundColor = [UIColor colorWithR:204 g:204 b:204];
    [self.topV addSubview:self.line2];
    
//    self.conversionBtn = [UIButton new];
//    [self.conversionBtn setTitle:@"兑换明细" forState:0];
//    [self.conversionBtn setTitleColor:[UIColor textBlackColor] forState:0];
//    self.conversionBtn.tag = BillDetailConversionBtnTag;
//    [self.conversionBtn addTarget:self action:@selector(billDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.topV addSubview:self.conversionBtn];
    
}

- (void)billDetailBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(billDetailButtonClick:)]) {
        [_delegate billDetailButtonClick:sender];
    }
}

- (void)layoutSubviews {
//    CGFloat width = self.width*0.7;
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rechargeBtn.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.line1.mas_bottom).with.offset(0);
        make.height.mas_equalTo(50);

    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topV.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
//    [self.conversionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.line2.mas_bottom).with.offset(0);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(48);
//    }];
}

@end
