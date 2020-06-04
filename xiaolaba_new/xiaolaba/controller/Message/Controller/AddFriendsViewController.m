//
//  AddFriendsViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/9.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "XLBFindUserModel.h"
#import "AddFriendCell.h"
#import "FriendCell.h"
#import "XLBChatViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "XLBAddressTool.h"
#define MAX_STARWORDS_LENGTH 20
@interface AddFriendsViewController()<FriendCellDelegate>
{
    UITextField *addTextField;
}
@end
static NSString * const addFri = @"addcell";
static NSString * const Fri = @"fricell";


@implementation AddFriendsViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchController.active = NO;
    self.showBtn = YES;
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.showBtn = YES;
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    self.searchMode =  SearchModeAction;
    [super viewDidLoad];
    self.title = @"加好友";
    self.naviBar.slTitleLabel.text = @"加好友";
    [MobClick event:@"AddFriend"];
    /// 设置数据
    [[XLBAddressTool addressToolShared] setDict:self.callNODic];
    [[XLBAddressTool addressToolShared] creatPhoneNumber];
    
    [self.tableView registerClass:[AddFriendCell class] forCellReuseIdentifier:addFri];
    [self.tableView registerClass:[FriendCell class] forCellReuseIdentifier:Fri];

    self.showBtn = YES;
    self.page = 1;
    self.size = 20;
    [self loadHttpRecommendFriend];
    kWeakSelf(self);
    self.tableView.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    /// 更新数据
    self.updateSearchResultsConfigure = ^(NSString *searchText){
        if (weakSelf.searchController.active == NO) {
            weakSelf.showBtn = YES;
            [weakSelf.tableView reloadData];
        }else{
            weakSelf.showBtn = NO;
            [weakSelf.tableView reloadData];
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf loadMore];
            }];
            weakSelf.page = 1;
            [weakSelf searchRequestData:searchText];
        }
        // NSPredicate 谓词
        
        return weakSelf.dataArr;
        
//        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText];
//        return [weakSelf.dataArr filteredArrayUsingPredicate:searchPredicate];
    };
    self.heightForRowAtIndexPathConfigure = ^CGFloat(UITableView *tableView, NSIndexPath *indexPath, BOOL isSearching) {
        if (isSearching) {
            return 70;
        }
        return 100;

    };
    /// 点击了某一行
    self.didSelectRowAtIndexPathConfigure = ^(UITableView *tableView, NSIndexPath *indexPath, BOOL isSearching){
        
        NSLog(@"点击了第 %zi 行", indexPath.row);
        weakSelf.searchController.active = NO;
        
        XLBFindUserModel *title = isSearching ? weakSelf.searchResults[indexPath.row] : weakSelf.dataArr[indexPath.row];
        [weakSelf performSelector:@selector(pushOwnerVC:) withObject:title.ID afterDelay:0.5];
        NSLog(@"---%@---", title.nickname);
    };
}
-(void)pushOwnerVC:(NSString *)userId {
    OwnerViewController *ownerVC= [OwnerViewController new];
    ownerVC.userID =userId;
    ownerVC.delFlag = 0;
    [self.navigationController pushViewController:ownerVC animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showBtn ==NO) {
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:Fri forIndexPath:indexPath];
        XLBFindUserModel *dic = [self.searchResults objectAtIndex:indexPath.row];
        [cell setFriendModel:dic status:FriendCellNone];
        [cell setDelegate:self];
        return cell;
    }else{
        AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:addFri forIndexPath:indexPath];
        XLBFindUserModel *dic = [self.dataArr objectAtIndex:indexPath.row];
        [cell setFriendModel:dic];
        return cell;
    }
    
}
-(void)loadMore {
    self.page++;
    if (self.showBtn ==NO) {
        [self searchRequestData:self.searchController.searchBar.text];
    }else{
        [self loadHttpRecommendFriend];

    }
}

- (void)friendCell:(FriendCell *)cell addFriendDic:(FriendModel*)userDic{
    [cell.rightBtn setEnabled:NO];
    NSString *userId = [NSString stringWithFormat:@"%@",userDic.userId];
    if ([cell.rightBtn.titleLabel.text isEqualToString:@"加好友"]) {
        [self showAddfriendMsgAlert:cell userId:userId];
    }else if ([cell.rightBtn.titleLabel.text isEqualToString:@"发消息"]) {
        [cell.rightBtn setEnabled:YES];
        XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:userId conversationType:EMConversationTypeChat];
        chat.hidesBottomBarWhenPushed = YES;
        chat.nickname = userDic.nickname;
        chat.avatar = userDic.img;
        chat.userId = userId;
        [self.navigationController pushViewController:chat animated:YES];
    }else if([cell.rightBtn.titleLabel.text isEqualToString:@"邀请"]) {
        [cell.rightBtn setEnabled:YES];
    }else{//关注
        [cell.rightBtn setEnabled:YES];
    }
}
- (void)showAddfriendMsgAlert:(FriendCell*)cell userId:(NSString*)userId {
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
            [self addfriend:envirnmentNameTextField.text cell:cell userId:userId];
        }else{
            [self addfriend:@"" cell:cell userId:userId];
        }
    }]];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}
-(void)addfriend:(NSString*)string cell:(FriendCell*)cell userId:(NSString*)userId{
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kAddFriend params:@{@"friendId":userId,@"message":string} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 加好友 %@",result);
        [weakSelf hideHud];
        [MBProgressHUD showError:@"已发送好友请求"];
        for (XLBFindUserModel*model in self.searchResults) {
            NSString *modelID = [NSString stringWithFormat:@"%@",model.ID];
            if([modelID isEqualToString:userId]){
                model.friends = @"1";
            }
        }
        [cell.rightBtn setTitle:@"等待验证" forState:0];
        //        [btn removeFromSuperview];
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [cell.rightBtn setEnabled:YES];
    }];
}
-(void)loadHttpRecommendFriend {
    
    NSMutableDictionary *params = [@{@"page":@{@"curr":@(self.page),
                                               @"size":@(self.size)},
                                     @"lng":[XLBUser user].longitude,
                                     @"lat":[XLBUser user].latitude} mutableCopy];
    [[NetWorking network] POST:krecommendFriend params:params cache:NO success:^(id result) {
        NSArray *list = [result objectForKey:@"list"];
        NSMutableArray <XLBFindUserModel *>*modelArray = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBFindUserModel *model = [XLBFindUserModel mj_objectWithKeyValues:obj];
            model.ID = [obj objectForKey:@"id"];
            NSMutableArray *tags = [NSMutableArray array];
            [[obj objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
                [tags addObject:tag];
            }];
            model.tags = tags;
            [modelArray addObject:model];
        }];
        if (self.page == 1) {

            self.dataArr = [NSMutableArray arrayWithArray:modelArray];
        }else{
            [self.dataArr addObjectsFromArray:modelArray];
        }
        [self.tableView reloadData];
        if (list.count!=self.size) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSString *description) {
        
    }];
}
-(void)searchRequestData:(NSString*)string {
    if (string.length<1) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (string.length<3&&[JXutils isNum:string]) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"纯数字搜索必须不少于三位"];
        return;
    }
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kSeacherFri params:@{@"nickname":string,@"page":@{@"curr":@(self.page),@"size":@"10"}} cache:YES success:^(id result) {
        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
        NSArray *list = [result objectForKey:@"list"];
        NSMutableArray <XLBFindUserModel *>*modelArray = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBFindUserModel *model = [XLBFindUserModel mj_objectWithKeyValues:obj];
            model.ID = [obj objectForKey:@"id"];
            NSMutableArray *tags = [NSMutableArray array];
            [[obj objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
                [tags addObject:tag];
            }];
            model.tags = tags;
            [modelArray addObject:model];
        }];
        if (self.page == 1) {
            
            self.searchResults = [NSMutableArray arrayWithArray:modelArray];
        }else{
            [self.searchResults addObjectsFromArray:modelArray];
        }
        
        if (list.count!=self.size) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        NSLog(@"%@",modelArray);
        [weakSelf.tableView reloadData];
    } failure:^(NSString *description) {
        
    }];
}
//头视图
-(UIView*)tableviewHeaderView {
    UIView *headView = [UIView new];
    [headView setBackgroundColor:[UIColor whiteColor]];
    float btnSize = 90;
    float space =(kSCREEN_WIDTH-btnSize*2)/3.0;
    if ([BQLAuthEngine isWXAppInstalled]&&[BQLAuthEngine isWeiboAppInstalled]) {
        space = (kSCREEN_WIDTH-btnSize*3)/4.0;
    }else if(![BQLAuthEngine isWXAppInstalled]&&![BQLAuthEngine isWeiboAppInstalled]){
        space =(kSCREEN_WIDTH-btnSize)/2.0;
    }
    if (space <(kSCREEN_WIDTH-btnSize)/2.0-1) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(1.5*space+btnSize, 30, 1, 40)];
        lineView.backgroundColor = [UIColor lineColor];
        [headView addSubview:lineView];
    }
    [headView addSubview:[self addButtonWithFrame:CGRectMake(space, 5, btnSize,btnSize) image:[UIImage imageNamed:@"msg_icon_txl"] title:@"添加通讯录好友" action:@selector(bookBtnClick:)]];
    if (![BQLAuthEngine isWXAppInstalled]) {
        if ([BQLAuthEngine isWeiboAppInstalled]) {
            [headView addSubview:[self addButtonWithFrame:CGRectMake(btnSize+2*space, 5, btnSize,btnSize) image:[UIImage imageNamed:@"msg_icon_wb"] title:@"添加微博好友" action:@selector(weiboBtnClick:)]];
        }
    }else{
        [headView addSubview:[self addButtonWithFrame:CGRectMake(btnSize+2*space, 5, btnSize, btnSize) image:[UIImage imageNamed:@"msg_icon_wx"] title:@"邀请微信好友" action:@selector(wechatBtnClick:)]];
        if ([BQLAuthEngine isWeiboAppInstalled]) {
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(btnSize*2+2.5*space, 30, 1, 40)];
            lineView2.backgroundColor = [UIColor lineColor];
            [headView addSubview:lineView2];
            [headView addSubview:[self addButtonWithFrame:CGRectMake(btnSize*2+3*space, 5, btnSize,btnSize) image:[UIImage imageNamed:@"msg_icon_wb"] title:@"添加微博好友" action:@selector(weiboBtnClick:)]];
        }

    }
    
    [headView sizeToFit];
    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kSCREEN_WIDTH, 44)];
    tipView.backgroundColor = [UIColor viewBackColor];
    UILabel*tipLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, kSCREEN_WIDTH-30, 30)];
    tipLbl.font = [UIFont systemFontOfSize:13];
    tipLbl.text = @"为您推荐";
    tipLbl.textColor = [UIColor commonTextColor];
    [tipView addSubview:tipLbl];
    [headView addSubview:tipView];
    return headView;
}
-(UIView*)addButtonWithFrame:(CGRect)frame image:(UIImage*)img title:(NSString*)title action:(SEL)action{
    UIView *btnView = [[UIView alloc]initWithFrame:frame];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 40, 40)];
    [image setImage:img];
    [btnView addSubview:image];
    UILabel *lebl = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 90, 20)];
    lebl.font = [UIFont systemFontOfSize:12];
    lebl.textAlignment = NSTextAlignmentCenter;
    lebl.text = title;
    lebl.textColor = [UIColor minorTextColor];
    [btnView addSubview:lebl];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [btnView addGestureRecognizer:tap];
    return btnView;
}
-(void)bookBtnClick:(id)sender{
    [[CSRouter share]push:@"AdressBookViewController" Params:nil hideBar:YES];

}
-(void)wechatBtnClick:(id)sender{
    [[NetWorking network] POST:kUicode params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = @"小喇叭-高端交友！！";
            message.description = @"在小喇叭看到的俊男靓女我很喜欢，快来看看呦~";
            UIImage *imag = [UIImage imageNamed:@"abc"];
            [message setThumbImage:imag];
            
            WXWebpageObject *webpageobject = [WXWebpageObject object];
            webpageobject.webpageUrl = [NSString stringWithFormat:@"http://t.cn/RQXH215"];
            message.mediaObject = webpageobject;
            
            SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.scene = WXSceneSession;
            req.message = message;
            [WXApi sendReq:req];
        }
    } failure:^(NSString *description) {
        
    }];

}
-(void)weiboBtnClick:(id)sender{
    [[CSRouter share]push:@"WeiBoViewController" Params:nil hideBar:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0&&self.showBtn==YES) {
        return  [self tableviewHeaderView];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0&&self.showBtn==YES) {
        return  144;
    }
    return 0.01;
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

@end
