//
//  SLBaseTablePage.m
//  nxh
//
//  Created by smilelu on 15/9/10.
//  Copyright (c) 2015年 speed. All rights reserved.
//

#import "BaseTablePage.h"
#import <MJRefresh/MJRefresh.h>
#import "AppDelegate.h"
#import "UIImage+Util.h"
#import "XLBRefreshGifHeader.h"
#import "XLBRefreshFooter.h"

@interface BaseTablePage ()<UITableViewDelegate, UITableViewDataSource>{
    UIColor *currNavColor;
}

@end

@implementation BaseTablePage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNaviBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _autoRefresh = YES;
    
    UITableViewStyle tStyle;
    if (_isGrouped) {
        tStyle = UITableViewStyleGrouped;
    }else {
        tStyle = UITableViewStylePlain;
    }
    
    if(self.navigationController) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom) style:tStyle];
    }else {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:tStyle];
    }
    if (self.translucentNav) {
        _tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    
    _tableView.tag = 999;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
    }
//    self.view = _tableView;
    [self.view insertSubview:_tableView belowSubview:self.naviBar];

//    _isLimitReq = ((AppDelegate *)[UIApplication sharedApplication].delegate).launchInfo.isLimitReq.boolValue;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (currNavColor) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage colorImage:currNavColor] forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_autoRefresh) {
        if (self.tableView.mj_header) {
            [self.tableView.mj_header beginRefreshing];
        }
        _autoRefresh = NO;
    }
}

- (void)startRefresh {
    [self.tableView.mj_header beginRefreshing];
}

- (NSMutableArray *)data {
    if(!_data) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setAllowRefresh:(BOOL)allowRefresh {
    if(allowRefresh) {
        __weak BaseTablePage *weakSelf = self;
        self.tableView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refresh];
        }];
    }
}

- (void)setAllowLoadMore:(BOOL)allowLoadMore {
    if (allowLoadMore) {
        __weak BaseTablePage *weakSelf = self;
        self.tableView.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
        
    } else {
        self.tableView.mj_footer = nil;
    }
}

-(void)refresh {
    [self resetNoMoreData];
}

-(void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)noMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData {
    [self.tableView.mj_footer resetNoMoreData];
}

-(void)loadMore {
    
}

-(void)endLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)tapRefreshView:(UITapGestureRecognizer*)sender {
//    [super tapRefreshView:sender];
    [self refresh];
}

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
