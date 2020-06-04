//
//  XLBRemindView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/31.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBRemindView.h"

@interface XLBRemindView ()

@property (nonatomic, strong) UIImageView *remindName;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *cretainBtn;
@property (nonatomic, strong) UIView *bgV;
@end

@implementation XLBRemindView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(1, 1, 1, 0.5);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [self setUpSubViews];
    }
    return self;
}

- (void)setUserName:(NSString *)userName {
    if (kNotNil(userName)) {
        self.nameLabel.text = userName;
    }
    _userName = userName;
}

- (void)setUpSubViews {
    
    self.remindName = [UIImageView new];
    self.remindName.image = [UIImage imageNamed:@"pic_k"];
    [self addSubview:self.remindName];
    
    self.bgV = [UIView new];
    self.bgV.backgroundColor = [UIColor whiteColor];
    self.bgV.layer.masksToBounds = YES;
    self.bgV.layer.cornerRadius = 5;
    [self addSubview:self.bgV];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor textBlackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:17];
    self.nameLabel.text = @"姓名";
    [self.bgV addSubview:self.nameLabel];
    
    self.subLabel = [UILabel new];
    self.subLabel.text = @"查看或者编辑个人资料";
    self.subLabel.textColor = [UIColor annotationTextColor];
    self.subLabel.font = [UIFont systemFontOfSize:14];
    [self.bgV addSubview:self.subLabel];
    
    self.cretainBtn = [UIButton new];
    [self.cretainBtn addTarget:self action:@selector(cretainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cretainBtn setBackgroundImage:[UIImage imageNamed:@"pic_ws"] forState:UIControlStateNormal];
    self.cretainBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.cretainBtn];
    
}

- (void)layoutSubviews {
    kWeakSelf(self);
    
    [weakSelf.remindName mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(89);
        }else {
            make.top.mas_equalTo(65);
        }
        make.left.mas_equalTo(90);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(63);
    }];
    
    [weakSelf.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.remindName.mas_top).with.offset(4);
        make.left.mas_equalTo(weakSelf.remindName.mas_left).with.offset(4);
        make.bottom.mas_equalTo(weakSelf.remindName.mas_bottom).with.offset(-4);
        make.right.mas_equalTo(weakSelf.remindName.mas_right).with.offset(-4);
        
    }];
    
    [weakSelf.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.bgV.mas_left).with.offset(6);
        make.top.mas_equalTo(weakSelf.bgV.mas_top).with.offset(10);
    }];
    
    [weakSelf.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).with.offset(5);
    }];
    
    [weakSelf.cretainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.remindName.mas_bottom).with.offset(10);
        make.width.mas_equalTo(249);
        make.height.mas_equalTo(148);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        
    }];
}

- (void)cretainBtnClick:(UIButton *)sender {
    [[XLBCache cache] store:@"guidance" key:@"guidance"];
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
}
@end
