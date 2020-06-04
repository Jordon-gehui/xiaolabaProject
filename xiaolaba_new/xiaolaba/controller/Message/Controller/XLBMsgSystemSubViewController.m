//
//  XLBMsgSystemSubViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMsgSystemSubViewController.h"

@interface XLBMsgSystemSubViewController ()
@property (nonatomic, strong) UILabel *headline;
@property (nonatomic, strong) UILabel *content;
@end

@implementation XLBMsgSystemSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统消息";
    self.naviBar.slTitleLabel.text = @"系统消息";
    [self setSubViews];
}

- (void)setSubViews {
    self.headline = [[UILabel alloc] init];
    self.headline.textAlignment = NSTextAlignmentRight;
    self.headline.textColor = [UIColor textBlackColor];
//    self.headline.backgroundColor = [UIColor redColor];
    self.headline.font = [UIFont systemFontOfSize:12];
    self.headline.text = self.model.createDate;
    [self.view addSubview:self.headline];
    
    self.content = [[UILabel alloc] init];
    self.content.numberOfLines = 0;
    self.content.textColor = RGB(102, 102, 102);
    self.content.font = [UIFont systemFontOfSize:15];
    self.content.text = self.model.content;
    [self.view addSubview:self.content];
    
    
    [self.headline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(22);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headline.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.headline);
        make.right.mas_equalTo(-15);
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
