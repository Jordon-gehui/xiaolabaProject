//
//  XLBQuestionNewViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBQuestionNewViewController.h"

@interface XLBQuestionNewViewController ()

@property (retain, nonatomic)  UILabel *topLabel;

@property (retain, nonatomic)  UIView *lineView;

@property (retain, nonatomic)  UILabel *content;
@end

@implementation XLBQuestionNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNaviBar];
    self.title = @"常见问题";
    self.naviBar.slTitleLabel.text = @"常见问题";
    self.topLabel = [UILabel new];
    self.topLabel.font = [UIFont systemFontOfSize:15];
    self.topLabel.textColor = [UIColor commonTextColor];
    self.topLabel.numberOfLines = 0;
    [self.view addSubview:self.topLabel];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor lineColor];
    [self.view addSubview:self.lineView];
    
    self.content = [UILabel new];
    self.content.font = [UIFont systemFontOfSize:15];
    self.content.textColor = [UIColor minorTextColor];
    self.content.numberOfLines = 0;
    [self.view addSubview:self.content];
    
    self.topLabel.text = self.topTitle;
    self.content.text = self.contentTitle;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView).with.offset(15);
        make.left.mas_equalTo(15);
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
