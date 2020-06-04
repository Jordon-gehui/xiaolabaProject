//
//  XLBNoticeViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/13.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBNoticeViewController.h"
#import "XLBTimingView.h"
#import "XLBChatViewController.h"
#import "AppDelegate.h"

@interface XLBNoticeViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIView *sendMsgButton;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *remindButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) XLBTimingView *timingView;

@end

@implementation XLBNoticeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.navigationController.navigationBar.alpha = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.naviBar setHidden:YES];
    UIImageView *bgimgeV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [bgimgeV setImage:[UIImage imageNamed:@"pic_banner"]];
    [self.view addSubview:bgimgeV];
    //添加毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = bgimgeV.bounds;
    [bgimgeV addSubview:effectView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"NSNotificationCenter" object:@"MoveCarOver"];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self performSelector:@selector(setup) withObject:nil afterDelay:0.3];
}

-(void)receiveNotificiation:(id)userinfo {
    //@{@"carId":carId,@"type":@"0"} // 0 展示 1重新提醒 2 完成挪车
    NSDictionary  *dic = [userinfo userInfo];

    if ([[dic objectForKey:@"type"] isEqualToString:@"2"]) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        self.navigationController.navigationBar.alpha = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([[dic objectForKey:@"type"] isEqualToString:@"1"]) {
        if(self.timingView) {
            [self.timingView startAnimation:900];
        }
    }else {
        if(self.timingView) {
            [self.timingView stopTime];
//            [self.timingView stopAnimation];
        }
    }
}

- (void)setup {
    if (self.timeDown <1) {
        self.timeDown = 900;
    }
    CGFloat width = kSCREEN_WIDTH * 0.4;
    
    self.timingView = [[XLBTimingView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH - width) / 2, (kSCREEN_HEIGHT-width-10)/2.0, width, width) time:self.timeDown];
    kWeakSelf(self)
    self.timingView.timeOverBlock = ^(NSInteger number) {
        [[NetWorking network] POST:KMoveCarDown params:@{@"userId":weakSelf.userId} cache:NO success:^(NSDictionary* result) {
            NSLog(@"------------------挪车倒计时结束 %@",result);
            if (kNotNil(result)) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showMoveOverViewWithMoveCarID:result[@"id"]];
            }
        } failure:^(NSString *description) {
            
        }];
        
    };
    [self.view addSubview:self.timingView];
    self.nameLabel.frame = CGRectMake(20, self.timingView.bottom+20, kSCREEN_WIDTH - 40, 100);
    
    self.cancleButton =[UIButton new];
    self.cancleButton.frame = CGRectMake(30, kSCREEN_HEIGHT-58-50, (kSCREEN_WIDTH-90)/2.0, 50);
    self.cancleButton.backgroundColor = [UIColor whiteColor];
    self.cancleButton.layer.cornerRadius = 5;
    self.cancleButton.layer.masksToBounds = YES;
    [self.cancleButton setTitleColor:[UIColor textBlackColor] forState:0];
    [self.cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleButton setTitle:@"取消" forState:0];
    [self.cancleButton setEnabled:YES];
    [self.view addSubview:self.cancleButton];
    
    self.remindButton =[UIButton new];
    self.remindButton.frame = CGRectMake(self.cancleButton.right+30, kSCREEN_HEIGHT-58-50, (kSCREEN_WIDTH-90)/2.0, 50);
    self.remindButton.backgroundColor = RGB(255, 222, 2);
    self.remindButton.layer.cornerRadius = 5;
    self.remindButton.layer.masksToBounds = YES;
    [self.remindButton setEnabled:YES];
    [self.remindButton addTarget:self action:@selector(remindButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.remindButton setTitleColor:[UIColor textBlackColor] forState:0];

    [self.remindButton setTitle:@"已完成挪车" forState:0];
    [self.view addSubview:self.remindButton];
    
//    NSString *name = @"余文乐";
    NSString *string = [NSString stringWithFormat:@"您已成功通知车主，请稍等..."];
    self.nameLabel.textColor =RGB(165, 165, 165);
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.text = string;
    
//    
    [self addSendMsgButton];

}

-(void)addSendMsgButton {
    self.sendMsgButton =[UIView new];
    self.sendMsgButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    self.sendMsgButton.layer.cornerRadius = 25;
    self.sendMsgButton.layer.masksToBounds = YES;
    [self.view addSubview:self.sendMsgButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMsgButtonClick)];
    [self.sendMsgButton addGestureRecognizer:tap];
    
    UILabel *label = [UILabel new];
    label.text = @"给车主发送消息";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [self.sendMsgButton addSubview:label];
    
    UIImageView *imageV = [UIImageView new];
    imageV.tintColor = [UIColor whiteColor];
    imageV.image =[[UIImage imageNamed:@"icon_wd_fh"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.sendMsgButton addSubview:imageV];
    
    kWeakSelf(self)
    [_sendMsgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(78);
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(50);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_sendMsgButton);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_sendMsgButton.mas_right).with.offset(-30);
        make.centerY.mas_equalTo(_sendMsgButton);
    }];
}

-(void) sendMsgButtonClick {
    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",_userId] conversationType:EMConversationTypeChat];
    chat.hidesBottomBarWhenPushed = YES;
    chat.nickname = _nickname;
    chat.avatar = _imgUrl;
    chat.userId = [NSString stringWithFormat:@"%@",_userId];
    chat.isMoveCar = YES;
    [self.navigationController pushViewController:chat animated:YES];
}

-(void)cancleButtonClick {
    if (self.isVerify) {
        NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
        
        for (UIViewController *owner in arr) {
            if ([owner isKindOfClass:[OwnerViewController class]]) {
                [self.naviBar setHidden:NO];
                [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
                [self.navigationController setNavigationBarHidden:NO];
                self.navigationController.navigationBar.alpha = 1;
                [self.navigationController popToViewController:owner animated:YES];
                continue;
            }
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)remindButtonClick { //完成挪车
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定已经完成挪车了么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==1) {
        [self showHudWithText:nil];
        kWeakSelf(self);
        [[NetWorking network] POST:KFinishMoveCar params:@{@"id":self.moveCarId} cache:NO success:^(NSDictionary* result) {
            NSLog(@"------------------我要挪车 %@",result);
            [weakSelf hideHud];
            if(self.timingView) {
                [self.timingView stopAnimation];
            }
            [self.naviBar setHidden:NO];
            [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
            [self.navigationController setNavigationBarHidden:NO];
            self.navigationController.navigationBar.alpha = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSString *description) {
            [weakSelf hideHud];
            [MBProgressHUD showError:description];
        }];
        
    }
}

- (UILabel *)nameLabel {
    
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationCenter" object:@"MoveCarOver"];
    if(self.timingView) {
        [self.timingView stopAnimation];
    }
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
