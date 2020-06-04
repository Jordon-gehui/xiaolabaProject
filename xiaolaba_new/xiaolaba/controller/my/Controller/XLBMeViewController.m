//
//  XLBMeViewController.m
//  xiaolaba
//
//  Created by lin on 2017/6/29.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMeViewController.h"
#import "XLBMeHeaderView.h"
#import "XLBMeCell.h"
#import "XLBFllowFansViewController.h"
#import "XLBMeRequestModel.h"
#import "XLBAlertController.h"
#import "NetWorking.h"
#import "XLBMyFriendsViewController.h"
#import "XLBIdentityViewController.h"
#import "XLBMyInfoShowSubViewController.h"
#import "XLBSystemSettingViewController.h"
#import "XLBMoveRecordsViewController.h"
#import "XLBIdentSuccessViewController.h"
#import "XLBCompleteViewController.h"
#import "XLBMyInfoSubShowViewController.h"
#import "MJRefresh.h"
#import "XLBRemindView.h"
#import "XLBNotLoginView.h"
#import "XLBLoginViewController.h"
#import "XLBNotLoginMeView.h"
#import "OwnerDynamicViewController.h"
#import "XLBChatViewController.h"
@interface XLBMeViewController () <XLBMeHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLBCompleteViewControllerDelegate,UITextFieldDelegate>
{
    UIView *showTipSetMoneyView;
    BOOL isShow;
}
@property (weak, nonatomic) IBOutlet UITableView *meTable;
@property (nonatomic, strong) NSMutableArray *settingSource;
//@property (nonatomic, strong) XLBUser *user;
@property (nonatomic, strong) XLBMeHeaderView *headerView;
@property (nonatomic, strong) XLBNotLoginView *notLoginV;
//@property (nonatomic, strong) XLBNotLoginMeView *notLoginV;
@property (nonatomic, assign) BOOL status;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mtable_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mtable_bottom;

@end

@implementation XLBMeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isShow = YES;
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [self noLogin];
        self.meTable.mj_header = nil;
    }else {
//        [self setUpdate];
//        if(![[[XLBCache cache]cache:@"guidance"] isEqualToString:@"guidance"]) {
//            XLBRemindView *remindV = [[XLBRemindView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
//            [XLBMeRequestModel requestInfo:^(XLBUser *user) {
//                remindV.userName = user.userModel.nickname;
//            } failure:^(NSString *error) {
//
//            }];
//        }
    }
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (iPhoneX) {
//        [self.meTable setContentOffset:CGPointMake(0,-88) animated:NO];
//    }else{
//        [self.meTable setContentOffset:CGPointMake(0,-22) animated:NO];
//    }
    if (iPhoneX) {
        self.mtable_top.constant = -44;
    }
}

- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];
    [self setUpdate];
    
    self.mtable_bottom.constant = self.tabBarController.view.top;
//    if (iPhoneX) {
//        self.mtable_top.constant = -88;
//    }else{
//        self.mtable_top.constant = -22;
//    }
    [MobClick event:@"MeInformation"];
    //    [self preferRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpdate) name:@"saveSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpdate) name:@"vehicleArea" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpdate) name:@"phoneSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpdate) name:@"followSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(setUpdate) name:@"loginSuccess" object:nil];
}
-(void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"icon_sz"];
    [rightItem setImage:image forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

-(void)rightClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }//ApplyForViewController  XLBSystemSettingViewController
    [[CSRouter share]push:@"XLBSystemSettingViewController" Params:nil hideBar:YES];
}
- (void)headerViewRightItemClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }//ApplyForViewController  XLBSystemSettingViewController
    [[CSRouter share]push:@"XLBSystemSettingViewController" Params:nil hideBar:YES];
}
- (void)setUpdate {
    
    if ([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        
        self.headerView = [[XLBMeHeaderView alloc] initWithUser:[XLBUser user] complete:self.status];
        self.headerView.delegate = self;
        self.meTable.tableHeaderView = self.headerView;
        self.meTable.tableFooterView = [UIView new];
        
        kWeakSelf(self);
        [XLBMeRequestModel requestInfo:^(XLBUser *user) {
//            weakSelf.user = user;
            [[NetWorking network] POST:kGETCertification params:nil cache:NO success:^(id result) {
                if (kNotNil(result)) {
                    user.imgAkira = [result objectForKey:@"imgAkira"];
                    user.imgStatus = [result objectForKey:@"imgStatus"];
                    user.voiceAkira = [result objectForKey:@"voiceAkira"];
                    user.voiceStatus = [result objectForKey:@"voiceStatus"];
                    user.priceAkira = [NSString stringWithFormat:@"%@",[result objectForKey:@"priceAkira"]];
                    user.onlineType = [result objectForKey:@"onlineType"];
                    user.type = [result objectForKey:@"type"];
                    user.status = [result objectForKey:@"status"];
                }
                self.status = [user.userModel.status integerValue] == 30 ? YES:NO;
//                weakSelf.headerView = [[XLBMeHeaderView alloc] initWithUser:user complete:self.status];
//                weakSelf.headerView.delegate = weakSelf;
                [weakSelf.headerView updateUser:user];
//                weakSelf.meTable.tableHeaderView = weakSelf.headerView;
//                weakSelf.meTable.tableFooterView = [UIView new];
                [weakSelf updateList:user];
                [self.meTable.mj_header endRefreshing];
                
            } failure:^(NSString *description) {
                self.status = [user.userModel.status integerValue] == 30 ? YES:NO;
//                weakSelf.headerView = [[XLBMeHeaderView alloc] initWithUser:user complete:self.status];
//                weakSelf.headerView.delegate = weakSelf;
                [weakSelf.headerView updateUser:user];
//                weakSelf.meTable.tableHeaderView = weakSelf.headerView;
//                weakSelf.meTable.tableFooterView = [UIView new];
                [weakSelf updateList:user];
                [weakSelf.headerView layoutIfNeeded];
                [self.meTable.mj_header endRefreshing];
            }];
            
            
        } failure:^(NSString *error) {
        }];
        
        if(![[[XLBCache cache]cache:@"guidance"] isEqualToString:@"guidance"] && [[self topViewController] isKindOfClass:[XLBMeViewController class]]) {
            XLBRemindView *remindV = [[XLBRemindView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
            [XLBMeRequestModel requestInfo:^(XLBUser *user) {
                remindV.userName = user.userModel.nickname;
            } failure:^(NSString *error) {
                
            }];
        }
    }
}

- (void)noLogin {
    [self updateList:nil];
    
    _notLoginV = [[XLBNotLoginView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH/1.59) type:@"1"];
    [_notLoginV.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.meTable.tableHeaderView = _notLoginV;
    self.meTable.tableFooterView = [UIView new];
}

- (void)loginBtnClick {
    [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:^(id data) {

    }];
}

- (NSMutableArray *)settingSource {
    if(!_settingSource) {
//        if (([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) || (![XLBUser user].isLogin || !kNotNil([XLBUser user].token))) {
//            _settingSource = [[DefaultList initMeSubList] mutableCopy];
//        }else {
//            _settingSource = [[DefaultList initMeList] mutableCopy];
//        }
        _settingSource = [[DefaultList initMeList] mutableCopy];
    }
    return _settingSource;
}

- (void)updateList:(XLBUser *)user {
    BOOL status = [user.userModel.status integerValue] == 30 ? YES:NO;
    NSArray <NSArray *>*temp;
//    if (([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) || (![XLBUser user].isLogin || !kNotNil([XLBUser user].token))) {
//        temp = [NSArray arrayWithArray:[[DefaultList initMeSubList] mutableCopy]];
//    }else {
//      temp = [NSArray arrayWithArray:[[DefaultList initMeList] mutableCopy]];
//    }
    temp = [NSArray arrayWithArray:[[DefaultList initMeList] mutableCopy]];
    [self.settingSource removeAllObjects];
    [temp enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        if(idx == 0) {
//            NSMutableArray *array = [NSMutableArray array];
//            NSArray <NSDictionary *>*x = [NSArray arrayWithArray:obj];
//            [x enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:obj];
//                if(kNotNil([obj objectForKey:@"title"]) && [[obj objectForKey:@"title"] isEqualToString:@"声优认证"]) {
//                    if (![user.status isEqualToString:@"3"]) {
//                        [mudic setValue:@"未认证" forKey:@"subtitle"];
//                        [mudic setValue:@"a7a7a7" forKey:@"subtitle_color"];
//                    }else {
//                        [mudic setValue:@"已认证" forKey:@"subtitle"];
//                        [mudic setValue:@"ffde02" forKey:@"subtitle_color"];
//                    }
//                }
//                if(kNotNil([mudic objectForKey:@"title"]) && [[mudic objectForKey:@"title"] isEqualToString:@"收费标准"]) {
//                    if ([XLBUser user].priceAkira ==nil) {
//                        [XLBUser user].priceAkira = @"0";
//                    }
//                    NSString *title = [NSString stringWithFormat:@"%@车币/分钟",[XLBUser user].priceAkira];
//                    [mudic setValue:title forKey:@"subtitle"];
//                    [mudic setValue:@"a2a2a2" forKey:@"subtitle_color"];
//                }
//
//                [array addObject:mudic];
//            }];
//            if (array.count >5) {
//                if (![user.status isEqualToString:@"3"]){
//                    [array removeObjectAtIndex:array.count-2];
//                }
//
//            }
//            [self.settingSource addObject:array];
//        }
//        else {
//
//        }
        NSMutableArray *array = [NSMutableArray array];
        NSArray <NSDictionary *>*x = [NSArray arrayWithArray:obj];
        [x enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:obj];
            if(kNotNil([obj objectForKey:@"title"]) && [[obj objectForKey:@"title"] isEqualToString:@"车辆认证"]) {
                if (kNotNil(user)) {
                    [mudic setValue:status ? @"已认证":@"未认证" forKey:@"subtitle"];
                    [mudic setValue:status ? @"ffde02":@"a7a7a7" forKey:@"subtitle_color"];
                }else {
                    [mudic setValue:nil forKey:@"subtitle"];
                    [mudic setValue:@"a7a7a7" forKey:@"subtitle_color"];
                }
            }
            [array addObject:mudic];
        }];
        [self.settingSource addObject:array];
    }];
    [self.meTable reloadData];
}

- (void)headerViewUpdateInfoClick {
    if ([[XLBUser user].userModel.status integerValue] < 10 || [XLBUser user].userModel.pick.count == 0) {
        XLBMyInfoSubShowViewController *myInfo = [[XLBMyInfoSubShowViewController alloc] init];
        myInfo.editUser = [XLBUser user];
        myInfo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myInfo animated:YES];
    }else {
        [[CSRouter share] push:@"XLBMyInfoShowSubViewController" Params:nil hideBar:YES];
    }
}
/**
 关注
 */
- (void)headerViewFollowClick {
    //    NSLog(@"关注");
    XLBFllowFansViewController *fllow = [[XLBFllowFansViewController alloc] initWith:FllowFansTypeFllow];
    fllow.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fllow animated:YES];

}
/**
 粉丝
 */
- (void)headerViewFollowerClick {
    //    NSLog(@"粉丝");
    XLBFllowFansViewController *fans = [[XLBFllowFansViewController alloc] initWith:FllowFansTypeFans];
    fans.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fans animated:YES];
}

/**
 好友
 */
- (void)headerViewMomentClick {
        NSLog(@"好友");
    [[CSRouter share] push:@"XLBMyFriendsViewController" Params:@{@"isMe":@1} hideBar:YES];
}

/**
 修改头像
 */

- (void)headerUserImageUpdateClick {
    [self showSheet];
}

- (void)headerViewCertiClick {
    if ([[XLBUser user].userModel.status integerValue] < 10) {
        [self pushCompleteVC];
    }else {
        [[CSRouter share] push:@"XLBIdentityViewController" Params:nil hideBar:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.settingSource.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.settingSource[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section == self.settingSource.count - 1) {
        return 0.f;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f*kiphone6_ScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMeCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMeCell class]) owner:self options:nil].lastObject;
    }
    NSArray *list = self.settingSource[indexPath.section];
    if (indexPath.row ==0) {
        [cell.topLine setHidden:YES];
    }else{
        [cell.topLine setHidden:YES];
    }
    if (list.count-1 ==indexPath.row) {
        [cell.bottomLine setHidden:NO];
    }else{
        [cell.bottomLine setHidden:YES];
    }
    NSDictionary *data = self.settingSource[indexPath.section][indexPath.row];
    cell.keyValue = data;
//        XLBUser *user= [XLBUser user];
//        if (!kNotNil(user.priceAkira)||[user.priceAkira isEqualToString:@"0"]) {
//            if ([user.status isEqualToString:@"3"]&&isShow) {
//                    if (indexPath.row==4) {
//                        UIView *view = [cell viewWithTag:23];
//                        [view removeFromSuperview];
//                        UIView *showSetView = [[UIView alloc]initWithFrame:CGRectMake(50, 52.0f*kiphone6_ScreenHeight-20, 230, 20)];
//                        showSetView.tag =23;
//                        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(30, 4, 22, 11)];
//                        imagev.image = [UIImage imageNamed:@"sanjiao"];
//                        imagev.alpha = 0.85;
//                        [showSetView addSubview:imagev];
//                        UIView *balckV = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 230, 5)];
//                        balckV.backgroundColor = [UIColor blackColor];
//                        balckV.alpha = 0.85;
//                        [showSetView addSubview:balckV];
//                        balckV.layer.mask = [ZZCHelper cornerRadiusUIBezierPath:XLBRoundCornerCellTypeTop :balckV.bounds size:CGSizeMake(5, 5)];
//                        [cell addSubview:showSetView];
//                    }
//                    if (indexPath.row==5) {
//                        UIView *view = [cell viewWithTag:33];
//                        [view removeFromSuperview];
//                        showTipSetMoneyView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 230, 52.0f*kiphone6_ScreenHeight)];
//                        showTipSetMoneyView.alpha = 0.85;
//                        showTipSetMoneyView.tag =33;
//                        showTipSetMoneyView.backgroundColor = [UIColor blackColor];
//                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSettingMoneyAlert)];
//                        [showTipSetMoneyView addGestureRecognizer:tap];
//                        UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 170, 40)];
//                        lbl.numberOfLines =2;
//                        lbl.font = [UIFont systemFontOfSize:12];
//                        NSString*string = @"您还未设置声优资费，设置后\n才能赚钱哦！  立即前往设置";
//                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//                        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length-6)];
//                        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(string.length-6, 6)];
//                        lbl.attributedText = attributedString;
//                        [showTipSetMoneyView addSubview:lbl];
//
//                        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(lbl.right, 5, 1, 40)];
//                        line.backgroundColor = RGB(102, 102, 102);
//                        [showTipSetMoneyView addSubview:line];
//                        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(line.right+8, line.top+5, 30, 30)];
//                        [button setImage:[UIImage imageNamed:@"icon_gb_b"] forState:0];
//                        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//                        [showTipSetMoneyView addSubview:button];
//                        showTipSetMoneyView.layer.mask = [ZZCHelper cornerRadiusUIBezierPath:XLBRoundCornerCellTypeBottom :showTipSetMoneyView.bounds size:CGSizeMake(5, 5)];
//
//                        [cell addSubview:showTipSetMoneyView];
//                    }
//            }
//        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    switch (indexPath.section) {
            
        case 0: {
            switch (indexPath.row) {
                case 0: {
//                    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
//                        OwnerDynamicViewController * ower = [OwnerDynamicViewController new];
//                        ower.ID = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID] ;
//                        ower.owerTitle = @"我的动态";
//                        ower.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:ower animated:YES];
//                    }else {
//                        [[CSRouter share]push:@"XLBAccountDetailViewController" Params:nil hideBar:YES];
//                    }
                    [MobClick event:@"MeDynamic"];
                    OwnerDynamicViewController * ower = [OwnerDynamicViewController new];
                    ower.ID = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID] ;
                    ower.owerTitle = @"我的动态";
                    ower.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:ower animated:YES];
                }
                    break;
                case 1: {
//                    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
//                        if ([[XLBUser user].userModel.status integerValue] < 10 || [XLBUser user].userModel.pick.count == 0) {
//                            [MBProgressHUD showError:@"请先完善个人资料"];
//                            return;
//                        }
//                        if ([[XLBUser user].imgStatus isEqualToString:@"0"]) {
//                            [[CSRouter share]push:@"CertificationPhotoViewController" Params:nil hideBar:YES];
//                            return;
//                        }
//                        if ([[XLBUser user].voiceStatus isEqualToString:@"0"]) {
//                            [[CSRouter share]push:@"TheRecordingViewController" Params:@{@"isPushTo":@"1"} hideBar:YES];
//                            return;
//                        }
//                        [[CSRouter share]push:@"MakingTheCertificationViewController" Params:nil hideBar:YES];
//                    }else {
//                        OwnerDynamicViewController * ower = [OwnerDynamicViewController new];
//                        ower.ID = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID] ;
//                        ower.owerTitle = @"我的动态";
//                        ower.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:ower animated:YES];
//                    }
                    [MobClick event:@"CarApprove"];
                    if ([[XLBUser user].userModel.status integerValue] < 10) {
                        [self showAlert];
                    }else {
                        if (self.status == YES) {
                            [[CSRouter share]push:@"XLBIdentSuccessViewController" Params:nil hideBar:YES];
                        }else {
                            [[CSRouter share]push:@"XLBIdentityViewController" Params:nil hideBar:YES];
                        }
                    }
                }
                    break;
                case 2: {
//                    [[CSRouter share] push:@"XLBMeAccountViewController" Params:nil hideBar:YES];
                    [[CSRouter share] push:@"XLBInviteFriendsViewController" Params:nil hideBar:YES];
                }
                    break;
                case 3: { //声优认证
//                    if ([[XLBUser user].userModel.status integerValue] < 10 || [XLBUser user].userModel.pick.count == 0) {
//                        [MBProgressHUD showError:@"请先完善个人资料"];
//                        return;
//                    }
//                    if ([[XLBUser user].imgStatus isEqualToString:@"0"]) {
//                        [[CSRouter share]push:@"CertificationPhotoViewController" Params:nil hideBar:YES];
//                        return;
//                    }
//                    if ([[XLBUser user].voiceStatus isEqualToString:@"0"]) {
//                        [[CSRouter share]push:@"TheRecordingViewController" Params:@{@"isPushTo":@"1"} hideBar:YES];
//                        return;
//                    }
//                    [[CSRouter share]push:@"MakingTheCertificationViewController" Params:nil hideBar:YES];
                    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:@"42327218134736896" conversationType:EMConversationTypeChat];
                    chat.hidesBottomBarWhenPushed = YES;
                    chat.nickname = @"小喇叭客服";
                    chat.avatar = @"http://zhangshangxiaolaba.oss-cn-shanghai.aliyuncs.com/avatar/02B4334D-92E0-4ADA-BCEE-8BB676BBA7DB.jpg";
                    chat.userId = @"42327218134736896";
                    [self.navigationController pushViewController:chat animated:YES];

                }
                    break;
                case 4: { //收费标准
//                    if (![[XLBUser user].status isEqualToString:@"3"]){
//                        [[CSRouter share]push:@"CallRecordsViewController" Params:nil hideBar:YES];
//                    }else{
//                        [self showSettingMoneyAlert];
//                    }
                    [[CSRouter share]push:@"LXBFeedBackListViewController" Params:nil hideBar:YES];
                }
                    break;
                case 5: { //通话记录
//                    [[CSRouter share]push:@"CallRecordsViewController" Params:nil hideBar:YES];
                    [[CSRouter share] push:@"XLBAboutMeViewController" Params:nil hideBar:YES];

                }
                    break;
                    
                default:
                    break;
                }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    if ([[XLBUser user].userModel.status integerValue] < 10) {
                        [self showAlert];
                    }else {
                        if (self.status == YES) {
                            [[CSRouter share]push:@"XLBIdentSuccessViewController" Params:nil hideBar:YES];
                        }else {
                            [[CSRouter share]push:@"XLBIdentityViewController" Params:nil hideBar:YES];
                        }
                    }
                }
                    break;
                case 1: {
                    [[CSRouter share] push:@"CarOrderViewController" Params:nil hideBar:YES];
                }
                    break;
                case 2: {
                    [[CSRouter share] push:@"XLBInviteFriendsViewController" Params:nil hideBar:YES];
                }
                    break;
                case 3: {
                    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:@"42327218134736896" conversationType:EMConversationTypeChat];
                    chat.hidesBottomBarWhenPushed = YES;
                    chat.nickname = @"小喇叭客服";
                    chat.avatar = @"http://zhangshangxiaolaba.oss-cn-shanghai.aliyuncs.com/avatar/02B4334D-92E0-4ADA-BCEE-8BB676BBA7DB.jpg";
                    chat.userId = @"42327218134736896";
                    [self.navigationController pushViewController:chat animated:YES];
                }
                    break;
                case 4: {
                    [[CSRouter share]push:@"LXBFeedBackListViewController" Params:nil hideBar:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)buttonClick {
    isShow = NO;
    [self.meTable reloadData];
}
- (void)showSettingMoneyAlert {
    isShow = NO;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入收费金额" preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入收费金额";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = 1;
        textField.delegate = self;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        //输出 检查是否正确无误
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        [self uploadMoney:[envirnmentNameTextField.text floatValue]];
    }]];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //金额限制text
    if (textField.tag == 1) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (textField.text.length >= 4&&string.length>0) {
            textField.text = @"10000";
            return NO;
        }
    }
    return YES;
}
-(void)uploadMoney:(CGFloat)moneyFloat{
    kWeakSelf(self)
    if (moneyFloat<0.1) {
        [MBProgressHUD showError:@"设置金额必须大于0"];
        return;
    }
    [[NetWorking network] POST:kSYMoney params:@{@"priceAkira":@(moneyFloat)} cache:NO success:^(id result) {
        NSLog(@"修改成功");
        NSNumber *number = [NSNumber numberWithFloat:moneyFloat];
        [XLBUser user].priceAkira = number;
        [weakSelf setUpdate];
    } failure:^(NSString *description) {
        NSLog(@"修改失败");
    }];
}
- (void)completeBtnClick:(XLBUser *)user {
    [self.headerView updateUser:user];
    [self.meTable.mj_header beginRefreshing];
    
}
- (void)showSheet {
    
    kWeakSelf(self);
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"拍照",@"从相册选取"] title:nil message:nil cancel:YES cancelBlock:^{
        
        NSLog(@"点击了取消");
    } itemBlock:^(NSUInteger index) {
        
        switch (index) {
            case 0: {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSLog(@"点击了拍照");
                    [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypeCamera];
                }
                else {
                    NSLog(@"模拟器打不开相机");
                }
            }
                break;
            case 1: {
                [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
                
            default:
                break;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showAlert {
    NSString *alertString = @"完善信息才能进行车辆认证哦～";
    
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"去完善信息"] title:nil message:alertString cancel:NO cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        if (index == 0) {
            [self pushCompleteVC];
        }
    }];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, alertString.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertString.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)pushCompleteVC {
    XLBCompleteViewController *completeVC = [[XLBCompleteViewController alloc] init];
    completeVC.rightItemTag = @"1";
    completeVC.delegate = self;
    completeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:completeVC animated:YES];
}

- (void)chooseCameraOrAlbum:(UIImagePickerControllerSourceType )type {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = type;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headerView.avatar_image.image = image;
    [self uploadUserImages:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadUserImages:(UIImage *)image {
    
    [MBProgressHUD showMessage:@""];
    [[NetWorking network] asyncUploadImage:image avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
        if (state == UploadStatusSuccess) {
            if (names) {
                NSDictionary *parameter = @{@"nickname":@"",
                                            @"sex":@"",
                                            @"age":@"",
                                            @"city":@"",
                                            @"signature":@"",
                                            @"img":names[0],};
                [XLBMeRequestModel reviseInfo:parameter error:^(NSString *error) {
                    
                    [self.meTable.mj_header beginRefreshing];

                    NSLog(@"保存用户信息%@",error);
                    if (kNotNil(error)) {
                        [MBProgressHUD showError:@"出错了，请重试"];
                    }
                    [MBProgressHUD hideHUD];
                    
                }];
            }
        }
    }];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saveSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"vehicleArea" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"phoneSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"followSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
