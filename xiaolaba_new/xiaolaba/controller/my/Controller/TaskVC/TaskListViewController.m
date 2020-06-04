//
//  TaskListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskDetailListTableViewCell.h"
@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务交易明细";
    self.tableView.rowHeight = 60.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.isGrouped = YES;
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
}
- (void)refresh {
    [super refresh];
    NSArray *ar = @[@"1",@"2",@"3",@"4",@"5",@"6",];
    [self.data addObjectsFromArray:ar];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)loadMore {
    [super loadMore];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskDetailListTableViewCell taskDetailListCell]];
    if (!cell) {
        cell = [[TaskDetailListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TaskDetailListTableViewCell taskDetailListCell]];
    }
    return cell;
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
