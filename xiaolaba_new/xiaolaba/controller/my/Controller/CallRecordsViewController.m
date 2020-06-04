//
//  CallRecordsViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CallRecordsViewController.h"
#import "CallRecordsCell.h"
#import "XLBErrorView.h"
#import "XLBMeRequestModel.h"
#import "CallOrderDeatilsVC.h"
#import "VoiceActorOwnerViewController.h"

@interface CallRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate,CallRecordsCellDelegate>
{
    UIView *selectLineView;
    NSInteger isSelectCalling;
    UIButton *callingBtn;
    UIButton *calledBtn;
}
@property (nonatomic, strong) XLBErrorView *errorV;


@end

@implementation CallRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下单记录";
    self.naviBar.slTitleLabel.text = @"下单记录";
    isSelectCalling = 1;
    self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom);
    self.tableView.backgroundColor = RGB(247, 247, 247);
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CallRecordsCell class] forCellReuseIdentifier:[CallRecordsCell cellReuseIdentifier]];
    self.allowRefresh = YES;
    self.allowLoadMore = YES;

    // Do any additional setup after loading the view.
}
-(void)initNaviBar {
    [super initNaviBar];
    if ([[XLBUser user].status isEqualToString:@"3"]) {
        [self createTitleBtn];
    }
}
- (void)createTitleBtn {

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(52, 0, 150, 44)];//allocate titleView
    self.navigationItem.titleView = titleView;
    titleView.frame = self.navigationItem.titleView.frame;

    callingBtn = [UIButton new];
    [callingBtn setFrame:CGRectMake(titleView.left, 4, 70, 38)];
    [callingBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [callingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [callingBtn setTitleColor:[UIColor commonTextColor] forState:0];
    [callingBtn setTitle:@"下单记录" forState:0];
    [titleView addSubview:callingBtn];
    
    calledBtn = [UIButton new];
    [calledBtn setFrame:CGRectMake(titleView.left+80, 4, 70, 38)];
    [calledBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [calledBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [calledBtn setTitleColor:[UIColor commonTextColor] forState:0];
    [calledBtn setTitle:@"接单记录" forState:0];
    [titleView addSubview:calledBtn];
    selectLineView = [UIView new];
    selectLineView.backgroundColor = [UIColor commonTextColor];
    [titleView addSubview:selectLineView];
    [selectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(callingBtn.mas_bottom);
        make.centerX.mas_equalTo(callingBtn);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(2);
    }];
    //Set to titleView
    self.navigationItem.titleView = titleView;
    [self.navigationItem.titleView layoutIfNeeded];
    NSLog(@"%lf===%f",self.navigationItem.titleView.frame.origin.x,self.navigationItem.titleView.frame.size.width);
}
-(void)titleClick:(UIButton*)sender{
NSLog(@"%lf===%f",self.navigationItem.titleView.frame.origin.x,self.navigationItem.titleView.frame.size.width);
    [self showHudWithText:@"加载中"];
    if ([sender.titleLabel.text isEqualToString:@"接单记录"]) {
        isSelectCalling = 0;
        [selectLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(callingBtn.mas_bottom);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
            make.centerX.mas_equalTo(calledBtn);
        }];
        [self refresh];
    }else{
        isSelectCalling = 1;
        [selectLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(callingBtn.mas_bottom);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
            make.centerX.mas_equalTo(callingBtn);
        }];
        [self refresh];
    }
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
    
    [XLBMeRequestModel requestCallOrderInfo:params isSY:isSelectCalling success:^(NSArray<XLBMeCarDetailModel *> *models) {
        [weakSelf hideHud];
        NSLog(@"%@",models);
        if (weakSelf.page == 1 && models.count==0) {
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
            [weakSelf.data addObjectsFromArray:models];
            [weakSelf.tableView reloadData];
            if (models.count<20) {
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
    } more:^(BOOL more) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CallRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:[CallRecordsCell cellReuseIdentifier] forIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setViewData:[self.data objectAtIndex:indexPath.row] issecectCalling:isSelectCalling];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CallOrderDeatilsVC *vc = [CallOrderDeatilsVC new];
    vc.orderModel = [self.data objectAtIndex:indexPath.row];
    vc.isPlace = isSelectCalling;
    [self.navigationController pushViewController:vc animated:YES];
//    [[CSRouter share] push:@"CallOrderDeatilsVC" Params:nil hideBar:YES];

}
- (void)callHeaderImgClick:(NSString *)modelid issy:(NSString*)isSY{
    if ([isSY isEqualToString:@"3"]) {
        VoiceActorOwnerViewController * oner = [VoiceActorOwnerViewController new];
        oner.userID = modelid;
        oner.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:oner animated:YES];
    }else{
        OwnerViewController * oner = [OwnerViewController new];
        oner.userID = modelid;
        oner.delFlag = 0;
        oner.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:oner animated:YES];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

