//
//  XLBFllowFansViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFllowFansViewController.h"
#import "XLBFllowFansCell.h"
#import "XLBMeRequestModel.h"
#import "XLBErrorView.h"
@interface XLBFllowFansViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>
//{
//    NSInteger _curr;            // 请求起始点
//    NSInteger _size;            // 一页数据量
//    BOOL _hasMore;               // 是否还有更多
//}
@property (nonatomic, assign) BOOL isFllow;
@property (nonatomic, assign) BOOL isNotice;
@property (nonatomic, assign) FllowFansType type;

//@property (nonatomic, strong) NSMutableArray *data;
//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XLBErrorView *errorV;

@end

@implementation XLBFllowFansViewController

- (instancetype)initWith:(FllowFansType )type {
    
    if(self = [super init]) {
        
        self.title = [self vc_title:type];
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.slTitleLabel.text = [self vc_title:self.type];
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 70.0f;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.isGrouped = YES;
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
//    _curr = 1;
//    _size = 10;
//    _hasMore = YES;
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
    [XLBMeRequestModel requestFindFollowOrFocus:self.isFllow notice:self.isNotice params:params success:^(NSArray<XLBFllowFansModel *> *models) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBFllowFansCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBFllowFansCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBFllowFansCell class]) owner:self options:nil].lastObject;
        cell.isFllow = self.isFllow;
    }
    cell.model = self.data[indexPath.row];
    cell.handle_button.tag = indexPath.row;
//    cell.handle_label.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBFllowFansModel *model = self.data[indexPath.row];
    XLBFllowFansCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    OwnerViewController *ownerVC = [[OwnerViewController alloc] init];
    ownerVC.userID = model.user.ID;
    ownerVC.delFlag = 0;
    ownerVC.returnBlock = ^(id data) {
        NSDictionary *params = (NSDictionary *)data;
        NSString *string = [params objectForKey:@"follows"];
        if (kNotNil(string)) {
            if (_isFllow == NO) {
                if ([string isEqualToString:@"1"]) {
                    model.type = @"2";
                    cell.model = model;
                }else {
                    model.type = @"1";
                    cell.model = model;
                }
            }else {
                if ([string isEqualToString:@"0"]) {
                    model.type = @"0";
                    cell.model = model;
                }else {
                    model.type = @"1";
                    cell.model = model;
                }
            }
            
            [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:ownerVC animated:YES];
//    [[CSRouter share]push:@"OwnerViewController" Params:@{@"userID":model.user.ID,@"":@0} hideBar:YES];
}




- (NSString *)vc_title:(FllowFansType )type {
    
    switch (type) {
        case FllowFansTypeFllow: {
            self.isFllow = YES;
            self.isNotice = YES;
            return @"关注";
        }
            break;
        case FllowFansTypeFans: {
            self.isFllow = NO;
            self.isNotice = NO;
            return @"粉丝";
        }
            break;
            
        default:
            break;
    }
}
//
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
    [self refresh];
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
