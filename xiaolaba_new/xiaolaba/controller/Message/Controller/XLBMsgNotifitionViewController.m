//
//  XLBMsgNotifitionViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMsgNotifitionViewController.h"
#import "XLBMsgNotifitionCell.h"
#import "NetWorking.h"
#import "MsgNoticeModel.h"
#import "XLBChatViewController.h"
#import "XLBMeRequestModel.h"
#import "XLBErrorView.h"

@interface XLBMsgNotifitionViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>
//{
//    NSInteger _curr;            // 请求起始点
//    NSInteger _size;            // 一页数据量
//    BOOL _hasMore;              // 是否还有更多
//}
//@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XLBErrorView *errorV;

@end

@implementation XLBMsgNotifitionViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = @"消息通知";
    self.naviBar.slTitleLabel.text = @"消息通知";
//    _curr = 1;
//    _size = 10;
//    _hasMore = YES;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    [self.tableView registerClass:[XLBMsgNotifitionCell class] forCellReuseIdentifier:NSStringFromClass([XLBMsgNotifitionCell class])];

    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    
//    [self creatTableView];
//    [self refresh];
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
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(30)}};
    kWeakSelf(self);
    
    [XLBMeRequestModel requsetFriendsNotice:NO params:params success:^(NSArray<MsgNoticeModel *> *models) {
        if (self.page == 1 && models.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            self.errorV.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page == 1) {
                [weakSelf.data removeAllObjects];
            }
            [weakSelf.data addObjectsFromArray:models];
            [weakSelf.tableView reloadData];
            if (models.count<30) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(NSString *error) {
        self.errorV.hidden = NO;
        [self.data removeAllObjects];
        [self.tableView reloadData];
        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } more:^(BOOL more) {
        
    }];
}

//
//- (void)refresh {
//    //加载更多刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _curr ++;
//        if (_hasMore) {
//            [self requestData:nil];
//        }else {
//            [self.tableView.mj_footer endRefreshing];
//        }
//        
//    }];
//    
//    //下拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _curr = 1;
//        [self.dataSource removeAllObjects];
//        [self requestData:YES];
//    }];
//    // 马上进入刷新状态
//    [ self.tableView.mj_header beginRefreshing];
//}
//
//- (void)requestData:(BOOL )header {
//    
//    NSDictionary *params = @{@"page":@{@"curr":@(_curr),
//                                       @"size":@(_size)}};
//    kWeakSelf(self);
//    [XLBMeRequestModel requsetFriendsNotice:NO params:params success:^(NSArray<MsgNoticeModel *> *models) {
//        if (_curr == 1 && models.count==0) {
//            [self.errorV showErrorView];
//            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
//        }else {
//            if(header) {
//                [weakSelf.dataSource removeAllObjects];
//                [self.tableView.mj_header endRefreshing];
//            }
//            else {
//                [self.tableView.mj_footer endRefreshing];
//            }
//            [weakSelf.dataSource addObjectsFromArray:models];
//            
//            [self.tableView reloadData];
//        }
//        
//    } failure:^(NSString *error) {
//        if (_curr ==1) {
//            [self.errorV showErrorView];
//            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
//        }else {
//            if(header) {
//                [self.tableView.mj_header endRefreshing];
//            }
//            else {
//                [self.tableView.mj_footer endRefreshing];
//            }
//        }
//    } more:^(BOOL more) {
//        
//        if(!more && !header) {
//            [self.tableView.mj_footer endRefreshing];
//        }
//        _hasMore = more;
//    }];
//
//}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBMsgNotifitionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMsgNotifitionCell class]) forIndexPath:indexPath];

    __block MsgNoticeModel *model= self.data[indexPath.row];
	cell.model = self.data[indexPath.row];
	cell.lineV.hidden = indexPath.row == self.data.count-1;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kWeakSelf(self);
    cell.returnBlock = ^(NSString* friendId){
        if ([cell.model.status integerValue] ==1) {
            XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",model.friendId] conversationType:EMConversationTypeChat];
            chat.hidesBottomBarWhenPushed = YES;
            chat.nickname = model.nickName;
            chat.avatar = model.img;
            chat.userId = [NSString stringWithFormat:@"%@",model.friendId];
            [self.navigationController pushViewController:chat animated:YES];
        }else {
            [weakSelf showHudWithText:nil];
            [[NetWorking network] POST:kAgree params:@{@"friendId":friendId} cache:NO success:^(id result) {
                [weakSelf hideHud];
                MsgNoticeModel *returnmodel = weakSelf.data[indexPath.row];
                returnmodel.status = @"1";
                [weakSelf.tableView reloadData];
            } failure:^(NSString *description) {
                [weakSelf hideHud];
            }];
        }
        
    };
	return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return 70;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block MsgNoticeModel *model= self.data[indexPath.row];
    
    [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":model.friendId,@"delFlag":@0} hideBar:YES];
    
}
//- (NSMutableArray *)dataSource {
//    
//    if(!_dataSource) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    [self.view addSubview:self.tableView];
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
