//
//  XLBPraiseListController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBPraiseListController.h"
#import "PraiseTableViewCell.h"
#import "XLBMeRequestModel.h"
#import "XLBFllowFansModel.h"
#import "XLBErrorView.h"
#import "LittleDetailViewController.h"

@interface XLBPraiseListController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>
{
    NSInteger _curr;            // 请求起始点
    NSInteger _size;            // 一页数据量
    BOOL _hasMore;               // 是否还有更多
}
//@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL praise;

@property (nonatomic, strong)XLBErrorView *errorV;

@end

@implementation XLBPraiseListController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([_praiseAndFans isEqualToString:@"粉丝"]) {
        self.title = @"关注";
        self.naviBar.slTitleLabel.text = @"关注";
        [MobClick event:@"FollowList"];
    }
    if ([_praiseAndFans isEqualToString:@"赞"]){
        [MobClick event:@"PraiseList"];
        self.title = @"赞";
        self.naviBar.slTitleLabel.text = @"赞";
        _praise = NO;
        
    }if ([_praiseAndFans isEqualToString:@"评论"]) {
        self.title = @"评论";
        self.naviBar.slTitleLabel.text = @"评论";
        [MobClick event:@"CommentList"];
        _praise = YES;
    }
    _curr = 1;
    _size = 10;
    _hasMore = YES;
    self.view.backgroundColor = [UIColor viewBackColor];
//    [self creatTableView];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    
    [self refresh];
}


- (void)refresh {
    [super refresh];
    
    self.page = 0;
    if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
        [self getData];
    }else {
        [self getPraiseRequest];
    }
}

- (void)loadMore {
    [super loadMore];
    if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
        [self getData];
    }else {
        [self getPraiseRequest];
    }
    
}

- (void)getData {
    self.page++;
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(30)}};
    kWeakSelf(self);
    NSLog(@"%@",params);
    [XLBMeRequestModel requestFindFollowOrFocus:NO notice:YES params:params success:^(NSArray<XLBFllowFansModel *> *models) {
        if (self.page == 1 && models.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [weakSelf.data removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
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


- (void)getPraiseRequest {
    self.page++;
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(30)}};
    kWeakSelf(self);
    
    [XLBMeRequestModel requsetPraiseOrComment:_praise params:params success:^(NSArray <PraiseModel *>*models) {
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
        [self.data removeAllObjects];
        [self.tableView reloadData];
        if (self.page ==1) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } more:^(BOOL more) {
        
    }];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    PraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PraiseTableViewCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PraiseTableViewCell class]) owner:self options:nil].lastObject;
    }
    if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
        cell.fansModel = self.data[indexPath.row];
        cell.userBtn.tag = indexPath.row;
        [cell.userBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([self.praiseAndFans isEqualToString:@"赞"]) {
        cell.praiseModel = self.data[indexPath.row];
        cell.nickSubLabel.text = @"赞了您";
        cell.userBtn.tag = indexPath.row;
        [cell.userBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([self.praiseAndFans isEqualToString:@"评论"]) {
        cell.praiseModel = self.data[indexPath.row];
        cell.nickSubLabel.text = @"评论了您";
        cell.userBtn.tag = indexPath.row;
        [cell.userBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
        XLBFllowFansModel *model = self.data[indexPath.row];
        PraiseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        OwnerViewController *owner = [[OwnerViewController alloc] init];
        owner.userID = model.user.ID;
        owner.delFlag = 0;
        owner.returnBlock = ^(id data) {
            NSDictionary *params = (NSDictionary *)data;
            NSString *string = [params objectForKey:@"follows"];
            if (kNotNil(string)) {
                if ([string isEqualToString:@"1"]) {
                    model.type = @"2";
                    cell.fansModel = model;
                }else {
                    model.type = @"1";
                    cell.fansModel = model;
                }
                [self.tableView reloadData];
            }
        };
        [self.navigationController pushViewController:owner animated:YES];
    }else {
        PraiseModel *model = self.data[indexPath.row];
        [self searchDynamicDetailsWithPraise:model];
    }
}

- (void)searchDynamicDetailsWithPraise:(PraiseModel *)model {
    if (kNotNil(model.initiatorId)) {
        [[NetWorking network] POST:kDynamic params:@{@"id":model.initiatorId} cache:NO success:^(id result) {
            if (kNotNil(result)) {
                LittleHornTableViewModel *model = [LittleHornTableViewModel mj_objectWithKeyValues:result];
                LittleDetailViewController *detail = [LittleDetailViewController new];
                detail.hidesBottomBarWhenPushed = YES;
                detail.detailModel = model;
                [self.navigationController pushViewController:detail animated:YES];
            }else {
                [[CSRouter share] push:@"XLBErrorViewController" Params:nil hideBar:YES];
            }
        } failure:^(NSString *description) {
            [MBProgressHUD showError:@"网络错误，请点击重试"];
        }];
    }else {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"delFlag":@0,@"userID":model.uid,} hideBar:YES];
    }
}

- (void)userBtnClick:(UIButton *)sender {
    if ([_praiseAndFans isEqualToString:@"粉丝"]) {
        if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
            XLBFllowFansModel *model = self.data[sender.tag];
            OwnerViewController *owner = [[OwnerViewController alloc] init];
            owner.userID = model.user.ID;
            owner.delFlag = 0;
            owner.returnBlock = ^(id data) {
                NSDictionary *params = (NSDictionary *)data;
                NSString *string = [params objectForKey:@"follows"];
                if (kNotNil(string)) {
                    if ([string isEqualToString:@"1"]) {
                        model.type = @"2";
                    }else {
                        model.type = @"1";
                    }
                    [self.tableView reloadData];
                }
            };
            [self.navigationController pushViewController:owner animated:YES];
        }
    }else {
        PraiseModel *model = self.data[sender.tag];
        if (kNotNil(model) && kNotNil(model.uid)) {
            [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":model.uid,@"delFlag":@0,} hideBar:YES];
        }
    }

}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    [self.view addSubview:self.tableView];
}


- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.tableView addSubview:self.errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
//    if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
//        [self requestData:YES];
//    }else {
//        [self praiseRequest:YES];
//    }
    self.page = 0;
    if ([self.praiseAndFans isEqualToString:@"粉丝"]) {
        [self getData];
    }else {
        [self getPraiseRequest];
    }
    
    
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
