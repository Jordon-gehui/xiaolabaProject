//
//  TaskViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskDetailTableViewCell.h"

@interface TaskViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic, strong) UITableView *rightTable;
@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) NSMutableArray *leftData;
@property (nonatomic, strong) NSMutableArray *rightData;


@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务中心";
    self.headerV.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self refresh];
}

- (void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightItem setTitle:@"车币 90" forState:0];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightItem setTitleColor:[UIColor textBlackColor] forState:0];
    rightItem.layer.masksToBounds = YES;
    rightItem.layer.cornerRadius = 10;
    rightItem.layer.borderColor = [UIColor textBlackColor].CGColor;
    rightItem.layer.borderWidth = 1;
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];

}

- (void)rightClick {
    [[CSRouter share] push:@"TaskListViewController" Params:nil hideBar:YES];
}
- (void)refresh {
    NSArray *ar = @[@"1",@"2",@"3",@"4",@"5",@"6",];
    [self.leftData addObjectsFromArray:ar];
    [self.leftTable reloadData];
    [self.leftTable.mj_header endRefreshing];
    [self.leftTable.mj_footer endRefreshing];
    [self.rightTable reloadData];
    [self.rightTable.mj_header endRefreshing];
    [self.rightTable.mj_footer endRefreshing];
}

- (void)loadMore {
    [self.leftTable.mj_header endRefreshing];
    [self.leftTable.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return 5;
    }else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskDetailTableViewCell taskDetailCell]];
        if (!cell) {
            cell = [[TaskDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TaskDetailTableViewCell taskDetailCell]];
        }
        return cell;
    }else {
        TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskDetailTableViewCell taskDetailCell]];
        if (!cell) {
            cell = [[TaskDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TaskDetailTableViewCell taskDetailCell]];
        }
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 300) {
        CGFloat index = scrollView.contentOffset.x / kSCREEN_WIDTH;
        if (index == 0) {
            [UIView animateWithDuration:0.3f animations:^{
                self.bottomLabel.right = self.headerV.centerX - 10;
            }];
        }else {
            [UIView animateWithDuration:0.3f animations:^{
                self.bottomLabel.left = self.headerV.centerX + 10;
            }];
        }
    }
}

- (void)topBtnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.scrollV setContentOffset:CGPointMake(kSCREEN_WIDTH, 0) animated:YES];
    }else {
        [self.scrollV setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (UITableView *)leftTable {
    if (!_leftTable) {
        self.leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom - 50) style:UITableViewStyleGrouped];
        self.leftTable.backgroundColor = [UIColor viewBackColor];
        self.leftTable.tag = 100;
        self.leftTable.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
            [self refresh];
        }];
        self.leftTable.rowHeight = 70.0f;
        self.leftTable.separatorStyle = UITableViewCellSelectionStyleNone;
        self.leftTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
        self.leftTable.delegate = self;
        self.leftTable.dataSource = self;
        [self.scrollV addSubview:_leftTable];
    }
    return _leftTable;
}

- (UITableView *)rightTable {
    if (!_rightTable) {
        self.rightTable = [[UITableView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom - 50) style:UITableViewStyleGrouped];
        self.rightTable.backgroundColor = [UIColor viewBackColor];
        self.rightTable.tag = 200;
        self.rightTable.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
            [self refresh];
        }];
        self.rightTable.rowHeight = 70.0f;
        self.rightTable.tableFooterView = [UIView new];
        self.rightTable.separatorStyle = UITableViewCellSelectionStyleNone;
        self.rightTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
        self.rightTable.delegate = self;
        self.rightTable.dataSource = self;
        [self.scrollV addSubview:_rightTable];
    }
    return _rightTable;
}
- (UIScrollView *)scrollV {
    if (!_scrollV) {
        self.scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom + 50, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        self.scrollV.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, kSCREEN_HEIGHT);
        self.scrollV.showsHorizontalScrollIndicator = NO;
        self.scrollV.pagingEnabled = YES;
        self.scrollV.tag = 300;
        self.scrollV.delegate = self;
        self.scrollV.backgroundColor = [UIColor viewBackColor];
        [self.view addSubview:self.scrollV];
    }
    return _scrollV;
}

- (UIView *)headerV {
    if (!_headerV) {
        self.headerV = [UIView new];
        self.headerV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.headerV];
        [self.headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/2, 49)];
        [leftBtn setTitle:@"新手任务" forState:0];
        [leftBtn setTitleColor:[UIColor textBlackColor] forState:0];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        leftBtn.tag = 200;
        [leftBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerV addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.headerV.mas_centerX).with.offset(-10);
            make.top.mas_equalTo(self.headerV.mas_top).with.offset(0);
            make.bottom.mas_equalTo(self.headerV.mas_bottom).with.offset(-1);
        }];
        
        UIButton *rightBtn = [UIButton new];
        [rightBtn setTitle:@"日常任务" forState:0];
        [rightBtn setTitleColor:[UIColor textBlackColor] forState:0];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        rightBtn.tag = 100;
        [rightBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerV addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headerV.mas_centerX).with.offset(10);
            make.top.mas_equalTo(self.headerV.mas_top).with.offset(0);
            make.bottom.mas_equalTo(self.headerV.mas_bottom).with.offset(-1);
        }];
        
        self.bottomLabel = [UILabel new];
        self.bottomLabel.backgroundColor = [UIColor redColor];
        [self.headerV addSubview:self.bottomLabel];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBtn.mas_left).with.offset(0);
            make.right.mas_equalTo(leftBtn.mas_right).with.offset(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.headerV.mas_bottom).with.offset(0);
        }];
    }
    
    return _headerV;
}

- (NSMutableArray *)leftData {
    if (!_leftData) {
        _leftData = [NSMutableArray array];
    }
    return _leftData;
}

- (NSMutableArray *)rightData {
    if (!_rightData) {
        _rightData = [NSMutableArray array];
    }
    return _rightData;
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
