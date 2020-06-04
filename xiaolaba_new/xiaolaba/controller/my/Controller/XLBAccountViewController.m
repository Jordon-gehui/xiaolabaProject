//
//  XLBAccountViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBAccountViewController.h"
#import "BQLCodeButton.h"
#import "BQLAuthEngine.h"
#import "NetWorking.h"
#import "XLBUser.h"

#import "XLBCompleteViewController.h"
#import "RootTabbarController.h"
#import "XLBEaseMobManager.h"
#import "XLBAlterPhoneViewController.h"
#import "XLBAlertController.h"

@interface XLBAccountViewController ()
{
    BOOL isForbid;//微信绑定
    BOOL isSina; //新浪绑定
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telephoneTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaTop;

@property (weak, nonatomic) IBOutlet UIView *weChatBgV;
@property (weak, nonatomic) IBOutlet UIView *weiboBgV;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation XLBAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账户信息";
    self.naviBar.slTitleLabel.text = @"账户信息";
    [self setup];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.telephoneTop.constant = iPhoneX ? 98:74;

    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        self.weChatBgV.hidden = YES;
        self.sinaTop.constant = 10;
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        self.weiboBgV.hidden = YES;
    }
}
- (void)setup {
    
    XLBUser *user = [XLBUser user];
    self.phone = user.userModel.phone;
    self.phoneLabel.text = self.phone;
    self.logo.hidden = !(user.userModel.phone.length > 0);

    self.weChatLabel.textColor = [user.userModel.weixinId boolValue] ? [UIColor lightColor]:RGB(169, 169, 169);
    self.weChatLabel.text = [user.userModel.weixinId boolValue] ? @"已绑定":@"未绑定";

    self.weiboLabel.textColor = [user.userModel.weiboId boolValue] ? [UIColor lightColor]:RGB(169, 169, 169);
    self.weiboLabel.text = [user.userModel.weiboId boolValue] ? @"已绑定":@"未绑定";
    isForbid = [user.userModel.weixinId boolValue];
    isSina = [user.userModel.weiboId boolValue];
}

- (IBAction)phoneModifyClick:(id)sender {
    XLBAlterPhoneViewController *alterPhoneVC = [XLBAlterPhoneViewController new];
    alterPhoneVC.telePhone = self.phone;
    alterPhoneVC.block = ^(id telePhone) {
        NSLog(@"%@",telePhone);
        self.phone = [telePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneLabel.text = [telePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    };
    [self.navigationController pushViewController:alterPhoneVC animated:YES];
//    [[CSRouter share]push:@"XLBAlterPhoneViewController" Params:nil hideBar:YES];
}

- (IBAction)weChatModifyClick:(id)sender {

//    if (isForbid == YES) {
//        [self weChatIsForbid:YES];
//    }
//    if (isForbid == NO) {
//        [self weChatIsForbid:NO];
//    }
    [self weChatIsForbid:isForbid];
}



- (IBAction)weiboModifyClick:(id)sender {
//    [MBProgressHUD showError:@"暂不支持微博绑定"];
    [self sinaIsForbid:isSina];
}

- (void)weChatIsForbid:(BOOL) forbid {
    kWeakSelf(self);

    if (isForbid == YES) {
//        UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"确定"] title:@"是否解除绑定？" message:nil cancel:YES cancelBlock:^{
//
//        } itemBlock:^(NSUInteger index) {
//            if (index == 0) {
//
//            }
//        }];
//        [self presentViewController:alert animated:YES completion:nil];

        UIAlertController *aler1 = [UIAlertController alertControllerWithTitle:@"是否解除绑定？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *certain = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"0" forKey:@"type"];
            [[NetWorking network] POST:kWxCancle params:params cache:NO success:^(id result) {
                NSLog(@"%@",result);
                [MBProgressHUD showSuccess:@"解除成功"];
                isForbid = NO;
                self.weChatLabel.textColor = RGB(169, 169, 169);
                self.weChatLabel.text = @"未绑定";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                
            } failure:^(NSString *description) {
                
                [MBProgressHUD showError:description];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [aler1 addAction:certain];
        [aler1 addAction:cancel];
        [self presentViewController:aler1 animated:YES completion:nil];
    }
    if (isForbid == NO) {
        
        [weakSelf showHudWithText:@"正在绑定"];
        [[BQLAuthEngine sharedAuthEngine] auth_wechat_login:^(id response) {
            NSLog(@"%@",response);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:[response objectForKey:@"unionid"] forKey:@"weixinId"];

            [[NetWorking network] POST:kWxForbid params:params cache:NO success:^(id result) {
                NSLog(@"%@",result);
                [weakSelf hideHud];
                [MBProgressHUD showSuccess:@"绑定成功"];
                isForbid = YES;
                self.weChatLabel.text = @"已绑定";
                self.weChatLabel.textColor = [UIColor lightColor];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];

            } failure:^(NSString *description) {
                isForbid = NO;
                [weakSelf hideHud];
                [MBProgressHUD showError:description];
            }];
            
        } failure:^(NSString *error) {
            
            [weakSelf hideHud];
            [MBProgressHUD showError:error];
        }];
    }
}

- (void)sinaIsForbid:(BOOL) forbid {
    kWeakSelf(self);
    if (isSina == YES) {
//        UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"确定"] title:@"是否解除绑定？" message:nil cancel:YES cancelBlock:^{
//            
//        } itemBlock:^(NSUInteger index) {
//            if (index == 0) {
//                NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                [params setObject:@"0" forKey:@"type"];
//                [[NetWorking network] POST:kWbCancle params:params cache:NO success:^(id result) {
//                    NSLog(@"%@",result);
//                    [MBProgressHUD showSuccess:@"解除成功"];
//                    isSina = NO;
//                    self.weiboLabel.textColor = RGB(169, 169, 169);
//                    self.weiboLabel.text = @"未绑定";
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
//                    
//                } failure:^(NSString *description) {
//                    
//                    [MBProgressHUD showError:description];
//                }];
//            }
//        }];
//        [self presentViewController:alert animated:YES completion:nil];
        
        UIAlertController *aler1 = [UIAlertController alertControllerWithTitle:@"是否解除绑定？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *certain = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"0" forKey:@"type"];
            [[NetWorking network] POST:kWbCancle params:params cache:NO success:^(id result) {
                NSLog(@"%@",result);
                [MBProgressHUD showSuccess:@"解除成功"];
                isSina = NO;
                self.weiboLabel.textColor = RGB(169, 169, 169);
                self.weiboLabel.text = @"未绑定";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                
            } failure:^(NSString *description) {
                
                [MBProgressHUD showError:description];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [aler1 addAction:certain];
        [aler1 addAction:cancel];
        [self presentViewController:aler1 animated:YES completion:nil];
    }
    if (isSina == NO) {
        
        [weakSelf showHudWithText:@"正在绑定"];
        [[BQLAuthEngine sharedAuthEngine] auth_sina_login:^(id response) {
            NSLog(@"%@",response);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (kNotNil(response) && kNotNil(response[@"id"])) {
                [params setObject:response[@"id"] forKey:@"weiboId"];
            }
            [[NetWorking network] POST:kWbForbid params:params cache:NO success:^(id result) {
                [weakSelf hideHud];
                [MBProgressHUD showSuccess:@"绑定成功"];
                isSina = YES;
                self.weiboLabel.text = @"已绑定";
                self.weiboLabel.textColor = [UIColor lightColor];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                
            } failure:^(NSString *description) {
                isSina = NO;
                [weakSelf hideHud];
                [MBProgressHUD showError:description];
            }];
        } failure:^(NSString *error) {
            [weakSelf hideHud];
            [MBProgressHUD showError:error];
        }];
    }
}

NSString *versionos() {
    
    UIDevice *device = [UIDevice currentDevice];
    return device.systemVersion;
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
