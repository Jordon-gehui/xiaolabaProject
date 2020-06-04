//
//  XLBMessageViewController.m
//  xiaolaba
//
//  Created by lin on 2017/6/29.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMessageViewController.h"
#import "XLBMessageCell.h"
#import <Hyphenate/Hyphenate.h>
#import "XLBMsgRequestModel.h"
#import "XLBChatViewController.h"
#import "XLBChatGroupViewController.h"
#import "XLBUser.h"
#import "CSRouter.h"
#import "MsgNoticeModel.h"
#import "XLBPraiseListController.h"
#import "HideMsgViewController.h"
#import "XLBEaseMobManager.h"
#import "XLBNotLoginView.h"
#import "XLBLoginViewController.h"
#import "XLBErrorView.h"
#import "XLBMessageSheetView.h"


/*
 [XLBNetwork.m:115行] ----------- params = {
 userIds = 8283598167760896;
 }   url  user/user/usli
 [XLBNetwork.m:133行] ----------- responseObject  - {
 code = 000000;
 data =     (
 {
 id = 8283598167760896;
 img = "http://wx.qlogo.cn/mmopen/BuAtQhyDJ3LDwFQia0IsjctOTxhIz0LJDrZvGo4WvoXfGbN916fceOF8ica9jhG3eicPxPQzeKNGzIW41U00T0WiaU05aeBagFfO/0";
 nickname = "\U7edd\U4e16\U7f8e\U5973";
 }
 );
 message = success;
 }
 [XLBMessageViewController.m:51行] from：8283598167760896
 to:5
 
 */

@interface XLBMessageViewController () <EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate,XLBMessageSheetViewDelegate>
{
    FMDatabase *_db;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTableTop;

@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (nonatomic, strong) NSDictionary *callNODic;


@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *defaultArray;
@property (nonatomic, strong) NSMutableArray *meeageArr;
@property (nonatomic, strong) NSMutableArray *allDataArr;
@property (nonatomic, strong) NSMutableArray *dataSou;

@property (nonatomic, strong) NSDate *lastPlaySoundDate;

@property (nonatomic, assign) NSInteger msgCount;
@property (nonatomic, assign) NSInteger noctiCount;
@property (nonatomic, strong) XLBNotLoginView *notV;
@property (nonatomic, strong) XLBErrorView *errorV;
@property (nonatomic, strong) XLBMessageSheetView *messageSheetView;
//@property (nonatomic, copy) NSString *noticeCount;
@property (nonatomic, strong) NSMutableArray *stickGroupList;


@end

@implementation XLBMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        _stickGroupList=[[[XLBCache cache]cache:@"stickGroupList"] mutableCopy];
        [self requestNotice];
        if([EMClient sharedClient].isLoggedIn) {
            [self reloadAllMsgView];
        }else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(easeMobIsLogin:) name:@"EaseMobIsLogin" object:nil];
        }
    }else {
        [self.dataSou removeAllObjects];
        [self.messageTable reloadData];
//        [self notV];
        [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"NSNotificationCenter" object:@"cs"];
    [center addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    self.title = @"消息";
    self.naviBar.slTitleLabel.text = @"消息";
    [self setup];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [[NetWorking network] POST:kCallContent params:nil cache:NO success:^(id result) {
        _callNODic = result[0];
//        self.callNODic = @{@"callName":@"小喇叭平台",@"callNOList":@[@"1111",@"2222"]};
    }failure:^(NSString *description) {

    }];
}

- (void) initNaviBar {
    [super initNaviBar];

    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage *img = [UIImage imageNamed:@"icon_xx_tj"];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setImage:img forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];

}

- (void)rightClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    [self messageSheetViewAlpheWithFloat:1];
}

- (void)loginBtnClick {
    [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:^(id data) {
        
    }];
}
- (void)loginSuccess {
//    [_notV removeFromSuperview];
//    _notV = nil;
    _stickGroupList=[[[XLBCache cache]cache:@"stickGroupList"] mutableCopy];
    [self requestNotice];
    [self reloadAllMsgView];
}
- (void)easeMobIsLogin:(NSNotification *)notification {
    _stickGroupList=[[[XLBCache cache]cache:@"stickGroupList"] mutableCopy];
    [self requestNotice];
    [self reloadAllMsgView];
}

- (void)requestNotice {

    [[NetWorking network] POST:kNoticeNews params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            self.errorV.hidden = YES;
            [self.defaultArray removeAllObjects];
            NSInteger count = 0;
            for (NSDictionary *Dict in result) {
                
                XLBSessionModel *model = [[XLBSessionModel alloc] init];
                model.em_unRead = [Dict objectForKey:@"content"];
                model.em_lastMsg = [Dict objectForKey:@"summary"];
                model.em_time = [Dict objectForKey:@"pushDate"];
                model.em_date = [Dict objectForKey:@"pushDate"];

                if (kNotNil([Dict objectForKey:@"content"])) {
                    count += [[Dict objectForKey:@"content"] integerValue];
                }

                if ([[Dict objectForKey:@"type"] isEqualToString:@"0"]) {
                    model.em_id = @"type0";
                }
                else if ([[Dict objectForKey:@"type"] isEqualToString:@"1"]) {
                    model.em_id = @"type1";
                }
                else if ([[Dict objectForKey:@"type"] isEqualToString:@"2"]) {
                    model.em_id = @"type2";
                }
                else if ([[Dict objectForKey:@"type"] isEqualToString:@"3"]) {
                    model.em_id = @"type3";
                }
                else if ([[Dict objectForKey:@"type"] isEqualToString:@"4"]) {
                    model.em_id = @"type4";
                }
                else if ([[Dict objectForKey:@"type"] isEqualToString:@"5"]) {
                    model.em_id = @"type5";
                }
                [self.defaultArray addObject:model];

            }
            _noctiCount = count;
            NSLog(@"%@",self.defaultArray);
            [self.dataSou removeAllObjects];
            [self.allDataArr removeAllObjects];
            [self.allDataArr addObjectsFromArray:self.dataSource];
            [self.allDataArr addObjectsFromArray:self.defaultArray];
            [self.dataSou addObjectsFromArray:[self stickWithDataSoure:[self dateWithDateArr:self.allDataArr]]];

            if (_noctiCount + _msgCount >= 0) {
                if (_noctiCount + _msgCount > 0) {
                    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
                    [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
                    [userDefa synchronize];
                    [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%li",_noctiCount + _msgCount]];
                }else {
                    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
                    [userDefa setObject:@0 forKey:@"kMsgCount"];
                    [userDefa synchronize];
                    [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
                }
            }else {
                [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
            }
            [self.messageTable reloadData];
        }
        
    } failure:^(NSString *description) {
        self.errorV.hidden = NO;
        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
    }];

}

-(void) reloadAllMsgView {

    NSString *userID = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableString *userIds = [NSMutableString string];
    NSMutableArray *groupIds = [NSMutableArray array];
    NSArray <EMConversation *>*conversations = [[EMClient sharedClient].chatManager getAllConversations];
    _msgCount = 0;
    [conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(!kNotNil(obj.latestMessage.from)) return ;
        if(!kNotNil(obj.latestMessage.to)) return ;
        XLBSessionModel *model = [[XLBSessionModel alloc] init];

        NSLog(@"%@,%@,%@",obj.latestMessage.from,obj.latestMessage.to,userID);
        if (obj.type == EMConversationTypeGroupChat) {
            [groupIds addObject:obj.conversationId];
            model.em_id = obj.conversationId;
        }else {
            NSString *from = [userID isEqualToString:obj.latestMessage.from] ? obj.latestMessage.to:obj.latestMessage.from;
            [userIds appendString:from];
            if(idx < conversations.count - 1) {
                [userIds appendString:@","];
            }
            model.em_id = from;

        }

        _msgCount += obj.unreadMessagesCount;
        if (_msgCount + _noctiCount > 0) {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%li",_noctiCount + _msgCount]];
        }else {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        }
        model.em_unRead = [NSString stringWithFormat:@"%d",obj.unreadMessagesCount];
        model.em_time = [NSString stringWithFormat:@"%lld",obj.latestMessage.localTime];
        model.em_date = [NSString stringWithFormat:@"%lld",obj.latestMessage.localTime];
        model.messageID = obj.latestMessage.messageId;
        model.type = [NSString stringWithFormat:@"%d",obj.type];
        id text = obj.latestMessage.body;
        if([text isKindOfClass:[EMTextMessageBody class]]) {
            EMTextMessageBody *body = text;
            if ([body.text isEqualToString:@"xiaolaba通话无人接听"]) {
                if (obj.latestMessage.direction) {
                    model.em_lastMsg = @"您有一个未接来电";
                }else {
                    model.em_lastMsg = @"您的通话无人接听";
                }
            }else if ([body.text isEqualToString:@"xiaolaba已取消"]) {
                model.em_lastMsg = @"[语音通话]";
            }else {
                model.em_lastMsg = body.text;
            }
//            model.em_lastMsg = [self NSStringTransformeGift:body.text isSender:[userID isEqualToString:obj.latestMessage.from]];
        }
        else if ([text isKindOfClass:[EMVoiceMessageBody class]]) {
            model.em_lastMsg = @"[语音]";
        }
        else if ([text isKindOfClass:[EMVideoMessageBody class]]) {
            model.em_lastMsg = @"[视频]";
        }
        else if ([text isKindOfClass:[EMImageMessageBody class]]) {
            model.em_lastMsg = @"[图片]";
        }
        else if ([text isKindOfClass:[EMLocationMessageBody class]]) {
            model.em_lastMsg = @"[位置]";
        }
        [temp addObject:model];
    }];
    
    kWeakSelf(self);
    NSString *groupS = [NSString stringWithFormat:@"%@",[groupIds componentsJoinedByString:@","]];
    [XLBMsgRequestModel requestSessionUserId:userIds groupIds:groupS session:temp success:^(NSMutableArray<XLBSessionModel *> *modes) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSou removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:modes];
        [weakSelf.allDataArr removeAllObjects];
        [weakSelf.allDataArr addObjectsFromArray:self.dataSource];
        [weakSelf.allDataArr addObjectsFromArray:weakSelf.defaultArray];
        [self.dataSou addObjectsFromArray:[self stickWithDataSoure:[self dateWithDateArr:self.allDataArr]]];
        [weakSelf.messageTable reloadData];
    } failure:^(NSString *error) {
//        [MBProgressHUD showError:@"出错了，请稍后重试"];
    }];
    if (_noctiCount + _msgCount >= 0) {
        NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
        [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
        [userDefa synchronize];
    }
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
        if (kNotNil([userDefa objectForKey:@"kMsgCount"]) && [[userDefa objectForKey:@"kMsgCount"] integerValue] > 0) {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@",[userDefa objectForKey:@"kMsgCount"]]];
        }else {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        }
        NSLog(@"____%@",[userDefa objectForKey:@"kMsgCount"]);
    }else {
        [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
    }
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    
    [aMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        EMMessage *message = (EMMessage *)obj;
        [self updateList:message];
    }];
}


- (void)updateList:(EMMessage *)message {
    
    NSString *ID = message.from;
    if (self.dataSource.count==0) {
        [self reloadAllMsgView];
    }else{
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBSessionModel *model = (XLBSessionModel *)obj;
            if([model.em_id isEqualToString:ID]) {
                
                id text = message.body;
                if([text isKindOfClass:[EMTextMessageBody class]]) {
                    EMTextMessageBody *body = text;
                    if ([body.text isEqualToString:@"xiaolaba通话无人接听"]) {
                        if (message.direction) {
                            model.em_lastMsg = @"您有一个未接来电";
                        }else {
                            model.em_lastMsg = @"您的通话无人接听";
                        }
                    }else {
                        model.em_lastMsg = body.text;
                    }
                }
                else if ([text isKindOfClass:[EMVoiceMessageBody class]]) {
                    model.em_lastMsg = @"[语音]";
                }
                else if ([text isKindOfClass:[EMVideoMessageBody class]]) {
                    model.em_lastMsg = @"[视频]";
                }
                else if ([text isKindOfClass:[EMImageMessageBody class]]) {
                    model.em_lastMsg = @"[图片]";
                }
                else if ([text isKindOfClass:[EMLocationMessageBody class]]) {
                    model.em_lastMsg = @"[位置]";
                }
                model.em_unRead = [NSString stringWithFormat:@"%ld",[model.em_unRead integerValue] + 1];
                model.em_time = [NSString stringWithFormat:@"%lld",message.localTime];
                model.messageID = message.messageId;
                if ([[self topViewController] isKindOfClass:[XLBMessageViewController class]] && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                    [self.messageTable reloadRowsAtIndexPaths:@[model.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else {
                [self reloadAllMsgView];
            }
        }];
    }
}

- (void)setup {
    
    self.messageTable.rowHeight = 65;
    self.messageTable.backgroundColor = RGB(247, 247, 247);
    self.messageTable.tableFooterView = [UIView new];
    self.messageTableTop.constant = self.naviBar.bottom;
    self.naviBar.slTitleLabel.text = @"消息";
}

- (void)receiveNotificiation:(NSNotification*)sender {
    _stickGroupList=[[[XLBCache cache]cache:@"stickGroupList"] mutableCopy];
    [self requestNotice];

}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSou.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMessageCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMessageCell class]) owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        XLBSessionModel *model = self.dataSou[indexPath.row];
        model.indexPath = indexPath;
        cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
    XLBSessionModel *model = self.dataSou[indexPath.row];
    
    if ([model.em_id containsString:@"type"]) {
        if ([model.em_id isEqualToString:@"type0"]) {
            [[CSRouter share]push:@"XLBMsgSystemViewController" Params:nil hideBar:YES];
        }
        else if ([model.em_id isEqualToString:@"type1"]) {
            [[CSRouter share]push:@"MoveCarNotifitionVC" Params:nil hideBar:YES];
        }
        else if ([model.em_id isEqualToString:@"type2"]) {
            [[CSRouter share]push:@"XLBMsgNotifitionViewController" Params:nil hideBar:YES];
        }
        else if ([model.em_id isEqualToString:@"type3"]) {
            [self pushPraiseVCWithString:@"粉丝"];
        }
        else if ([model.em_id isEqualToString:@"type4"]) {
            [self pushPraiseVCWithString:@"赞"];
        }
        else if ([model.em_id isEqualToString:@"type5"]) {
            [self pushPraiseVCWithString:@"评论"];
        }
        _noctiCount = _noctiCount - [model.em_unRead integerValue];
        [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
        
    }else if([model.type isEqualToString:@"1"]){
        XLBChatGroupViewController *chat = [[XLBChatGroupViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",model.em_id] conversationType:EMConversationTypeGroupChat];
        chat.nickName = model.em_nickname;
        chat.hidesBottomBarWhenPushed = YES;
        _msgCount = _msgCount - [model.em_unRead integerValue];
        [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
        [self.navigationController pushViewController:chat animated:YES];
    }else {
        XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",model.em_id] conversationType:EMConversationTypeChat];
        chat.hidesBottomBarWhenPushed = YES;
        chat.nickname = model.em_nickname;
        chat.avatar = model.em_avatar;
        chat.userId = [NSString stringWithFormat:@"%@",model.em_id];
        _msgCount = _msgCount - [model.em_unRead integerValue];
        [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
        [self.navigationController pushViewController:chat animated:YES];
    }
    [userDefa synchronize];
    [self.messageTable reloadData];

}
#pragma make -- 表格左滑
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBSessionModel *model = self.dataSou[indexPath.row];
    if ([model.em_id containsString:@"type"] || [model.type isEqualToString:@"1"]) {
        return nil;
    }
    kWeakSelf(self)
    __block NSIndexPath *index = indexPath;
    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
    UITableViewRowAction *hideAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"隐藏聊天记录" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        HideMsgViewController *hideVC = [HideMsgViewController new];
        hideVC.em_id = model.em_id;
        hideVC.model = model;
        hideVC.returnBlock = ^(id data) {
            [self.dataSource removeObject:model];
            [self.dataSou removeObjectAtIndex:index.row];
            
            _msgCount = _msgCount - [model.em_unRead integerValue];
            
            //            [self.messageTable deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
            
        };
        if (_msgCount + _noctiCount > 0) {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%li",_noctiCount + _msgCount]];
        }else {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        }
        [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
        [userDefa synchronize];
        hideVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:hideVC animated:YES];
        
    }];
    hideAction.backgroundColor = [UIColor lightGrayColor];
    
    
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        [self.dataSource removeObject:model];
        [self.dataSou removeObjectAtIndex:indexPath.row];
        _msgCount = _msgCount - [model.em_unRead integerValue];
        [[EMClient sharedClient].chatManager deleteConversation:model.em_id isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError){
        }];
        if (_msgCount + _noctiCount > 0) {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%li",_noctiCount + _msgCount]];
        }else {
            [[[[[RootTabbarController sharedRootBar] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        }
        [userDefa setObject:@(_noctiCount + _msgCount) forKey:@"kMsgCount"];
        [userDefa synchronize];
        
        [self deleteTableWithToID:model.em_id];
        
        [self.messageTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
    
    
    return @[deleAction,hideAction,];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBSessionModel *model = self.dataSou[indexPath.row];
    if ([model.em_id containsString:@"type"] || [model.type isEqualToString:@"1"]) return NO;
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBSessionModel *model = self.dataSou[indexPath.row];
    if ([model.em_id containsString:@"type"] || [model.type isEqualToString:@"1"]) return NO;
    return NO;
}
- (NSMutableArray *)stickWithDataSoure:(NSMutableArray<XLBSessionModel *>*)array {
    NSMutableArray *returnArr = [NSMutableArray array];
    NSMutableArray *stickArr = [NSMutableArray array];
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:array];
    [array enumerateObjectsUsingBlock:^(XLBSessionModel * _Nonnull session, NSUInteger idx, BOOL * _Nonnull stop) {
        if (kNotNil(_stickGroupList) && _stickGroupList.count > 0) {
            [_stickGroupList enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([session.em_id isEqualToString:obj]) {
                    [stickArr addObject:session];
                    [dataArr removeObject:session];
                }
            }];
        }
    }];
    [returnArr addObjectsFromArray:stickArr];
    [returnArr addObjectsFromArray:dataArr];
    return returnArr;
}

- (NSMutableArray *)dateWithDateArr:(NSArray *)dateArr{
    
    NSMutableArray *sortArray = (NSMutableArray *)[dateArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        XLBSessionModel *pModel1 = obj1;
        XLBSessionModel *pModel2 = obj2;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
        
        NSDate *date1= [dateFormatter dateFromString:pModel1.em_date];
        NSDate *date2= [dateFormatter dateFromString:pModel2.em_date];
        
        if (date1 == [date1 earlierDate: date2]) {
            return NSOrderedDescending;
            
        }else if (date1 == [date1 laterDate: date2]) {
            return NSOrderedAscending;
            
        }else{
            return NSOrderedSame;
        }  
    }];
    return sortArray;
}

- (void)pushPraiseVCWithString:(NSString *)praise {
    XLBPraiseListController *praiseListVC = [XLBPraiseListController new];
    praiseListVC.praiseAndFans = praise;
    praiseListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:praiseListVC animated:YES];
}


- (void)didSeletedMessageSheetViewBtnClick:(UIButton *)sender {
    [self messageSheetViewAlpheWithFloat:0];
    switch (sender.tag) {
        case MessageSheetAddGroupBtnTag: {
            [[CSRouter share] push:@"XLBAddGroupMemberViewController" Params:@{@"titleStr":@"创建群聊",@"type":@"2"} hideBar:YES];
        }
            break;
        case MessageSheetAddFriendBtnTag: {
            if (kNotNil(self.callNODic)) {
                [[CSRouter share]push:@"AddFriendsViewController" Params:@{@"callNODic":self.callNODic} hideBar:YES];
            }else{
                [[CSRouter share]push:@"AddFriendsViewController" Params:nil hideBar:YES];
            }
        }
            break;
        case MessageSheetGroupListBtnTag: {
            [[CSRouter share] push:@"XLBGroupListViewController" Params:nil hideBar:YES];
        }
            break;
        case MessageSheetScanBtnTag: {
            [[CSRouter share] push:@"ScanViewController" Params:@{@"type":@"3"} hideBar:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)messageSheetViewAlpheWithFloat:(CGFloat)alpha {
    [UIView animateWithDuration:0.2 animations:^{
        self.messageSheetView.alpha = alpha;
    }];
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

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)meeageArr {
    if (!_meeageArr) {
        _meeageArr = [NSMutableArray array];
    }
    
    return _meeageArr;
}

- (NSMutableArray *)allDataArr {
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray array];
    }
    
    return _allDataArr;
}

- (NSMutableArray *)defaultArray {
    if (!_defaultArray) {
        _defaultArray = [NSMutableArray array];
    }
    
    return _defaultArray;
}

- (NSMutableArray *)dataSou {
    if (!_dataSou) {
        _dataSou = [NSMutableArray array];
    }
    
    return _dataSou;
}

//- (XLBNotLoginView *)notV {
//    if (!_notV) {
//        _notV = [[XLBNotLoginView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:@"0"];
//        [_notV.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.messageTable addSubview:_notV];
//    }
//    return _notV;
//}
- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.messageTable addSubview:_errorV];
    }
    return _errorV;
}
- (XLBMessageSheetView *)messageSheetView {
    if (!_messageSheetView) {
        _messageSheetView = [[XLBMessageSheetView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:AlertSheetTypeDefault];
        _messageSheetView.alpha = 0;
        _messageSheetView.delegate = self;
        [self.view.window addSubview:_messageSheetView];
    }
    return _messageSheetView;
}

- (void)errorViewTap {
    _stickGroupList=[[[XLBCache cache]cache:@"stickGroupList"] mutableCopy];
    [self requestNotice];
    [self reloadAllMsgView];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationCenter" object:@"cs"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EaseMobIsLogin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSString*)NSStringTransformeGift:(NSString *)string isSender:(BOOL)isSender{
    if ([string isEqualToString:@"@13445"]) {
        if (isSender) {
            return [NSString stringWithFormat:@"您发送一个礼物%@",string];
        }else{
            return [NSString stringWithFormat:@"您收到一个礼物%@",string];
        }
    }
    return string;
}

@end
