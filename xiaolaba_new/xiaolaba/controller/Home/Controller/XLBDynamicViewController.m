//
//  XLBDynamicViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBDynamicViewController.h"
#import "SLCycleScrollView.h"
#import "XLBIdentityViewController.h"
#import "BaseWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "XLBLocation.h"
#import "XLBCompleteViewController.h"
#import "XLBIdentSuccessViewController.h"
#import "XLBRDViewController.h"
#import "MomentsCell.h"
#import "LittleHeadView.h"
#import "LittleDetailViewController.h"
#import "LittleHeadModel.h"
#import "ScroHeadView.h"
#import "ScroHeadModel.h"
#import "XLBAlertController.h"
#import "LoginView.h"
#import "XLBLoginViewController.h"

@interface XLBDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MomentsCellDelegate>

@property (strong ,nonatomic) UIButton *rightItem;
@property (strong ,nonatomic) UIButton *followBu;//关注的人
@property (strong ,nonatomic) UIButton *fujinProBu;//附近的人
@property (strong ,nonatomic) UIButton *goodPeoBu;//好友
@property (strong ,nonatomic) UIButton *followLeftBu;//关注的人
@property (strong ,nonatomic) UIButton *fujinLeftProBu;//附近的人
@property (strong ,nonatomic) UIButton *goodLeftPeoBu;//好友

@property (strong,nonatomic) LittleHeadView *littleHeadView;
@property (strong,nonatomic) LittleHornTableViewModel *littleModel;
@property (strong,nonatomic) NSMutableArray *bannersArr;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (copy,nonatomic) NSString *shooseTag;
@property (strong,nonatomic) UIButton *chooseBu;
@property (strong,nonatomic) UIView *chooseView;
@property (nonatomic) NSInteger curr;
@property (strong,nonatomic) NSMutableArray *scroArr;
@property (strong,nonatomic) ScroHeadView *scroHeadView;

@property (assign,nonatomic) BOOL isScorling;
@property (strong,nonatomic) NSMutableArray *reloadArr;

@property (nonatomic, strong)NSArray *blackList;

@property (nonatomic, strong) UIButton *issueBtn;

@end

static NSString *const celldef = @"celldef";
static NSString *const cellvalue1 = @"cellvalue1";
static NSString *const cellvalue2 = @"cellvalue2";

@implementation XLBDynamicViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"rootShow" object:nil];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollCallback ?: self.didScrollCallback(scrollView);
}

- (void)viewDidLoad {
    self.isGrouped = YES;
    self.translucentNav = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //动态
    [self location];
    [self createTableView];
    //解档
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"mainData.archiver"];
    NSArray * mainData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (mainData) {
        self.data = [LittleHornTableViewModel mj_objectArrayWithKeyValuesArray:mainData];
    }
    
}

-(void)loadMore {
    _curr ++;
    [self getDataFromServer:_curr];
}
- (void)refresh {
    if (self.data.count==0) {
        _curr ++;
    }else{
        _curr = 1;
    }
    [self getDataFromServer:_curr];
}

-(void)chooseData:(UIButton *)button{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    button.selected = !button.selected;
    if (button.selected) {
        
        self.chooseView = [UIView new];
        
        self.chooseView.backgroundColor = [UIColor whiteColor];
        self.chooseView.layer.borderWidth = 0.5;
        [self.chooseView.layer setMasksToBounds:YES];
        [self.chooseView.layer setCornerRadius:4];
        self.chooseView.layer.borderColor = [UIColor lineColor].CGColor;
        
        [self.tableView addSubview:self.chooseView];
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSCREEN_WIDTH - 120);
            make.top.mas_equalTo(self.chooseBu.mas_bottom).with.offset(15);
            make.width.height.mas_equalTo(110);
        }];
        
        self.fujinLeftProBu = [UIButton new];
        self.fujinLeftProBu.frame = CGRectMake(10 , 15, 8, 10);
        [self.fujinLeftProBu setBackgroundImage:[UIImage imageNamed:@"icon_fx_dw"] forState:UIControlStateNormal];
        [self.fujinLeftProBu addTarget:self action:@selector(chooseClickBu:) forControlEvents:UIControlEventTouchUpInside];
        self.fujinLeftProBu.tag = 20;
        [self.chooseView addSubview:self.fujinLeftProBu];
        
        self.fujinProBu = [UIButton new];
        self.fujinProBu.frame = CGRectMake(30 , 10, 75, 20);
        [self.fujinProBu setTitle:@"附近的人" forState:UIControlStateNormal];
        [self.fujinProBu setTitleColor:[UIColor colorWithR:102 g:102 b:102] forState:UIControlStateNormal];
        self.fujinProBu.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.fujinProBu addTarget:self action:@selector(chooseClickBu:) forControlEvents:UIControlEventTouchUpInside];
        self.fujinProBu.tag = 20;
        [self.chooseView addSubview:self.fujinProBu];
        
        UILabel *lineOne = [UILabel new];
        lineOne.frame = CGRectMake(0, self.fujinProBu.bottom + 5, self.chooseView.width, 0.5);
        lineOne.backgroundColor = [UIColor lineColor];
        [self.chooseView addSubview:lineOne];
        
        
        self.followLeftBu = [UIButton new];
        self.followLeftBu.frame = CGRectMake(10 , self.fujinProBu.bottom + 15, 20, 20);
        [self.followLeftBu setBackgroundImage:[UIImage imageNamed:@"icon-yiguanzhu"] forState:UIControlStateNormal];
        [self.followLeftBu addTarget:self action:@selector(chooseClickBu:) forControlEvents:UIControlEventTouchUpInside];
        self.followLeftBu.tag = 21;
        [self.chooseView addSubview:self.followLeftBu];
        
        self.followBu = [UIButton new];
        self.followBu .frame = CGRectMake(30 , self.fujinProBu.bottom + 15, 75, 20);
        [self.followBu  setTitle:@"关注的人" forState:UIControlStateNormal];
        self.followBu .titleLabel.font = [UIFont systemFontOfSize:14];
        [self.followBu setTitleColor:[UIColor colorWithR:102 g:102 b:102] forState:UIControlStateNormal];
        
        [self.followBu  addTarget:self action:@selector(chooseClickBu:) forControlEvents:UIControlEventTouchUpInside];
        self.followBu .tag = 21;
        [self.chooseView addSubview:self.followBu];
        
        UILabel *lineTwo = [UILabel new];
        lineTwo.frame = CGRectMake(0, self.followBu.bottom + 5, self.chooseView.width, 0.5);
        lineTwo.backgroundColor = [UIColor lineColor];
        [self.chooseView addSubview:lineTwo];
        
        self.goodLeftPeoBu = [UIButton new];
        self.goodLeftPeoBu.frame = CGRectMake(10 , self.followBu.bottom + 15, 20, 20);
        [self.goodLeftPeoBu setBackgroundImage:[UIImage imageNamed:@"icon_zy_hy"] forState:UIControlStateNormal];
        [self.goodLeftPeoBu addTarget:self action:@selector(chooseClickBu:) forControlEvents:UIControlEventTouchUpInside];
        self.goodLeftPeoBu.tag = 22;
        [self.chooseView addSubview:self.goodLeftPeoBu];
        
        self.goodPeoBu = [UIButton new];
        self.goodPeoBu.frame = CGRectMake(30 , self.followBu.bottom + 15, 75, 20);
        [self.goodPeoBu setTitle:@"我的好友" forState:UIControlStateNormal];
        [self.goodPeoBu setTitleColor:[UIColor colorWithR:102 g:102 b:102] forState:UIControlStateNormal];
        
        self.goodPeoBu.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.goodPeoBu addTarget:self action:@selector(chooseClickBu:) forControlEvents:UIControlEventTouchUpInside];
        self.goodPeoBu.tag = 22;
        [self.chooseView addSubview:self.goodPeoBu];
        
    }else{
        
        [self.chooseView removeFromSuperview];
    }
}

- (void)chooseClickBu:(UIButton *)bu{
    if (bu.tag == 20) {
        self.shooseTag = @"0";
        [self.fujinProBu setTitleColor:[UIColor colorWithR:255 g:192 b:2] forState:UIControlStateNormal];
        
    }else if(bu.tag == 21){
        
        self.shooseTag = @"1";
        [self.followBu setTitleColor:[UIColor colorWithR:255 g:192 b:2] forState:UIControlStateNormal];
        
    }else{
        self.shooseTag = @"2";
        [self.goodPeoBu setTitleColor:[UIColor colorWithR:255 g:192 b:2] forState:UIControlStateNormal];
    }
    [self refresh];
    [self.chooseView removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [self.chooseView removeFromSuperview];
    self.chooseView.hidden = YES;
}
- (void)getDataFromServer:(NSInteger)current{
//    if(self.bannersArr.count==0) {
//        [self getBannerDeta];
//    }
    
    NSDictionary *dict;
    NSString *URL;
    if ([self.shooseTag isEqualToString:@"0"] || [self.shooseTag isEqualToString:@""]  || self.shooseTag == nil) {
        
        dict = @{@"page":@{@"curr":@(current),@"size":@"30"},@"longitude":[XLBUser user].longitude,@"latitude":[XLBUser user].latitude};
        if([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
            URL = [NSString stringWithFormat:@"%@",kHomeList];
        }else{
            URL = [NSString stringWithFormat:@"%@",kHomeListAnon];
        }
        
    }
    
//    else if([self.shooseTag isEqualToString:@"1"]) {
//        dict = @{@"page":@{@"curr":@(current),@"size":@"30"}};
//        URL = [NSString stringWithFormat:@"%@",kHomeFollowList];
//    }else if([self.shooseTag isEqualToString:@"2"]) {
//        dict = @{@"page":@{@"curr":@(current),@"size":@"30"}};
//        URL = [NSString stringWithFormat:@"%@",kHomeGoodFreList];
//    }
    
    [[NetWorking network] POST:URL params:dict cache:NO success:^(id result) {
        NSLog(@"-------------------  首页--%@  %@  %@",dict,result[@"offset"],result[@"next"]);
        
        NSMutableArray *listArr = [result[@"list"] mutableCopy];
        NSLog(@"数据数量%ld",listArr.count);
        for (int i = 0; i<listArr.count; i++) {
            
            NSDictionary *dic = listArr[i];
            NSString *createUser =[NSString stringWithFormat:@"%@",[dic objectForKey:@"createUser"]];
            //            NSLog(@"===666 %@===%@",[dic objectForKey:@"nickName"],createUser);
            
            for (NSString *userid in _blackList) {
                //                NSLog(@"===%@",[dic objectForKey:@"nickName"]);
                
                if ([createUser isEqualToString:userid]) {
                    [listArr removeObject:dic];
                    NSLog(@"删除===%@",[dic objectForKey:@"nickName"]);
                    i--;
                    break;
                }
            }
        }
        if (_curr ==1||self.data.count==0) {
            if (listArr.count!=0) {
                [self.data removeAllObjects];
                [self.littleModel.imgs removeAllObjects];
                self.data = [LittleHornTableViewModel mj_objectArrayWithKeyValuesArray:listArr];
            }
            [self.tableView reloadData];
        }else {
            NSInteger count = self.data.count-1;
            [self.data addObjectsFromArray:[LittleHornTableViewModel mj_objectArrayWithKeyValuesArray:listArr]];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if (_curr == 1 && listArr.count != 0) {
            NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            NSString *path=[docPath stringByAppendingPathComponent:@"mainData.archiver"];
            BOOL falg = [NSKeyedArchiver archiveRootObject:listArr toFile:path];
            if (falg == YES) {
                NSLog(@"归档成功");
            }else {
                NSLog(@"归档失败");
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        BOOL nextHome = [result[@"next"] boolValue];
        if (nextHome == NO || nextHome == 0) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
            
        }
        
    } failure:^(NSString *description) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


- (void)createTableView {
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:celldef];
    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:cellvalue1];
    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:cellvalue2];

    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    
//    self.issueBtn = [[UIButton alloc] init];
//    [self.issueBtn setBackgroundImage:[UIImage imageNamed:@"icon_fb_1"] forState:0];
//    [self.issueBtn setTitle:@"+发布动态" forState:0];
//    [self.issueBtn setTitleColor:[UIColor lightColor] forState:0];
//    self.issueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.issueBtn setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
//    [self.issueBtn addTarget:self action:@selector(issueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.issueBtn];
//    
//    [self.issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (iPhoneX) {
//            make.bottom.mas_equalTo(self.tableView.mas_bottom).with.offset(-110);
//        }else {
//            make.bottom.mas_equalTo(self.tableView.mas_bottom).with.offset(-80);
//        }
//        make.right.mas_equalTo(self.tableView.mas_right).with.offset(-10);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(110);
//    }];
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    LittleHornTableViewModel*model = self.data[indexPath.row];
    MomentsCell *littleCell;
    if (model.imgs.count ==1) {
        littleCell = [tableView dequeueReusableCellWithIdentifier:cellvalue1];
    }else if(model.imgs.count>1){
        littleCell = [tableView dequeueReusableCellWithIdentifier:cellvalue2];
    }else {
        littleCell = [tableView dequeueReusableCellWithIdentifier:celldef];
    }
    if (self.data.count > 0) {
        [littleCell setDelegate:self];
        littleCell.indexPath = indexPath;
        [littleCell setModel:self.data[indexPath.row]];
        
    }
    return littleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0.001);
    return view;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * view = [UIView new];
//    view.backgroundColor = [UIColor whiteColor];
//
//    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 100);
//
//
//    UILabel * label = [UILabel new];
//    label.frame = CGRectMake(15, 15, 100, 20);
//    label.text = @"动态";
//    label.font = [UIFont systemFontOfSize:15];
//    [view addSubview:label];
//
//
//    self.chooseBu = [UIButton new];
//    self.chooseBu.frame = CGRectMake(kSCREEN_WIDTH - 100, 15, 80, 20);
//    [self.chooseBu setTitle:@"附近的人 > " forState:UIControlStateNormal];
//    self.chooseBu.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.chooseBu.titleLabel.textAlignment = 2;
//    //    self.chooseBu.backgroundColor = [UIColor lightGrayColor];
//    [self.chooseBu addTarget:self action:@selector(chooseData:) forControlEvents:UIControlEventTouchUpInside];
//    [self.chooseBu setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//
//
//    [view addSubview:self.chooseBu];
//
//    if ([self.shooseTag isEqualToString:@"0"]) {
//
//        [self.chooseBu setTitle:@"附近的人 >" forState:UIControlStateNormal];
//
//        [self.chooseView removeFromSuperview];
//        self.chooseView.hidden = YES;
//
//
//    }else if ([self.shooseTag isEqualToString:@"1"]){
//
//        [self.chooseView removeFromSuperview];
//        self.chooseView.hidden = YES;
//        [self.chooseBu setTitle:@"关注的人 >" forState:UIControlStateNormal];
//
//    }else if ([self.shooseTag isEqualToString:@"2"])
//        [self.chooseBu setTitle:@"我的好友 >" forState:UIControlStateNormal];
//
//
//    UILabel * line = [UILabel new];
//    line.frame  = CGRectMake(0, self.chooseBu.bottom + 14, kSCREEN_WIDTH, 1);
//    line.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
//    [view addSubview:line];
//
//    return view;
//
//
//}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.chooseBu.selected = NO;
//    [self.chooseView removeFromSuperview];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
//
    [MobClick event:@"Dynamic_owner"];
    self.chooseBu.selected = NO;
    [self.chooseView removeFromSuperview];
    LittleHornTableViewModel *model =self.data[indexPath.row];
    MomentsCell *littleCell = [self.tableView cellForRowAtIndexPath:indexPath];
    //请求查看接口
    [self lookDataWith:model.ID with:littleCell];
    
}

- (void)lookDataWith:(NSString *)currentID with:(MomentsCell*)littleCell{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    NSString *str = [NSString stringWithFormat:@"%@%@",kLookLish,currentID];
    
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        littleCell.cellModel.views = [NSString stringWithFormat:@"%li",[littleCell.cellModel.views integerValue]+1];
        [self pushDetailVC:littleCell];
    } failure:^(NSString *description) {
        [self pushDetailVC:littleCell];
    }];
    
}
- (void)pushDetailVC:(MomentsCell*)littleCell {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    LittleDetailViewController *detail = [LittleDetailViewController new];
    detail.hidesBottomBarWhenPushed = YES;
    detail.detailModel = littleCell.cellModel;
    detail.returnBlock = ^(id data) {
        LittleHornTableViewModel *littleModl = data;
        int index = 0;
        for (int i=0; i<self.data.count; i++) {
            LittleHornTableViewModel *model =self.data[i];
            if ([littleModl.ID isEqualToString:model.ID]) {
                index = i;
                [self.data replaceObjectAtIndex:i withObject:littleModl];
            }
        }
        [littleCell setModel:littleModl];
        //        [self.tableView reloadData];
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    };
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - cell代理
-(void)cellReLoadDelegate:(NSIndexPath *)index {
    if (self.isScorling) {
        [self.reloadArr addObject:index];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}
//删除
- (void)deleteCell:(NSString *)userId {
    
}
//头像
- (void)headImageClick:(MomentsCell*)cell withId:(NSString *)userID {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.chooseBu.selected = NO;
    [self.chooseView removeFromSuperview];
    OwnerViewController * oner = [OwnerViewController new];
    oner.userID = userID;
    oner.delFlag = 0;
    oner.hidesBottomBarWhenPushed =YES;
    oner.returnBlock = ^(id data) {
        NSDictionary *params = (NSDictionary *)data;
        NSString *string = [params objectForKey:@"follows"];
        BOOL isrefresh = NO;
        if (kNotNil(string)) {
            if ([string isEqualToString:@"1"]) {
                for (LittleHornTableViewModel *model in self.data) {
                    if ([userID isEqualToString:model.createUser]) {
                        if (![model.follows isEqualToString:string]) {
                            model.follows = @"1";
                            isrefresh = YES;
                        }
                    }
                }
            }else {
                for (LittleHornTableViewModel *model in self.data) {
                    if ([userID isEqualToString:model.createUser]) {
                        if (![model.follows isEqualToString:string]) {
                            model.follows = @"0";
                            isrefresh = YES;
                        }
                    }
                }
            }
            if (isrefresh) {
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }
    };
    [self.navigationController pushViewController:oner animated:YES];
}
//关注
- (void)followClick:(MomentsCell*)cell withId:(NSString *)userID {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.chooseBu.selected = NO;
    [self.chooseView removeFromSuperview];
    NSDictionary *dict = @{@"followId": userID ?: @""};
    if ([cell.cellModel.follows isEqualToString:@"1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NetWorking network] POST:kCancleFollow params:dict cache:NO success:^(id result) {
                NSLog(@"-----%@",result);
                for (LittleHornTableViewModel *model in self.data) {
                    if ([userID isEqualToString:model.createUser]) {
                        model.follows = @"0";
                    }
                }
                [self.tableView reloadData];
            } failure:^(NSString *description) {
                [MBProgressHUD showError:@"取消关注失败"];
                
            }];
        }];
        [alert addAction:cancle];
        [alert addAction:creatain];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    }else{
        [[NetWorking network] POST:kAddFollow params:dict cache:NO success:^(id result) {
            for (LittleHornTableViewModel *model in self.data) {
                if ([userID isEqualToString:model.createUser]) {
                    model.follows = @"1";
                }
            }
            [self.tableView reloadData];
            
        } failure:^(NSString *description) {
            
            [MBProgressHUD showError:@"关注失败"];
            
        }];
    }
    
}
//点赞
- (void)zanBuAddClick:(MomentsCell*)cell withId:(NSString *)currentID withLike:(NSString *)like {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.chooseBu.selected = NO;
    [self.chooseView removeFromSuperview];
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubZanlish,currentID];
    if ([like isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"不能重复点赞"];
        return;
    }
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        for (LittleHornTableViewModel *model in self.data) {
            if ([currentID isEqualToString:model.ID]) {
                model.liked = @"1";
                NSString *str =[NSString stringWithFormat:@" %ld", [model.likes integerValue] + 1];
                model.likes = str;
                [cell setModel:model];
            }
        }
        //        [self.tableView reloadData];
        //        [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"点赞失败"];
        
    }];
}

- (void)issueBtnClick:(UIButton *)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.chooseBu.selected = NO;
    [self.chooseView removeFromSuperview];
    NSInteger  num = [[XLBUser user].userModel.status integerValue];
    
    if (num < 10 ) {
        
        [MBProgressHUD showError:@"请完善信息"];
        XLBCompleteViewController * com = [XLBCompleteViewController new];
        com.rightItemTag = @"1";
        com.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
        
    }else{
        [[CSRouter share]push:@"XLBRDViewController" Params:nil hideBar:YES];
    }
}

-(void)location {
    XLBLocation *location = [XLBLocation location];
    [location getCurrentLocationComplete:^(NSDictionary *location) {
        if(kNotNil(location)) {
            if([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
                //更新定位
                [[NetWorking network] postUpdateLocation:@{@"province":[XLBUser user].province,@"city":[XLBUser user].city,@"district":[XLBUser user].subLocality,@"longitude":[XLBUser user].longitude,@"latitude":[XLBUser user].latitude}];
            }
            
        }
    }];
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
