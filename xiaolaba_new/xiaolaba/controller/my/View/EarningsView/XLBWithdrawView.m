//
//  XLBWithdrawView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBWithdrawView.h"
@interface XLBWithdrawView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *moneyV;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *moneySubLabel;

@property (nonatomic, strong) UIView *accountV;
@property (nonatomic, strong) UILabel *accountRemind;
//@property (nonatomic, strong) UIButton *accountBtn;
//@property (nonatomic, strong) UIImageView *rightImg;

@property (nonatomic, strong) UIView *nickNameV;
@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIButton *remindBtn;
@property (nonatomic, strong) UIButton *withdrawBtn;

@end


@implementation XLBWithdrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor viewBackColor];
        [self setSubViews];
    }
    return self;
}
- (void)setAliUserId:(NSString *)aliUserId {
    _aliUserId = aliUserId;
    if (kNotNil(aliUserId) && ![aliUserId containsString:@"(null)"]) {
        self.accountTextField.text = aliUserId;
        self.accountTextField.enabled = NO;
    }
}
- (void)setAliNickname:(NSString *)aliNickname {
    _aliNickname = aliNickname;
    if (kNotNil(aliNickname) && ![aliNickname containsString:@"(null)"]) {
        self.nickTextField.text = aliNickname;
        self.nickTextField.enabled = NO;
    }
}
- (void)setResidueMoney:(NSString *)residueMoney {
    _residueMoney = residueMoney;
    self.moneyTextField.placeholder = [NSString stringWithFormat:@"当前账户余额%@元",residueMoney];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 100) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];

        if ([text integerValue] < 10) {
            [self.withdrawBtn setBackgroundColor:[UIColor colorWithR:161 g:161 b:161]];
            [self.withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            if (text.length > 0) {
                [self.withdrawBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:self.withdrawBtn.size]]];
                [self.withdrawBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
            }else {
                [self.withdrawBtn setBackgroundColor:[UIColor colorWithR:161 g:161 b:161]];
                [self.withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        
        return YES;
    }
    return YES;
}

- (void)setSubViews {
    self.moneyV = [UIView new];
    self.moneyV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.moneyV];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"余额总额";
    self.moneyLabel.textColor = [UIColor listTitleColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:16];
    [self.moneyV addSubview:self.moneyLabel];
    
//    self.moneySubLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
//    self.moneySubLabel.text = @"¥";
//    self.moneySubLabel.textColor = [UIColor shadeStartColor];
//    self.moneySubLabel.font = [UIFont systemFontOfSize:15];
//    [self.moneyTextField.leftView addSubview:self.moneySubLabel];
    
    self.moneyTextField = [UITextField new];
    self.moneyTextField.placeholder = @"当前账户余额0.00元";
    self.moneyTextField.borderStyle = UITextBorderStyleNone;
    self.moneyTextField.textAlignment = NSTextAlignmentRight;
    self.moneyTextField.font = [UIFont systemFontOfSize:15];
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTextField.textColor = [UIColor shadeStartColor];
    self.moneyTextField.delegate = self;
    self.moneyTextField.tag = 100;
    [self.moneyV addSubview:self.moneyTextField];
    
    self.accountV = [UIView new];
    self.accountV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.accountV];
    
    self.accountRemind = [UILabel new];
    self.accountRemind.text = @"账号";
    self.accountRemind.textColor = [UIColor listTitleColor];
    self.accountRemind.font = [UIFont systemFontOfSize:16];
    [self.accountV addSubview:self.accountRemind];
    
    self.accountTextField = [UITextField new];
    self.accountTextField.placeholder = @"请输入支付宝账号(邮箱或手机)";
    self.accountTextField.borderStyle = UITextBorderStyleNone;
    self.accountTextField.textAlignment = NSTextAlignmentRight;
    self.accountTextField.font = [UIFont systemFontOfSize:15];
    self.accountTextField.keyboardType = UIKeyboardTypeDefault;
    self.accountTextField.textColor = [UIColor listTitleColor];
    self.accountTextField.delegate = self;
    self.accountTextField.tag = 200;
    [self.accountV addSubview:self.accountTextField];
    
    self.nickNameV = [UIView new];
    self.nickNameV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nickNameV];
    
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.text = @"姓名";
    self.nickNameLabel.textColor = [UIColor listTitleColor];
    self.nickNameLabel.font = [UIFont systemFontOfSize:16];
    [self.nickNameV addSubview:self.nickNameLabel];
    
    self.nickTextField = [UITextField new];
    self.nickTextField.placeholder = @"请输入你的真实姓名";
    self.nickTextField.borderStyle = UITextBorderStyleNone;
    self.nickTextField.textAlignment = NSTextAlignmentRight;
    self.nickTextField.font = [UIFont systemFontOfSize:15];
    self.nickTextField.keyboardType = UIKeyboardTypeDefault;
    self.nickTextField.textColor = [UIColor listTitleColor];
    self.nickTextField.delegate = self;
    self.nickTextField.tag = 300;
    [self.nickNameV addSubview:self.nickTextField];
    
//    self.accountLabel = [UILabel new];
//    self.accountLabel.text = @"去绑定";
//    self.accountLabel.font = [UIFont systemFontOfSize:15];
//    self.accountLabel.textColor = [UIColor listTitleColor];
//    [self.accountV addSubview:self.accountLabel];
    
//    self.rightImg = [UIImageView new];
//    self.rightImg.image = [UIImage imageNamed:@"icon_right"];
//    [self.accountV addSubview:self.rightImg];
    
//    self.accountBtn = [UIButton new];
//    self.accountBtn.tag = WithdrawAccountBtnTag;
//    [self.accountBtn addTarget:self action:@selector(withdrawBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.accountV addSubview:self.accountBtn];
    
    self.remindLabel = [UILabel new];
    self.remindLabel.font = [UIFont systemFontOfSize:12];
    self.remindLabel.numberOfLines = 0;
    self.remindLabel.text = @"*为了您的资金安全，此账号为您唯一提现账号，请务必核实\n 以上信息\n\n*提现金额不能小于10元\n\n*到账时间为3个工作日内,提现金额将自动转入您的支付宝";
    self.remindLabel.textColor = [UIColor annotationTextColor];
    [self addSubview:self.remindLabel];
    
    self.remindBtn = [UIButton new];
    [self.remindBtn setTitle:@"提现额度说明 >>" forState:0];
    [self.remindBtn setTitleColor:[UIColor shadeStartColor] forState:0];
    self.remindBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.remindBtn.tag = WithdrawRemindBtnTag;
    [self.remindBtn addTarget:self action:@selector(withdrawBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.remindBtn];
    
    self.withdrawBtn = [UIButton new];
    self.withdrawBtn.layer.masksToBounds = YES;
    self.withdrawBtn.layer.cornerRadius = 5;
    self.withdrawBtn.backgroundColor = [UIColor colorWithR:161 g:161 b:161];
    [self.withdrawBtn setTitle:@"确定提现" forState:0];
    [self.withdrawBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.withdrawBtn.tag = WithdrawWithdrawBtnTag;
    self.withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.withdrawBtn addTarget:self action:@selector(withdrawBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.withdrawBtn];
}
- (void)withdrawBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(withdrawButtonClick:)]) {
        [_delegate withdrawButtonClick:sender];
    }
}


- (void)layoutSubviews {
    
    [self.moneyV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moneyV.mas_left).with.offset(15);
        make.top.bottom.mas_equalTo(self.moneyV).with.offset(0);
    }];
    
//    [self.moneySubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.moneyV.mas_right).with.offset(-15);
//        make.top.bottom.mas_equalTo(self.moneyV).with.offset(0);
//        make.width.mas_equalTo(15);
//    }];
    
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moneyV.mas_right).with.offset(-15);
        make.left.mas_equalTo(self.moneyLabel.mas_right).with.offset(5);
        make.top.bottom.mas_equalTo(self.moneyV).with.offset(0);
    }];
    
    [self.accountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyV.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.moneyV.mas_height);
    }];
    
    [self.accountRemind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountV.mas_left).with.offset(15);
        make.centerY.mas_equalTo(self.accountV.mas_centerY).with.offset(0);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.accountV.mas_right).with.offset(-15);
        make.left.mas_equalTo(self.accountRemind.mas_right).with.offset(5);
        make.top.bottom.mas_equalTo(self.accountV).with.offset(0);
    }];
    
    [self.nickNameV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountV.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.accountV.mas_height);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameV.mas_left).with.offset(15);
        make.centerY.mas_equalTo(self.nickNameV.mas_centerY).with.offset(0);
    }];
    
    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.nickNameV.mas_right).with.offset(-15);
        make.left.mas_equalTo(self.nickNameLabel.mas_right).with.offset(5);
        make.top.bottom.mas_equalTo(self.nickNameV).with.offset(0);
    }];
    
//    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.accountV.mas_right).with.offset(-15);
//        make.centerY.mas_equalTo(self.accountV.mas_centerY).with.offset(0);
//        make.width.height.mas_equalTo(15);
//    }];
//
//    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.rightImg.mas_left).with.offset(-5);
//        make.centerY.mas_equalTo(self.accountV.mas_centerY).with.offset(0);
//    }];
//
//    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(self.accountV).with.offset(0);
//    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameV.mas_bottom).with.offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(80);
    }];
    
    [self.remindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(15);
    }];
    
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindBtn.mas_bottom).with.offset(50);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(48);
    }];
}

@end
