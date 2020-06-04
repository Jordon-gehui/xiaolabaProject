//
//  XLBCallView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBCallView.h"
@interface XLBCallView ()

@property (nonatomic, strong) UILabel *callLabel;
@property (nonatomic, strong) UILabel *callSubLabel;
@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UIImageView *rightSubImg;


@property (nonatomic, strong) UILabel *defaultBtnLabel;
@property (nonatomic, strong) UILabel *callBtnLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSArray <UIButton *>*items;
@end

@implementation XLBCallView

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        self.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setSubViews];
    }
    return self;
}
- (void)setDeviceNo:(NSString *)deviceNo {
    _deviceNo = deviceNo;
    if ([deviceNo isEqualToString:@"0"]) {
        self.defaultBtn.hidden = YES;
        self.defaultBtnLabel.hidden = YES;
    }
}
- (void)setSubViews {
    self.callLabel = [UILabel new];
    self.callLabel.text = @"电话呼叫";
    self.callLabel.textColor = [UIColor commonTextColor];
    self.callLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.callLabel];
    
    self.rightImg = [UIImageView new];
    self.rightImg.image = [UIImage imageNamed:@"icon_call"];
    [self.contentView addSubview:self.rightImg];
    
    self.callSubLabel = [UILabel new];
    self.callSubLabel.textColor = [UIColor minorTextColor];
    self.callSubLabel.font = [UIFont systemFontOfSize:13];
    self.callSubLabel.numberOfLines = 0;
    self.callSubLabel.text = @"电话呼叫提供免费通话，且将在60s后自动挂断，只作为第三方中转，不存留电话，充分保证双方隐私通话";
    [self.contentView addSubview:self.callSubLabel];
    
    self.defaultLabel = [UILabel new];
    self.defaultLabel.text = @"铃声通知";
    self.defaultLabel.textColor = [UIColor commonTextColor];
    self.defaultLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.defaultLabel];
    
    self.rightSubImg = [UIImageView new];
    self.rightSubImg.image = [UIImage imageNamed:@"icon_call"];
    [self.contentView addSubview:self.rightSubImg];
    
    self.subLabel = [UILabel new];
    self.subLabel.textColor = [UIColor minorTextColor];
    self.subLabel.font = [UIFont systemFontOfSize:13];
    self.subLabel.numberOfLines = 0;
    self.subLabel.text = @"铃声通知提供响铃提醒，发起挪车请求成功后，挪车方将会收到响铃，保证双方快速挪车";
    [self.contentView addSubview:self.subLabel];
    
    self.callBtn = [UIButton new];
    [self.callBtn setBackgroundImage:[UIImage imageNamed:@"bg_nc"] forState:UIControlStateNormal];
    self.callBtn.tag = 100;
    [self.callBtn setImage:[UIImage imageNamed:@"icon_dh"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.callBtn];

    self.callBtnLabel = [UILabel new];
    self.callBtnLabel.text = @"电话呼叫";
    self.callBtnLabel.textAlignment = NSTextAlignmentCenter;
    self.callBtnLabel.textColor = [UIColor commonTextColor];
    self.callBtnLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.callBtnLabel];

    self.defaultBtn = [UIButton new];
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"bg_nc"] forState:UIControlStateNormal];
    [self.defaultBtn setImage:[UIImage imageNamed:@"icon_ls"] forState:UIControlStateNormal];
    self.defaultBtn.tag = 200;
    [self.contentView addSubview:self.defaultBtn];

    self.defaultBtnLabel = [UILabel new];
    self.defaultBtnLabel.text = @"铃声通知";
    self.defaultBtnLabel.textAlignment = NSTextAlignmentCenter;
    self.defaultBtnLabel.textColor = [UIColor commonTextColor];
    self.defaultBtnLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.defaultBtnLabel];
    
    self.closeBtn = [UIButton new];
    [self.closeBtn setImage:[UIImage imageNamed:@"icon_ncgb"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setEnlargeEdge:8];
    [self.contentView addSubview:self.closeBtn];
}

- (void)apper {
}
- (void)closeBtnClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [self.callLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70*kiphone6_ScreenHeight);
        make.left.mas_equalTo(30);
    }];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.callLabel.mas_centerY);
        make.width.height.mas_equalTo(10);
        make.left.mas_equalTo(self.callLabel.mas_right).with.offset(3);
    }];
    
    [self.callSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
    }];
    
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callSubLabel.mas_bottom).with.offset(30);
        make.left.mas_equalTo(30);
    }];
    
    [self.rightSubImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.defaultLabel.mas_centerY);
        make.width.height.mas_equalTo(10);
        make.left.mas_equalTo(self.defaultLabel.mas_right).with.offset(3);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.defaultLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-175 * kiphone6_ScreenHeight);
        if ([self.deviceNo isEqualToString:@"0"]) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX).with.offset(0);
        }else {
            make.left.mas_equalTo((kSCREEN_WIDTH - 174) / 3);
        }
        make.width.height.mas_equalTo(87);
    }];

    [self.callBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callBtn.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.callBtn.mas_centerX);
    }];

    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callBtn.mas_top).with.offset(0);
        make.left.mas_equalTo(self.callBtn.mas_right).with.offset((kSCREEN_WIDTH - 174) / 3);
        make.width.height.mas_equalTo(self.callBtn);
    }];

    [self.defaultBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.defaultBtn.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.defaultBtn.mas_centerX);
        make.centerY.mas_equalTo(self.defaultBtnLabel.mas_centerY);
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-35);
        make.width.height.mas_equalTo(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
}
@end
