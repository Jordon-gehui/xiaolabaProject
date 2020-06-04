//
//  ShoppingMallViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "ShoppingMallViewController.h"

@interface ShoppingMallViewController ()

@end

@implementation ShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商城";
}
-(void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"兑换记录" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}
-(void)rightClick {
    [[CSRouter share] push:@"ConversionRecordViewController" Params:nil hideBar:YES];
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
}·
*/

@end
