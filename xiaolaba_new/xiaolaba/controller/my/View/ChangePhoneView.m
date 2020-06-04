//
//  ChangePhoneView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/1.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "ChangePhoneView.h"


@interface ChangePhoneView() {
    NSTimer* _timer;
}

@property (nonatomic, retain) UIView *phoneV;
@property (nonatomic, retain) UILabel *phoneL;
@property (nonatomic, retain) UIView *centreLineV;

@property (nonatomic, retain) UIView *topLineV;

@property (nonatomic, retain) UIView *validV;

@property (nonatomic, retain) UILabel *validL;


@end

static int count = 0;

@implementation ChangePhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

-(void)initializer {
    _hintL = [UILabel new];
    _hintL.font = [UIFont systemFontOfSize:14.0];
    _hintL.textColor = [UIColor normalTextColor];
    _hintL.textAlignment = NSTextAlignmentCenter;
    _hintL.numberOfLines = 0;
    [self addSubview:_hintL];

    
    _phoneV = [UIView new];
    _phoneV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_phoneV];
    
    _phoneL = [UILabel new];
    _phoneL.textColor = [UIColor normalTextColor];
    _phoneL.font = [UIFont systemFontOfSize:14.0];
    _phoneL.text = @"新手机号";
    [self.phoneV addSubview:_phoneL];
    
    _phoneTextField = [UITextField new];
    _phoneTextField.textColor = [UIColor normalTextColor];
    _phoneTextField.font = [UIFont systemFontOfSize:14.0];
    _phoneTextField.placeholder = @"请输入新手机号";
    [self.phoneV addSubview:_phoneTextField];
    
    _centreLineV = [UIView new];
    _centreLineV.backgroundColor = [UIColor lineColor];
    [self addSubview:_centreLineV];
    
    _sendBtn = [UIButton new];
    [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_sendBtn setTitleColor:[UIColor clickTextColor] forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor clickTextColor] forState:UIControlStateHighlighted];
    [_sendBtn setTitleColor:[UIColor clickTextColor] forState:UIControlStateDisabled];
    _sendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _sendBtn.layer.borderWidth = 1.0;
    _sendBtn.clipsToBounds = YES;
    _sendBtn.layer.cornerRadius = 2.0;
    [self.phoneV addSubview:_sendBtn];
    
    _topLineV = [UIView new];
    _topLineV.backgroundColor = [UIColor lineColor];
    [self addSubview:_topLineV];
    
    _validV = [UIView new];
    _validV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_validV];
    
    _validL = [UILabel new];
    _validL.textColor = [UIColor normalTextColor];
    _validL.font = [UIFont systemFontOfSize:14.0];
    _validL.text = @"验证码";
    [self.validV addSubview:_validL];
    
    _validTextField = [UITextField new];
    _validTextField.textColor = [UIColor normalTextColor];
    _validTextField.font = [UIFont systemFontOfSize:14.0];
    _validTextField.placeholder = @"请输入验证码";
    [self.validV addSubview:_validTextField];
    
}

- (void) layoutSubviews {
    kWeakSelf(self);
    [_hintL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(weakSelf).with.offset(15);
        make.right.mas_equalTo(weakSelf).with.offset(-15);
    }];
    [_phoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.hintL.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@44);
    }];
    [_phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.phoneV);
        make.left.mas_equalTo(weakSelf.phoneV).with.offset(15);
    }];
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.phoneV);
        make.left.mas_equalTo(weakSelf.phoneL.mas_right).with.offset(15);
        //        make.right.mas_equalTo(weakSelf.sendBtn.mas_left).with.offset(-15);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.phoneV);
        make.width.mas_equalTo(@100);
        make.left.mas_greaterThanOrEqualTo(weakSelf.phoneTextField.mas_right).with.offset(15);
        make.right.mas_equalTo(weakSelf.phoneV).with.offset(-15);
    }];
    
    [_centreLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.phoneV);
        make.left.mas_equalTo(weakSelf.sendBtn).with.offset(-5);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@10);
    }];

    [_topLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.phoneV.mas_bottom);
        make.left.mas_equalTo(weakSelf).with.offset(15);
        make.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@1);
    }];
    [_validV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneV.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@44);
    }];
    [_validL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.validV);
        make.left.mas_equalTo(weakSelf.validV).with.offset(15);
    }];
    
    [_validTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.validV);
        make.left.mas_equalTo(weakSelf.phoneTextField);
    }];
}

- (void) startCountDown {
    if (!_timer) {
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
}

- (void)updateTime {
    count++;
    if (count>=60)
    {
        _sendBtn.enabled = YES;
        [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self stopTimer];
        count = 0;
        return;
    }
    _sendBtn.enabled = NO;
    [_sendBtn setTitle:[NSString stringWithFormat:@"%is", 60-count] forState:UIControlStateDisabled];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) dealloc {
    [self stopTimer];
}
@end
