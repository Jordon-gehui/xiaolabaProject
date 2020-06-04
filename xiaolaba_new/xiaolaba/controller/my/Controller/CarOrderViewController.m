//
//  CarOrderViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/7/14.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CarOrderViewController.h"
#import "CheTieCell.h"
#import "XLBErrorView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface CarOrderViewController ()<XLBErrorViewDelegate>

@property (nonatomic, strong) XLBErrorView *errorV;
@end

@implementation CarOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.naviBar.slTitleLabel.text = @"我的订单";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"paySuccess" object:nil];
    self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom);
    self.tableView.backgroundColor = RGB(247, 247, 247);
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CheTieCell class] forCellReuseIdentifier:[CheTieCell cellReuseIdentifier]];
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    // Do any additional setup after loading the view.
}
- (void)refresh {
    [super refresh];
    
    self.page = 0;
    [self getData];
    
}

- (void)loadMore {
    [super loadMore];
    [self getData];
    
}
-(void)getData {
    self.page++;
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(20)}};
    kWeakSelf(self);
    [[NetWorking network] POST:kGetCheTieOrder params:params cache:NO success:^(id result) {
        [weakSelf hideHud];
        NSLog(@"%@",result);
        NSArray *list = [result objectForKey:@"list"];
        if (weakSelf.page == 1 && list.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        }else {
            weakSelf.errorV.hidden = YES;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.page ==1) {
                [weakSelf.data removeAllObjects];
            }
            [weakSelf.data addObjectsFromArray:list];
            [weakSelf.tableView reloadData];
            if (list.count<20) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSString *error) {
        [weakSelf hideHud];
        if (self.page ==1) {
            [self.data removeAllObjects];
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheTieCell *cell = [tableView dequeueReusableCellWithIdentifier:[CheTieCell cellReuseIdentifier] forIndexPath:indexPath];
    [cell setData:[self.data objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.data[indexPath.row];
    if (!kNotNil([dict objectForKey:@"id"]) || !kNotNil([dict objectForKey:@"money"]) || !kNotNil([dict objectForKey:@"productId"]) || !kNotNil([dict objectForKey:@"addressId"])) {
        return;
    }else {
        [self buyTrafficAllowanceWithParameter:dict];
    }
}
    
- (void)buyTrafficAllowanceWithParameter:(NSDictionary *)parameter {
    
    NSDictionary *dict = @{@"money":[parameter objectForKey:@"money"],@"productId":[parameter objectForKey:@"productId"],@"indentId":[parameter objectForKey:@"id"],@"addressId":[parameter objectForKey:@"addressId"],};
    NSLog(@"%@",dict);
    [[NetWorking network] POST:kCheTieSignAgain params:dict cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if (!kNotNil(result)) return ;
        [[AlipaySDK defaultService] payOrder:result[@"orderSign"] fromScheme:@"xiaolaba" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.view addSubview:_errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
    self.page = 0;
    [self getData];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paySuccess" object:nil];
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
