//
//  XLBChatViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBChatViewController.h"
#import "XLBUser.h"
#import "MsgDeatilViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImage+GIF.h>

#define MAX_STARWORDS_LENGTH 20
@interface XLBChatViewController () <EaseMessageViewControllerDataSource,EaseMessageViewControllerDelegate,UIGestureRecognizerDelegate>
{
    CGFloat endHeight;
    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
    FMDatabase *_db;
    UITextField *addTextField;
}

@property (nonatomic, strong) SLNavigationBar *navBar;
@property (nonatomic, strong)NSMutableArray *cashArr;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong)NSMutableArray *blackList;
@property (nonatomic,retain)UIView *addFriView;
@property (nonatomic,retain)UIView *moveCarView;
@property (nonatomic,retain)UILabel *tipTimeL;

@property (nonatomic, assign)NSInteger friStaus; //好友状态 0不是好友 1等待验证 2是好友
@property (nonatomic, assign)NSInteger moving; //挪车状态 0有挪车 1 无挪车

@property (nonatomic,strong)GiftView *giftView;

@property (nonatomic,strong)UIView *intefaceView;
@property (nonatomic,strong)UIView *kjhfView;

@property (nonatomic, strong)UIView *sayHiV;

@property (nonatomic, strong)NSMutableDictionary *emotionDic;
@end

@implementation XLBChatViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:@"MessageList"];
    if ([self.userId isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"]) {
        [self tableViewDidTriggerHeaderRefreshWithID:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,self.userId] Withcash:self.cashArr];
    }else {
        [self HttpIsFriend];
    }

    //删除功能模块中的实时通话
    [self.chatBarMoreView removeItematIndex:3];
    //删除功能模块中的录制视频(注意:删除通话以后,视频的索引变成了3,所以这里还是3哦)
    [self.chatBarMoreView removeItematIndex:3];
//    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"fanhui"] highlightedImage:[UIImage imageNamed:@"fanhui"] title:@"礼物"];
    if (_isFinishMove) {
        [self.chatToolbar setUserInteractionEnabled:NO];
        self.chatToolbar.inputTextView.placeHolder = @"挪车已完成 无法继续发送消息";
    }
    _blackList=[[[XLBCache cache]cache:@"BlackList"] mutableCopy];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"NSNotificationCenter" object:@"MoveCarOver"];
    [center addObserver:self selector:@selector(restrictedTalk) name:@"NSNotificationCenter" object:@"reload"];
    [center addObserver:self selector:@selector(removeAllCashArr) name:@"NSNotificationCenter" object:@"removeAllCashArr"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
    kWeakSelf(self)
    self.tableView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    [self setup];
    [self intefaceView];
    [self loadCash];
    self.tableView.frame = CGRectMake(0, self.navBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.navBar.bottom);
}


-(void)removeAllCashArr {
    [self.cashArr removeAllObjects];
}
-(void)loadCash{
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"messageCache_xlb.sqlite"];
    NSLog(@"%@",filename);
    _db = [FMDatabase databaseWithPath:filename];
    
    [_db open];
    NSString *key = [NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,self.userId];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"select * from messageCache_xlb where isRead = 1 and key like '%@%%' ",key]];
    while ([res next]) {
        if ([[res stringForColumn:@"isRead"] isEqualToString:@"1"]) {
            NSDictionary *dic = @{@"startTime":[res stringForColumn:@"startTime"],@"messageID":[res stringForColumn:@"messageID"],@"stopTime":[res stringForColumn:@"stopTime"]};
            [self.cashArr addObject:dic];
            
        }
    }
    [_db close];
}
-(void)restrictedTalk {
    NSInteger count = 0;
    for (EaseMessageModel *model in self.dataArray) {
        if ([model isKindOfClass:[EaseMessageModel class]]) {
            //            NSLog(@"%@====%i",model.text,model.isSender);
            if (model.isSender) {
                count++;
            }
        }
    }
    //最多发10条消息
    if ([self.userId isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"]) {
        NSLog(@"客服");
    }else {
        //最多发10条消息
        if (count >=9 &&(_friStaus==0||_friStaus==1)&&self.chatToolbar.isUserInteractionEnabled) {
            [self.chatToolbar setUserInteractionEnabled:NO];
            self.chatToolbar.inputTextView.placeHolder = @"加好友后可以自由发送消息";
        }
    }
    
}
-(void)HttpIsFriend{
    [[NetWorking network] POST:kIsFriends params:@{@"friendId":self.userId} cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSString *string = [NSString stringWithFormat:@"%@",[result objectForKey:@"isFriend"]];
        _friStaus = [string integerValue];
        _moving = [[NSString stringWithFormat:@"%@",[result objectForKey:@"moving"]] integerValue];
        if (_friStaus ==2) {
            [self.addFriView setHidden:YES];
            self.tableView.tableHeaderView = nil;
        }else{
            [self.addFriView setHidden:NO];
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
            if (_friStaus ==1) {
                [_addButton setTitle:@"等待验证" forState:0];
                [_addButton setEnabled:NO];
            }else {
                [_addButton setTitle:@"加好友" forState:0];
                [_addButton setEnabled:YES];
            }
        }
        if (_moving ==2&&kNotNil([result objectForKey:@"second"])) {
            [self.addFriView setHidden:YES];
            [self.moveCarView setHidden:NO];
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
            secondsCountDown = [[result objectForKey:@"second"] integerValue];
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        }
//        [self tableViewDidTriggerHeaderRefresh];

        [self tableViewDidTriggerHeaderRefreshWithID:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,self.userId] Withcash:self.cashArr];
        [self performSelector:@selector(showSayHi) withObject:nil afterDelay:0.5];
    } failure:^(NSString *description) {
        [_addFriView setHidden:YES];
//        [self tableViewDidTriggerHeaderRefresh];
        [self tableViewDidTriggerHeaderRefreshWithID:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,self.userId] Withcash:self.cashArr];
    }];
}
-(void)showSayHi{
    if (_moving ==1&&self.dataArray.count ==0&&self.cashArr.count==0) {
        self.sayHiV.hidden = NO;
    }
}
-(void)refresh {
//    [self tableViewDidTriggerHeaderRefresh];
    [self tableViewDidTriggerHeaderRefreshWithID:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,self.userId] Withcash:self.cashArr];
    
    [self.tableView.mj_header endRefreshing];
}

-(void)receiveNotificiation:(id)userinfo {
        //@{@"carId":carId,@"type":@"0"} // 0 展示 1重新提醒 2 完成挪车
    NSDictionary  *dic = [userinfo userInfo];
        if ([[dic objectForKey:@"type"] isEqualToString:@"2"]) {
            if (countDownTimer) {
                [countDownTimer invalidate];
                [self.moveCarView setHidden:YES];
                if (_friStaus ==2) {
                    [self.addFriView setHidden:YES];
                    self.tableView.tableHeaderView = nil;
                    
                }else{
                    [self.addFriView setHidden:NO];
                    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
                    if (_friStaus ==1) {
                        [_addButton setTitle:@"等待验证" forState:0];
                        [_addButton setEnabled:NO];
                    }else {
                        [_addButton setTitle:@"加好友" forState:0];
                        [_addButton setEnabled:YES];
                    }
                }
            }
        }else if ([[dic objectForKey:@"type"] isEqualToString:@"1"]) {
            secondsCountDown = 900;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        }else {
            if (countDownTimer) {
                [countDownTimer invalidate];
                [self.moveCarView setHidden:YES];
                if (_friStaus ==2) {
                    [self.addFriView setHidden:YES];
                    self.tableView.tableHeaderView = nil;

                }else{
                    [self.addFriView setHidden:NO];
                    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
                    if (_friStaus ==1) {
                        [_addButton setTitle:@"等待验证" forState:0];
                        [_addButton setEnabled:NO];
                    }else {
                        [_addButton setTitle:@"加好友" forState:0];
                        [_addButton setEnabled:YES];
                    }
                }
            }
        }
    
}
- (void)setup {
    
    if(self.nickname) {
        self.title = self.nickname;
        self.navBar.slTitleLabel.text = self.nickname;
    }
    
    
    [self.navBar setLeftItem:self.backButton];
    self.dataSource = self;
    self.delegate = self;
    
    
    
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
    if ([self.userId isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"]) {
        return;
    }else {
        [self.navBar setRightItem:self.rightButton];
//        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
//        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
//    self.called = [XLBUser user].userModel.nickname;
//    self.calledImg = [XLBUser user].userModel.img;
}

- (SLNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[SLNavigationBar alloc] init];
        if (iPhoneX) {
            _navBar.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 82);
        }else {
            _navBar.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 64);
        }
        _navBar.backgroundColor = [UIColor whiteColor];
        _navBar.lineView.hidden = NO;
        [self.view addSubview:_navBar];
    }
    return _navBar;
}
-(UIView *)addFriView {
    if (!_addFriView) {
        _addFriView =[UIView new];
        _addFriView.backgroundColor = [UIColor textBlackColor];
        UILabel *lbl = [UILabel new];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor =[UIColor whiteColor];
        lbl.text = @"加好友后，可以自由发送消息";
        [_addFriView addSubview:lbl];
        _addButton = [UIButton new];
        [_addButton setTitleColor:[UIColor shadeStartColor] forState:UIControlStateNormal];
        [_addButton setTitle:@"加好友" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addFriView addSubview:_addButton];
        [_addButton addTarget:self action:@selector(addFriViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addFriView];
        
        UIButton *closeBtn = [UIButton new];
        UIImage *imge = [[UIImage imageNamed:@"icon_gb"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        closeBtn.tintColor = [UIColor shadeStartColor];
        [closeBtn setImage:imge forState:0];
        [_addFriView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_addFriView];
        kWeakSelf(self)
        [_addFriView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.navBar.bottom);
            make.left.right.mas_equalTo(weakSelf.view);
            make.height.mas_equalTo(50);
        }];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_addFriView);
            make.left.mas_equalTo(_addFriView.mas_left).with.offset(15);
        }];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(closeBtn.mas_left).with.offset(-15);
            make.centerY.mas_equalTo(_addFriView);
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_addFriView.mas_right).with.offset(-15);
            make.centerY.mas_equalTo(_addFriView);
        }];
    }
    return _addFriView;
}
-(UIView*)moveCarView {
    if (!_moveCarView) {
        _moveCarView =[UIView new];
        _moveCarView.backgroundColor = [UIColor textBlackColor];
        UILabel *lbl = [UILabel new];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor =[UIColor whiteColor];
        lbl.text = @"挪车进度提醒";
        [_moveCarView addSubview:lbl];
        
        _tipTimeL = [UILabel new];
        _tipTimeL.font = [UIFont systemFontOfSize:14];
        _tipTimeL.textColor =[UIColor shadeStartColor];
        _tipTimeL.text = @"--:--";
        [_moveCarView addSubview:_tipTimeL];
        
        UILabel *lbl2 = [UILabel new];
        lbl2.font = [UIFont systemFontOfSize:14];
        lbl2.textColor =UIColorFromRGB(0xaeb5c2);
        lbl2.text = @"您已成功通知对方车主，请稍等...";
        [_moveCarView addSubview:lbl2];
        
        [self.view addSubview:_moveCarView];
        kWeakSelf(self)
        [_moveCarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.navBar.bottom);
            make.left.right.mas_equalTo(weakSelf.view);
        }];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moveCarView).with.offset(15);
            make.left.mas_equalTo(_moveCarView.mas_left).with.offset(15);
        }];
        [_tipTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(lbl);
            make.left.mas_equalTo(lbl.mas_right).with.offset(15);
        }];
        [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lbl.mas_bottom).with.offset(5);
            make.left.mas_equalTo(_moveCarView.mas_left).with.offset(15);
            make.bottom.mas_equalTo(_moveCarView.mas_bottom).with.offset(-15);
        }];
    }
    return _moveCarView;
}
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message {
    
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) { // self
        //头像
        model.avatarURLPath = [JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar];
        //[XLBUser user].userModel.img;
        //昵称
        model.nickname = [XLBUser user].userModel.nickname;
        //头像占位图
        model.failImageName = @"weitouxiang";
    }
    else { // Opponent
        //头像
        if(self.avatar) {
            model.avatarURLPath = [JXutils judgeImageheader:self.avatar Withtype:IMGAvatar];
//            self.avatar;
            //[JXutils judgeImageheader:self.avatar Withtype:IMGCircle];//头像网络地址
        }
        if(self.nickname) {
            model.nickname = self.nickname;//用户昵称
        }
        model.failImageName = @"weitouxiang";
    }
    return model;
}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)backButton {
    
    if(!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 30 , 30);
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIImage *theImage = [UIImage imageNamed:@"icon_fh_z"];
        [self.backButton setImage:theImage forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)rightButton {
    
    if(!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 40 , 40);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(void) rightButtonClick {
    MsgDeatilViewController *msgdeaVC = [[MsgDeatilViewController alloc]init];
    msgdeaVC.userDic = @{@"name":self.nickname,@"headerImg":self.avatar,@"ID":self.userId};
    msgdeaVC.isFriend= _friStaus;
    BOOL isBlack = NO;
    for (NSString*stering in _blackList) {
        if ([stering isEqualToString:self.userId]) {
            isBlack = YES;
            continue;
        }
    }
    msgdeaVC.isBlack = isBlack;
    msgdeaVC.retrunDelAllBlock = ^(BOOL isDel) {
        [self deleteAllMessages:self.userId];
        
    };
    
    msgdeaVC.retrunBlackListBlock = ^(BOOL isDel) {
        if (isDel) {
            EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:self.userId relationshipBoth:YES];
            if (!error) {
                [_blackList addObject:self.userId];
                [[XLBCache cache] store:_blackList key:@"BlackList"];
                [MBProgressHUD showError:@"已经屏蔽"];
            }
        }else {
            EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.userId];
            if (!error) {
                [_blackList removeObject:self.userId];
                [[XLBCache cache] store:_blackList key:@"BlackList"];
                [MBProgressHUD showError:@"已经移除屏蔽"];
            }
        }
    };
    
    [self.navigationController pushViewController:msgdeaVC animated:YES];
    
}
- (void)deleteAllMessages:(id)sender
{
    [self deleteTableWithToID:self.userId];
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"没有消息需要清除", @"no messages")];
        return;
    }
    
    NSString *groupId = (NSString *)sender;
    BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
    if (self.conversation.type == EMConversationTypeChat && isDelete) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.messsagesSource removeAllObjects];
        [self.dataArray removeAllObjects];
        
        [self.tableView reloadData];
        [self showHint:NSLocalizedString(@"聊天记录清除完毕", @"no messages")];
    }
}
- (void)deleteTableWithToID:(NSString *)toID {
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"messageCache.sqlite"];
    NSLog(@"%@",filename);
    _db = [FMDatabase databaseWithPath:filename];
    
    [_db open];
    
    NSString *update = [NSString stringWithFormat:@"DELETE FROM messageCache where key like '%@/%@%%'",[XLBUser user].userModel.ID,toID];
    BOOL  ress = [_db executeUpdate:update];
    if (ress) {
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"删除失败");
    }
    [_db close];
    
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    [userDe setObject:nil forKey:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,toID]];
    [userDe synchronize];
}
-(void)addFriViewClick {
    NSLog(@"加好友");
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
    [[NetWorking network] POST:kAddFriend params:@{@"friendId":self.userId,@"message":string} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 加好友 %@",result);
        [_addButton setTitle:@"等待验证" forState:0];
        [_addButton setEnabled:NO];
        [MBProgressHUD showError:@"已发送好友请求"];
    } failure:^(NSString *description) {
    }];
}
-(void)closeClick {
    [_addFriView setHidden:YES];
    self.tableView.tableHeaderView = nil;

}
//获取本地消息
- (BOOL)getNativeData:(NSString *)passWord {
    BOOL isSuccess = NO;
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"messageCache_xlb.sqlite"];
    NSLog(@"%@",filename);
    _db = [FMDatabase databaseWithPath:filename];
    
    [_db open];
    NSString *key = [NSString stringWithFormat:@"%@/%@/%@",[XLBUser user].userModel.ID,self.userId,passWord];
    
    NSLog(@"%@",key);
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"select * from messageCache_xlb where key = '%@' ",key]];
    while ([res next]) {
        if ([[res stringForColumn:@"isRead"] isEqualToString:@"0"]) {
            NSDictionary *dic = @{@"startTime":[res stringForColumn:@"startTime"],@"messageID":[res stringForColumn:@"messageID"],@"stopTime":[res stringForColumn:@"stopTime"]};
            [self.cashArr addObject:dic];
            NSLog(@"%@",[res stringForColumn:@"messageID"]);
        }
        isSuccess = YES;
    }
    
    NSString *update = [NSString stringWithFormat:@" UPDATE messageCache_xlb SET  isRead=1 WHERE  key= '%@'",key];
    BOOL  ress = [_db executeUpdate:update];
    if (ress) {
        NSLog(@"更新成功");
    }
    else
    {
        NSLog(@"更新失败");
    }
    [_db close];
    return isSuccess;
}
- (void)_sendMessage:(EMMessage *)message{
    [self.sayHiV removeFromSuperview];
    [MobClick event:@"SendMessage"];
    NSInteger count = 0;
    for (EaseMessageModel *model in self.dataArray) {
        if ([model isKindOfClass:[EaseMessageModel class]]) {
            //            NSLog(@"%@====%i",model.text,model.isSender);
            if (model.isSender) {
                count++;
            }
        }
    }
    NSInteger cashCount = self.cashArr.count;
    if ([self.chatToolbar.inputTextView.text hasPrefix:@"#"]) {
        if ([self getNativeData:[self.chatToolbar.inputTextView.text substringFromIndex:1]]) {
            self.chatToolbar.inputTextView.text = @"";
            [self refresh];
            if (self.cashArr.count != cashCount) {
                [self.dataArray addObject:@"您已开启隐藏记录"];
            }
            return;
        }
        self.chatToolbar.inputTextView.text = @"";
    }

    if ([self.userId isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"]) {
        NSLog(@"客服");
    }else {
        //最多发10条消息
        if (count >=9 &&(_friStaus==0||_friStaus==1)) {
            [self.chatToolbar setUserInteractionEnabled:NO];
            self.chatToolbar.inputTextView.placeHolder = @"加好友后可以自由发送消息";
        }
    }
    
    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        if (weakself.dataSource && [weakself.dataSource respondsToSelector:@selector(messageViewController:updateProgress:messageModel:messageBody:)]) {
            [weakself.dataSource messageViewController:weakself updateProgress:progress messageModel:nil messageBody:message.body];
        }
    } completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            [weakself _refreshAfterSentMessage:aMessage];
        }
        else {
            [weakself.tableView reloadData];
        }
    }];
}
#pragma mark - 送礼物
- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index{
    if (index ==3) {
        [self.view endEditing:YES];
        [self.chatToolbar willShowBottomView:self.giftView];
    }
}
-(GiftView*)giftView {
    if (!_giftView) {
        _giftView = [[GiftView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 240)];
    }
    return _giftView;
}
#pragma mark - 快捷聊天相关
//  键盘弹出触发该方法
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"键盘弹出");
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_moving ==2||_moving==3) {
        endHeight = frame.size.height;
        [_intefaceView setFrame:CGRectMake(0, self.view.size.height- endHeight-64-40, kSCREEN_WIDTH, 40)];
        _intefaceView.hidden = NO;
        _intefaceView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            _intefaceView.alpha = 1;
        }];
    }else {
        
    }
    [self.view setUserInteractionEnabled:YES];
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide:(NSNotification *)notification
{
    NSLog(@"键盘隐藏");

    if (_moving ==2||_moving==3) {
        [UIView animateWithDuration:0.3 animations:^{
            _intefaceView.alpha = 0;
        } completion:^(BOOL finished) {
            _intefaceView.hidden = YES;
        }];
    }    
}

-(UIView*)intefaceView {
    if (!_intefaceView) {
        _intefaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        [_intefaceView setBackgroundColor:[UIColor clearColor]];
        [_intefaceView setHidden:YES];
        UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-100, 4, 80, 32)];
        faceBtn.tag = 0;
        [faceBtn setTitle:@"快捷回复" forState:0];
        [faceBtn setTitleColor:[UIColor whiteColor] forState:0];
        faceBtn.backgroundColor = [UIColor shadeStartColor];
        faceBtn.layer.cornerRadius = 10;
        faceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        faceBtn.layer.masksToBounds = YES;
        [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_intefaceView addSubview:faceBtn];
        [self.view addSubview:_intefaceView];
    }
    return _intefaceView;
}

-(void)clickedFaceBtn:(UIButton *)button {
    [self.view endEditing:YES];
    [self.chatToolbar willShowBottomView:self.kjhfView];
    
}

-(UIView*)kjhfView {
    if (!_kjhfView) {
        _kjhfView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 200)];
        [_kjhfView setBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
        UIButton *tempV = nil;
        NSArray*array= @[@" 您的爱车已挡道，请您前来挪车！ ",@" 违章停车，请前来挪车！ ",@" 您的车窗未关闭，请速来挪车！ ",@" 十万火急，请速来挪车！ "];
        if (_moving ==3) {
            _kjhfView.frame= CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 160);
            array= @[@" 我已收到，在过来的路上了！ ",@" 不在附近，暂时无法来挪车！ ",@" 很抱歉，我现在不方便过去，请稍等！ "];
        }
        
        for (NSString*str in array) {
            UIButton *button = [self addbuttonWith:str];
            if (tempV) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(tempV.mas_bottom).with.offset(10);
                    make.left.mas_equalTo(_kjhfView).with.offset(15);
                }];
            }else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.mas_equalTo(_kjhfView).with.offset(15);
                }];
            }
            tempV = button;
        }

    }
    return _kjhfView;
}
-(UIButton *)addbuttonWith:(NSString *)text{
    UIButton *button = [UIButton new];
    [button setTitle:text forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.backgroundColor = [UIColor shadeStartColor];
    button.layer.cornerRadius = 10;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(sendkjhf:) forControlEvents:UIControlEventTouchUpInside];
    [_kjhfView addSubview:button];
    return button;
}
-(void)sendkjhf:(UIButton*)button {
    [self sendTextMessage:button.titleLabel.text];
    [self.chatToolbar endEditing:YES];

}
#pragma mark - 打招呼
- (UIView *)sayHiV {
    if (!_sayHiV) {
        if (iPhone5s) {
            _sayHiV = [[UIView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-120)/2.0, self.navBar.bottom + 60, 120, 150)];
        }else {
            _sayHiV = [[UIView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-120)/2.0, self.navBar.bottom + 110, 120, 150)];
        }
        [_sayHiV setBackgroundColor:[UIColor clearColor]];
        [_sayHiV setHidden:YES];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 70, 70)];
        imageV.backgroundColor = [UIColor whiteColor];
        imageV.image = [UIImage imageNamed:@"hand_message.gif"];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"hand_message" ofType:@"gif"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        imageV.layer.cornerRadius = imageV.width/2.0;
        imageV.layer.masksToBounds = YES;
//        imageV.image = image;
//        [imageV.layer removeAllAnimations];
//        [[NSRunLoop mainRunLoop]
        [self shakeView:imageV];
        [_sayHiV addSubview:imageV];
        
        UILabel *tipLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, imageV.bottom+10, 120, 15)];
        tipLbl.font = [UIFont systemFontOfSize:13];
        tipLbl.text =@"打个招呼吧";
        tipLbl.textColor = RGB(153, 153, 153);
        tipLbl.textAlignment = NSTextAlignmentCenter;
        [_sayHiV addSubview:tipLbl];

        UILabel *contentLbl =[[UILabel alloc]initWithFrame:CGRectMake(0, tipLbl.bottom+10, 120, 15)];
        contentLbl.font = [UIFont systemFontOfSize:13];
        contentLbl.text =@"点击招手";
        contentLbl.textColor = RGB(129, 155, 246);
        contentLbl.textAlignment = NSTextAlignmentCenter;
        [_sayHiV addSubview:contentLbl];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sayHiClick:)];
        [_sayHiV addGestureRecognizer:tap];
        [self.view addSubview:_sayHiV];
    }
    return _sayHiV;
}
- (void)shakeView:(UIView*)viewToShake
{
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        //        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = CGAffineTransformRotate(viewToShake.transform, M_PI_2/3.0);
        
        //        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformRotate(viewToShake.transform, -M_PI_2/3.0);
            } completion:NULL];
        }
    }];

}

- (void)sayHiClick:(UIButton *)sender {
    [MobClick event:@"SendMessage"];
    [self sendTextMessage:@"👋 Hi~"];
    [self.sayHiV removeFromSuperview];
//    EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"您好" emotionId:@"em1001" emotionThumbnail:@"icon_002_cover" emotionOriginal:@"icon_002" emotionOriginalURL:@"" emotionType:2];
//    [self didSendText:emotion.emotionTitle withExt:@{EASEUI_EMOTION_DEFAULT_EXT:emotion}];
    [self.chatToolbar endEditing:YES];
}

#pragma mark - 挪车相关
-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    //修改倒计时标签现实内容
    _tipTimeL.text =[NSString stringWithFormat:@" %@",format_time];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [self.moveCarView setHidden:YES];
        [countDownTimer invalidate];
        [self.view endEditing:YES];
        kWeakSelf(self);
        [[NetWorking network] POST:KMoveCarDown params:@{@"userId":weakSelf.userId} cache:NO success:^(NSDictionary* result) {
            NSLog(@"------------------挪车倒计时结束 %@",result);
            if (kNotNil(result)) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showMoveOverViewWithMoveCarID:result[@"id"]];
            }
        } failure:^(NSString *description) {
            
        }];
        if (_friStaus ==2) {
            [self.addFriView setHidden:YES];
            self.tableView.tableHeaderView = nil;
        }else{
            [self.addFriView setHidden:NO];
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];

            if (_friStaus ==1) {
                [_addButton setTitle:@"等待验证" forState:0];
                [_addButton setEnabled:NO];
            }else {
                [_addButton setTitle:@"加好友" forState:0];
                [_addButton setEnabled:YES];
            }
        }
    }
}
- (BOOL)messageViewControllerShouldMarkMessagesAsRead:(EaseMessageViewController *)viewController {
    return YES;
}
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read {
    return NO;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    if (!messageModel.isSender) {
        if ([self.userId isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"]) {
            return;
        }else {
            [[CSRouter share]push:@"OwnerViewController" Params:@{@"userID":self.userId,@"delFlag":@"0"} hideBar:YES];
        }
    }else{
        [[CSRouter share]push:@"OwnerViewController" Params:@{@"userID":[XLBUser user].userModel.ID,@"delFlag":@"0"} hideBar:YES];
    }
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationCenter" object:@"MoveCarOver"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationCenter" object:@"reload"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationCenter" object:@"removeAllCashArr"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [countDownTimer invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:addTextField];

}
-(NSMutableArray*)cashArr{
    if (!_cashArr) {
        _cashArr =[NSMutableArray array];
    }
    return _cashArr;
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



@end
