//
//  XLBErrorViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/27.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBErrorViewController.h"

@interface XLBErrorViewController ()

@end

@implementation XLBErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态";
    self.naviBar.slTitleLabel.text = @"动态";
    [self errorView];
}

- (void)errorView {
    UIImageView *imgV = [UIImageView new];
    imgV.image = [UIImage imageNamed:@"errorImg"];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(41);
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"恩，我想我们的页面被恐龙吃掉了~";
    label.textColor = [UIColor textBlackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imgV.mas_bottom).with.offset(10);
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
