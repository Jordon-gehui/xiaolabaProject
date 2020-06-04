//
//  XLBQuestionViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/20.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBQuestionNewViewController.h"
#import "XLBQuestionViewController.h"

@interface XLBQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation XLBQuestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"常见问题";
    self.naviBar.slTitleLabel.text = @"常见问题";
    self.tableView.estimatedRowHeight = 43.0f*kiphone6_ScreenHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.data =(NSMutableArray *)[DefaultList initCarQRCodeList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.data[indexPath.row] objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGB(60, 60, 60);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBQuestionNewViewController *questionNewVC = [XLBQuestionNewViewController new];
    questionNewVC.topTitle = [self.data[indexPath.row] objectForKey:@"title"];
    questionNewVC.contentTitle = [self.data[indexPath.row] objectForKey:@"subtitle"];
    [self.navigationController pushViewController:questionNewVC animated:YES];
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
