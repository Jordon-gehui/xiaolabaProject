//
//  ConversionListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "ConversionListViewController.h"
#import "XLBEarningsListTableViewCell.h"

@interface ConversionListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *moneyV;
@property (nonatomic, strong) UILabel *rechargeMoney;

@end

@implementation ConversionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换明细";
    self.naviBar.slTitleLabel.text = @"兑换明细";
    self.tableView.rowHeight = 60.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.isGrouped = YES;
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    [self initheaderView];
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

- (void)initheaderView {
    UIView *moneyV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 65)];
    _rechargeMoney = [UILabel new];
    _rechargeMoney.text = @"累计兑换：20000元";
    _rechargeMoney.font = [UIFont systemFontOfSize:18];
    _rechargeMoney.textColor = [UIColor textBlackColor];
    _rechargeMoney.textAlignment = NSTextAlignmentCenter;
    [moneyV addSubview:_rechargeMoney];
    [_rechargeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = moneyV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBEarningsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBEarningsListTableViewCell earningsCellID]];
    if (!cell) {
        cell = [[XLBEarningsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XLBEarningsListTableViewCell earningsCellID]];
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
