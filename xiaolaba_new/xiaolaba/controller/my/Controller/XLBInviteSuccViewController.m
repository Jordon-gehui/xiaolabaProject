//
//  XLBInviteSuccViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/8.
//  Copyright © 2017年 jackzhang. All rights reserved.
//
#import "XLBVerificationCodeView.h"
#import "XLBInviteSuccViewController.h"

@interface XLBInviteSuccViewController ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIImageView *imgLine;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIButton *successBtn;
@property (nonatomic, strong) XLBVerificationCodeView *invitationCode;
@property (nonatomic, copy) NSString *passWord;

@end

@implementation XLBInviteSuccViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写邀请码";
    self.naviBar.slTitleLabel.text = @"填写邀请码";
    [self setSubViews];
}


- (void)successBtnClick:(UIButton *)sender {
    NSLog(@"%@",_passWord);
    if ([self.successBtn.backgroundColor isEqual:[UIColor lineColor]] || [[self.ucode lowercaseString] isEqualToString:[_passWord lowercaseString]] || !kNotNil(_passWord)) {
        [MBProgressHUD showError:@"邀请码错误"];
        return;
    }
    [[NetWorking network] POST:kInviteCode params:@{@"incode":_passWord,} cache:NO success:^(id result) {
        self.returnBlock(@"1");
        [self.successBtn setBackgroundColor:[UIColor lineColor]];
        [MBProgressHUD showSuccess:@"金币已存入您的账户"];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"邀请码错误"];
    }];
}

- (void)setSubViews {
    
    kWeakSelf(self);
    UIImageView *img = [UIImageView new];
    img.image = [UIImage imageNamed:@"bg_yqsr"];
    [self.view addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);

        make.left.right.bottom.mas_equalTo(self.view).with.offset(0);
    }];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10;
    [self.view addSubview:_bgView];
    
    _topLabel = [UILabel new];
    
    _topLabel.text = @"输入好友邀请码";
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
    
    _invitationCode = [[XLBVerificationCodeView alloc] initWithFrame:CGRectMake(0, self.imgLine.bottom + 28*kiphone6_ScreenHeight, 250*kiphone6_ScreenWidth, 50*kiphone6_ScreenHeight)];
    _invitationCode.passwordBlock = ^(NSString *password) {
        _passWord = password;
        if (password.length < 6) {
            [weakSelf.successBtn setBackgroundColor:[UIColor lineColor]];
        }else {
            UIColor *btnColor = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:weakSelf.successBtn.size]];
            [weakSelf.successBtn setBackgroundColor:btnColor];
        }
    };
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
    _successBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_successBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    _successBtn.adjustsImageWhenHighlighted = NO;
    _successBtn.backgroundColor = [UIColor lineColor];
    _successBtn.layer.masksToBounds = YES;
    _successBtn.layer.cornerRadius = 22;
    [_successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_successBtn];
    
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(10*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(293*kiphone6_ScreenWidth);
        if (iPhone5s) {
            make.height.mas_equalTo(350*kiphone6_ScreenHeight);
        }else {
            make.height.mas_equalTo(317*kiphone6_ScreenHeight);
        }
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
//        make.left.mas_equalTo(self.bgView.mas_left).with.offset(22*kiphone6_ScreenWidth);
//        make.right.mas_equalTo(self.bgView.mas_right).with.offset(-22*kiphone6_ScreenWidth);
        make.width.mas_equalTo(250*kiphone6_ScreenWidth);
        make.height.mas_equalTo(50*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(_bgView.mas_centerX).with.offset(0);
    }];
    
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.invitationCode.mas_bottom).with.offset(27*kiphone6_ScreenHeight);
        make.left.right.mas_equalTo(self.invitationCode);
        
    }];
    
    [_successBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindLabel.mas_bottom).with.offset(25*kiphone6_ScreenHeight);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(216*kiphone6_ScreenWidth);
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
