//
//  XLBAddGroupMemberViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAddGroupMemberViewController.h"
#import "BQLChineseString.h"
#import "XLBMyFriendsCell.h"
#import "EaseUI.h"
#import "XLBChatViewController.h"
#import "XLBMsgRequestModel.h"
#import "XLBAlertController.h"
#import "XLBErrorView.h"
#import "UITableView+CCPIndexView.h"
#import "XLBAddGroupMemberTableViewCell.h"
#import "XLBAddGroupMemberBottomView.h"
#import "XLBChatGroupViewController.h"
#import "GroupHeadPortraitView.h"
#import "XLBChatViewController.h"
@interface XLBAddGroupMemberViewController ()
{
    NSString *imgString;
}
@property (nonatomic, strong) NSMutableArray *indexArray; // 索引
@property (nonatomic, assign)BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchData;
@property (nonatomic, strong) NSMutableArray <GroupMemberModel *>*dataSource;
@property (nonatomic, strong) XLBErrorView *errorV;
@property (nonatomic, strong) NSMutableArray *indexArr;

@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) NSMutableDictionary *seleUser;
@property (nonatomic, strong) NSMutableDictionary *seleUserNickName;
@property (nonatomic, strong) NSMutableArray *seleUserAllKeys;
@property (nonatomic, strong) NSMutableArray *groupNameArr;
@property (nonatomic, strong) NSMutableArray *groupImgArr;

@property (nonatomic, strong) XLBAddGroupMemberBottomView *bottomV;

@property (nonatomic, strong) GroupHeadPortraitView *groupImgV;

@end

@implementation XLBAddGroupMemberViewController
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 20);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleStr;
    self.naviBar.slTitleLabel.text = self.titleStr;
    [self bottomV];
    self.tableView.sectionIndexColor = RGB(102, 102, 102);
    [self.tableView ccpIndexView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[XLBAddGroupMemberTableViewCell class] forCellReuseIdentifier:[XLBAddGroupMemberTableViewCell addGroupMemberCellID]];
    [self refresh];
    [self setpUp];
    kWeakSelf(self)
    self.tableView.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    self.heightForRowAtIndexPathConfigure = ^CGFloat(UITableView *tableView, NSIndexPath *indexPath, BOOL isSearching) {
        return 65;
    };
    /// 更新数据
    self.updateSearchResultsConfigure = ^(NSString *searchText){
        if (weakSelf.searchController.active == NO) {
            weakSelf.showBtn = NO;
            [weakSelf.tableView reloadData];
        }else{
            weakSelf.showBtn = YES;
            [weakSelf.tableView reloadData];
            [weakSelf searchRequestData:searchText];
        }
        
        return weakSelf.dataArr;
    };
}

-(void)setpUp {
    for (UIView *subView in self.searchController.searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                UITextField *textField = [subView.subviews objectAtIndex:0];
                textField.backgroundColor = [UIColor whiteColor];
                
                //设置输入框边框的颜色
                textField.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
                textField.layer.borderWidth = 1;
                textField.layer.cornerRadius = 13;
                textField.layer.masksToBounds = YES;
                //设置输入字体颜色
                textField.textColor = [UIColor textBlackColor];
                
                //设置默认文字颜色
                UIColor *color = [UIColor grayColor];
                [textField setAttributedPlaceholder:
                 [[NSAttributedString alloc] initWithString:@"搜索昵称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:color}]];
            }
        }
    }
}
-(void)searchRequestData:(NSString*)string {
    if (string.length<1) {
        return;
    }
    [self filterBySubstring:string];
}


- (void)refresh {
    [self requestData:YES];
}

- (void)loadMore {
    if (self.searchController.searchBar.text.length>0) {
        [self.tableView.mj_footer endRefreshing];
        [self filterBySubstring:self.searchController.searchBar.text];
    }else{
        if (self.showBtn ==YES&&self.searchController.searchBar.text.length<1) {
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        [self requestData:NO];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return self.indexArr;
    }
    return self.indexArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return [self.indexArr count];
    }
    return [self.indexArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [[self.searchData objectAtIndex:section] count];
    }
    return [[self.dataArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLBAddGroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBAddGroupMemberTableViewCell addGroupMemberCellID]];
    
    NSString *value ;
    NSString *imgName ;
    NSString *nickNameValue;
    
    if ([self.type isEqualToString:@"2"]) {
        XLBFriendModel *model;
        if (self.searchController.active) {
            model = self.searchData[indexPath.section][indexPath.row];
            value = [NSString stringWithFormat:@"%@",model.friendId];
            imgName = [NSString stringWithFormat:@"%@",model.img];
            nickNameValue = [NSString stringWithFormat:@"%@",model.nickname];
        }else {
            model = self.dataArr[indexPath.section][indexPath.row];
            value = [NSString stringWithFormat:@"%@",model.friendId];
            imgName = [NSString stringWithFormat:@"%@",model.img];
            nickNameValue = [NSString stringWithFormat:@"%@",model.nickname];
        }
    }else {
        GroupMemberModel *model;
        if (self.searchController.active) {
            model = self.searchData[indexPath.section][indexPath.row];
            value = [NSString stringWithFormat:@"%@",model.membersId];
            imgName = [NSString stringWithFormat:@"%@",model.img];
            nickNameValue = [NSString stringWithFormat:@"%@",model.membersName];
        }else {
            model = self.dataArr[indexPath.section][indexPath.row];
            value = [NSString stringWithFormat:@"%@",model.membersId];
            imgName = [NSString stringWithFormat:@"%@",model.img];
            nickNameValue = [NSString stringWithFormat:@"%@",model.membersName];
        }
    }
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:imgName Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    cell.nickName.text = nickNameValue;
    if ([self.seleUser.allKeys containsObject:value]) {
        [cell.seleImage setImage:[UIImage imageNamed:@"icon_syth_yx"]];
    }else {
        [cell.seleImage setImage:[UIImage imageNamed:@"icon_syth_wx"]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLBAddGroupMemberTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *modelsArray = self.dataArr[indexPath.section];
    NSString *value ;
    NSString *imgName ;
    NSString *nickNameValue;
    if ([self.type isEqualToString:@"2"]) {
        XLBFriendModel *model = modelsArray[indexPath.row];
        value = [NSString stringWithFormat:@"%@",model.friendId];
        imgName = model.img;
        nickNameValue = model.nickname;
    }else {
        GroupMemberModel *model = modelsArray[indexPath.row];
        value = [NSString stringWithFormat:@"%@",model.membersId];
        imgName = model.img;
        nickNameValue = model.membersName;
      }
    if ([self.seleUser.allKeys containsObject:value]) {
        [self.seleUser removeObjectForKey:value];
        [self.seleUserNickName removeObjectForKey:value];
        [self.seleUserAllKeys removeObject:value];
        cell.seleImage.image = [UIImage imageNamed:@"icon_syth_wx"];
    }else {
        [self.seleUser setObject:imgName forKey:value];
        [self.seleUserNickName setObject:nickNameValue forKey:value];
        [self.seleUserAllKeys addObject:value];
        cell.seleImage.image = [UIImage imageNamed:@"icon_syth_yx"];
    }
    [self addBottomViewsWithDict:self.seleUser];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *content = [[UIView alloc] init];
    content.backgroundColor = RGB(247, 247, 247);
    
    UILabel *lab = [UILabel new];
    if (self.searchController.active) {
        lab.text = [self.indexArr objectAtIndex:section];
    }else {
        lab.text = [self.indexArray objectAtIndex:section];
    }
    lab.textColor = [UIColor textBlackColor];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:12];
    [content addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    return content;
}


-(void)pushOwnerViewController:(NSString*)ownerStr {
    self.searchController.active = NO;
    OwnerViewController *ownerVC= [OwnerViewController new];
    ownerVC.userID =ownerStr;
    ownerVC.delFlag = 0;
    [self.navigationController pushViewController:ownerVC animated:YES];
}


- (void) filterBySubstring:(NSString*) subStr {
    NSLog(@"----filterBySubstring------");
    [self.indexArr removeAllObjects];
    [self.searchData removeAllObjects];
    kWeakSelf(self)

    if ([self.type isEqualToString:@"1"]) {
        [self.searchData removeAllObjects];
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *models = [NSMutableArray array];
        [self.dataSource enumerateObjectsUsingBlock:^(GroupMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.membersName lowercaseTranfrom:obj.membersName] containsString:[subStr lowercaseTranfrom:subStr]]) {
                [nameArr addObject:obj.membersName];
                [models addObject:obj];
            }
            
        }];
        [self.tableView.mj_footer endRefreshing];

        NSMutableArray *resultArr = [self searchDataWithArray:nameArr modelArray:models];
        [weakSelf.indexArr addObjectsFromArray:[resultArr objectAtIndex:0]];
        [weakSelf.searchData addObjectsFromArray:[resultArr objectAtIndex:1]];
        [weakSelf.tableView reloadData];
        if (models.count==0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else {
        [XLBMsgRequestModel requestMyFriendWithfriendLike:subStr type:self.type menberList:self.menberList :^(NSArray<NSString *> *indexs, NSArray<NSArray<XLBFriendModel *> *> *models) {
            [self.tableView.mj_footer endRefreshing];
            [weakSelf.indexArr addObjectsFromArray:indexs];
            [weakSelf.searchData addObjectsFromArray:models];
            [weakSelf.tableView reloadData];
            if (models.count==0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSString *error) {
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error];
        }];

    }
}
- (void)requestData:(BOOL )header {
    [self.indexArray removeAllObjects];
    [self.dataArr removeAllObjects];
    [self.dataSource removeAllObjects];
    kWeakSelf(self);
    if ([self.type isEqualToString:@"2"]) {
        //添加群成员
        [XLBMsgRequestModel requestMyFriendWithfriendLike:nil type:self.type menberList:self.menberList :^(NSArray<NSString *> *indexs, NSArray<NSArray<XLBFriendModel *> *> *models) {
            [self.tableView.mj_footer endRefreshing];
            if (models.count==0) {
                self.errorV.hidden = NO;
                self.tableView.tableHeaderView = nil;
                [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
                [weakSelf.tableView.mj_header endRefreshing];
            }else {
                self.errorV.hidden = YES;
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.indexArray addObjectsFromArray:indexs];
                [weakSelf.dataArr addObjectsFromArray:models];
                [weakSelf.tableView reloadData];
            }
            if (models.count==0||models.count ==weakSelf.dataArr.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSString *error) {
            [self.tableView.mj_footer endRefreshing];
            self.errorV.hidden = NO;
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }else {
        //删除群成员
        [XLBMsgRequestModel requestSessionUserId:self.groupDetail.groupId admins:self.groupDetail.adminList type:@"1" success:^(NSMutableArray<GroupMemberModel *> *modes) {
            [self.dataSource addObjectsFromArray:modes];
        } groupMenberList:^(NSArray<NSString *> *indexs, NSArray<NSArray<GroupMemberModel *> *> *models) {
            [self.tableView.mj_footer endRefreshing];
            if (models.count==0) {
                self.errorV.hidden = NO;
                self.tableView.tableHeaderView = nil;
                [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
                [weakSelf.tableView.mj_header endRefreshing];
            }else {
                self.errorV.hidden = YES;
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.indexArray addObjectsFromArray:indexs];
                [weakSelf.dataArr addObjectsFromArray:models];
                [weakSelf.tableView reloadData];
            }
            if (models.count==0||models.count ==weakSelf.dataArr.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSString *error) {
            [self.tableView.mj_footer endRefreshing];
            self.errorV.hidden = NO;
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }
}

- (void)addBottomViewsWithDict:(NSDictionary *)dict {
    self.bottomV.dict = dict;
    self.bottomV.data = self.seleUserAllKeys;
    [self.bottomV.collectionV reloadData];

}
- (void)certainBtnClick {
    if ([self.type isEqualToString:@"1"]) {
        if (kNotNil(self.seleUser) && self.seleUser.allKeys.count > 0) {
            [self delePeopleWithGroup];
        }else {
            [MBProgressHUD showError:@"请选择群成员"];
        }
    }else if([self.type isEqualToString:@"2"]){
        if (kNotNil(self.seleUser) && self.seleUser.allKeys.count > 0) {
            if (kNotNil(self.groupModel.groupImg)) {
                [self invitationPeopleJoinGroup];
            }else {
                [self createGroup];
            }
        }else {
            [MBProgressHUD showError:@"请选择要添加的成员"];
        }
    }
}

- (void)createGroup {
    if (kNotNil(self.seleUser) && self.seleUser.allKeys.count > 1) {
        [self.groupNameArr removeAllObjects];
        [self.groupImgArr removeAllObjects];
        if (self.seleUserNickName.allKeys.count > 0) {
            NSInteger y = 0;
            if (self.seleUserNickName.allKeys.count > 9) {
                y = 9;
            }else {
                y = self.seleUserNickName.allKeys.count;
            }
            [self.groupNameArr addObject:[XLBUser user].userModel.nickname];
            [self.groupImgArr addObject:[XLBUser user].userModel.img];
            for (int i = 0; i < y; i ++ ) {
                NSString *sr = [self.seleUserNickName objectForKey:self.seleUserNickName.allKeys[i]];
                [self.groupNameArr addObject:sr];
                NSString *img = [self.seleUser objectForKey:self.seleUser.allKeys[i]];
                [self.groupImgArr addObject:img];
            }
        }
        self.groupImgV = [[GroupHeadPortraitView alloc] initWithArray:self.groupImgArr];
        [self performSelector:@selector(updateGroupImg) withObject:self afterDelay:0.5];
    }else if(self.seleUser.allKeys.count == 0){
        [MBProgressHUD showError:@"请选择群成员"];
        return;
    }else {
        XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",self.seleUser.allKeys[0]] conversationType:EMConversationTypeChat];
        chat.hidesBottomBarWhenPushed = YES;
        chat.nickname = [self.seleUserNickName objectForKey:self.seleUserNickName.allKeys[0]];
        chat.avatar = [self.seleUser objectForKey:self.seleUser.allKeys[0]];
        chat.userId = [NSString stringWithFormat:@"%@",[self.seleUserNickName objectForKey:self.seleUserNickName.allKeys[0]]];
        [self.navigationController pushViewController:chat animated:YES];
    }
}
- (void)delePeopleWithGroup {
    NSDictionary *dict = @{@"groupHuanxin":self.groupDetail.groupId,@"membersIds":[self.seleUser.allKeys componentsJoinedByString:@","],};
    [MBProgressHUD showMessage:@""];
    [[EMClient sharedClient].groupManager removeMembers:self.seleUser.allKeys fromGroup:self.groupDetail.groupId completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            [[NetWorking network] POST:kDelMember params:dict cache:NO success:^(id result) {
                NSLog(@"%@",result);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"移除成功"];
                [self pushGroupChatViewControllerWithGroupID:self.groupDetail.groupId nickName:self.groupDetail.subject];
            } failure:^(NSString *description) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"移除失败"];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }];
        }else {
            NSLog(@"%@",aError.errorDescription);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"移除失败"];
            [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        }
    }];
}

- (void)invitationPeopleJoinGroup {
    [MBProgressHUD showMessage:@""];
    [[EMClient sharedClient].groupManager addMembers:self.seleUser.allKeys toGroup:self.groupDetail.groupId message:@"" completion:^(EMGroup *aGroup, EMError *aError) {
        NSLog(@"%@",aError.errorDescription);
        NSDictionary *dict = @{@"groupHuanxin":self.groupDetail.groupId,@"membersIds":[self.seleUser.allKeys componentsJoinedByString:@","],@"membersName":@"",};
        if (!aError) {
            [[NetWorking network] POST:kAddGroupMembers params:dict cache:NO success:^(id result) {
                NSLog(@"%@",result);
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"添加成功"];
                [self pushGroupChatViewControllerWithGroupID:self.groupDetail.groupId nickName:self.groupDetail.subject];

            } failure:^(NSString *description) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"添加失败"];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }];
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"添加失败"];
            [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        }
    }];
}

- (void)updateGroupImg {
    NSString *groupDes = @"您好，欢迎加入这个大家庭，希望我们能够开心愉快";
    NSMutableArray *membersIds = [NSMutableArray arrayWithArray:self.seleUser.allKeys];
    [membersIds addObject:[XLBUser user].userModel.ID];
    UIImage *img = [self.groupImgV imageWithUIView:self.groupImgV];
    [MBProgressHUD showMessage:@""];

    if (img) {
        [[NetWorking network] asyncUploadImage:img avatar:NO complete:^(NSArray<NSString *> *names, UploadStatus state) {
            if (names) {
                EMGroupOptions *setting = [[EMGroupOptions alloc] init];
                setting.maxUsersCount = 500;
                setting.IsInviteNeedConfirm = NO;
                setting.style = EMGroupStylePublicOpenJoin;
                [[EMClient sharedClient].groupManager createGroupWithSubject:[self.groupNameArr componentsJoinedByString:@","] description:groupDes invitees:self.seleUser.allKeys message:[NSString stringWithFormat:@"%@邀请您加入群聊",[XLBUser user].userModel.nickname] setting:setting completion:^(EMGroup *aGroup, EMError *aError) {
                    if (!aError) {
                        NSLog(@"创建成功 -- %@",aGroup);
                        NSDictionary *dicr = @{@"groupName":[self.groupNameArr componentsJoinedByString:@","],@"groupImg":names[0],@"groupHuanxin":aGroup.groupId,@"groupDescription":groupDes,@"groupAnnouncement":@"",@"pullPeople":@"0",@"isSearch":@"0",@"membersIds":[membersIds componentsJoinedByString:@","],};
                        NSLog(@"%@",dicr);
                        [[NetWorking network] POST:kAddGroups params:dicr cache:NO success:^(id result) {
                            NSLog(@"%@",result);
                            NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
                            [userDe setObject:names[0] forKey:aGroup.groupId];
                            [userDe synchronize];
                            [MBProgressHUD hideHUD];
                            [self pushGroupChatViewControllerWithGroupID:aGroup.groupId nickName:aGroup.subject];
                        } failure:^(NSString *description) {
                            [MBProgressHUD showError:@"创建失败"];
                            [MBProgressHUD hideHUD];
                        }];
                    }else {
                        NSLog(@"创建失败%@",aError.errorDescription);
                        [MBProgressHUD showError:@"创建失败"];
                        [MBProgressHUD hideHUD];
                    }
                }];
            }else {
                [MBProgressHUD showError:@"创建失败"];
                [MBProgressHUD hideHUD];
            }
        }];
    }else {
        [MBProgressHUD showError:@"创建失败"];
        [MBProgressHUD hideHUD];
    }
}

- (void)pushGroupChatViewControllerWithGroupID:(NSString *)groupID nickName:(NSString *)nickName{
    XLBChatGroupViewController *chat = [[XLBChatGroupViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",groupID] conversationType:EMConversationTypeGroupChat];
    chat.hidesBottomBarWhenPushed = YES;
    chat.nickName = nickName;
    [self.navigationController pushViewController:chat animated:YES];
}
- (NSMutableArray *)searchDataWithArray:(NSArray *)nameArray modelArray:(NSArray *)modelArray{
    NSMutableArray *baseData = [NSMutableArray array];
    NSMutableArray *baseDataSub = [NSMutableArray array];
    
    NSMutableArray *indexsArray = [NSMutableArray arrayWithArray:[BQLChineseString IndexArray:nameArray]];
    NSMutableArray <NSArray *>*letterArray = [NSMutableArray arrayWithArray:[BQLChineseString LetterSortArray:nameArray]];
    if([indexsArray containsObject:@"#"] && [[indexsArray firstObject] isEqualToString:@"#"]) {
        [indexsArray removeObjectAtIndex:0];
        [indexsArray addObject:@"#"];
        NSArray *spec = [letterArray firstObject];
        [letterArray removeObjectAtIndex:0];
        [letterArray addObject:spec];
    }
    [letterArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableArray *temp = [NSMutableArray array];
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *name = obj;
            [modelArray enumerateObjectsUsingBlock:^(GroupMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if([obj.membersName isEqualToString:name]) {
                    [temp addObject:obj];
                }
            }];
        }];
        [baseDataSub addObject:temp];
    }];
    
    [baseData addObject:indexsArray];
    [baseData addObject:baseDataSub];
    
    return baseData;
}


- (XLBAddGroupMemberBottomView *)bottomV {
    if (!_bottomV) {
        _bottomV = [[XLBAddGroupMemberBottomView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 64, kSCREEN_WIDTH, 64)];
        [_bottomV.certainBtn addTarget:self action:@selector(certainBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomV];
    }
    return _bottomV;
}
- (NSMutableDictionary *)seleUser {
    if (!_seleUser) {
        _seleUser = [NSMutableDictionary dictionary];
    }
    return _seleUser;
}
- (NSMutableDictionary *)seleUserNickName {
    if (!_seleUserNickName) {
        _seleUserNickName = [NSMutableDictionary dictionary];
    }
    return _seleUserNickName;
}

- (NSMutableArray *)indexArr {
    if(!_indexArr) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}
- (NSMutableArray *)searchData {
    if(!_searchData) {
        _searchData = [NSMutableArray array];
    }
    return _searchData;
}
- (NSMutableArray *)indexArray {
    
    if(!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)groupNameArr {
    if (!_groupNameArr) {
        _groupNameArr = [NSMutableArray array];
    }
    return _groupNameArr;
}
- (NSMutableArray *)groupImgArr {
    if (!_groupImgArr) {
        _groupImgArr = [NSMutableArray array];
    }
    return _groupImgArr;
}
- (NSMutableArray *)seleUserAllKeys {
    if (!_seleUserAllKeys) {
        _seleUserAllKeys = [NSMutableArray array];
    }
    return _seleUserAllKeys;
}


- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
