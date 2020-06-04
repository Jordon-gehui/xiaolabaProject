//
//  XLBFriendDynamicVC.m
//  xiaolaba
//
//  Created by 斯陈 on 2019/3/9.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import "XLBFriendDynamicVC.h"
#import "SLCycleScrollView.h"
#import "XLBIdentityViewController.h"
#import "BaseWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "XLBLocation.h"
#import "XLBCompleteViewController.h"
#import "XLBIdentSuccessViewController.h"
#import "XLBRDViewController.h"
#import "MainMomentsCell.h"
#import "LittleHeadView.h"
#import "LittleDetailViewController.h"
#import "LittleHeadModel.h"
#import "ScroHeadView.h"
#import "ScroHeadModel.h"
#import "XLBAlertController.h"
#import "LoginView.h"
#import "XLBLoginViewController.h"
#import "XLBErrorView.h"
#import "ReportChatViewController.h"
@interface XLBFriendDynamicVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MainMomentsCellDelegate,XLBErrorViewDelegate,XLBShareViewDelegate>

@property (strong ,nonatomic) UITableView *tableView;
@property (strong ,nonatomic) NSMutableArray *data;
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

@property (nonatomic, strong) XLBErrorView *errorV;


@end

static NSString *const celldef = @"celldef";
static NSString *const cellvalue1 = @"cellvalue1";
static NSString *const cellvalue2 = @"cellvalue2";

@implementation XLBFriendDynamicVC

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //动态
    //    [self location];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [self createTableView];
    //解档
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"mainFriendsData.archiver"];
    NSArray * mainData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (mainData) {
        self.data = [LittleHornTableViewModel mj_objectArrayWithKeyValuesArray:mainData];
    }
}
- (void)loginSuccess{
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadMore {
    _curr ++;
    [self getDataFromServer:_curr];
}
- (void)refresh {
    _curr = 1;
    [self getDataFromServer:_curr];
}

- (void)getDataFromServer:(NSInteger)current{
    //    if(self.bannersArr.count==0) {
    //        [self getBannerDeta];
    //    }
    
    NSDictionary *dict = @{@"page":@{@"curr":@(current),@"size":@"30"}};
    NSString *URL = [NSString stringWithFormat:@"%@",kHomeGoodFreList];
    kWeakSelf(self);
    [[NetWorking network] POST:URL params:dict cache:NO success:^(id result) {
        NSLog(@"-------------------  首页--%@  %@",dict,result[@"offset"]);
        
        NSMutableArray *listArr = [result[@"list"] mutableCopy];
        NSLog(@"数据数量%ld",listArr.count);
        
        if (current == 1 && listArr.count == 0) {
            weakSelf.errorV.hidden = NO;
            [weakSelf.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [weakSelf.data removeAllObjects];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        }else {
            weakSelf.errorV.hidden = YES;
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
                NSString *path=[docPath stringByAppendingPathComponent:@"mainFriendsData.archiver"];
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
        }
    } failure:^(NSString *description) {
        weakSelf.errorV.hidden = NO;
        [weakSelf.data removeAllObjects];
        [weakSelf.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}


- (void)createTableView {
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsDefault]];
    
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsOneImageWidthCell]];
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsOneImageHeightCell]];
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsTwoImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsThreeImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsFourImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsFiveImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsSixImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsSevenImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsEightImageCell]];
    
    [self.tableView registerClass:[MainMomentsCell class] forCellReuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsNineImageCell]];
    
    //    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:celldef];
    //    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:cellvalue1];
    //    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:cellvalue2];
    if ([XLBUser user].isLogin || kNotNil([XLBUser user].token)) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    LittleHornTableViewModel*model = self.data[indexPath.row];
    MainMomentsCell *littleCell = [tableView cellForRowAtIndexPath:indexPath];
    if (littleCell == nil) {
        if (model.imgs.count == 0) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsDefault]];
        }else if (model.imgs.count == 1) {
            if ([model.height floatValue] > [model.width floatValue]) {
                littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsOneImageHeightCell]];
                
            }else {
                littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsOneImageWidthCell]];
            }
        }else if (model.imgs.count == 2) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsTwoImageCell]];
        }else if (model.imgs.count == 3) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsThreeImageCell]];
            
        }else if (model.imgs.count == 4) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsFourImageCell]];
        }else if (model.imgs.count == 5) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsFiveImageCell]];
            
        }else if (model.imgs.count == 6) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsSixImageCell]];
        }else if (model.imgs.count == 7) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsSevenImageCell]];
        }else if (model.imgs.count == 8) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsEightImageCell]];
        }else if (model.imgs.count == 9) {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsNineImageCell]];
        }else {
            littleCell = [[MainMomentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainMomentsCell mainMomentCellIDWith:MainMomentsDefault]];
        }
    }
    littleCell.model = model;
    littleCell.delegate = self;
    littleCell.indexPath = indexPath;
    return littleCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0.001);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    //    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
    //        [LoginView addLoginView];
    //        return;
    //    }
    
    [MobClick event:@"Dynamic_owner"];
    //    self.chooseBu.selected = NO;
    //    [self.chooseView removeFromSuperview];
    LittleHornTableViewModel *model =self.data[indexPath.row];
    MainMomentsCell *littleCell = [self.tableView cellForRowAtIndexPath:indexPath];
    //请求查看接口
    [self lookDataWith:model.ID with:littleCell];
    
}

- (void)lookDataWith:(NSString *)currentID with:(MainMomentsCell*)littleCell{
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
        littleCell.model.views = [NSString stringWithFormat:@"%li",[littleCell.model.views integerValue]+1];
        [self pushDetailVC:littleCell type:nil];
    } failure:^(NSString *description) {
        [self pushDetailVC:littleCell type:nil];
    }];
    
}
- (void)pushDetailVC:(MainMomentsCell*)littleCell type:(NSString *)type{

    LittleDetailViewController *detail = [LittleDetailViewController new];
    detail.hidesBottomBarWhenPushed = YES;
    detail.detailModel = littleCell.model;
    detail.type = type;
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

- (void)lookBtnClick:(MainMomentsCell *)cell withId:(NSString *)currentId {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    [self pushDetailVC:cell type:nil];
}
- (void)commentBtnClick:(MainMomentsCell *)cell withID:(NSString *)currentId {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    [self pushDetailVC:cell type:@"read"];
}
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
- (void)headImageClick:(MainMomentsCell*)cell withId:(NSString *)userID {
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

- (void)shareModelClick:(MainMomentsCell *)cell withId:(NSString *)contentId model:(LittleHornTableViewModel *)model {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    
    self.littleModel = model;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            [self setShareViewWithHidden:ShareBtnWeChatHidden];
        }else if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]){
            [self setShareViewWithHidden:ShareBtnWeiBoHidden];
        }else {
            [self setShareViewWithHidden:3];
        }
    }];
    
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报该内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReportChatViewController *chat = [ReportChatViewController new];
        chat.hidesBottomBarWhenPushed = YES;
        chat.reportType = @"1";
        chat.detailID = model.ID;
        [self.navigationController pushViewController:chat animated:YES];
    }];
    
    [alert addAction:cancle];
    [alert addAction:share];
    [alert addAction:report];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)setShareViewWithHidden:(ShareBtnHidden)hidden {
    XLBShareView *shareView = [[XLBShareView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:ShareViewDefault isHidden:hidden];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];
}
#pragma mark - share
- (void)shareViewBtnClickWithTag:(UIButton *)sender {
    switch (sender.tag) {
        case ShareViewWeChatBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneSession isWeiBo:NO];
        }
            break;
        case ShareViewWeChatPyqBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneTimeline isWeiBo:NO];
        }
            break;
        case ShareViewWeiBoBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneSession isWeiBo:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)shareViewWithWeChatType:(WechatShareScene)weChatType isWeiBo:(BOOL)weibo{
    BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:nil];
    shareModel.urlString = [NSString stringWithFormat:@"%@wechat/moment?id=%@",kDomainUrl,self.littleModel.ID];
    shareModel.title = [NSString stringWithFormat:@"来自%@的小喇叭动态",self.littleModel.nickName];
    if (kNotNil(self.littleModel.moment) && [self.littleModel.moment hasSuffix:@"\n"]) {
        NSString *b = [self.littleModel.moment stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        if (weibo == YES) {
            shareModel.text = b;
        }else {
            shareModel.describe = b;
        }
    }else {
        if (weibo == YES) {
            shareModel.text = self.littleModel.moment;
        }else {
            shareModel.describe = self.littleModel.moment;
        }
    }
    
    UIImage *imag;
    if (kNotNil(self.littleModel.imgs) && self.littleModel.imgs.count > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:self.littleModel.imgs[0] Withtype:IMGAvatar]]];
        imag = [UIImage imageWithData:data];
    }else {
        if (weibo == YES) {
            imag = [UIImage imageNamed:@"pic_m"];
        }else {
            imag = [UIImage imageNamed:@"abc"];
        }
    }
    shareModel.image = imag;
    
    if (weibo == YES) {
        [[BQLAuthEngine sharedAuthEngine] auth_sina_share_link:shareModel success:^(id response) {
        } failure:^(NSString *error) {
        }];
    }else {
        [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_link:shareModel scene:weChatType success:^(id response) {
        } failure:^(NSString *error) {
        }];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubSharelish,self.littleModel.ID];
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
    } failure:^(NSString *description) {
    }];
}
//点赞
- (void)zanBuAddClick:(MainMomentsCell*)cell withId:(NSString *)currentID withLike:(NSString *)like {
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
        //        [MBProgressHUD showError:@"不能重复点赞"];
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

- (void)contentImageClick:(NSArray *)image index:(NSInteger)index {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    ImageReviewViewController *im = [[ImageReviewViewController alloc] init];
    im.imageArray = image;
    im.currentIndex = [NSString stringWithFormat:@"%li",(long)index];
    im.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:im animated:YES completion:nil];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [UIColor viewBackColor];
        kWeakSelf(self);
        _tableView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refresh];
        }];
        
        _tableView.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
