//
//  SLBaseTablePage.h
//  nxh
//
//  Created by smilelu on 15/9/10.
//  Copyright (c) 2015年 speed. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTablePage : BaseViewController

@property (nonatomic,retain) UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *data; //为tableView提供数据

@property (nonatomic, assign) NSInteger page; //页数
@property (nonatomic, assign) NSInteger size; //每页数量
@property (nonatomic, assign) BOOL allowRefresh;
@property (nonatomic, assign) BOOL allowLoadMore;

@property (nonatomic, assign) BOOL isGrouped; //table的样式是否为grouped

@property (nonatomic, assign) BOOL autoRefresh;

@property (nonatomic, assign) BOOL isLimitReq;

- (void)refresh;
- (void)loadMore;

- (void)startRefresh;
- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData;
- (void)resetNoMoreData;

@end
