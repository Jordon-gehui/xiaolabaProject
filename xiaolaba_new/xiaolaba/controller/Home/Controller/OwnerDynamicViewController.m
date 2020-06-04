//
//  OwnerDynamicViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "OwnerDynamicViewController.h"
#import "MainMomentsCell.h"
#import "XLBCompleteViewController.h"
#import "XLBRDViewController.h"
#import "LittleDetailViewController.h"
#import "ReportChatViewController.h"

@interface OwnerDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MainMomentsCellDelegate,XLBShareViewDelegate>

@property (strong,nonatomic) LittleHornTableViewModel *littleModel;

@property (nonatomic,strong) UILabel *nilLabel;

@property (assign,nonatomic) NSIndexPath *indexPath;

@property (nonatomic) NSInteger curr;
@property (copy,nonatomic) NSString *nilImageTag;

@property (copy,nonatomic) NSString *creatUserId;
@property (copy, nonatomic) NSString *isFollow;

@property (copy,nonatomic) LittleHornTableViewModel *delegateModel;//删除

@property (assign,nonatomic) BOOL isScorling;
@property (strong,nonatomic) NSMutableArray *reloadArr;
@end

static NSString *const celldef = @"celldef";
static NSString *const cellvalue1 = @"cellvalue1";
static NSString *const cellvalue2 = @"cellvalue2";

@implementation OwnerDynamicViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.returnBlock) {
        self.returnBlock(_isFollow);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.owerTitle;
    self.naviBar.slTitleLabel.text = self.owerTitle;
    _curr  = 1;
    //创建tableview
    [self creatTableView];
}
- (void)initNaviBar {
    [super initNaviBar];
    
    self.creatUserId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    
    if ([self.creatUserId isEqualToString:self.ID]) {
        
        UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [rightItem setImage:[UIImage imageNamed:@"icon_wd_fdt"] forState:0];
        [rightItem setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
        [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self.naviBar setRightItem:rightItem];
    }
}

- (void)rightClick {
    
    NSInteger  num = [[XLBUser user].userModel.status integerValue];
    
    if (num < 10 ) {
        
        [MBProgressHUD showError:@"请完善信息"];
        XLBCompleteViewController * com = [XLBCompleteViewController new];
        com.rightItemTag = @"1";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
        
    }else{
        
        XLBRDViewController * com = [XLBRDViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
        
    }
    
}
- (void)creatTableView{
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
    [self.view addSubview:self.tableView];
    
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
    
    NSDictionary *dict = @{@"page":@{@"curr":@(current),@"size":@"10"},@"createUser":self.ID};
    
    [[NetWorking network] POST:kCarList params:dict cache:NO success:^(id result) {
        NSLog(@"-------------------  车主首页2244--%@%@",kCarList,result);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSArray *listArr = result[@"list"];
        if (_curr ==1) {
            
            self.data = [LittleHornTableViewModel mj_objectArrayWithKeyValuesArray:listArr];
            if (self.data.count > 0) {
                self.nilLabel.hidden = YES;
                self.tableView.mj_footer.hidden = NO;
            }else {
                self.tableView.mj_footer.hidden = YES;
                self.nilLabel.hidden = NO;
            }
        }else {
            [self.data addObjectsFromArray:[LittleHornTableViewModel mj_objectArrayWithKeyValuesArray:listArr]];
        }
        [self.tableView reloadData];

        if (listArr.count<10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

    } failure:^(NSString *description) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (UILabel *)nilLabel {
    if (!_nilLabel) {
        _nilLabel = [UILabel new];
        _nilLabel.textAlignment = NSTextAlignmentCenter;
        _nilLabel.font = [UIFont systemFontOfSize:16];
        _nilLabel.textColor = RGB(174,181,194);
        _nilLabel.frame = CGRectMake((kSCREEN_WIDTH-200)/2.0, (kSCREEN_HEIGHT-150)/2.0, 200, 150);
        if ([self.creatUserId isEqualToString:self.ID]) {
            _nilLabel.text = @"快去发布你的第一条动态吧～";
        }else{
            _nilLabel.text = @"好友还未发表动态哦～";
        }
        [self.view addSubview:_nilLabel];
    }
    return _nilLabel;
}
#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
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
    if ([self.creatUserId isEqualToString:self.ID]) {
        littleCell.isSelf = YES;
    }
    littleCell.model = model;
    littleCell.delegate = self;
    littleCell.indexPath = indexPath;
    return littleCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"车主"];
    LittleHornTableViewModel *model =self.data[indexPath.row];
    MainMomentsCell *littleCell = [self.tableView cellForRowAtIndexPath:indexPath];
    //请求查看接口
    [self lookDataWith:model.ID with:littleCell];
    
}

- (void)lookDataWith:(NSString *)currentID with:(MainMomentsCell*)littleCell{
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
    };
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)lookBtnClick:(MainMomentsCell *)cell withId:(NSString *)currentId {
    [self pushDetailVC:cell type:nil];
}
- (void)commentBtnClick:(MainMomentsCell *)cell withID:(NSString *)currentId {
    [self pushDetailVC:cell type:@"read"];
}

- (void)deleteCell:(LittleHornTableViewModel *)model {
    //如果按钮是加在cell上的contentView上
    _delegateModel = model;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *share = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NetWorking network] POST:[NSString stringWithFormat:@"%@%@",kMyDellish,_delegateModel.ID] params:nil cache:NO success:^(id result) {
            if (self.data.count > 0) {
                for (int i =0; i<self.data.count; i++) {
                    LittleHornTableViewModel *model = self.data[i];
                    if ([model.ID isEqualToString:_delegateModel.ID]) {
                        [self.data removeObject:model];
                        [self.tableView  reloadData];
                    }
                }
            }
            [MBProgressHUD showError:@"删除成功"];
            if (self.data.count ==0) {
                [self.nilLabel setHidden:NO];
                self.tableView.mj_footer.hidden = YES;
            }
        } failure:^(NSString *description) {
            
            [MBProgressHUD showError:@"删除失败"];
            
        }];
    }];
    
    [alert addAction:cancle];
    [alert addAction:share];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)lookDataWith:(NSString *)currentID{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kLookLish,currentID];
    
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        
        NSLog(@"-----------------查看-%@--",result);
        
    } failure:^(NSString *description) {
        
    }];
    
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
//头像
- (void)headImageClick:(MainMomentsCell*)cell withId:(NSString *)userID {
    OwnerViewController * oner = [OwnerViewController new];
    oner.userID = userID;
    oner.delFlag = 0;
    oner.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:oner animated:YES];
}


- (void)contentImageClick:(NSArray *)image index:(NSInteger)index {

    ImageReviewViewController *im = [[ImageReviewViewController alloc] init];
    im.imageArray = image;
    im.currentIndex = [NSString stringWithFormat:@"%li",(long)index];
    im.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:im animated:YES completion:nil];
}
//关注
- (void)shareModelClick:(MainMomentsCell *)cell withId:(NSString *)contentId model:(LittleHornTableViewModel *)model {
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
//回复
- (void)reportClick:(MainMomentsCell*)cell {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isScorling = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScorling = NO;
    if (self.reloadArr.count>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:self.reloadArr withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}
-(NSMutableArray*)reloadArr {
    if (!_reloadArr) {
        _reloadArr = [NSMutableArray array];
    }
    return _reloadArr;
}

@end
