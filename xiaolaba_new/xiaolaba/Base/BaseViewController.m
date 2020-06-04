//
//  BaseViewController.m
//  IMMPapp
//
//  Created by jackzhang on 2017/7/3.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UINavigationControllerDelegate>

@property (nonatomic, retain) MBProgressHUD *hud;


@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [MobClick beginLogPageView:self.title];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    NSLog(@"%@==viewWillDisappear", NSStringFromClass([self class]));
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewBackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self initNaviBar];
}

- (SLNavigationBar *) naviBar {
    if (!_naviBar) {
        _naviBar.slTitleLabel.text = self.title;
        if (iPhoneX) {
            _naviBar = [[SLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 82)];
        }else
        _naviBar = [[SLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
        [self.view addSubview:_naviBar];
    }
    return _naviBar;
}


//导航栏
- (void)initNaviBar {
    
    if (self.translucentNav) {
        self.naviBar.backgroundColor = [UIColor whiteColor];
        self.naviBar.lineView.hidden = YES;
        self.naviBar.hidden = YES;
    } else {
        self.naviBar.naviBgColor = [UIColor whiteColor];
        self.naviBar.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.naviBar.lineView.hidden = NO;
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        // 左侧返回按钮
        UIButton *leftNavItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        leftNavItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftNavItem setImage:[UIImage imageNamed:@"icon_fh_z"] forState:UIControlStateNormal];
        [leftNavItem addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviBar setLeftItem:leftNavItem];
    }
}

-(void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (MBProgressHUD *) hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;
}

- (void) showHudWithText:(NSString *)text {
    
    [self.view addSubview:self.hud];
    [_hud show:YES];
    _hud.detailsLabelText = text;
}

- (void) hideHud {
    [_hud removeFromSuperview];
    _hud = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
