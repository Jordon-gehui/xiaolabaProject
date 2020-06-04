//
//  FindViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "FindViewController.h"
#import "FindButton.h"
#import "XLBLocation.h"
#import "FindCardView.h"
#import "XLBChatViewController.h"
#import "XLBScreenViewController.h"
#import "LoginView.h"
#import "XLBRadarView.h"
#import "XLBLoginViewController.h"

#define MAX_STARWORDS_LENGTH 20
@interface FindViewController ()<FindCardDelegate,ZLSwipeableViewDelegate, ZLSwipeableViewDataSource>
{
    BOOL  _more;
    XLBFindUserModel *selectModel;
    NSDictionary *_seekParams;
    NSInteger beforehandIndex;
    NSString *isFind;
    UITextField *addTextField;
}
@property (nonatomic, copy) NSString *locationCity;
@property (nonatomic, strong)XLBRadarView *radarV;
@property (nonatomic, strong) FindButton *addBtn;
@property (nonatomic, strong) FindButton *sayHiBtn;
@property (nonatomic, strong) FindButton *likeBtn;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, retain)UILabel *errorTip;

@property (nonatomic, strong)UIImageView *cashSDImg;

@property (nonatomic, strong)NSString *lockSet;

@end

@implementation FindViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self location];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.radarV.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    beforehandIndex = 0;
    _selectIndex = 0;
    self.naviBar.slTitleLabel.text = @"车友";
    [MobClick event:@"Nav_carPage"];

//    self.lockSet = [self getFindLockSet];
    _addBtn = [FindButton new];
    [_addBtn initButton:30];
    [_addBtn setImage:[UIImage imageNamed:@"icon_xcy_jhy"]];
    [_addBtn addBtnTarget:self action:@selector(addClick)];
    [self.view addSubview:_addBtn];
    
    _sayHiBtn = [FindButton new];
    [_sayHiBtn initButton:40];
    
    [_sayHiBtn setImage:[UIImage imageNamed:@"icon_cy_dzh"]];
    [_sayHiBtn addBtnTarget:self action:@selector(sayHiClick)];
    [self.view addSubview:_sayHiBtn];
    
    _likeBtn = [FindButton new];
    [_likeBtn initButton:30];
    [_likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_n"]];
    [_likeBtn addBtnTarget:self action:@selector(likeClick)];
    [self.view addSubview:_likeBtn];
    
    [self.view addSubview:self.swipeableView];
    ZLSwipeableView *swipeableView = _swipeableView;
    // Required Data Source
    self.swipeableView.dataSource = nil;
    
    // Optional Delegate
    self.swipeableView.delegate = nil;
    
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Adding constraints
    [swipeableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(15);
        if (iPhone5s) {
            make.height.mas_equalTo(kSCREEN_WIDTH+50*kiphone6_ScreenHeight);
        }else {
            make.height.mas_equalTo(kSCREEN_WIDTH+60);
        }
    }];

    [self initButton];
    [self adddic];
    [self refresh];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(notificationUserInfo:) name:@"loginSuccess" object:nil];
}

-(void)adddic{
    _seekParams = [NSMutableDictionary new];

    NSMutableDictionary *dict = [[[XLBUser user] other] mutableCopy];
    if (kNotNil(dict[@"ageDic"])) {
        NSDictionary *ageDic = [dict[@"ageDic"] mutableCopy];
        [_seekParams setValue:[ageDic.allKeys componentsJoinedByString:@","] forKey:@"age"];
    }
    if (kNotNil(dict[@"carPriceDic"])) {
        NSDictionary *carDic = [dict[@"carPriceDic"] mutableCopy];
        NSString*srrrr=[carDic.allKeys componentsJoinedByString:@","];
        [_seekParams setValue:srrrr forKey:@"brands"];
    }
    if ([[dict allKeys] containsObject:@"sex"]) {
        [_seekParams setValue:[dict objectForKey:@"sex"] forKey:@"sex"];
    }
    if ([[dict allKeys] containsObject:@"city"]) {
        if ([[dict objectForKey:@"city"] isEqualToString:@"同城"]) {
            [_seekParams setValue:@"1" forKey:@"city"];
        }else{
            [_seekParams setValue:@"" forKey:@"city"];
        }
    }
    if ([[dict allKeys] containsObject:@"cpValue"]) {
        [_seekParams setValue:[dict objectForKey:@"cpValue"] forKey:@"price"];
    }

}
- (void)notificationUserInfo:(NSNotification *)notification {
    if (kNotNil(notification)) {
        isFind = [NSString stringWithFormat:@"%@",notification.object];
    }
    [self refresh];
}
- (void)refresh {
    self.page = 1;
    self.size = 30;
    _selectIndex = 0;
    _more = YES;
    [self requestFindListparams];
}
- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setImage:[UIImage imageNamed:@"icon_cy_sx"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];    
}

- (void) rightClick {
    XLBScreenViewController *screen = [[XLBScreenViewController alloc] init];
    screen.hidesBottomBarWhenPushed = YES;
    kWeakSelf(self)
    screen.block = ^(id dic,NSInteger idex) {
//        if (idex ==1) {
//            [self setFindLockSet:@""];
//        }
        
        _seekParams = dic;
        [weakSelf refresh];
    };
    [self.navigationController pushViewController:screen animated:YES];
}

-(void)initButton {
    kWeakSelf(self);
    
    [_sayHiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(weakSelf.swipeableView.mas_bottom).with.offset(30*kiphone6_ScreenHeight);
        }else if(iPhone5s){
            make.top.mas_equalTo(weakSelf.swipeableView.mas_bottom).with.offset(5*kiphone6_ScreenHeight);
        }else {
            make.top.mas_equalTo(weakSelf.swipeableView.mas_bottom).with.offset(18*kiphone6_ScreenHeight);
        }
        make.width.height.mas_equalTo(80*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.sayHiBtn);
        make.width.height.mas_equalTo(60*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(weakSelf.view).with.offset(-90*kiphone6_ScreenHeight);
    }];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.sayHiBtn);
        make.width.height.mas_equalTo(60*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(weakSelf.view).with.offset(+90*kiphone6_ScreenHeight);
    }];
}

- (void)requestFindListparams {

    NSMutableDictionary *params = [@{@"page":@{@"curr":@(self.page),
                                               @"size":@(self.size)},
                                     @"lng":[XLBUser user].longitude,
                                     @"lat":[XLBUser user].latitude} mutableCopy];
    for (NSString*key in [_seekParams allKeys]) {
        if ([key isEqualToString:@"city"]) {
            if ([[_seekParams objectForKey:key] isEqualToString:@"1"]) {
                [params setValue:_locationCity forKey:key];
            }
        }else {
            [params setValue:[_seekParams objectForKey:key] forKey:key];
        }
    }
//    if(self.page ==1){ [self showHudWithText:nil]; }
    if ((self.page == 1 && [[self currentViewController] isKindOfClass:[RootTabbarController class]]) || (self.page == 1 && [isFind isEqualToString:@"1"])) {self.radarV.hidden = NO; self.radarV.alpha = 1;        [self.radarV setIconImageViewImg];}
    kWeakSelf(self);
    weakSelf.swipeableView.allData = nil;
    [MessageNetWorking requestFindList:params success:^(NSArray<XLBFindUserModel *> *models) {
        NSLog(@"获取结果%@",[NSDate date]);
        [self hideErrorView];
        if(weakSelf.page==1) {
            [weakSelf.data removeAllObjects];
            self.lockSet = @"";
            [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XLBFindUserModel *model =(XLBFindUserModel*)obj;
                NSString *sring = [NSString stringWithFormat:@"%@",model.ID];
                NSRange range = [self.lockSet rangeOfString:sring];
                if (range.location == NSNotFound){
                    [self.data addObject:model];
                    self.lockSet = [NSString stringWithFormat:@"%@,%@",self.lockSet,model.ID];
                }
                
            }];
//            [self.data addObjectsFromArray:models];

            if (weakSelf.data.count<30&&models.count>0&&_more) {
                weakSelf.page += 1;
                [weakSelf requestFindListparams];
                return ;
            }

            if (models.count==0) {
//                [weakSelf hideHud];
                [self performSelector:@selector(removeRadarView) withObject:nil afterDelay:2.0];


                [weakSelf showErrorView];
                _errorTip.text = @"暂无数据,请修改筛选条件";
                weakSelf.swipeableView.dataSource = nil;
                weakSelf.swipeableView.delegate = nil;
            }else{
                if (self.data.count>0) {
//                    [weakSelf hideHud];
                    [self performSelector:@selector(removeRadarView) withObject:nil afterDelay:2.0];

                    weakSelf.swipeableView.dataSource = self;
                    weakSelf.swipeableView.delegate = self;
                    FindCard*card= (FindCard*)weakSelf.swipeableView.topView;
                    card.model = weakSelf.data.firstObject;
                    weakSelf.swipeableView.allindex = _selectIndex;
                    selectModel = weakSelf.data.firstObject;
                    if ([selectModel.liked isEqualToString:@"1"]) {
                        [weakSelf.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_s"]];
                        weakSelf.likeBtn.tag = 1;
                    }
                    if ([selectModel.friends isEqualToString:@"1"]) {
                        [weakSelf.addBtn setImage:[UIImage imageNamed:@"icon_xcy_hy"]];
                        weakSelf.addBtn.tag = 1;
                    }
                    [self hideErrorView];
                }else{
                    weakSelf.swipeableView.dataSource = nil;
                    weakSelf.swipeableView.delegate = nil;
//                    [self setFindLockSet:@""];
                    weakSelf.page = 1;
                    [weakSelf requestFindListparams];
                }
            }
        }else {
            [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XLBFindUserModel *model =(XLBFindUserModel*)obj;
                NSString *sring = [NSString stringWithFormat:@"%@",model.ID];
                NSRange range = [self.lockSet rangeOfString:sring];

                if (range.location == NSNotFound){
                    [self.data addObject:model];
                    self.lockSet = [NSString stringWithFormat:@"%@,%@",self.lockSet,model.ID];
                }
            }];
//            [self.data addObjectsFromArray:models];
            if (weakSelf.data.count<60&&models.count>0&&_more) {
                weakSelf.page += 1;
                [weakSelf requestFindListparams];
                return ;
            }
//            [weakSelf hideHud];
            [self performSelector:@selector(removeRadarView) withObject:nil afterDelay:2.0];

            if (self.data.count>0) {
//                [weakSelf.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if (weakSelf.data.count>=90&&idx<30) {
//                        NSLog(@"remove ---idx===%zd",idx);
//                        [weakSelf.data removeObject:obj];
//                        _selectIndex--;
//                    }
//                }];
                weakSelf.swipeableView.dataSource = self;
                weakSelf.swipeableView.delegate = self;
                if (_selectIndex<0) {
                    _selectIndex =0;
                }
                selectModel = weakSelf.data[_selectIndex];
                weakSelf.swipeableView.allindex = _selectIndex;
                FindCard*card= (FindCard*)weakSelf.swipeableView.topView;
                card.model = selectModel;
                if ([selectModel.liked isEqualToString:@"1"]) {
                    [weakSelf.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_s"]];
                    weakSelf.likeBtn.tag = 1;
                }
                if ([selectModel.friends isEqualToString:@"1"]) {
                    [weakSelf.addBtn setImage:[UIImage imageNamed:@"icon_xcy_hy"]];
                    weakSelf.addBtn.tag = 1;
                }
                [self hideErrorView];
            }else{
                weakSelf.swipeableView.dataSource = nil;
                weakSelf.swipeableView.delegate = nil;
//                [self setFindLockSet:@""];
                weakSelf.page = 1;
                [weakSelf requestFindListparams];
            }
        }
        weakSelf.swipeableView.allData = weakSelf.data;

    } failure:^(NSString *error) {
        [self performSelector:@selector(removeRadarView) withObject:nil afterDelay:2.0];
        
        if (self.page ==1) {
            [self showErrorView];
            _errorTip.text = @"网络错误,点击重试";
        }

//        [weakSelf hideHud];
    } more:^(BOOL more) {
        NSLog(@"有没有下一页%i",more);
        _more = more;
    }];
}

- (XLBRadarView *)radarV {
    if (!_radarV) {
        _radarV = [[XLBRadarView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom + 1, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom)];
        [[UIApplication sharedApplication].keyWindow addSubview:_radarV];
        [_radarV setIconImageViewImg];
    }
    return _radarV;
}

-(void)removeRadarView {
    if ([[self currentViewController] isKindOfClass:[RootTabbarController class]]) {
        [UIView animateWithDuration:1 animations:^{
            self.radarV.alpha = 0;
        } completion:^(BOOL finished) {
            self.radarV.hidden = YES;
        }];
    }
}

-(UIView*)errorView {
    if (!_errorView) {
        _errorView =[[UIView alloc]initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom-45)];
        _errorView.backgroundColor = [UIColor whiteColor];
        _errorView.hidden = YES;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((_errorView.width-80*kiphone6_ScreenWidth)/2.0, (_errorView.height-80*kiphone6_ScreenWidth)/2.0-30, 80*kiphone6_ScreenWidth, 80*kiphone6_ScreenWidth)];
        [imgView setImage:[UIImage imageNamed:@"pic_wsj"]];
        [_errorView addSubview:imgView];

        _errorTip=[[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+30, kSCREEN_WIDTH, 20)];
        _errorTip.textAlignment = NSTextAlignmentCenter;
        _errorTip.numberOfLines = 0;
        _errorTip.font = [UIFont systemFontOfSize:18];
         _errorTip.textColor = [UIColor tipTextColor];
        [_errorView addSubview:_errorTip];
        [self.view addSubview:_errorView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(retryHttp)];
        [_errorView addGestureRecognizer:tap];
    }
    return _errorView;
}
-(void)retryHttp {
//    [self setFindLockSet:@""];
    self.page = 1;
    [self requestFindListparams];
}
-(void)showErrorView {
    if (self.errorView.hidden == YES) {
        _errorView.hidden = NO;
    }
}
-(void)hideErrorView {
    if (self.errorView.hidden == NO) {
        _errorView.hidden = YES;
    }
}

-(void)addClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    if (self.addBtn.tag ==1) {
        [MBProgressHUD showError:@"已是你的好友或者等待同意"];
        [self.addBtn setImage:[UIImage imageNamed:@"icon_xcy_hy"]];
        return;
    }
    [self.addBtn setUserInteractionEnabled:NO];
    if (!kNotNil(selectModel.ID)) {
        return;
    }
    [self showAddfriendMsgAlert];
}
-(void)addfriend:(NSString *)string{
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kAddFriend params:@{@"friendId":selectModel.ID,@"message":string} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 加好友 %@",result);
        [weakSelf hideHud];
        [MBProgressHUD showError:@"已发送好友请求"];
        
        //        [btn removeFromSuperview];
        [weakSelf.addBtn setImage:[UIImage imageNamed:@"icon_xcy_hy"]];
        weakSelf.addBtn.tag = 1;
        [self.addBtn setUserInteractionEnabled:YES];
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [self.addBtn setUserInteractionEnabled:YES];
    }];
}
-(void)sayHiClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    NSLog(@"选择的姓名%@",selectModel.nickname);
    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",selectModel.ID] conversationType:EMConversationTypeChat];
    chat.hidesBottomBarWhenPushed = YES;
    chat.nickname = selectModel.nickname;
    chat.avatar = selectModel.img;
    chat.userId = [NSString stringWithFormat:@"%@",selectModel.ID];
    [self.navigationController pushViewController:chat animated:YES];
}

-(void)likeClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    if (self.likeBtn.tag ==1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.likeBtn.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.likeBtn.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.likeBtn.imageView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
        return;
    }
   
    [self.likeBtn setUserInteractionEnabled:NO];
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kAddLiked params:@{@"likeUser":selectModel.ID,} cache:NO success:^(id result) {
        [weakSelf.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_s"]];
        weakSelf.likeBtn.tag = 1;
        XLBFindUserModel*find = [weakSelf.data objectAtIndex:_selectIndex];
        find.liked = @"1";
        [weakSelf hideHud];
        [self.likeBtn setUserInteractionEnabled:YES];
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [self.likeBtn setUserInteractionEnabled:YES];
        [MBProgressHUD showError:description];
    }];

}

#pragma FindCardDelegate
- (void)cardView:(FindCard *)cardView card:(XLBFindUserModel *)model{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    NSLog(@"这人是谁：%@",model.nickname);
    [MobClick event:@"Find_InformationClick"];

    OwnerViewController *vc = [OwnerViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userID = model.ID;
    vc.returnBlock = ^(id data) {
        NSDictionary *params = (NSDictionary *)data;
        NSString *string = [params objectForKey:@"liked"];
        if ([string isEqualToString:@"1"]) {
            for (XLBFindUserModel *userModel in self.data) {
                if(userModel.ID == model.ID){
                    userModel.liked = @"1";
                    selectModel.liked = @"1";
                }
            }
        }else{
            for (XLBFindUserModel *userModel in self.data) {
                if(userModel.ID == model.ID){
                    userModel.liked = @"0";
                    selectModel.liked = @"0";
                }
            }
        }
        if ([selectModel.liked isEqualToString:@"1"]) {
            [self.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_s"]];
            self.likeBtn.tag =1;
        }else{
            [self.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_n"]];
            self.likeBtn.tag =0;
        }
    };
    vc.delFlag = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cardView:(FindCard *)cardView didTouchCardImages:(NSArray<NSString *> *)images {
    NSLog(@"%@",images);
    [MobClick event:@"Find_ImageClick"];
    if (!kNotNil(images) || images.count == 0) return;
    ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
    vc.imageArray = [images mutableCopy];
    vc.currentIndex = @"0";
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:^{
    }];
    
}


-(void)location {
    XLBLocation *location = [XLBLocation location];
    kWeakSelf(self);
    [location getCurrentLocationComplete:^(NSDictionary *location) {
        if(kNotNil(location)) {
            weakSelf.locationCity =location[@"City"];
        }
    }];
}

-(void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    NSLog(@"%ld",selectIndex);
    self.swipeableView.allindex = selectIndex;
    
    selectModel = self.data[_selectIndex];
    if (!(self.addBtn.tag == [selectModel.friends integerValue]) || !(self.likeBtn.tag==[selectModel.liked integerValue])) {
        NSLog(@"%@===%@",selectModel.liked,selectModel.friends);
        self.addBtn.tag = [selectModel.friends integerValue];
        [self.addBtn setImage:[UIImage imageNamed:[selectModel.friends isEqualToString:@"1"] ?@"icon_xcy_hy":@"icon_xcy_jhy"]];
        self.likeBtn.tag = [selectModel.liked integerValue];
        if ([selectModel.liked isEqualToString:@"1"]) {
            [self.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_s"]];
        }else{
            [self.likeBtn setImage:[UIImage imageNamed:@"icon_cy_dz_n"]];
        }
    }
}
- (ZLSwipeableView *)swipeableView
{
    if (_swipeableView == nil) {
        _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(25, 0, 100, 200)];
    }
    return _swipeableView;
}
- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    FindCard *cardview = (FindCard*)view;
    NSInteger index = 0;
    for (int i=0; i<self.data.count; i++) {
        XLBFindUserModel *model = self.data[i];
        if ([model.ID isEqual:cardview.model.ID]) {
            index = i;
            break;
        }
    }
    if (direction ==  ZLSwipeableViewDirectionRight) {
        
        if (index >=1) {
            self.selectIndex = index-1;
        }else{
            self.selectIndex = index;
        }
        
    }else{
        if (index < self.data.count-1) {
            self.selectIndex = index+1;
        }else{
            self.selectIndex = index;
        }
        
    }
//    [self setFindLockSet:cardview.model.ID];
    
//    NSLog(@"==---===%li----%li--%i--direction=%i",index,self.data.count,_more,direction ==ZLSwipeableViewDirectionRight);
    if ((index == self.data.count-10)&&_more&&(direction==ZLSwipeableViewDirectionLeft)) {
        self.page += 1;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"再次请求%@",[NSDate date]);
            [self requestFindListparams];
        });
    }
//    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
    if (self.selectIndex ==self.data.count-1) {
        [MBProgressHUD showError:@"没有下一张了"];
    }else if(self.swipeableView.allindex ==0){
        [MBProgressHUD showError:@"没有上一张了"];
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
//    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSArray<UIView *> *activeViews = [swipeableView activeViews];
    FindCard *findview = (FindCard*)activeViews[1];
    FindCard *cardview = (FindCard*)view;
    NSInteger index = 0;
    for (int i=0; i<self.data.count; i++) {
        XLBFindUserModel *model = self.data[i];
        if ([model.ID isEqual:cardview.model.ID]) {
            index = i;
            break;
        }
    }
    if (translation.x>0) {
        if (index>0) {
            findview.model = [self.data objectAtIndex:index-1];
        }else{
            findview.model = [self.data objectAtIndex:index];
        }
    }else{
        if (index<self.data.count-1) {
            findview.model = [self.data objectAtIndex:index+1];
        }else{
            findview.model = [self.data objectAtIndex:index];
        }
    }
    if (index!=0) {
        beforehandIndex = index+4;
    }
        NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
              translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (beforehandIndex >= self.data.count) {
        beforehandIndex = 0;
    }
    FindCard *view = [[FindCard alloc] initWithFrame:swipeableView.bounds];
    view.model = self.data[beforehandIndex];
    
    [view setDelegate:self];
    beforehandIndex++;
    NSLog(@"+++++++++%li,++++%li",beforehandIndex,self.data.count-1);
    return view;
}
- (UIView *)previousViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    UIView *view = [self nextViewForSwipeableView:swipeableView];
    [self applyRandomTransform:view];

    return view;
}

- (void)applyRandomTransform:(UIView *)view {
    CGFloat width = self.swipeableView.bounds.size.width;
    CGFloat height = self.swipeableView.bounds.size.height;
    CGFloat distance = MAX(width, height);
    
    CGAffineTransform transform = CGAffineTransformMakeRotation([self randomRadian]);
    transform = CGAffineTransformTranslate(transform, distance, 0);
    transform = CGAffineTransformRotate(transform, [self randomRadian]);
    view.transform = transform;
}
- (CGFloat)randomRadian {
    return (random() % 360) * (M_PI / 180.0);
}
- (UIViewController *)currentViewController {
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:addTextField];
    self.radarV.service.delegate = nil;
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
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.addBtn setUserInteractionEnabled:YES];
    }]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
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
-(UIImageView *)cashSDImg {
    if (!_cashSDImg) {
        _cashSDImg = [UIImageView new];
    }
    return _cashSDImg;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
