//
//  XLBSuccessQRViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/21.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBSuccessQRViewController.h"
#import "XLBAddressTool.h"


@interface XLBSuccessQRViewController ()


@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

@implementation XLBSuccessQRViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.subTitle isEqualToString:@"挪车贴"]) {
        self.title = @"挪车贴绑定成功";
        self.naviBar.slTitleLabel.text = @"挪车贴绑定成功";
        self.topLabel.text = @"绑定成功";
        self.subLabel.text = @"请将车贴贴在醒目位置\n方便扫描!";
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CallPhoneDict"];
        if (kNotNil(dict)) {
            [[XLBAddressTool addressToolShared] setDict:dict];
            [[XLBAddressTool addressToolShared] creatPhoneNumber];
        }
        
    }else {
        self.title = @"提交成功";
        self.naviBar.slTitleLabel.text = @"提交成功";
        self.topLabel.text = @"精品的挪车贴开始上路咯！";
        self.subLabel.text = @"约在3～5个工作日内寄到，请耐心等待";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
    }
}

- (void)backClick:(id)sender {
    if ([self.subTitle isEqualToString:@"挪车贴"]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }else {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
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
