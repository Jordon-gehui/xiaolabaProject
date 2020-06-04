 //
//  VoiceActorOwnerViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceActorOwnerViewController.h"
#import "VoiceActorHeaderView.h"
#import "OwnerRequestManager.h"
#import "OwnerDynamicViewController.h"
#import "OwnerInfoModel.h"
#import "XLBOwnerModel.h"
#import "OwnerVoiceInfoTableViewCell.h"
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
#import "VoiceCallView.h"
#import "VoiceCallEndView.h"
#import "VoiceEndCallView.h"
#import "OwnerVoiceActorTableViewCell.h"
#import "OwnerVisitorTableViewCell.h"
#import "VoiceActorOwnerBottomView.h"
#import <AVFoundation/AVFoundation.h>

#define MAX_STARWORDS_LENGTH 20
@interface VoiceActorOwnerViewController ()<UITableViewDelegate,UITableViewDataSource,VoiceActorOwnerHeadViewDelegate,XLBShareViewDelegate,VoiceCallViewDelegate,OwnerVisitorCellDelegate>
{
    NSInteger _curr;            // 请求起始点
    NSInteger _size;            // 一页数据量
    NSString *follows;
    NSString *praise;
    NSString *likeSum;
    NSString *deviceNo;
    AVPlayer *player;
    BOOL isPlay;
    
    NSString *seletedUserMoney;
    UITextField *addTextField;
}
@property (strong, nonatomic) NSMutableArray *headModelArr;
@property (strong, nonatomic) LittleHeadModel *headModel;
@property (strong, nonatomic) NSMutableArray *imgArr;
@property (strong, nonatomic) Imgs *imgModel;
@property (strong, nonatomic) VoiceActorHeaderView *voiceActorHeadView;
@property (strong, nonatomic) XLBVoiceActorModel *voiceAcotrModel;
@property (assign, nonatomic) BOOL isFriend;
@property (assign, nonatomic) BOOL isFollow;
@property (strong, nonatomic) UIView *btnBgView;
@property (strong, nonatomic) UIView *meunView;
@property (strong, nonatomic) XLBCallView *callView;
@property (strong, nonatomic) XLBCallSubView *callSubView;
@property (strong, nonatomic) VoiceCallView *voiceCallV;

@property (strong, nonatomic) VoiceActorOwnerBottomView *bottomView;
@property (strong, nonatomic) AVPlayerItem * songItem;

@property (nonatomic, strong)NSMutableArray *blackList;

@end

@implementation VoiceActorOwnerViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (player) {
        [player pause];
        self.voiceActorHeadView.videoImg.image = [UIImage imageNamed:@"btn_zy_bf"];
    }
}

- (void)dealloc {
    [self.songItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.songItem];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:addTextField];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setup];

    likeSum = @"0";
    _blackList=[[[XLBCache cache]cache:@"BlackList"] mutableCopy];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(-150*kiphone6_ScreenHeight, 0, 0, 0);

    [self getOwnerInfo];
    if (iPhoneX) {
        self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom-20);
    }else {
        if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:self.userID]) {
            self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom);
        }else {
            self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom-50);
        }
    }
    
}

- (void)initNaviBar {
    [super initNaviBar];
    UIButton *reportItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [reportItem setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
    [reportItem addTarget:self action:@selector(rightClick2) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:reportItem];
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
    NSArray *array =@[@"举报用户",isBlack ? @"移除黑名单":@"加入黑名单"];
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
                [weakSelf reportOwner];
                break;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setup {
    self.view.backgroundColor = [UIColor navBackColor];//230
    self.voiceActorHeadView = [[VoiceActorHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH + 70)];
    self.tableView.backgroundColor = [UIColor navBackColor];
    self.tableView.delaysContentTouches = NO;
    self.voiceActorHeadView.delegate = self;
    [self.voiceActorHeadView.portraitBtn addTarget:self action:@selector(portraitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceActorHeadView.praiseBtn addTarget:self action:@selector(pariseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceActorHeadView.videoBtn addTarget:self action:@selector(playvideo:) forControlEvents:UIControlEventTouchUpInside];
    self.voiceActorHeadView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = self.voiceActorHeadView;
    
    self.bottomView = [VoiceActorOwnerBottomView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.bottomView.callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView.addFriend addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.addFlow addTarget:self action:@selector(addFlowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-20);
        }else {
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
        }
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.height.mas_equalTo(53);
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    if (kNotNil(self.userID) && [@([self.userID integerValue])  isEqual: [XLBUser user].userModel.ID])  {
        self.bottomView.hidden = YES;
    }
}


- (void)getOwnerInfo {
    
    if (!kNotNil(self.userID)) return;
    kWeakSelf(self);
    [weakSelf showHudWithText:@""];
    
    NSDictionary *parae = @{@"createUser":self.userID,};
    
    [OwnerRequestManager requestVoiceActorOwnerWithParameter:parae success:^(XLBVoiceActorModel *respones) {
        [weakSelf hideHud];
        self.voiceAcotrModel = respones;
        self.bottomView.money = respones.akiraModel.priceAkira;
        self.voiceActorHeadView.model = respones;
        self.bottomView.model = respones;
        self.title = respones.user.nickname;
        self.naviBar.slTitleLabel.text = respones.user.nickname;

        if (kNotNil(respones)) {
            deviceNo = respones.user.deviceNo;

            if (([respones.user.follows isEqualToString:@"0"])) {
                self.isFollow = NO;
            }
            if ([respones.user.follows isEqualToString:@"1"]) {
                self.isFollow = YES;
            }
            if ([respones.user.friends isEqualToString:@"0"]) {
                self.isFriend = NO;
            }
            if ([respones.user.friends isEqualToString:@"1"]) {
                self.isFriend = YES;
            }
            if (kNotNil(respones.akiraModel.voiceAkira)) {
                [self playVideo];
            }
            praise = respones.user.liked;
            follows = respones.user.follows;
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (iPhone5s) {
            return 140*kiphone6_ScreenHeight;
        }else if (kSCREEN_HEIGHT == 480){
            return 120;
        }
       return 120*kiphone6_ScreenHeight;
    }else if (indexPath.section == 1) {
        return 60/375.0*kSCREEN_WIDTH+46;
    }else if (indexPath.section == 2) {
        if (kSCREEN_HEIGHT == 480) {
            return 150;
        }else {
            return 150*kiphone6_ScreenHeight;
        }
    }
    return 200*kiphone6_ScreenHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        OwnerVoiceActorTableViewCell *voiceActorCell = [tableView dequeueReusableCellWithIdentifier:[OwnerVoiceActorTableViewCell voiceAcotrTableViewCellID]];
        if (!voiceActorCell) {
            voiceActorCell = [[OwnerVoiceActorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OwnerVoiceActorTableViewCell voiceAcotrTableViewCellID]];
        }
        voiceActorCell.selectionStyle = UITableViewCellSelectionStyleNone;
        voiceActorCell.voiceModel = self.voiceAcotrModel;
        [voiceActorCell.checkBtn addTarget:self action:@selector(voiceActorAppressCheckBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return voiceActorCell;
        
        
    }else if(indexPath.section == 1){
        OwnerImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OwnerImageTableViewCell cellIdentifie]];
        if (!cell) {
            cell = [[OwnerImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OwnerImageTableViewCell cellIdentifie]];;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.momentsCount = self.voiceAcotrModel.user.momentCount;
        cell.momentImg = self.voiceAcotrModel.user.momentsImg;
        cell.isVoice = YES;
//        [cell.allBigBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    else if(indexPath.section == 2){
        OwnerVoiceInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:[OwnerVoiceInfoTableViewCell cellID]];
        if (!infoCell) {
            infoCell = [[OwnerVoiceInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OwnerVoiceInfoTableViewCell cellID]];
        }
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        infoCell.owner = self.voiceAcotrModel;
        
        return infoCell;
    }else {
        OwnerVisitorTableViewCell *visitorCell = [tableView dequeueReusableCellWithIdentifier:[OwnerVisitorTableViewCell visitorTableViewCellID]];
        if (!visitorCell) {
            visitorCell = [[OwnerVisitorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OwnerVisitorTableViewCell visitorTableViewCellID]];
        }
        visitorCell.selectionStyle = UITableViewCellSelectionStyleNone;
        visitorCell.voiceModel = self.voiceAcotrModel;
        visitorCell.delegate = self;
        return visitorCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self allDynamic];
    }
}

- (void)voiceActorAppressCheckBtnClick:(UIButton *)sender {
    [[CSRouter share] push:@"VoiceAppraiseViewController" Params:@{@"userId":self.userID} hideBar:YES];
}
- (void)callBtnClick:(UIButton *)sender {
    
    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
        [player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.userID,@"nickName":self.voiceAcotrModel.user.nickname,@"userImg":self.voiceAcotrModel.user.img,@"money":@"0",@"type":[NSNumber numberWithInt:0]}];
    }else {
        if ([self.voiceAcotrModel.akiraModel.onlineType isEqualToString:@"2"]) {
            NSDictionary *parae = @{@"createUser":self.voiceAcotrModel.user.ID};
            kWeakSelf(self)
            [weakSelf showHudWithText:@""];
            [OwnerRequestManager requestVoiceActorOwnerWithParameter:parae success:^(XLBVoiceActorModel *respones) {
                [weakSelf hideHud];
                seletedUserMoney = respones.akiraModel.priceAkira;
                _voiceCallV = [VoiceCallView new];
                _voiceCallV.delegate = self;
                _voiceCallV.money = self.voiceAcotrModel.akiraModel.priceAkira;
                [self.view.window addSubview:_voiceCallV];
                [_voiceCallV changeStatus];
            } error:^(id error) {
                [weakSelf hideHud];
                [MBProgressHUD showError:@"网络错误"];
            }];
        }else {
            [MBProgressHUD showError:@"对方不在线!"];
        }
    }
}
- (void)startBtnClick {
    [player pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.userID,@"nickName":self.voiceAcotrModel.user.nickname,@"userImg":self.voiceAcotrModel.user.img,@"money":seletedUserMoney,@"type":[NSNumber numberWithInt:0]}];
}

- (void)goRecharge {
    [[CSRouter share] push:@"XLBAccountDetailViewController" Params:nil hideBar:YES];
}

- (void)addFriendBtnClick:(UIButton *)sender {
    //加好友
    
    if (self.isFriend == YES) {
        [MBProgressHUD showError:@"已是你的好友或者等待同意"];
        return;
    }
    if (!kNotNil(self.voiceAcotrModel.user.ID)) {
        return;
    }
   
    [self showAddfriendMsgAlert];
}

- (void)sendBtnClick:(UIButton *)sender {
    //打招呼
    if (!kNotNil(self.userID)) return;
    
    NSString *messageID = [NSString stringWithFormat:@"%@",self.userID];
    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:messageID conversationType:EMConversationTypeChat];
    chat.nickname = self.voiceAcotrModel.user.nickname;
    chat.avatar = self.voiceAcotrModel.user.img;
    chat.userId = messageID;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (void)showImage {
    ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
    if (!kNotNil(self.voiceAcotrModel.user.pick[0])) {
        UIImage *image = [UIImage imageNamed:@"pic_m"];
        NSArray *array = [NSArray arrayWithObject:image];
        vc.imageArray = (NSMutableArray *)array;
    }else {
        vc.imageArray = (NSMutableArray *)self.voiceAcotrModel.user.pick;
    }
    vc.currentIndex = @"0";
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
//头像预览
- (void)portraitBtnClick:(UIButton *)sender {
    if (kNotNil(self.voiceAcotrModel.user.img)) {
        NSArray *array = [NSArray arrayWithObject:self.voiceAcotrModel.user.img];
        ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
        vc.imageArray = (NSMutableArray *)array;
        vc.currentIndex = @"0";
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)shareBtnClick:(UIButton *)sender {
    [self shareOwner];
}
- (void)addFlowClick:(UIButton *)sender {
    if (!kNotNil(self.voiceAcotrModel.user.ID)) return;
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
    NSDictionary *parameter = @{@"followId":self.voiceAcotrModel.user.ID ?: @""};
    
    [[NetWorking network] POST:kAddFollow params:parameter cache:NO success:^(id result) {
        [MBProgressHUD showSuccess:@"关注成功"];
        follows = @"1";
        weakSelf.bottomView.fllowLabel.text = @"已关注";
        [weakSelf.bottomView.addFlow setImage:[UIImage imageNamed:@"icon_ygz"] forState:UIControlStateNormal];
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"关注失败"];
        
    }];
    
}

- (void)cancleFollow {
    
    kWeakSelf(self);
    NSDictionary *parameter = @{@"followId":self.voiceAcotrModel.user.ID,};
    [[NetWorking network] POST:kCancleFollow params:parameter cache:NO success:^(id result) {
        NSLog(@"-----%@",result);
        follows =@"0";
        [MBProgressHUD showSuccess:@"取消成功"];
        weakSelf.bottomView.fllowLabel.text = @"加关注";
        [weakSelf.bottomView.addFlow setImage:[UIImage imageNamed:@"icon_gz_v"] forState:UIControlStateNormal];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"取消失败"];
        
    }];
}
- (void)pariseBtnClick:(UIButton *)sender {
    
    if ([self.voiceAcotrModel.user.liked isEqualToString:@"1"] || !kNotNil(self.voiceAcotrModel.user.ID)) {
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
    [[NetWorking network] POST:kAddLiked params:@{@"likeUser":self.voiceAcotrModel.user.ID,} cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [self.voiceActorHeadView.praiseBtn setBackgroundImage:[UIImage imageNamed:@"icon_gz_m"] forState:0];
        self.voiceActorHeadView.praiseCountLabel.text = [NSString stringWithFormat:@"%li",[self.voiceAcotrModel.user.likeSum integerValue] + 1];
        praise = @"1";
        likeSum = @"1";
        self.voiceAcotrModel.user.liked = @"1";
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
                follows =@"0";
                _isFollow = NO;
                self.bottomView.fllowLabel.text = @"加关注";
                [self.bottomView.addFlow setImage:[UIImage imageNamed:@"icon_gz_v"] forState:UIControlStateNormal];
            }else {
                self.bottomView.fllowLabel.text = @"已关注";
                [self.bottomView.addFlow setImage:[UIImage imageNamed:@"icon_ygz"] forState:UIControlStateNormal];
                follows =@"1";
                _isFollow = YES;
            }
        }
    };
    ower.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ower animated:YES];
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
    shareModel.urlString = [NSString stringWithFormat:@"%@wechat/owner?id=%@",kDomainUrl,self.voiceAcotrModel.user.ID];
    shareModel.title = @"小喇叭-高端交友！！";
    shareModel.describe = @"在小喇叭看到的俊男靓女我很喜欢，快来看看呦~";
    if (weibo == YES) {
        shareModel.text = @"小喇叭-高端交友！！";
    }
    UIImage *imag;
    if (kNotNil(self.voiceAcotrModel.user.pick) && self.voiceAcotrModel.user.pick.count > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:self.voiceAcotrModel.user.pick[0] Withtype:IMGAvatar]]];
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
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubSharelish,self.voiceAcotrModel.user.ID];
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        NSLog(@"ffffff========%@",result);
    } failure:^(NSString *description) {
    }];
}

- (void)didSelectButtonWithModel:(UserAkiraVisitorModel *)voice {
    if ([voice.status isEqualToString:@"3"]) {
        //声优
        [[CSRouter share] push:@"VoiceActorOwnerViewController" Params:@{@"userID":voice.visitor,} hideBar:YES];
    }else {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":voice.visitor,@"delFlag":@0,} hideBar:YES];
    }
}
-(void)playvideo:(UIButton *)sender{
    if (isPlay) {
        if (self.voiceActorHeadView.videoBtn.selected) {
            [self playVideo];
            self.voiceActorHeadView.videoImg.image = [UIImage imageNamed:@"btn_zy_zt"];
        }else {
            [player pause];
            self.voiceActorHeadView.videoImg.image = [UIImage imageNamed:@"btn_zy_bf"];
        }
        self.voiceActorHeadView.videoBtn.selected = !self.voiceActorHeadView.videoBtn.selected;
    }else{
        [player pause];
        self.voiceActorHeadView.videoImg.image = [UIImage imageNamed:@"btn_zy_bf"];
        isPlay = YES;
    }
}


-(void)playVideo {
    NSLog(@"播放录音");
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    if (kNotNil([userDe objectForKey:@"inTheCall"])) {
        return;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (!self.voiceActorHeadView.videoBtn.selected) {
        self.voiceActorHeadView.videoBtn.selected = !self.voiceActorHeadView.videoBtn.selected;
        self.voiceActorHeadView.videoImg.image = [UIImage imageNamed:@"btn_zy_zt"];
    }
    if (_voiceAcotrModel.akiraModel.voiceAkira.length<=0) {
        return;
    }
    NSURL *recordFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",kImagePrefix,_voiceAcotrModel.akiraModel.voiceAkira]];
    self.songItem = [[AVPlayerItem alloc]initWithURL:recordFileUrl];
    player = [[AVPlayer alloc]initWithPlayerItem:self.songItem];
[self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.songItem];

}

- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");
    self.voiceActorHeadView.videoImg.image = [UIImage imageNamed:@"btn_zy_bf"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                [player play];
                break;
            case AVPlayerStatusFailed:
                NSLog(@"加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
        CGFloat Offset_y = scrollView.contentOffset.y;
        if ( Offset_y < 0) {
            CGFloat totalOffset = kSCREEN_WIDTH - Offset_y;
            CGFloat scale = totalOffset / kSCREEN_WIDTH;
            NSLog(@"%f",scale);
            self.voiceActorHeadView.ownerImg.frame = CGRectMake(-(kSCREEN_WIDTH * scale - kSCREEN_WIDTH) / 2, Offset_y, kSCREEN_WIDTH * scale, totalOffset);
        }
    }
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
    [[NetWorking network] POST:kAddFriend params:@{@"friendId":self.voiceAcotrModel.user.ID,@"message":string} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 加好友 %@",result);
        [weakSelf hideHud];
        [MBProgressHUD showError:@"已发送好友请求"];
        self.isFriend = YES;
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"添加好友失败"];
    }];
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
