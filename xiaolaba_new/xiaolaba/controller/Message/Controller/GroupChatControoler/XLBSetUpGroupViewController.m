//
//  XLBSetUpGroupViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBSetUpGroupViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "GroupHeadPortraitView.h"
@interface XLBSetUpGroupViewController ()
@property (nonatomic, strong) UITextField *nickNameField;
@property (nonatomic, strong) UITextField *describeField;
@end

@implementation XLBSetUpGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建群组";
    self.nickNameField = [[UITextField alloc] init];
    self.nickNameField.placeholder = @"请输入群组名称";
    self.nickNameField.textAlignment = NSTextAlignmentLeft;
    self.nickNameField.textColor = [UIColor textBlackColor];
    self.nickNameField.backgroundColor = [UIColor whiteColor];
    self.nickNameField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.nickNameField];
    
    [self.nickNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    self.describeField = [[UITextField alloc] init];
    self.describeField.placeholder = @"请输入群组描述";
    self.describeField.textAlignment = NSTextAlignmentLeft;
    self.describeField.textColor = [UIColor textBlackColor];
    self.describeField.backgroundColor = [UIColor whiteColor];
    self.describeField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.describeField];
    
    [self.describeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameField.mas_bottom).with.offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *btn = [UIButton new];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"创建" forState:0];
    [btn setTitleColor:[UIColor textBlackColor] forState:0];
    btn.backgroundColor = [UIColor lightColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeField.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
}

- (void)btnClick {
    
//    GroupHeadPortraitView *v = [[GroupHeadPortraitView alloc] initWithArray:@[@"",@"",@"",@"",@"",@"",]];
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.describeField.bottom + 60, 300, 300)];
//    img.image  = [v imageWithUIView:v];
//    [self.view addSubview:img];
    
    [[CSRouter share] push:@"XLBAddGroupMemberViewController" Params:nil hideBar:YES];
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
