//
//  VoiceActorViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/3.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceActorViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "LittleHeadView.h"
#import "LittleHeadModel.h"
#import "VoiceActorCollectionViewCell.h"
#import "OwnerRequestManager.h"
#import "XLBErrorView.h"
#import "VoiceCallView.h"
#import "LoginView.h"
#import "VoiceActorOwnerViewController.h"
#import "XLBIdentityViewController.h"
#import "BaseWebViewController.h"
#import "XLBAlertController.h"
#import "VoiceActorCollectionReusableView.h"
#import "SLCycleScrollView.h"
#import "XLBCallManager.h"
#import "VoiceScreenViewController.h"
#import "XLBRefreshGifHeader.h"

#define BannerHeight (kSCREEN_WIDTH * 2 / 5)

@interface VoiceActorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XLBErrorViewDelegate,VoiceActorCollectionViewCellDelegate,VoiceCallViewDelegate,VoiceScreenViewControllerDelegate>
/*SLCycleScrollViewDelegate,SLCycleScrollViewDatasource,*/
{
    NSInteger curr;
    NSString *sex;
    BOOL isChange;
    
    NSString *seletedUser;
    NSString *seletedUserImg;
    NSString *seletedUserNickName;
    NSString *seletedUserMoney;
    
    AVPlayer *player;

}
@property (strong,nonatomic) LittleHeadView *littleHeadView;
@property (strong,nonatomic) NSMutableArray *bannersArr;
@property (strong,nonatomic) UICollectionView *collectionV;
@property (strong,nonatomic) NSMutableArray *data;
@property (nonatomic, strong) VoiceCallView *callView;
@property (nonatomic, strong) XLBErrorView *errorV;
@property (nonatomic, strong) SLCycleScrollView *csView;
@property (nonatomic, strong) UIButton *placeBtn;
@property (nonatomic, strong) UIButton *screenBtn;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) NSDictionary *seletedDic;

@property (strong, nonatomic) AVPlayerItem * songItem;
@property(nonatomic ,strong) AVAudioRecorder *recorder;

@end

@implementation VoiceActorViewController
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (player) {
        [player pause];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //声优
    [self setSubViews];
    [XLBCallManager sharedManager];
    [self.collectionV.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginSuccess) name:@"logout" object:nil];

}
- (void)loginSuccess {
    [self.collectionV.mj_header beginRefreshing];
}

- (void)screenBtnClick:(UIButton *)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    VoiceScreenViewController *screenVC = [VoiceScreenViewController new];
    screenVC.hidesBottomBarWhenPushed = YES;
    screenVC.delegate = self;
    [self.navigationController pushViewController:screenVC animated:YES];
}

- (void)didSeletedWithParame:(NSDictionary *)dict {
    self.seletedDic = dict;
    [self.collectionV.mj_header beginRefreshing];
}
- (void)setMoneyRequest {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        return;
    }
    [[NetWorking network] POST:kMoney params:nil cache:NO success:^(id result) {
        NSLog(@"金钱 === %@",result);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (kNotNil(result)) {
            [userDefault setObject:[result objectForKey:@"coinSum"] forKey:@"coinSum"];
        }else {
            [userDefault setObject:@"0" forKey:@"coinSum"];
        }
        [userDefault synchronize];
        
    } failure:^(NSString *description) {
        
    }];

}
- (void)placeBtnClick:(UIButton *)sender {
    //下单
    NSLog(@"%@",self.seletedDic);
}
- (void)loadData {
    curr = 1;
    [self getData];
}

- (void)loadAllData {
    curr++;
    [self getData];
}

- (void)getData {
    NSDictionary *parar;
    if (kNotNil(self.seletedDic)) {
       parar  = @{@"page":@{@"curr":@(curr),@"size":@(20)},
                                @"city":_seletedDic[@"city"],
                                @"sex":_seletedDic[@"sex"],
                                @"age":_seletedDic[@"age"],
                                @"highPrice":_seletedDic[@"highPrice"],
                                @"lowPrice":_seletedDic[@"lowPrice"],
                                };
    }else {
        parar = @{@"page":@{@"curr":@(curr),@"size":@(20)},
                  @"city":@"",
                  @"sex":@"",
                  @"age":@"",
                  @"highPrice":@"",
                  @"lowPrice":@"",
                  };
    }
    
    [OwnerRequestManager requestVoiceActorDataParams:parar success:^(NSArray *models) {
        if (models.count == 0 && curr == 1) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [self.data removeAllObjects];
            [self.collectionV.mj_header endRefreshing];
            [self.collectionV.mj_footer endRefreshing];
            [self.collectionV reloadData];
        }else {
            self.errorV.hidden = YES;
            [self.collectionV.mj_header endRefreshing];
            [self.collectionV.mj_footer endRefreshing];
            if (curr == 1) {
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:models];
            [self.collectionV reloadData];
            if (models.count<20) {
                [self.collectionV.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSString *error) {
        self.errorV.hidden = NO;
        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [self.data removeAllObjects];
        [self.collectionV reloadData];
        [self.collectionV.mj_header endRefreshing];
        [self.collectionV.mj_footer endRefreshing];
    } more:^(BOOL more) {
        
    } total:^(int total) {
        
    }];
    
    [self setMoneyRequest];

}

#pragma mark - collectionV 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VoiceActorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VoiceActorCollectionViewCell voiceActorID] forIndexPath:indexPath];
    if (!cell) {
        cell = [[VoiceActorCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 165, 100)];
    }
    cell.model = self.data[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    VoiceActorListModel *model = self.data[indexPath.item];
    [[NetWorking network] POST:kVisitor params:@{@"interviewee":model.userId,} cache:NO success:^(id result) {
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        NSLog(@"%@",description);
    }];
    VoiceActorOwnerViewController *voiceActorViewController = [VoiceActorOwnerViewController new];
    voiceActorViewController.userID = model.userId;
    NSLog(@"%@",model.voiceAkira);
    voiceActorViewController.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:voiceActorViewController animated:YES];
}

- (void)voiceActorCellDidSetedWith:(UIButton *)sender voiceActorModel:(VoiceActorListModel *)model voiceImg:(UIImageView *)voiceImg{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    if (sender.tag == 10) {
        //声音按钮
        if (player) {
            [player pause];
        }
        sender.selected = ! sender.selected;
        if (sender.selected) {
            if (model.voiceAkira.length <= 0) return;
            voiceImg.image = [UIImage imageNamed:@"btn_sy_zt"];
            [self playVideoWithUrlStr:model.voiceAkira];
        }else {
            [player pause];
            voiceImg.image = [UIImage imageNamed:@"btn_sy_bf"];
        }
    }else {
        //电话按钮
        if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:model.userId]) return;
        if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
            if ([model.onlineType isEqualToString:@"2"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":model.userId,@"nickName":model.nickname,@"userImg":model.img,@"money":@"0",@"type":[NSNumber numberWithInt:0]}];
            }else {
                [MBProgressHUD showError:@"对方不在线!"];
            }
        }else {
            if ([model.onlineType isEqualToString:@"2"]) {
                NSDictionary *parae = @{@"createUser":model.userId};
                kWeakSelf(self)
                [weakSelf showHudWithText:@""];
                [OwnerRequestManager requestVoiceActorOwnerWithParameter:parae success:^(XLBVoiceActorModel *respones) {
                    [weakSelf hideHud];
                    seletedUser = [NSString stringWithFormat:@"%@",respones.user.ID];
                    seletedUserMoney = respones.akiraModel.priceAkira;
                    seletedUserImg = respones.user.img;
                    seletedUserNickName = respones.user.nickname;
                    
                    self.callView = [VoiceCallView new];
                    self.callView.delegate = self;
                    self.callView.money = model.priceAkira;
                    [self.view.window addSubview:self.callView];
                    [self.callView changeStatus];
                } error:^(id error) {
                    [weakSelf hideHud];
                    [MBProgressHUD showError:@"网络错误"];
                }];
                
            }else {
                [MBProgressHUD showError:@"对方不在线!"];
            }
        }
    }
}


-(void)playVideoWithUrlStr:(NSString *)urlStr {
    NSLog(@"播放录音");
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    if (kNotNil([userDe objectForKey:@"inTheCall"])) {
        return;
    }
    NSURL *recordFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",kImagePrefix,urlStr]];
    self.songItem = [[AVPlayerItem alloc]initWithURL:recordFileUrl];
    player = [[AVPlayer alloc]initWithPlayerItem:self.songItem];
    [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
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

- (void)startBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":seletedUser,@"nickName":seletedUserNickName,@"userImg":seletedUserImg,@"money":seletedUserMoney,@"type":[NSNumber numberWithInt:0]}];
}
- (void)goRecharge {
    [[CSRouter share] push:@"XLBAccountDetailViewController" Params:nil hideBar:YES];
}

- (void)setSubViews {
    
    self.topV = [UIView new];
    self.topV.backgroundColor = [UIColor viewBackColor];
    [self.view addSubview:self.topV];
    
    self.screenBtn = [UIButton new];
    [self.screenBtn setTitle:@"  筛选" forState:UIControlStateNormal];
    [self.screenBtn setImage:[UIImage imageNamed:@"icon_sy_sx"] forState:UIControlStateNormal];
    [self.screenBtn setTitleColor:RGB(165, 166, 189) forState:UIControlStateNormal];
    self.screenBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.screenBtn addTarget:self action:@selector(screenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.screenBtn];
    
    UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (kSCREEN_WIDTH-45)/2;
    folwLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 70);
    folwLayout.minimumLineSpacing = 10;
    folwLayout.minimumInteritemSpacing = 10;
    folwLayout.sectionInset = UIEdgeInsetsMake(15, 17, 10, 17);
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 108) collectionViewLayout:folwLayout];
    [_collectionV registerClass:[VoiceActorCollectionViewCell class] forCellWithReuseIdentifier:[VoiceActorCollectionViewCell voiceActorID]];
    
    self.collectionV.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.collectionV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadAllData];
    }];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor viewBackColor];
    [self.view addSubview:self.collectionV];
    
    self.placeBtn = [UIButton new];
    self.placeBtn.layer.masksToBounds = YES;
    self.placeBtn.layer.cornerRadius = 25;
    [self.placeBtn setBackgroundColor:[UIColor shadeEndColor]];
    [self.placeBtn setTitle:@"下单" forState:0];
    [self.placeBtn setTitleColor:[UIColor textBlackColor] forState:0];
    [self.placeBtn addTarget:self action:@selector(placeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    [self.screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.topV.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(self.topV.mas_centerY).with.offset(0);
    }];
    
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topV.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-115);
    }];
}


- (NSMutableArray *)headModelArr{
    
    if (!_bannersArr) {
        _bannersArr = [NSMutableArray array];
    }
    return _bannersArr;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, -50, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.collectionV addSubview:_errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
    //    [self requestData:YES];
    //    self.page = 0;
    //    [self getData];
    NSLog(@"网络错误");
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
