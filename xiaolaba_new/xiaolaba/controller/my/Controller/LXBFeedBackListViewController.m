//
//  LXBFeedBackListViewController.m
//  xiaolaba
//
//  Created by lin on 2017/8/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "LXBFeedBackListViewController.h"
#import "XLBFeedBackListCell.h"
#import "XLBMeRequestModel.h"
#import "XLBErrorView.h"
@interface LXBFeedBackListViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>
@property (nonatomic, strong) XLBErrorView *errorV;

@end

@implementation LXBFeedBackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户反馈";
    self.naviBar.slTitleLabel.text = @"用户反馈";
    [MobClick event:@"UserTrckling"];
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
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

- (void)getData {
    self.page++;
    NSDictionary *params;
    if (kNotNil(self.initiatorId)) {
        params = @{@"page":@{@"curr":@(self.page),
                                           @"size":@(30)},
                   @"id":self.initiatorId};
    }else {
        params = @{@"page":@{@"curr":@(self.page),
                             @"size":@(10)}};
    }
    kWeakSelf(self);
    [XLBMeRequestModel requsetFeedBackList:params success:^(NSArray *list) {
        if (self.page == 1 && list.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"暂无反馈"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            self.errorV.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page == 1) {
                [weakSelf.data removeAllObjects];
            }
            [weakSelf.data addObjectsFromArray:list];
            [weakSelf.tableView reloadData];
            if (list.count<30) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(NSString *error) {
        [self.data removeAllObjects];
        [self.tableView reloadData];
        if (self.page ==1) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
            
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } more:^(BOOL more) {
        
    }];
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setImage:[UIImage imageNamed:@"icon_fk"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}


- (void)rightClick {
    [[CSRouter share] push:@"LXBFeedBackViewController" Params:nil hideBar:YES];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBFeedBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBFeedBackListCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBFeedBackListCell class]) owner:self options:nil].lastObject;
    }
    
    cell.data = self.data[indexPath.row];
    
    return cell;
}

- (void)scroll {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.tableView addSubview:_errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
//    [self requestData:YES];
//    self.page = 0;
//    [self getData];
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
