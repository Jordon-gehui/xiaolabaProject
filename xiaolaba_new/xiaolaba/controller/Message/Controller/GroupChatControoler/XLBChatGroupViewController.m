//
//  XLBChatGroupViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBChatGroupViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImage+GIF.h>
#import "XLBGroupModel.h"
#import "XLBGroupDetailViewController.h"
@interface XLBChatGroupViewController ()<EaseMessageViewControllerDataSource,EaseMessageViewControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    NSString *meNickName;
}
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) EMGroup *group;
@property (nonatomic, strong) XLBGroupModel *groupModel;
@property (nonatomic, strong) SLNavigationBar *navBar;


@end

@implementation XLBChatGroupViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.chatBarMoreView removeItematIndex:3];
    //删除功能模块中的录制视频(注意:删除通话以后,视频的索引变成了3,所以这里还是3哦)
    [self.chatBarMoreView removeItematIndex:3];
    kWeakSelf(self);
    [self setUp];
    [self setGroupDetail];

    self.tableView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    self.tableView.backgroundColor = [UIColor viewBackColor];
}

- (void)setGroupDetail {
    //群详情
    [[NetWorking network] POST:kGroupSelf params:@{@"groupHuanxin":self.conversation.conversationId} cache:NO success:^(id result) {
        NSLog(@"%@",result);
        self.groupModel = [XLBGroupModel mj_objectWithKeyValues:result[@"group"]];
        self.groupModel.subModel = [XLBGroupSubModel mj_objectWithKeyValues:result[@"members"]];
        meNickName = self.groupModel.subModel.membersName;
        [super tableViewDidTriggerHeaderRefresh];
    } failure:^(NSString *description) {
        [super tableViewDidTriggerHeaderRefresh];
    }];

    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            self.group = aGroup;
            [[EMClient sharedClient].groupManager getGroupMemberListFromServerWithId:self.conversation.conversationId cursor:nil pageSize:aGroup.occupantsCount completion:^(EMCursorResult *aResult, EMError *aError) {
                if (!aError) {
                    NSLog(@"%@",aResult.list);
                }else {
                    NSLog(@"错误信息%@",aError);
                }
            }];
            
        }
    }];
}
- (void)setUp {
    if (self.nickName) {
        NSString *st;
        if (self.nickName.length > 15) {
            st = [NSString stringWithFormat:@"%@...",[self.nickName substringWithRange:NSMakeRange(0, 15)]];
        }else {
            st = self.nickName;
        }
        self.title = st;
        self.navBar.slTitleLabel.text = st;
    }
    self.dataSource = self;
    self.delegate = self;
    
    [self.navBar setLeftItem:self.backButton];
    [self.navBar setRightItem:self.rightButton];
    
    self.tableView.frame = CGRectMake(0, self.navBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);

    
//    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
//
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)refresh {
    [super tableViewDidTriggerHeaderRefresh];
    [super.tableView.mj_header endRefreshing];
}

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message {
    
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        model.avatarURLPath = [JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar];
        model.nickname = kNotNil(meNickName) ? meNickName : [XLBUser user].userModel.nickname;
        model.failImageName = @"weitouxiang";
    }
    else {
        model.avatarURLPath = message.ext[@"userImg"];
        model.nickname = message.ext[@"userNickName"];
        model.failImageName = @"weitouxiang";
    }
    return model;
}
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    NSLog(@"%@",messageModel.message.ext[@"userId"]);
}

- (void)_sendMessage:(EMMessage *)message{
    NSInteger count = 0;
    for (EaseMessageModel *model in self.dataArray) {
        if ([model isKindOfClass:[EaseMessageModel class]]) {
            //            NSLog(@"%@====%i",model.text,model.isSender);
            if (model.isSender) {
                count++;
            }
        }
    }
    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    NSDictionary *exit = @{@"userImg":[XLBUser user].userModel.img,@"userNickName":kNotNil(meNickName) ? meNickName : [XLBUser user].userModel.nickname,@"userId":[XLBUser user].userModel.ID,};
    NSLog(@"%@",exit);
    if (message.ext == nil) {
        message.ext = exit;
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

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}



- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)rightButtonClick {
    if (kNotNil(_group) && kNotNil(self.groupModel)) {
        XLBGroupDetailViewController *groupDetailVC = [[XLBGroupDetailViewController alloc] init];
        groupDetailVC.groupID = self.conversation.conversationId;
        groupDetailVC.groupDetail = self.group;
        groupDetailVC.model = self.groupModel;
        groupDetailVC.hidesBottomBarWhenPushed = YES;
        groupDetailVC.returnBlock = ^(id data) {
            NSDictionary *dict = (NSDictionary *)data;
            self.title = [dict objectForKey:@"title"];
            self.navBar.slTitleLabel.text = [dict objectForKey:@"title"];
            meNickName = [dict objectForKey:@"meNickName"];
        };
        [self.navigationController pushViewController:groupDetailVC animated:YES];
    }else {
        [MBProgressHUD showError:@"获取群信息失败"];
    }
}
- (void)popViewController {
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
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
