//
//  ConversionViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "ConversionViewController.h"
#import "XLBAccountBalanceCell.h"
@interface ConversionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *changeBtn;
@end

@implementation ConversionViewController

- (void)viewDidLoad {
    self.isGrouped = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换";
    self.naviBar.slTitleLabel.text = @"兑换";
    self.tableView.rowHeight = 60.0f;
    self.tableView.backgroundColor = [UIColor viewBackColor];
    [self initHeaderViewAndFootView];
    
}

- (void)initHeaderViewAndFootView {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
    headerV.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerV;
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
    self.tableView.tableFooterView = footV;
    
    UILabel *accountLabel = [UILabel new];
    accountLabel.text = @"账户：";
    accountLabel.font = [UIFont systemFontOfSize:15];
    accountLabel.textColor = [UIColor textBlackColor];
    [headerV addSubview:accountLabel];
    
    
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerV.mas_left).with.offset(15);
        make.centerY.mas_equalTo(headerV.mas_centerY).with.offset(0);
        
    }];
    
    UILabel *nikename = [UILabel new];
    nikename.textColor = [UIColor textBlackColor];
    nikename.text = @"戴葛辉";
    nikename.font = [UIFont systemFontOfSize:15];
    [headerV addSubview:nikename];
    
    [nikename mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountLabel.mas_right).with.offset(5);
        make.centerY.mas_equalTo(headerV.mas_centerY).with.offset(0);
    }];
    
    UIView *accountV = [UIView new];
    accountV.layer.masksToBounds = YES;
    accountV.layer.cornerRadius = 15;
    accountV.layer.borderWidth = 1;
    accountV.layer.borderColor = [UIColor textBlackColor].CGColor;
    [headerV addSubview:accountV];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_icon_txl"]];
    [accountV addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountV.mas_left).with.offset(5);
        make.centerY.mas_equalTo(accountV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(15);
    }];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"余额 8989";
    self.moneyLabel.textColor = [UIColor textBlackColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:13];
    [accountV addSubview:self.moneyLabel];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).with.offset(5);
        make.right.mas_equalTo(accountV.mas_right).with.offset(-5);
        make.centerY.mas_equalTo(accountV.mas_centerY).with.offset(0);
    }];
    
    [accountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerV.mas_right).with.offset(-15);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(img.mas_left).with.offset(5);
        make.centerY.mas_equalTo(headerV.mas_centerY).with.offset(0);
    }];

    
    self.changeBtn = [UIButton new];
    self.changeBtn.layer.masksToBounds = YES;
    self.changeBtn.layer.cornerRadius = 10;
    [self.changeBtn setTitle:@"自定义金额" forState:0];
    [self.changeBtn setTitleColor:[UIColor textBlackColor] forState:0];
    self.changeBtn.backgroundColor = [UIColor shadeEndColor];
    [self.changeBtn addTarget:self action:@selector(changeMoneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:self.changeBtn];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footV.mas_left).with.offset(20);
        make.right.mas_equalTo(footV.mas_right).with.offset(-20);
        make.top.mas_equalTo(footV.mas_top).with.offset(10);
        make.height.mas_equalTo(50);
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor viewBackColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH, 20)];
    lable.text = @"选择金额(元)";
    lable.textColor = [UIColor annotationTextColor];
    lable.font = [UIFont systemFontOfSize:13];
    
    [line addSubview:lable];
    
    return line;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBAccountBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBAccountBalanceCell accountBalanceCell]];
    if (!cell) {
        cell = [[XLBAccountBalanceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[XLBAccountBalanceCell accountBalanceCell]];
    }
    return cell;
}
- (void)changeMoneyBtn {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"兑换车币" message:@"账户：2车币" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入兑换的车币 = N 车票";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        [[CSRouter share] push:@"ConversionListViewController" Params:nil hideBar:YES];

    }]];
    [self presentViewController:alertController animated:true completion:nil];
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
