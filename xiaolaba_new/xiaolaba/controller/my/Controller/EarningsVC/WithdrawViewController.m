//
//  WithdrawViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "WithdrawViewController.h"
#import "APOrderInfo.h"
@interface WithdrawViewController ()<XLBWithdrawViewDelegate,UIAlertViewDelegate>
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    self.naviBar.slTitleLabel.text = @"提现";
    self.withdrawV.backgroundColor = [UIColor viewBackColor];
    
}
- (void)withdrawButtonClick:(UIButton *)sender {
    switch (sender.tag) {

        case WithdrawRemindBtnTag: {
            //提现金额说明
            [[CSRouter share] push:@"ProViewController" Params:nil hideBar:YES];
        }
            break;
        case WithdrawWithdrawBtnTag: {
            //提现
            if (kNotNil(self.aliNickname) && ![self.aliNickname containsString:@"(null)"]) {
                if ([_withdrawV.moneyTextField.text intValue] < 10) {
                    [MBProgressHUD showError:@"提现金额不能少于10元!"];
                    return;
                }else if([_withdrawV.moneyTextField.text floatValue] > [self.residueMoney floatValue]){
                    [MBProgressHUD showError:@"账户余额不足!"];
                    return;
                }else {
                    [[NetWorking network] POST:kPayTransfer params:@{@"money":_withdrawV.moneyTextField.text,} cache:NO success:^(id result) {
                        NSLog(@"%@",result);
                        if ([[result objectForKey:@"status"] isEqualToString:@"-1"]) {
                            [MBProgressHUD showSuccess:@"提现失败"];
                        }else if([[result objectForKey:@"status"] isEqualToString:@"-2"]){
                            [MBProgressHUD showSuccess:@"账户余额不足!"];
                        }else {
                            [MBProgressHUD showSuccess:@"提现成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failure:^(NSString *description) {
                        [MBProgressHUD showSuccess:@"提现失败"];
                    }];
                }
                
            }else {
                if ([self.withdrawV.accountTextField.text isEqualToString:@""]) {
                    [MBProgressHUD showError:@"账号不能为空"];
                    return;
                }else if ([self.withdrawV.nickTextField.text isEqualToString:@""]) {
                    [MBProgressHUD showError:@"姓名不能为空"];
                    return;
                }else if ([_withdrawV.moneyTextField.text intValue] < 10) {
                    [MBProgressHUD showError:@"提现金额不能少于10元"];
                    return;
                }else if([_withdrawV.moneyTextField.text floatValue] > [self.residueMoney floatValue]){
                    [MBProgressHUD showError:@"账户余额不足!"];
                    return;
                }else {
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"确认信息：" message:[NSString stringWithFormat:@"\n提现金额:%@元\n姓名:%@\n账号:%@",self.withdrawV.moneyTextField.text,self.withdrawV.accountTextField.text,self.withdrawV.nickTextField.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertV show];
                }
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[NetWorking network] POST:kPayAccess params:@{@"aliUserId":self.withdrawV.accountTextField.text,@"aliNickname":self.withdrawV.nickTextField.text,} cache:NO success:^(id result) {
            NSLog(@"%@",result);
            [[NetWorking network] POST:kPayTransfer params:@{@"money":_withdrawV.moneyTextField.text,} cache:NO success:^(id result) {
                NSLog(@"%@",result);
                if ([[result objectForKey:@"status"] isEqualToString:@"-1"]) {
                    [MBProgressHUD showSuccess:@"提现失败"];
                }else if([[result objectForKey:@"status"] isEqualToString:@"-2"]){
                    [MBProgressHUD showSuccess:@"账户余额不足!"];
                }else {
                    [MBProgressHUD showSuccess:@"提现成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSString *description) {
                [MBProgressHUD showSuccess:@"提现失败"];
            }];
            
        } failure:^(NSString *description) {
            [MBProgressHUD showError:@"提现失败"];
        }];
    }
}

- (XLBWithdrawView *)withdrawV {
    if (!_withdrawV) {
        _withdrawV = [[XLBWithdrawView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom)];
        _withdrawV.delegate = self;
        _withdrawV.residueMoney = self.residueMoney;
        _withdrawV.aliNickname = self.aliNickname;
        _withdrawV.aliUserId = self.aliUserId;
        [_withdrawV.moneyTextField resignFirstResponder];
        [self.view addSubview:_withdrawV];
    }
    return _withdrawV;
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
