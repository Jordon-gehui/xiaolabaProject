//
//  RechargeView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "RechargeView.h"

@interface RechargeView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *textFieldBgV;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *themeSubLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation RechargeView

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self setSubViews];
    }
    return self;
}
- (void)setStyle:(NSString *)style {
    if (style) {
        self.themeLabel.text = @"充值车币";
        self.textField.placeholder = @"请输入要充值的金额";
    }
    _style = style;
}
- (void)setAccount:(NSString *)account {
    self.themeSubLabel.text = [NSString stringWithFormat:@"账户：%@车币",account];
    _account = account;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (kNotNil(_style)) {
        int money = [text intValue];
        self.moneyLabel.text = [NSString stringWithFormat:@"= %d车币",money*10];
        if (text.length == 1 && [text isEqualToString:@"0"]) {
            return NO;
        }
        if ([text containsString:@"."] == YES) {
            return NO;
        }
        if (textField.text.length > 8) {
            return NO;
        }
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textFieldBgV.mas_left).with.offset(5);
            make.centerY.mas_equalTo(self.textFieldBgV);
            make.height.mas_equalTo(self.textFieldBgV);
            make.width.mas_equalTo(80); make.right.mas_lessThanOrEqualTo(self.moneyLabel.mas_left).with.offset(1);
        }];
        [self.textField layoutIfNeeded];
        return YES;
    }else {
        int money = [text intValue];
        self.moneyLabel.text = [NSString stringWithFormat:@"= %d车币",money*100];
        
        if (text.length != 0) {
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.textFieldBgV.mas_left).with.offset(5);
                make.centerY.mas_equalTo(self.textFieldBgV);
                make.height.mas_equalTo(self.textFieldBgV);
                make.width.mas_equalTo(80); make.right.mas_lessThanOrEqualTo(self.moneyLabel.mas_left).with.offset(1);
            }];
            [self.textField layoutIfNeeded];
        }
        return YES;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    int money = [textField.text intValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%d",money*10];
}
- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    self.themeLabel = [UILabel new];
    self.themeLabel.text = @"兑换车币";
    self.themeLabel.textColor = [UIColor textBlackColor];
    self.themeLabel.font = [UIFont systemFontOfSize:18];
    [self.bgView addSubview:self.themeLabel];
    
    self.themeSubLabel = [UILabel new];
    self.themeSubLabel.text = @"账户：100车币";
    self.themeSubLabel.textColor = [UIColor shadeStartColor];
    self.themeSubLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:self.themeSubLabel];
    
    self.textFieldBgV = [UIView new];
    self.textFieldBgV.layer.borderColor = [UIColor lightColor].CGColor;
    self.textFieldBgV.layer.borderWidth = 1;
    self.textFieldBgV.layer.masksToBounds = YES;
    self.textFieldBgV.layer.cornerRadius = 5;
    self.textFieldBgV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.textFieldBgV];
    
    self.textField = [UITextField new];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = @"请输入要兑换的车票";
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.delegate = self;
    [self.textFieldBgV addSubview:self.textField];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"=  车币";
    self.moneyLabel.textColor = [UIColor shadeStartColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.textFieldBgV addSubview:self.moneyLabel];
    
    self.cancleBtn = [UIButton new];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn setBackgroundColor:[UIColor colorWithR:161 g:161 b:161]];
    [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.cancleBtn.layer.masksToBounds = YES;
    self.cancleBtn.layer.cornerRadius = 5;
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.cancleBtn];
    
    self.confirmBtn = [UIButton new];
    [self.confirmBtn setTitle:@"充值" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 5;
    [self.confirmBtn setBackgroundColor:[UIColor lightColor]];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.confirmBtn];
}

- (void)confirmBtnClick:(UIButton *)sender {
    if ([self.textField.text isEqualToString:@""]) return;
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(didConfirmWithMoney:)]) {
        [self.delegate didConfirmWithMoney:self.textField.text];
    }
}
- (void)cancleBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(200);
    }];
    
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(20);
        make.centerX.mas_equalTo(self.bgView);
    }];
    
    [self.themeSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.themeLabel.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.themeLabel.mas_centerX);
    }];
    
    [self.textFieldBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(25);
        make.right.mas_equalTo(self.bgView.mas_right).with.offset(-25);
        make.height.mas_equalTo(40);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textFieldBgV.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.textFieldBgV);
        make.height.mas_equalTo(self.textFieldBgV);
        make.width.mas_equalTo(130); make.right.mas_lessThanOrEqualTo(self.moneyLabel.mas_left).with.offset(1);
    }];

    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).with.offset(1);
        make.right.mas_equalTo(self.textFieldBgV.mas_right).with.offset(-5);
        make.centerY.mas_equalTo(self.textFieldBgV);
    }];

    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_centerX).with.offset(-5);
        make.top.mas_equalTo(self.textFieldBgV.mas_bottom).with.offset(20);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(40);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.mas_equalTo(self.cancleBtn);
        make.left.mas_equalTo(self.bgView.mas_centerX).with.offset(5);
    }];
}

@end
