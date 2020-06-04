//
//  VoiceEndCallView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/9.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceEndCallView.h"

@interface VoiceEndCallView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation VoiceEndCallView

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
- (void)setTime:(NSString *)time {
    int timeLenth = [time intValue];
    int hour = timeLenth / 3600;
    int m = (timeLenth - hour * 3600) / 60;
    int s = timeLenth - hour * 3600 - m * 60;
    if (hour > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"通话时间：%02d:%02d:%02d", hour, m, s];
    }else if(m > 0){
        self.timeLabel.text = [NSString stringWithFormat:@"通话时间：00:%02d:%02d", m, s];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"通话时间：00:00:%02d", s];
    }
    _time = time;
}
- (void)setMoney:(NSString *)money {
    if (kNotNil(money)) {
        if ([money containsString:@"(null)"]) {
            self.priceLabel.text = @"收入：0车票";
        }else {
            self.priceLabel.text = [NSString stringWithFormat:@"收入：%@车票",money];
        }
    }else {
        self.priceLabel.text = @"收入：0车票";
    }
    _money = money;
}

- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.topView = [UIView new];
    [self.bgView addSubview:self.topView];
    
    self.bgImg = [UIImageView new];
    self.bgImg.backgroundColor = [UIColor textBlackColor];
    [self.topView addSubview:self.bgImg];
    
    self.topLabel = [UILabel new];
    self.topLabel.text = @"通话结束";
    self.topLabel.font = [UIFont systemFontOfSize:16];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.topLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = [UIColor colorWithR:174 g:181 b:194];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"通话时间：02:20";
    [self.topView addSubview:self.timeLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor shadeStartColor];
    self.priceLabel.font = [UIFont systemFontOfSize:20];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.text = @"收入：100车币";
    [self.topView addSubview:self.priceLabel];
    
    self.closeBtn = [UIButton new];
    [self.closeBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    [self.closeBtn setBackgroundColor:[UIColor shadeStartColor]];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.closeBtn];
    
}

- (void)closeBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(175);
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(0);

    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.bgView.mas_width).with.offset(0);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(0);
        make.width.mas_equalTo(self.bgView.mas_width).with.offset(0);
        make.bottom.mas_equalTo(self.closeBtn.mas_top).with.offset(0);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
    }];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.topView.mas_centerY).with.offset(0);
        
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel.mas_top).with.offset(-20);
        make.centerX.mas_equalTo(self.topView.mas_centerX).with.offset(0);
    }];
    

    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(15);
        make.centerX.mas_equalTo(self.topView.mas_centerX).with.offset(0);
    }];
}

@end
