//
//  BQLCodeButton.m
//  BQLDemo
//
//  Created by hao 好享购 on 16/7/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "BQLCodeButton.h"
#import "masonry.h"
#import "UIColor+Utils.h"

// 默认获取验证码按钮背景颜色
#define CODEBACKGROUNDCOLORNORMAL RGB(255, 255, 255)
// 发送中获取验证码按钮背景颜色
#define CODEBACKGROUNDCOLORSENDDING  RGB(255, 255, 255)
// 默认获取验证码按钮文字颜色
#define CODETITLECOLOR [UIColor emphasizeTextColor]
// 默认获取验证码按钮文字
#define CODETITLE (iPhone5s ? @"验证码":@"获取验证码")

@interface BQLCodeButton ()
{
    dispatch_source_t _timer;
}
/**
 *  发送验证码按钮
 */
@property (nonatomic, strong) UIButton *sendCodeButton;

@end

@implementation BQLCodeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        [self initCodeButton];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self initCodeButton];
}

- (void)initCodeButton {
    
    //self.layer.cornerRadius = 3;
    //self.layer.borderWidth = 0.7f;
//    self.layer.borderColor = [UIColor colorWithRed:(51)/255.0 green:(147)/255.0 blue:(239)/255.0 alpha:1.0].CGColor;
//    self.backgroundColor = CODEBACKGROUNDCOLORNORMAL;
    //self.sendCodeButton = [[UIButton alloc] initWithFrame:self.bounds];
    self.sendCodeButton = [[UIButton alloc] init];
    self.sendCodeButton.layer.masksToBounds = YES;
    self.sendCodeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sendCodeButton.layer.borderWidth = 0.7;
    self.sendCodeButton.layer.cornerRadius = 5;
    [self addSubview:self.sendCodeButton];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.sendCodeButton.backgroundColor = [UIColor clearColor];
    [self.sendCodeButton setTitle:CODETITLE forState:0];
    [self.sendCodeButton setTitleColor:[UIColor whiteColor] forState:0];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.sendCodeButton addTarget:self action:@selector(sendCodeClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendCodeClick:(UIButton *)sender {
    
    __block int timeout=60; //倒计时时间-----这里如果是三位数看下面
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            [self closeTimer];
        }
        else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds]; //----- 要对应位数
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
//                self.backgroundColor = CODEBACKGROUNDCOLORSENDDING;
                self.sendCodeButton.backgroundColor = [UIColor clearColor];

                //[self.sendCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self.sendCodeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    if([self.delegate respondsToSelector:@selector(sendCode)]) {
        [self.delegate sendCode];
    }
}

// 关闭计时器
- (void)closeTimer
{
    // 关闭计时
    if(_timer) {
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置界面的按钮显示 根据自己需求设置
            //[self.getCode setBackgroundColor:SPDefaultButtonColor forState:UIControlStateNormal];
//            self.backgroundColor = CODEBACKGROUNDCOLORNORMAL;
            self.backgroundColor = [UIColor clearColor];
            [self.sendCodeButton setTitle:CODETITLE forState:UIControlStateNormal];
            self.sendCodeButton.userInteractionEnabled = YES;
        });
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
