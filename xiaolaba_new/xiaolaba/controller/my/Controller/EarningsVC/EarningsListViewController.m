//
//  EarningsListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "EarningsListViewController.h"
#import "XLBEarningsListView.h"
#import "XLBEarningsListTableViewCell.h"
#import "XLBMeRequestModel.h"
@interface EarningsListViewController ()<UITableViewDelegate,UITableViewDataSource,XLBEarningsListViewDelegate>
{
    BOOL isPay;
}
@property (nonatomic, strong) XLBEarningsListView *topV;
@property (nonatomic, strong) UIView *moneyV;
@property (nonatomic, strong) UILabel *rechargeMoney;
@end

@implementation EarningsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值明细 >";
    self.naviBar.slTitleLabel.text = @"充值明细 >";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBtnClick)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    self.tableView.rowHeight = 60.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.isGrouped = YES;
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    isPay = YES;
    [self initheaderView];
}

- (void)initheaderView {
    UIView *moneyV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
    moneyV.backgroundColor = [UIColor textBlackColor];
    _rechargeMoney = [UILabel new];
    _rechargeMoney.text = @"累计充值：0元";
    _rechargeMoney.font = [UIFont systemFontOfSize:15];
    _rechargeMoney.textColor = [UIColor whiteColor];
    _rechargeMoney.textAlignment = NSTextAlignmentCenter;
    [moneyV addSubview:_rechargeMoney];
    [_rechargeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = moneyV;
}

- (void)refresh {
    [super refresh];
    self.page = 0;
    [self requestWithIsPay:isPay];
}

- (void)loadMore {
    [super loadMore];
    [self requestWithIsPay:isPay];
}

- (void)requestWithIsPay:(BOOL)isPay {
    self.page++;
    NSDictionary *dict = @{@"page":@{@"curr":@(self.page),@"size":@30,}};
    
    [XLBMeRequestModel requestPayDetail:dict isPay:isPay success:^(NSArray<EarningsListModel *> *models) {
        if (self.page == 1 && models.count==0) {
            [self.data removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page == 1) {
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:models];
            [self.tableView reloadData];
            if (models.count<30) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } recharge:^(NSString *recharge) {
        
        if (isPay) {
            _rechargeMoney.text = [NSString stringWithFormat:@"累计充值:%@元",recharge];
        }else {
            _rechargeMoney.text = [NSString stringWithFormat:@"累计提现:%@元",recharge];
        }
    } failure:^(NSString *error) {
        [self.data removeAllObjects];
        [self.tableView reloadData];
        if (self.page ==1) {
            //            self.errorV.hidden = NO;
            //            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } more:^(BOOL more) {
        
    }];

}
- (void)navBtnClick {
    [self hideEarningsListViewWithAlpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBEarningsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBEarningsListTableViewCell earningsCellID]];
    if (!cell) {
        cell = [[XLBEarningsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XLBEarningsListTableViewCell earningsCellID]];
    }
    cell.isPay = isPay;
    cell.model = self.data[indexPath.row];
    return cell;
}

- (XLBEarningsListView *)topV {
    if (!_topV) {
        _topV = [[XLBEarningsListView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        self.topV.alpha = 0;
        self.topV.delegate = self;
        [self.topV.rechargeBtn setBackgroundColor:[UIColor colorWithR:240 g:240 b:240]];
        [self.view addSubview:_topV];
    }
    return _topV;
}

- (void)billDetailButtonClick:(UIButton *)sender {
    [self.data removeAllObjects];
    switch (sender.tag) {
        case BillDetailRechargeBtnTag: {
            //充值
            isPay = YES;
            self.title = @"充值明细 >";
            self.naviBar.slTitleLabel.text = @"充值明细 >";
            [self.topV.rechargeBtn setBackgroundColor:[UIColor colorWithR:240 g:240 b:240]];
            [self.topV.withdrawBtn setBackgroundColor:[UIColor whiteColor]];
            [self refresh];
        }
            break;
            
        case BillDetailWithdrawBtnTag: {
            //提现
            isPay = NO;
            self.title = @"提现明细 >";
            self.naviBar.slTitleLabel.text = @"提现明细 >";
            [self.topV.withdrawBtn setBackgroundColor:[UIColor colorWithR:240 g:240 b:240]];
            [self.topV.rechargeBtn setBackgroundColor:[UIColor whiteColor]];
            [self refresh];
        }
            break;
            
        default:
            break;
    }
    [self hideEarningsListViewWithAlpha:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hideEarningsListViewWithAlpha:0];
}

- (void)hideEarningsListViewWithAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.3 animations:^{
        self.topV.alpha = alpha;
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
