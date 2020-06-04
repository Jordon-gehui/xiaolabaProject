//
//  XLBInviteSuccessViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteSuccessViewController.h"
#import "InviteView.h"

@interface XLBInviteSuccessViewController ()<InviteViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIImageView *imgLine;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIButton *successBtn;
@property (nonatomic, strong) InviteView *invitationCode;
@end

@implementation XLBInviteSuccessViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _invitationCode.keyBoard = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    [self setSubViews];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
//
//- (void)keyboardDidShow:(NSNotification *)notification{
//    UIView *keyboardView = [self getKeyBoard];
//    keyboardView.subviews[0].backgroundColor = [UIColor redColor];
//}
//
//- (UIView *)getKeyBoard
//{
//
//    UIView *keyBoardView = nil;
//
//    NSArray *windows = [[UIApplication sharedApplication] windows];
//
//    for (UIWindow*window in [windows reverseObjectEnumerator])
//    {
//        keyBoardView = [self getKeyBoardInView:window];
//        if (keyBoardView)
//        {
//            return keyBoardView;
//        }
//    }
//
//    return nil;
//}
//
//- (UIView *)getKeyBoardInView:(UIView *)view
//{
//
//    for(UIView *subView in [view subviews])
//    {
//        if (strstr(object_getClassName(subView), "UIKeyboard"))
//        {
//            return subView;
//        }else{
//
//            UIView *tempView = [self getKeyBoardInView:subView];
//
//            if (tempView)
//            {
//                return tempView;
//            }
//        }
//    }
//
//    return nil;
//
//}

- (void)successBtnClick:(UIButton *)sender {
    NSLog(@"%@",_invitationCode.passText);
}


- (void)setSubViews {
    
    UIImageView *img = [UIImageView new];
    img.image = [UIImage imageNamed:@"bg_yqsr"];
    [self.view addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(22);
        }else {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);
        }
        make.left.right.bottom.mas_equalTo(self.view).with.offset(0);
    }];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10;
    [self.view addSubview:_bgView];
    
    _topLabel = [UILabel new];
    
    _topLabel.text = @"输入您的好友给的邀请码";
    _topLabel.font = [UIFont systemFontOfSize:20];
    _topLabel.textColor = [UIColor commonTextColor];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_topLabel];
    
    _imgLine = [UIImageView new];
    _imgLine.image = [UIImage imageNamed:@"pic_fgx_l"];
    [_bgView addSubview:_imgLine];
    
    UILabel *leftSemicircle = [UILabel new];
    leftSemicircle.backgroundColor = [UIColor lightColor];
    leftSemicircle.layer.masksToBounds = YES;
    leftSemicircle.layer.cornerRadius = 10;
    [_bgView addSubview:leftSemicircle];
    
    UILabel *rigthSemicircle = [UILabel new];
    rigthSemicircle.backgroundColor = [UIColor lightColor];
    rigthSemicircle.layer.masksToBounds = YES;
    rigthSemicircle.layer.cornerRadius = 10;
    [_bgView addSubview:rigthSemicircle];
    
    _invitationCode = [InviteView new];
    [_bgView addSubview:_invitationCode];
    
    _remindLabel = [UILabel new];
    _remindLabel.numberOfLines = 0;
    _remindLabel.text = @"输入成功后，您和您的好友将获得车币加成，并有可能帮助您的好友获得奖品";
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    _remindLabel.font = [UIFont systemFontOfSize:13];
    _remindLabel.textColor = [UIColor commonTextColor];
    [_bgView addSubview:_remindLabel];
    
    _successBtn = [UIButton new];
    [_successBtn setTitle:@"输入完成" forState:UIControlStateNormal];
    [_successBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    _successBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_successBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    _successBtn.adjustsImageWhenHighlighted = NO;
    [_successBtn setBackgroundImage:[UIImage imageNamed:@"btn_srwc"] forState:UIControlStateNormal];
    [_successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_successBtn];
    
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(82*kiphone6_ScreenHeight);
        }else {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(10*kiphone6_ScreenHeight);
        }
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(293*kiphone6_ScreenWidth);
        make.height.mas_equalTo(317*kiphone6_ScreenHeight);
//        if (iPhone5s) {
//            make.height.mas_equalTo(350*kiphone6_ScreenHeight);
//        }else {
//
//        }
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(22*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(18*kiphone6_ScreenHeight);
    }];
    
    [_imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(30*kiphone6_ScreenHeight);
        make.left.mas_equalTo(leftSemicircle.mas_right).with.offset(5);
        make.right.mas_equalTo(rigthSemicircle.mas_left).with.offset(-5);
        make.height.mas_equalTo(1);
    }];
    
    [leftSemicircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(self.imgLine.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(20);
    }];
    
    [rigthSemicircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).with.offset(10);
        make.width.height.mas_equalTo(leftSemicircle);
        make.centerY.mas_equalTo(self.imgLine.mas_centerY).with.offset(0);
        
    }];
    
    
    [_invitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgLine.mas_bottom).with.offset(28*kiphone6_ScreenHeight);
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(22*kiphone6_ScreenWidth);
        make.right.mas_equalTo(self.bgView.mas_right).with.offset(-22*kiphone6_ScreenWidth);
        make.height.mas_equalTo(50*kiphone6_ScreenHeight);
    }];
    
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.invitationCode.mas_bottom).with.offset(27*kiphone6_ScreenHeight);
        make.left.right.mas_equalTo(self.invitationCode);
        
    }];
    
    [_successBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindLabel.mas_bottom).with.offset(25*kiphone6_ScreenHeight);
//        make.height.mas_equalTo(55*kiphone6_ScreenHeight);
//        make.width.mas_equalTo(216*kiphone6_ScreenWidth);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
