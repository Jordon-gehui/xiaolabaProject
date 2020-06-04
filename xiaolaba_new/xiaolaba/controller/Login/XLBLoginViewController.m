//
//  XLBLoginViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/11.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBLoginViewController.h"
#import "BQLCodeButton.h"
#import "BQLAuthEngine.h"
#import "NetWorking.h"
#import "XLBUser.h"

#import "XLBCompleteViewController.h"
#import "RootTabbarController.h"
#import "XLBEaseMobManager.h"
#import "BaseWebViewController.h"
#import "XLBMeRequestModel.h"
#import "FindViewController.h"
#import "LRFourPingTransition.h"

@interface XLBLoginViewController () <BQLCodeButtonDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,clickDegate>
{
    BOOL isNormal; // 是否为普通登陆页面
    NSString *navTitle;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelContant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weChatCenter;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;
@property (weak, nonatomic) IBOutlet BQLCodeButton *codeButton;
@property (weak, nonatomic) IBOutlet UIView *line_one;
@property (weak, nonatomic) IBOutlet UIView *line_two;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) LRButton *loginView;
@property (nonatomic, strong) NSMutableArray *distrubGroupList;
@property (nonatomic, strong) NSMutableArray *stickGroupList;

// 第二套页面
@property (weak, nonatomic) IBOutlet UILabel *label_one;
@property (weak, nonatomic) IBOutlet UIButton *label_two;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaButton;

@property (nonatomic, strong) UIButton *leftItem;

@property (nonatomic) BOOL phoneIsValid;
@property (nonatomic) BOOL codeIsValid;

@end
#define phone_tag 999
#define code_tag 888
@implementation XLBLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.view endEditing:YES];
    [[NetWorking network] alertRemove];

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"屏幕高度%f",[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height <= 568) {
        _topLabelContant.constant = 48;
    }else {
        _topLabelContant.constant = 88;
    }
}
- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];


    // 基本配置
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    [self setup];
    [self setupSubViews];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(afterDelayDismiss) name:@"complete" object:nil];
}

- (void)leftClick {
    if ([self.type isEqualToString:@"0"]) {
        if (self.returnBlock) self.returnBlock(nil);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setup {
    navTitle = [self selfTitle];
//    self.title = [self selfTitle];
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.phoneTextfield setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTextfield setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.phoneTextfield.tintColor = [UIColor whiteColor];

    self.phoneTextfield.delegate = self;
//    self.phoneTextfield.clearButtonMode=UITextFieldViewModeAlways;
    self.phoneTextfield.tag = phone_tag;
    [self.phoneTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.codeTextfield setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTextfield setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.codeTextfield.tintColor = [UIColor whiteColor];
    self.codeTextfield.delegate = self;
    self.codeTextfield.tag = code_tag;
//    self.codeTextfield.clearButtonMode=UITextFieldViewModeAlways;
    [self.codeTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.codeButton.delegate = self;
    self.loginButton.userInteractionEnabled = NO;
//    [self.loginButton setHidden:YES];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 5;
    if(kNotNil(self.type)) {
        if([self.type integerValue] == 0) {
            [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
            [self.leftItem setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        }else {
            [self.loginButton setTitle:@"绑定" forState:UIControlStateNormal];
            [self.leftItem setImage:[UIImage imageNamed:@"icon_fh_z"] forState:UIControlStateNormal];
            [self.leftItem mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(30);
            }];
        }
    }
    
//    [self addLoginView];
}
-(void)addLoginView
{
    if (self.loginView) {
        [self.loginView removeFromSuperview];
        self.loginView = nil;
    }
    self.loginView = [[LRButton alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-80, 44)];
    [self.view addSubview:self.loginView];
    [self.loginView setDelegate:self];
    if (self.phoneTextfield.text.length > 10&&self.codeTextfield.text.length ==6) {
        UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH - 80, 44)]];
        self.loginView.backgroundColor = RGB(46, 48, 51);
        [self.loginView setButtonTitleColor:[UIColor whiteColor]];
        [self.loginView setUserInteractionEnabled:YES];
    }else{
        self.loginView.backgroundColor = RGB(194, 194, 194);
        [self.loginView setButtonTitleColor:[UIColor whiteColor]];
        [self.loginView setUserInteractionEnabled:NO];

    }
    
    self.loginView.layer.cornerRadius = 5;
    self.loginView.layer.masksToBounds = YES;
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_top);
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.height.mas_equalTo(48);
    }];
    if(kNotNil(self.type)) {
        if([self.type integerValue] == 0) {
            [self.loginView setButtonTitle:@"登录"];
        }else {
            [self.loginView setButtonTitle:@"绑定"];
        }
    }
}
#pragma mark - LRButtonDelegate
-(void)clickDegate:(LRButton *)lr {
    [self loginClick:nil];
    [self addLoginView];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == phone_tag) {
        if (textField.text.length > 10&&self.codeTextfield.text.length ==6) {
//            UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH - 80, 44)]];
            self.loginButton.backgroundColor = RGB(46, 48, 51);
            [self.loginButton setUserInteractionEnabled:YES];
//            self.loginView.backgroundColor = RGB(46, 48, 51);
//            [self.loginView setButtonTitleColor:[UIColor whiteColor]];
//            [self.loginView setUserInteractionEnabled:YES];
        }else{
//            self.loginView.backgroundColor = RGB(194, 194, 194);
//            [self.loginView setButtonTitleColor:[UIColor whiteColor]];
//            [self.loginView setUserInteractionEnabled:NO];
            self.loginButton.backgroundColor = RGB(194, 194, 194);
            [self.loginButton setUserInteractionEnabled:NO];
        }
    }else{
        if (textField.text.length >5&&self.phoneTextfield.text.length ==13) {
//            UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH - 80, 44)]];
            
            self.loginButton.backgroundColor = RGB(46, 48, 51);
            [self.loginButton setUserInteractionEnabled:YES];
//            self.loginView.backgroundColor = RGB(46, 48, 51);
//            [self.loginView setButtonTitleColor:[UIColor whiteColor]];
//            [self.loginView setUserInteractionEnabled:YES];2
        }else{
            
            self.loginButton.backgroundColor = RGB(194, 194, 194);
            [self.loginButton setUserInteractionEnabled:NO];
//            self.loginView.backgroundColor = RGB(194, 194, 194);
//            [self.loginView setButtonTitleColor:[UIColor whiteColor]];
//            [self.loginView setUserInteractionEnabled:NO];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == phone_tag) {
        if (range.location == 0 && string.length == 0) {
            self.removeBtn.hidden = YES;
        }else {
            self.removeBtn.hidden = NO;
        }
        return [textField valueChangeValueString:string shouldChangeCharactersInRange:range];
    }else {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
        return YES;
    }
    
//    if (textField.tag == phone_tag) {
//        if (range.location == 0 && string.length == 0) {
//            self.removeBtn.hidden = YES;
//        }else {
//            self.removeBtn.hidden = NO;
//        }
//
//    }
//    if (string.length == 0) return YES;
//    NSInteger existedLength = textField.text.length;
//    NSInteger selectedLength = range.length;
//    NSInteger replaceLength = string.length;
//    if (existedLength - selectedLength + replaceLength > (textField.tag == phone_tag ? 11:6)) {
//        return NO;
//    }
//    return YES;
}

// 发送验证码
- (void)sendCode {
    NSString *phoneString = [self.phoneTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(phoneString.length == 11) {
        if (![phoneString isValidMobileNumber]) {
            [MBProgressHUD showError:@"请输入正确的手机号"];
            [self.codeButton closeTimer];
            return;
        }
        
        [self showHudWithText:nil];
        [[NetWorking network] POST:kLoginCode params:@{@"phoneNumber":phoneString} cache:NO success:^(id result) {
            [self hideHud];
            [MBProgressHUD showError:@"验证码发送成功"];
        } failure:^(NSString *description) {
            [self hideHud];
            [MBProgressHUD showError:@"验证码发送失败"];

        }];
    }
    else {
        [self.codeButton closeTimer];
        [MBProgressHUD showError:@"请填写正确手机号"];

    }
}


- (IBAction)removeBtnClick:(id)sender {
    self.removeBtn.hidden = YES;
    [self.phoneTextfield setText:@""];
}

- (IBAction)loginClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *phoneString = [self.phoneTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![phoneString isValidMobileNumber]&&![phoneString hasPrefix:@"601"]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [self showHudWithText:@"正在登录……"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneString forKey:@"phoneNumber"];
    [params setObject:self.codeTextfield.text forKey:@"verifyCode"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [params setObject:app_Version forKey:@"appVersion"];
    [params setObject:[XLBUser user].deviceNo forKey:@"deviceNo"];
    [params setObject:[UIDeviceHardware platformString] forKey:@"deviceType"];
    [params setObject:osVersion() forKey:@"osVersion"];
    [params setObject:[XLBUser user].longitude forKey:@"longitude"];
    [params setObject:[XLBUser user].latitude forKey:@"latitude"];
    [params setObject:[XLBUser user].country forKey:@"country"];
    [params setObject:[XLBUser user].province forKey:@"province"];
    [params setObject:[XLBUser user].city forKey:@"city"];
    [params setObject:[XLBUser user].subLocality forKey:@"district"];
    [params setObject:@(0) forKey:@"pushType"];
    if(!isNormal) {
        if ([_isSina isEqualToString:@"1"]) {
            [params setObject:[XLBUser user].weiboId forKey:@"weiboId"];
        }else {
            [params setObject:[XLBUser user].weixinId forKey:@"weixinId"];
        }
    }
    if (![_type isEqualToString:@"1"]) {
        [[XLBUser user] setIsWeChatLogin:NO];
    }
    kWeakSelf(self);
    [[NetWorking network] POST:kLogin params:params cache:NO success:^(id result) {
        
        [weakSelf hideHud];
        [weakSelf setupPush:result];
        NSString *status = [NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
        if (![status isEqualToString:@"-1"]) {
            [weakSelf requestStick];
        }
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"验证码错误"];
    }];
}

- (IBAction)weChatClick:(UIButton *)sender {
    
    kWeakSelf(self);
    [self showHudWithText:@"正在登录……"];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_login:^(id response) {
        
        [[XLBUser user] setupThirdData:response weChat:YES];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(0) forKey:@"pushType"];
        [params setObject:[UIDeviceHardware platformString] forKey:@"deviceType"];
        [params setObject:osVersion() forKey:@"osVersion"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [params setObject:app_Version forKey:@"appVersion"];
        [params setObject:[XLBUser user].deviceNo forKey:@"deviceNo"];
        [params setObject:[XLBUser user].longitude forKey:@"longitude"];
        [params setObject:[XLBUser user].latitude forKey:@"latitude"];
        [params setObject:[XLBUser user].weixinId forKey:@"weixinId"];
        [params setObject:[XLBUser user].openId forKey:@"openId"];
        [params setObject:[XLBUser user].country forKey:@"country"];
        [params setObject:[XLBUser user].province forKey:@"province"];
        [params setObject:[XLBUser user].city forKey:@"city"];
        [params setObject:[XLBUser user].subLocality forKey:@"district"];
        
        [[XLBUser user] setIsWeChatLogin:YES];
        [[NetWorking network] POST:kSpeedy params:params cache:NO success:^(id result) {
            
            [weakSelf hideHud];
            _isSina = @"0";
            [weakSelf setupPush:result];
            NSString *status = [NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
            if (![status isEqualToString:@"-1"]) {
                [weakSelf requestStick];
            }
        } failure:^(NSString *description) {
            
            [weakSelf hideHud];
            [MBProgressHUD showError:@"出错了，请稍后重试"];
            
        }];
        
    } failure:^(NSString *error) {
        
        [weakSelf hideHud];
        [MBProgressHUD showError:error];
    }];
    
}

- (void)setupPush:(id )response {
    
    // 登陆环信
    NSString *username = [NSString stringWithFormat:@"%@",[response objectForKey:@"username"]];
    NSString *password = [NSString stringWithFormat:@"%@",[response objectForKey:@"password"]];
    [[XLBUser user] storeEmUser:username passwprd:password];
    [XLBEaseMobManager xlbLoginEaseMob:^(NSError *error) {
        if(!error) {
            NSLog(@"环信登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
        else {
            NSLog(@"环信登录失败");
        }
    }];
    /*
    [[EMClient sharedClient] loginWithUsername:username
                                      password:password
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        if (!aError) {
                                            NSLog(@"登录成功");
                                        } else {
                                            NSLog(@"登录失败");
                                        }
                                    }];
    */
    
    [XLBUser user].isLogin = YES;
    [XLBUser user].token = [response objectForKey:@"token"];
    // 0 -> 完善信息  -1 -> 绑定手机号 other -> 首页
    NSInteger status = [[response objectForKey:@"status"] integerValue];
    if(status == -1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CSRouter share]push:@"XLBLoginViewController" Params:@{@"type":@"1",@"isSina":_isSina} hideBar:YES];
        });
    }else if (status == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CSRouter share]push:@"XLBCompleteViewController" Params:nil hideBar:YES];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.returnBlock)
                self.returnBlock(@"1");
            [XLBMeRequestModel requestInfo:^(XLBUser *user) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:_isFind];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    RootTabbarController *tab = [RootTabbarController sharedRootBar];
                    [RootTabbarController transformRootControllerFrom:self to:tab];
                });
            } failure:^(NSString *error) {
            }];
//            dispatch_queue_t group = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_async(group, ^{
//                
//            });
        });
    }
}
-(void)afterDelayDismiss {
    if ([navTitle isEqualToString:@"登录"]) {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.3];

    }
}
-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)sinaClick:(UIButton *)sender {
    kWeakSelf(self);
    [self showHudWithText:@"正在登录……"];
    [[BQLAuthEngine sharedAuthEngine] auth_sina_login:^(id response) {
        NSLog(@"%@",response);
        NSMutableDictionary *responeDic = [NSMutableDictionary dictionary];
        if (kNotNil(response) && kNotNil(response[@"avatar_large"]) && kNotNil(response[@"screen_name"]) && kNotNil(response[@"id"])) {
            [responeDic setObject:response[@"avatar_large"] forKey:@"headimgurl"];
            [responeDic setObject:response[@"screen_name"] forKey:@"nickname"];
            [responeDic setObject:response[@"id"] forKey:@"weiboUid"];
            if ([response[@"gender"] isEqualToString:@"m"]) {
                [responeDic setObject:@"0" forKey:@"sex"];
            }
            if ([response[@"gender"] isEqualToString:@"f"]) {
                [responeDic setObject:@"1" forKey:@"sex"];
            }
        }
        [[XLBUser user] setupThirdData:responeDic weChat:nil];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(0) forKey:@"pushType"];
        [params setObject:[UIDeviceHardware platformString] forKey:@"deviceType"];
        [params setObject:osVersion() forKey:@"osVersion"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [params setObject:app_Version forKey:@"appVersion"];
        [params setObject:[XLBUser user].deviceNo forKey:@"deviceNo"];
        [params setObject:[XLBUser user].longitude forKey:@"longitude"];
        [params setObject:[XLBUser user].latitude forKey:@"latitude"];
        [params setObject:[XLBUser user].weiboId forKey:@"weiboId"];
        [params setObject:[XLBUser user].country forKey:@"country"];
        [params setObject:[XLBUser user].province forKey:@"province"];
        [params setObject:[XLBUser user].city forKey:@"city"];
        [params setObject:[XLBUser user].subLocality forKey:@"district"];
        
        [[XLBUser user] setIsWeChatLogin:YES];
        [[NetWorking network] POST:kSpeedy params:params cache:NO success:^(id result) {
            NSLog(@"%@",params);
            [weakSelf hideHud];
            _isSina = @"1";
            [weakSelf setupPush:result];
            NSString *status = [NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
            if (![status isEqualToString:@"-1"]) {
                [weakSelf requestStick];
            }
        } failure:^(NSString *description) {
            
            [weakSelf hideHud];
            [MBProgressHUD showError:@"出错了，请稍后重试"];
            
        }];
    } failure:^(NSString *error) {
        [weakSelf hideHud];
        [MBProgressHUD showError:error];
    }];
    
}

- (IBAction)protocolClick:(UIButton *)sender {
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.urlStr = [NSString stringWithFormat:@"%@agreement",kDomainUrl];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)setupSubViews {
    
    self.removeBtn.hidden = YES;
    self.label_one.hidden = !isNormal;
    self.label_two.hidden = !isNormal;
//    self.label_three.hidden = !isNormal;
//    self.line_three.hidden = !isNormal;
//    self.line_four.hidden = !isNormal;
    self.wechatBtn.hidden = !isNormal;
    self.sinaButton.hidden = !isNormal;
    if (isNormal == YES) {
        if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
            [_wechatBtn setHidden:YES];
            [_sinaButton setHidden:YES];
        }else {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
                [_wechatBtn setHidden:YES];
                self.sinaCenter.constant = 0;
            }
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
                [_sinaButton setHidden:YES];
                self.weChatCenter.constant = 0;
            }
        }
    }
    
    if(iPhone5s) {
        [self.codeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(65);
        }];
    }
    
    if(!isNormal) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            [self.phoneTextfield becomeFirstResponder];
        });
    }
}
- (void)requestStick {
    [self.distrubGroupList removeAllObjects];
    [self.stickGroupList removeAllObjects];
    [[NetWorking network] POST:kSearchDistrub params:nil cache:NO success:^(id result) {
        NSLog(@"免打扰%@",result);
        NSMutableArray <NSDictionary *>*distrubArr = (NSMutableArray *)result;
        NSMutableArray *distrub = [NSMutableArray array];
        [distrubArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [distrub addObject:obj[@"groupHuanxin"]];
        }];
        [self.distrubGroupList addObjectsFromArray:distrub];
        [[XLBCache cache] store:self.distrubGroupList key:@"distrubGroupList"];
    } failure:^(NSString *description) {
        
    }];
    [[NetWorking network] POST:kSearchOver params:nil cache:NO success:^(id result) {
        NSLog(@"置顶%@",result);
        NSMutableArray <NSDictionary *>*stickModelArr = (NSMutableArray *)result;
        NSMutableArray *stickArr = [NSMutableArray array];
        [stickModelArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [stickArr addObject:obj[@"groupHuanxin"]];
        }];
        [self.stickGroupList addObjectsFromArray:stickArr];
        [[XLBCache cache] store:self.stickGroupList key:@"stickGroupList"];
    } failure:^(NSString *description) {
    }];
}
- (NSString *)selfTitle {
    
    NSString *title = @"登录";
    isNormal = YES;
    if(kNotNil(self.type)) {
        if([self.type integerValue] == 0) {
            title = @"登录";
//            [self.loginView setButtonTitle:@"登录"];
            isNormal = YES;
        }
        else {
            title = @"绑定手机号";
//            [self.loginView setButtonTitle:@"绑定"];
            self.topLabel.text = @"绑定小喇叭";
            isNormal = NO;
            
        }
    }
    return title;
}

NSString *osVersion() {
    
    UIDevice *device = [UIDevice currentDevice];
    return device.systemVersion;
}

- (XLBLoginViewController *) openWithController:(UIViewController *)vc Withtag:(NSInteger)tag {
    XLBLoginViewController *loginVC = [[XLBLoginViewController alloc] init];
    RootNavigationController *naviController = [[RootNavigationController alloc] initWithRootViewController:loginVC];
    naviController.transitioningDelegate = self;
//    loginVC.title = @"登录";
    loginVC.type = @"0";
    [vc presentViewController:naviController animated:YES completion:nil];
    if (tag ==2) {
        [loginVC weChatClick:nil];
        loginVC.type = @"1";
    }else if (tag ==3) {
        [loginVC sinaClick:nil];
        loginVC.type = @"1";
    }
    if ([vc isKindOfClass:[FindViewController class]]) {
        loginVC.isFind = @"1";
    }else {
        loginVC.isFind = @"0";
    }
    return loginVC;
}
- (XLBLoginViewController *) openWithController:(UIViewController *)vc returnBlock:(RetrunBlock) returnBlock {
    XLBLoginViewController *loginVC = [[XLBLoginViewController alloc] init];
    RootNavigationController *naviController = [[RootNavigationController alloc] initWithRootViewController:loginVC];
    naviController.transitioningDelegate = self;
    [vc presentViewController:naviController animated:YES completion:nil];
    loginVC.returnBlock = returnBlock;
    loginVC.type = @"0";
//    loginVC.title = @"登录";
    return loginVC;
}

- (UIButton *)leftItem {
    if (!_leftItem) {
        _leftItem = [UIButton new];
        [_leftItem addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_leftItem];
        
        [_leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(20);
        }];
    }
    
    return _leftItem;
}
- (NSMutableArray *)distrubGroupList {
    if (!_distrubGroupList) {
        _distrubGroupList = [NSMutableArray array];
    }
    return _distrubGroupList;
}
- (NSMutableArray *)stickGroupList {
    if (!_stickGroupList) {
        _stickGroupList = [NSMutableArray array];
    }
    return _stickGroupList;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"complete" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [LRFourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [LRFourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
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
