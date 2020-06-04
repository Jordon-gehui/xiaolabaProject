//
//  XLBMoveRecordsViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMoveRecordsViewController.h"
#import "XLBMoveRecordsCell.h"
#import "XLBMeRequestModel.h"
#import "XLBMoveRecordsCell.h"
#import "XLBMoveCarDetailViewController.h"
#import "XLBNoticeViewController.h"
#import "XLBMoveCarNoticeViewController.h"
#import "XLBErrorView.h"
@interface XLBMoveRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>
{
//    NSInteger _curr;            // 请求起始点
//    NSInteger _size;            // 一页数据量
//    BOOL _hasMore;               // 是否还有更多
    BOOL seleted;
}

//@property (nonatomic, strong)UITableView *tableView;
//@property (nonatomic, strong)NSMutableArray *data;

@property (nonatomic, strong) XLBErrorView *errorV;

@end

@implementation XLBMoveRecordsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    seleted = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"挪车记录";
    self.naviBar.slTitleLabel.text = @"挪车记录";
    [MobClick event:@"MoveCarRecord"];
    seleted = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120*kiphone6_ScreenHeight;
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
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(30)}};
    kWeakSelf(self);
    
    [XLBMeRequestModel requestMyMoveList:params success:^(NSArray<XLBMoveRecordsModel *> *models) {
        if (self.page == 1 && models.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"还没有挪车记录哦～"];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120*kiphone6_ScreenHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBMoveRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMoveRecordsCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMoveRecordsCell class]) owner:nil options:nil].lastObject;
    }
    
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (seleted == NO) {
        seleted = YES;
        XLBMoveRecordsModel *model = self.data[indexPath.row];
        if (kNotNil(model.createID)) {
            [self requstMoveCarDate:model.createID];
        }
    }else {
        return;
    }
}


- (void)requstMoveCarDate:(NSString *) userId{
    NSDictionary *dict = @{@"id":userId,};
    [[NetWorking network] POST:KFindByDetail params:dict cache:NO success:^(id result) {
        NSLog(@"----------- 挪车记录详情 %@   %@",result,dict);
        XLBMoveRecordsModel *model = [XLBMoveRecordsModel mj_objectWithKeyValues:result];
        NSLog(@"%@",userId);
        
        if ([model.status isEqualToString:@"0"] && [model.countdown integerValue] > 0) {
            if ([model.notice isEqualToString:@"0"]) {
                //挪车通知未过时
                XLBNoticeViewController *noticeVC = [XLBNoticeViewController new];
                noticeVC.userId = model.uid;
                noticeVC.imgUrl = model.img;
                noticeVC.nickname = model.nickname;
                noticeVC.timeDown = [model.countdown integerValue];
                noticeVC.moveCarId = model.createID;
                noticeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:noticeVC animated:YES];

            }else {
                XLBMoveCarNoticeViewController *moveCarNotice = [[XLBMoveCarNoticeViewController alloc] init];
                moveCarNotice.carId = model.createID;
                
                moveCarNotice.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:moveCarNotice animated:YES];
            }
            
        }else {
            
            XLBMoveCarDetailViewController *moveCarSuccess = [[XLBMoveCarDetailViewController alloc] init];
            moveCarSuccess.hidesBottomBarWhenPushed = YES;
            moveCarSuccess.model = model;
            [self.navigationController pushViewController:moveCarSuccess animated:YES];

        }

    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"网络错误，请点击重试"];
    }];
}

//- (NSMutableArray *)data {
//    if (!_data) {
//        _data = [NSMutableArray array];
//    }
//    return _data;
//}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120*kiphone6_ScreenHeight;
    self.tableView.backgroundColor = RGB(247, 247, 247);
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
