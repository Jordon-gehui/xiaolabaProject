//
//  OwnerPageViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "OwnerViewController.h"
#import "OwnerHeadView.h"
#import "OwnerRequestManager.h"
#import "OwnerDynamicViewController.h"
#import "OwnerInfoModel.h"
#import "XLBOwnerModel.h"
#import "OwnerInfoTableViewCell.h"
#import "OwnerImageTableViewCell.h"
#import "XLBChatViewController.h"
#import "XLBNoticeViewController.h"
#import "MoveCarVerifyViewController.h"
#import "ImageReviewViewController.h"
#import "XLBMoveCarNoticeViewController.h"
#import "LittleHeadModel.h"
#import "LittleHornTableViewModel.h"
#import "XLBAlertController.h"
#import "ReportChatViewController.h"
#import "XLBCallView.h"
#import "XLBCallSubView.h"
#import "XLBCarRemindView.h"

#define MAX_STARWORDS_LENGTH 20
@interface OwnerViewController ()<UITableViewDelegate,UITableViewDataSource,OwnerHeadViewDelegate,XLBShareViewDelegate>
{
    NSInteger _curr;            // 请求起始点
    NSInteger _size;            // 一页数据量
    NSString *follows;
    NSString *praise;
    NSString *likeSum;
    NSString *deviceNo;
    UITextField *addTextField;
}
@property (strong,nonatomic) NSMutableArray *headModelArr;
@property (strong,nonatomic) LittleHeadModel *headModel;
@property (strong, nonatomic) NSMutableArray *imgArr;
@property (strong,nonatomic) Imgs *imgModel;
@property (strong, nonatomic) OwnerHeadView *ownerHeadView;
@property (strong, nonatomic) XLBOwnerModel *ownerModel;
@property (assign, nonatomic) BOOL isFriend;
@property (assign, nonatomic) BOOL isFollow;
@property (strong, nonatomic) UIButton *moveCarBtn;
@property (strong, nonatomic) UIView *btnBgView;
@property (strong, nonatomic) UIView *meunView;
@property (strong, nonatomic) XLBCallView *callView;
@property (strong, nonatomic) XLBCallSubView *callSubView;


@property (nonatomic, strong)NSMutableArray *blackList;
@end

@implementation OwnerViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.naviBar setHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MobClick event:@"CarFansHomePage"];
    likeSum = @"0";
    follows = @"0";
    praise = @"0";
    _blackList=[[[XLBCache cache]cache:@"BlackList"] mutableCopy];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(-150*kiphone6_ScreenHeight, 0, 0, 0);
    self.moveCarBtn = [UIButton new];
    [self.moveCarBtn addTarget:self action:@selector(moveCatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.moveCarBtn.hidden = YES;
    [self.moveCarBtn setBackgroundImage:[UIImage imageNamed:@"btn_nc"] forState:UIControlStateNormal];
    [self.view addSubview:_moveCarBtn];
    
    NSString *ownerRemind = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerRemind"];
    NSString *userId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    if (!kNotNil(ownerRemind) && self.delFlag != 0 && self.userID != userId) {
        XLBCarRemindView *remindView = [[XLBCarRemindView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:@"ownerRemind"];
    }
    
    [self getOwnerInfo];
    
    self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom);
    
    [self setup];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.returnBlock) {
        NSDictionary *params = @{@"follows":follows,@"praise":praise,@"likeSum":likeSum,};
        self.returnBlock(params);
    }
}
- (void)initNaviBar {
    [super initNaviBar];

    UIButton *reportItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [reportItem setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
    [reportItem addTarget:self action:@selector(rightClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:reportItem];
}
- (void)rightClick2 {
    BOOL isBlack = NO;
    for (NSString*stering in _blackList) {
        if ([stering isEqualToString:self.userID]) {
            isBlack = YES;
            continue;
        }
    }
    NSArray *array =@[@"分享给朋友",@"举报用户",isBlack ? @"移除黑名单":@"加入黑名单"];
    if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        array =@[@"举报用户",isBlack ? @"移除黑名单":@"加入黑名单"];
    }
    kWeakSelf(self);
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:array title:nil message:nil cancel:YES cancelBlock:^{
        
        NSLog(@"点击了取消");
    } itemBlock:^(NSUInteger index) {
        switch (index) {
            case 2:
                [weakSelf blackListAddOwner];
                break;
            case 1:
                if (array.count ==3) {
                    [weakSelf reportOwner];
                }else{
                    [weakSelf blackListAddOwner];
                }
                break;
            default:
                if (array.count ==3) {
                    [weakSelf shareOwner];
                }else{
                    [weakSelf reportOwner];
                }
                break;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setup {
    self.view.backgroundColor = [UIColor navBackColor];//230
    self.ownerHeadView = [[OwnerHeadView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH + 70)];
    self.tableView.backgroundColor = [UIColor navBackColor];
    self.ownerHeadView.delegate = self;
    self.ownerHeadView.model = self.ownerModel;
    [self.ownerHeadView.friendBtn addTarget:self action:@selector(friendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ownerHeadView.imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ownerHeadView.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ownerHeadView.portraitBtn addTarget:self action:@selector(portraitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ownerHeadView.praiseBtn addTarget:self action:@selector(pariseBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.ownerHeadView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = self.ownerHeadView;
}

- (void)getOwnerInfo {
    
    if (!kNotNil(self.userID)) return;
    kWeakSelf(self);
    [weakSelf showHudWithText:@""];
    
    NSDictionary *parae = @{@"createUser":self.userID,@"delFlag":[NSString stringWithFormat:@"%li",(long)self.delFlag]};
    
    [OwnerRequestManager requestOwnerWithParameter:parae success:^(XLBOwnerModel *respones) {
        [weakSelf hideHud];
        self.ownerModel = respones;
        self.ownerHeadView.model = respones;
        self.naviBar.slTitleLabel.text = respones.nickname;
        NSString *userId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
        if (kNotNil(respones)) {
            deviceNo = respones.deviceNo;
            if (![userId isEqualToString:self.userID] && self.delFlag != 0) {
                self.moveCarBtn.hidden = NO;
            }
            if (([respones.follows isEqualToString:@"0"])) {
                self.isFollow = NO;
            }
            if ([respones.follows isEqualToString:@"1"]) {
                self.isFollow = YES;
            }
            if ([respones.friends isEqualToString:@"0"]) {
                self.isFriend = NO;
            }
            if ([respones.friends isEqualToString:@"1"]) {
                self.isFriend = YES;
            }
            praise = respones.liked;
            follows = respones.follows;
        }
        [self.tableView reloadData];
    } error:^(id error) {
        [weakSelf hideHud];
        praise = @"0";
        follows= @"0";
        [MBProgressHUD showError:@"出错了"];
    }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60/375.0*kSCREEN_WIDTH+46;
    }
    return 300*kiphone6_ScreenHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        OwnerImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OwnerImageTableViewCell cellIdentifie]];
        if (!cell) {
            cell = [[OwnerImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OwnerImageTableViewCell cellIdentifie]];;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.momentsCount = self.ownerModel.momentCount;
        cell.momentImg = self.ownerModel.momentsImg;
        
//        [cell.allBigBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        OwnerInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:[OwnerInfoTableViewCell cellID]];
        if (!infoCell) {
            infoCell = [[OwnerInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OwnerInfoTableViewCell cellID]];
        }
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        infoCell.owner = self.ownerModel;
        
        return infoCell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self allDynamic];
    }
}

- (void)viewWillLayoutSubviews {
    kWeakSelf(self);
    [self.moveCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).mas_offset(-20);
        make.width.height.mas_equalTo(120);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        
    }];
}

- (void)friendBtnClick:(UIButton *)sender {
    //加好友
    
    if (self.isFriend == YES) {
        [MBProgressHUD showError:@"已是你的好友或者等待同意"];
        return;
    }
    if (!kNotNil(self.ownerModel.ID)) {
        return;
    }
    [self showAddfriendMsgAlert];
    
}
- (void)showAddfriendMsgAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您将向对方发送好友请求" preferredStyle:UIAlertControllerStyleAlert];
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入附加信息";
        addTextField = textField;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:addTextField];
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        
        //输出 检查是否正确无误
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        if(kNotNil(envirnmentNameTextField.text)){
            [self addfriend:envirnmentNameTextField.text];
        }else{
            [self addfriend:@""];
        }
    }]];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}
-(void)addfriend:(NSString*)string{
    kWeakSelf(self);
    
    [weakSelf showHudWithText:@""];
    [[NetWorking network] POST:kAddFriend params:@{@"friendId":self.ownerModel.ID,@"message":string} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 加好友 %@",result);
        [weakSelf hideHud];
        [MBProgressHUD showError:@"已发送好友请求"];
        self.isFriend = YES;
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"添加好友失败"];
    }];
}
- (void)imgBtnClick:(UIButton *)sender {
    //打招呼
    if (!kNotNil(self.userID)) return;
    
    NSString *messageID = [NSString stringWithFormat:@"%@",self.userID];
    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:messageID conversationType:EMConversationTypeChat];
    chat.nickname = self.ownerModel.nickname;
    chat.avatar = self.ownerModel.img;
    chat.userId = messageID;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (void)showImage {
    ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
    if (!kNotNil(self.ownerModel.pick[0])) {
        UIImage *image = [UIImage imageNamed:@"pic_m"];
        NSArray *array = [NSArray arrayWithObject:image];
        vc.imageArray = (NSMutableArray *)array;
    }else {
        vc.imageArray = (NSMutableArray *)self.ownerModel.pick;
    }
    vc.currentIndex = @"0";
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
//头像预览
- (void)portraitBtnClick:(UIButton *)sender {
    if (kNotNil(self.ownerModel.img)) {
        NSArray *array = [NSArray arrayWithObject:self.ownerModel.img];
        ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
        vc.imageArray = (NSMutableArray *)array;
        vc.currentIndex = @"0";
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)followBtnClick:(UIButton *)sender {
    if (!kNotNil(self.ownerModel.ID)) return;
    //关注
    if (_isFollow == YES) {
        //取消关注
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancleFollow];
            _isFollow = NO;
        }];
        [alert addAction:cancle];
        [alert addAction:creatain];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    }
    else {
        //添加关注
        [self addFollow];
        _isFollow = YES;
    }
    
}

- (void)addFollow {
    
    kWeakSelf(self);
    NSDictionary *parameter = @{@"followId":self.ownerModel.ID ?: @""};
    
    [[NetWorking network] POST:kAddFollow params:parameter cache:NO success:^(id result) {
        [MBProgressHUD showSuccess:@"关注成功"];
        follows = @"1";
        [weakSelf.ownerHeadView.followBtn setTitle:@" 已关注" forState:UIControlStateNormal];
        [weakSelf.ownerHeadView.followBtn setImage:[UIImage imageNamed:@"icon_own_ygz"] forState:UIControlStateNormal];
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"关注失败"];
        
    }];
    
}

- (void)cancleFollow {
    
    kWeakSelf(self);
    NSDictionary *parameter = @{@"followId":self.ownerModel.ID,};
    [[NetWorking network] POST:kCancleFollow params:parameter cache:NO success:^(id result) {
        NSLog(@"-----%@",result);
        follows =@"0";
        [MBProgressHUD showSuccess:@"取消成功"];
        [weakSelf.ownerHeadView.followBtn setTitle:@"  关注" forState:UIControlStateNormal];
        [weakSelf.ownerHeadView.followBtn setImage:[UIImage imageNamed:@"icon_own_gz"] forState:UIControlStateNormal];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"取消失败"];
        
    }];
}
- (void)pariseBtnClick:(UIButton *)sender {
    
    if ([self.ownerModel.liked isEqualToString:@"1"] || !kNotNil(self.ownerModel.ID)) {
        [UIView animateWithDuration:0.5 animations:^{
            sender.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                sender.transform = CGAffineTransformMakeScale(1.4, 1.4);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    sender.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {

                }];
            }];
        }];
        return;
    };
    [[NetWorking network] POST:kAddLiked params:@{@"likeUser":self.ownerModel.ID,} cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [self.ownerHeadView.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz_m"] forState:0];
        self.ownerHeadView.praiseCountLabel.text = [NSString stringWithFormat:@"%li",[self.ownerModel.likeSum integerValue] + 1];
        praise = @"1";
        likeSum = @"1";
        self.ownerModel.liked = @"1";
    } failure:^(NSString *description) {
        [MBProgressHUD showError:description];
    }];

}

- (void)allDynamic {
    //更多
    if (!kNotNil(self.userID)) return;
    OwnerDynamicViewController * ower = [OwnerDynamicViewController new];
    ower.ID = self.userID;
    ower.owerTitle = @"车主动态";
    ower.returnBlock = ^(id data) {
        NSString *string = data;
        if (kNotNil(string)) {
            if ([string isEqualToString:@"0"]) {
                [self.ownerHeadView.followBtn setBackgroundImage:[UIImage imageNamed:@"btn_gz-1"] forState:UIControlStateNormal];
                follows =@"0";
                _isFollow = NO;
            }else {
                [self.ownerHeadView.followBtn setBackgroundImage:[UIImage imageNamed:@"btn_ygz-1"] forState:UIControlStateNormal];
                follows =@"1";
                _isFollow = YES;
            }
        }
    };
    ower.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ower animated:YES];
}

- (void)moveCatBtnClick:(UIButton *)sender {
    [MobClick event:@"MoveCar"];
    if (!kNotNil(self.userID)) return;
    [self.view.window addSubview:self.callView];
    [UIView animateWithDuration:0.5 animations:^{
        self.callView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }];
    
}
-(void)moveTheCar:(NSInteger)second {
    if (!kNotNil(self.userID)) return;
    
    kWeakSelf(self)
    [weakSelf showHudWithText:@""];
    NSDictionary *parameter = @{@"userId":self.userID,};
    [[NetWorking network] POST:KMoveCarNoDetails params:parameter cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [weakSelf hideHud];
        XLBNoticeViewController *noticeVC = [XLBNoticeViewController new];
        noticeVC.userId = self.userID;
        noticeVC.imgUrl = _ownerModel.img;
        noticeVC.nickname = _ownerModel.nickname;
        noticeVC.timeDown = second;
        noticeVC.moveCarId = [result objectForKey:@"id"];
        [self.navigationController pushViewController:noticeVC animated:YES];
        
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:description];
        
    }];
}
#pragma mark -rightCLick
-(void)blackListAddOwner {
    BOOL isBlack = NO;
    for (NSString*stering in _blackList) {
        if ([stering isEqualToString:self.userID]) {
            isBlack = YES;
            continue;
        }
    }
    if (isBlack){
        EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.userID];
        if (!error) {
            [_blackList removeObject:self.userID];
            [[XLBCache cache] store:_blackList key:@"BlackList"];
            [MBProgressHUD showError:@"已经移除屏蔽"];
        }
    }else{
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:self.userID relationshipBoth:YES];
        if (!error) {
            [_blackList addObject:self.userID];
            [[XLBCache cache] store:_blackList key:@"BlackList"];
            [MBProgressHUD showError:@"已经屏蔽"];
        }
    }
}
-(void)reportOwner{
    //举报用户
    ReportChatViewController *chat = [ReportChatViewController new];
    chat.hidesBottomBarWhenPushed = YES;
    chat.reportType = @"4";
    chat.detailID = self.userID;
    [self.navigationController pushViewController:chat animated:YES];
}
- (void)shareOwner {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [self setShareViewWithHidden:ShareBtnWeChatHidden];
    }else if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]){
        [self setShareViewWithHidden:ShareBtnWeiBoHidden];
    }else {
        [self setShareViewWithHidden:3];
    }
}
- (void)setShareViewWithHidden:(ShareBtnHidden)hidden {
    XLBShareView *shareView = [[XLBShareView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:ShareViewDefault isHidden:hidden];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];
}

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
    shareModel.urlString = [NSString stringWithFormat:@"%@wechat/owner?id=%@",kDomainUrl,self.ownerModel.ID];
    shareModel.title = @"小喇叭-高端交友！！";
    shareModel.describe = @"在小喇叭看到的俊男靓女我很喜欢，快来看看呦~";
    if (weibo == YES) {
        shareModel.text = @"小喇叭-高端交友！！";
    }
    UIImage *imag;
    if (kNotNil(self.ownerModel.pick) && self.ownerModel.pick.count > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:self.ownerModel.pick[0] Withtype:IMGAvatar]]];
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
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubSharelish,self.ownerModel.ID];
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        NSLog(@"ffffff========%@",result);
    } failure:^(NSString *description) {
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
        CGFloat Offset_y = scrollView.contentOffset.y;
        if ( Offset_y < 0) {
            CGFloat totalOffset = kSCREEN_WIDTH - Offset_y;
            CGFloat scale = totalOffset / kSCREEN_WIDTH;
            NSLog(@"%f",scale);
            self.ownerHeadView.ownerImg.frame = CGRectMake(-(kSCREEN_WIDTH * scale - kSCREEN_WIDTH) / 2, Offset_y, kSCREEN_WIDTH * scale, totalOffset);
        }
    }
}
- (void)callBtnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        //打电话
        [UIView animateWithDuration:0.3 animations:^{
            _callView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_callView removeFromSuperview];
            [self.view.window addSubview:self.callSubView];
            [UIView animateWithDuration:0.5 animations:^{
                _callSubView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                [[NetWorking network] POST:kCarQMYCall params:@{@"userId":self.userID,} cache:NO success:^(id result) {
                    [self performSelector:@selector(removeCallSubView) withObject:self afterDelay:5];
                } failure:^(NSString *description) {
                    if (description.length > 100) {
                        [MBProgressHUD showError:@"请求错误"];
                    }else {
                        [MBProgressHUD showError:description];
                    }
                }];
            }];
        }];
        
    }else {
        //铃声
        [UIView animateWithDuration:0.3 animations:^{
            _callView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_callView removeFromSuperview];
            kWeakSelf(self);
            [weakSelf showHudWithText:@""];
            [[NetWorking network] POST:KMyMoveCar params:@{@"userId":self.userID} cache:NO success:^(NSDictionary* result) {
                NSLog(@"------------------我要挪车 %@",result);
                if ([[result objectForKey:@"messageReminder"] isEqualToString:@"1"]) {
                    if ([[result objectForKey:@"status"] isEqualToString:@"0"]) {
                        XLBNoticeViewController *noticeVC = [XLBNoticeViewController new];
                        noticeVC.userId = self.userID;
                        noticeVC.imgUrl = _ownerModel.img;
                        noticeVC.nickname = _ownerModel.nickname;
                        noticeVC.timeDown = [[result objectForKey:@"second"] integerValue];
                        noticeVC.moveCarId = [result objectForKey:@"id"];
                        [self.navigationController pushViewController:noticeVC animated:YES];
                    }else{
                        MoveCarVerifyViewController *noticeVC = [MoveCarVerifyViewController new];
                        noticeVC.carId = self.userID;
                        noticeVC.imgUrl = _ownerModel.img;
                        noticeVC.nickname = _ownerModel.nickname;
                        [weakSelf.navigationController pushViewController:noticeVC animated:YES];
                    }
                }else {
                    if ([[result objectForKey:@"status"] isEqualToString:@"0"]) {
                        XLBNoticeViewController *noticeVC = [XLBNoticeViewController new];
                        noticeVC.userId = self.userID;
                        noticeVC.imgUrl = _ownerModel.img;
                        noticeVC.nickname = _ownerModel.nickname;
                        noticeVC.timeDown = [[result objectForKey:@"second"] integerValue];
                        noticeVC.moveCarId = [result objectForKey:@"id"];
                        [self.navigationController pushViewController:noticeVC animated:YES];
                    }else{
                        [weakSelf moveTheCar:[[result objectForKey:@"second"] integerValue]];
                    }
                }
                [weakSelf hideHud];
            } failure:^(NSString *description) {
                [weakSelf hideHud];
            }];
        }];

    }
}

- (void)removeCallSubView {
    [UIView animateWithDuration:0.3 animations:^{
        _callSubView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_callSubView removeFromSuperview];
    }];
}
- (XLBCallView *)callView {
    if (!_callView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _callView = [[XLBCallView alloc] initWithEffect:effect];
        _callView.deviceNo = deviceNo;
        [_callView.callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_callView.defaultBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callView;
}
- (XLBCallSubView *)callSubView {
    if (!_callSubView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _callSubView = [[XLBCallSubView alloc] initWithEffect:effect];
        _callSubView.nickname.text = self.ownerModel.nickname;
        [_callSubView.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.ownerModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    return _callSubView;
}
- (NSMutableArray *)imgArr {
    if (_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}
- (NSMutableArray *)headModelArr {
    if (_headModelArr) {
        _headModelArr = [NSMutableArray array];
    }
    return _headModelArr;
}
#pragma mark - Notification Method
-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:addTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
