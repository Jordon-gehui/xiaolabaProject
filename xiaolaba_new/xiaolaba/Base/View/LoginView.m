//
//  LoginView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/12/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LoginView.h"
#import "XLBLoginViewController.h"
#import "RootNavigationController.h"

@interface LoginView ()
{
    UIView *backView;
    UIView *lineLeftView;
    UIView *lineRightView;
    UILabel *titelLbl;
    UIButton *phoneBtn;
    UIButton *wechatBtn;
    UIButton *sinaBtn;
}
@end
@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    lineLeftView = [UIView new];
    [lineLeftView setBackgroundColor:[UIColor annotationTextColor]];
    [backView addSubview:lineLeftView];
    
    lineRightView = [UIView new];
    [lineRightView setBackgroundColor:[UIColor annotationTextColor]];
    [backView addSubview:lineRightView];
    
    titelLbl = [UILabel new];
    titelLbl.textColor = [UIColor minorTextColor];
    titelLbl.font = [UIFont systemFontOfSize:15];
    titelLbl.text = @"请用以下方式进行登录";
    [backView addSubview:titelLbl];
    
    phoneBtn =[UIButton new];
    [phoneBtn setImage:[UIImage imageNamed:@"icon_sj"] forState:0];
    phoneBtn.tag = 1;
    [phoneBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:phoneBtn];
    
    wechatBtn =[UIButton new];
    [wechatBtn setImage:[UIImage imageNamed:@"icon_wx"] forState:0];
    wechatBtn.tag = 2;
    [wechatBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:wechatBtn];
    
    sinaBtn =[UIButton new];
    [sinaBtn setImage:[UIImage imageNamed:@"icon_wb"] forState:0];
    sinaBtn.tag = 3;
    [sinaBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sinaBtn];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [wechatBtn setHidden:YES];
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        [sinaBtn setHidden:YES];
    }
    [self setLayout];
}
-(void)setLayout {
    [lineLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titelLbl);
        make.right.mas_equalTo(titelLbl.mas_left).with.offset(-10);
        make.left.mas_equalTo(backView).with.offset(30);
        make.height.mas_equalTo(0.5);
    }];
    [lineRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titelLbl);
        make.left.mas_equalTo(titelLbl.mas_right).with.offset(10);
        make.right.mas_equalTo(backView).with.offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [titelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(backView);
    }];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titelLbl.mas_bottom).with.offset(20);
        if (wechatBtn.isHidden&&sinaBtn.isHidden) {
            make.centerX.mas_equalTo(backView);
        }else{
            make.right.mas_equalTo(wechatBtn.mas_left).with.offset(-60*kiphone6_ScreenWidth);
        }
        make.width.height.mas_equalTo(50);
    }];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titelLbl.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(backView);
        make.width.height.mas_equalTo(50);
    }];
    [sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titelLbl.mas_bottom).with.offset(20);
        make.left.mas_equalTo(wechatBtn.mas_right).with.offset(60*kiphone6_ScreenWidth);
        make.width.height.mas_equalTo(50);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self);
        make.top.mas_equalTo(titelLbl).with.offset(-15);
        make.bottom.mas_equalTo(phoneBtn.mas_bottom).with.offset(20);
        make.bottom.mas_equalTo(self);
    }];
}
-(void)loginClick:(UIButton*)button {
    [self removeFromSuperview];
    XLBLoginViewController *loginVC = [[XLBLoginViewController alloc] init];
   
    switch (button.tag) {
        case 2://wechat
            [loginVC openWithController:[self topViewController] Withtag:2];

            break;
        case 3://sina
            [loginVC openWithController:[self topViewController] Withtag:3];
            break;
        default://手机
            [loginVC openWithController:[self topViewController] Withtag:1];
            break;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}
+(void)addLoginView {
    LoginView *login = [[LoginView alloc]init];
    UIWindow *topWindow = [[[UIApplication sharedApplication] delegate] window];
    [topWindow addSubview:login];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
