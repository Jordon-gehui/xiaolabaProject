//
//  MoveCarNotifitionVC.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/27.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MoveCarNotifitionVC.h"
#import "XLBMeRequestModel.h"
#import "MoveCarNotCell.h"
#import "XLBNoticeViewController.h"
#import "XLBMoveCarNoticeViewController.h"
#import "XLBMoveCarDetailViewController.h"
#import "XLBErrorView.h"

@interface MoveCarNotifitionVC ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>
{
    BOOL isMove;
}

@property (nonatomic, strong) XLBErrorView *errorV;


@end

@implementation MoveCarNotifitionVC
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isMove = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挪车通知";
    self.naviBar.slTitleLabel.text = @"挪车通知";
    [MobClick event:@"MoveCarNotion"];
    self.tableView.backgroundColor = RGB(247, 247, 247);
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MoveCarNotCell class] forCellReuseIdentifier:[MoveCarNotCell cellReuseIdentifier]];
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    isMove = NO;
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
                                       @"size":@(30)}};
    kWeakSelf(self);

    [XLBMeRequestModel requestMoveCarNotList:params success:^(NSArray<XLBMoveRecordsModel *> *models) {
        if (self.page == 1 && models.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"还没有挪车通知哦～"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            self.errorV.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page ==1) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoveCarNotCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoveCarNotCell cellReuseIdentifier] forIndexPath:indexPath];
    [cell setViewData:[self.data objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isMove == NO ) {
        isMove = YES;
        XLBMoveRecordsModel *model = self.data[indexPath.row];
        if (kNotNil(model.createID)) {
            [self requestWithID:model.createID];
        }
    }else {
        return;
    }
}


- (void)requestWithID:(NSString *)ID {
    NSDictionary *dict = @{@"id":ID};
    [[NetWorking network] POST:KFindByDetail params:dict cache:NO success:^(id result) {
        NSLog(@"%@",result);
        XLBMoveRecordsModel *model = [XLBMoveRecordsModel mj_objectWithKeyValues:result];
        if ([model.status isEqualToString:@"0"] && [model.countdown integerValue] > 0 && [model.notice isEqualToString:@"1"]) {
            XLBMoveCarNoticeViewController *moveCarNotice = [[XLBMoveCarNoticeViewController alloc] init];
            moveCarNotice.carId = model.createID;
            moveCarNotice.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moveCarNotice animated:YES];
            
        }else {
            XLBMoveCarDetailViewController *moveCarSuccess = [[XLBMoveCarDetailViewController alloc] init];
            moveCarSuccess.hidesBottomBarWhenPushed = YES;
            moveCarSuccess.model = model;
            [self.navigationController pushViewController:moveCarSuccess animated:YES];
        }
        
    } failure:^(NSString *description) {
        
    }];
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
