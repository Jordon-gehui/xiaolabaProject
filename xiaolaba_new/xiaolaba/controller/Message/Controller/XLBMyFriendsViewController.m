//
//  XLBMyFriendsViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyFriendsViewController.h"
#import "BQLChineseString.h"
#import "XLBMyFriendsCell.h"
#import "EaseUI.h"
#import "XLBChatViewController.h"
#import "XLBMsgRequestModel.h"
#import "XLBAlertController.h"
#import "XLBErrorView.h"
#import "UITableView+CCPIndexView.h"
#import "GroupMemberModel.h"
@interface XLBMyFriendsViewController ()<UISearchBarDelegate,XLBErrorViewDelegate>

@property (nonatomic, strong) NSMutableArray *indexArray; // 索引
@property (nonatomic, assign)BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchData;
@property (nonatomic, strong) XLBErrorView *errorV;
@property (nonatomic, strong) NSMutableArray *indexArr;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation XLBMyFriendsViewController
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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的好友";
    self.naviBar.slTitleLabel.text = @"我的好友";
    [MobClick event:@"Me_Friends"];
    self.tableView.sectionIndexColor = RGB(102, 102, 102);
    [self.tableView ccpIndexView];
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
//            weakSelf.page = 1;
            [weakSelf searchRequestData:searchText];
        }
        // NSPredicate 谓词
        
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
//    self.page = 1;
    [self filterBySubstring:string];
}


- (void)refresh {
//    self.page = 1;
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
//        self.page ++;
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
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMyFriendsCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMyFriendsCell class]) owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.type isEqualToString:@"2"]) {
        GroupMemberModel *model;
        if (self.searchController.active) {
            model = self.searchData[indexPath.section][indexPath.row];
        }else {
            model = self.dataArr[indexPath.section][indexPath.row];
        }
        cell.nickname.text = model.membersName;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    }else {
        XLBFriendModel *model;
        if (self.searchController.active) {
            model = self.searchData[indexPath.section][indexPath.row];
        }else {
            model = self.dataArr[indexPath.section][indexPath.row];
        }
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@""]];
        
        cell.nickname.text = model.nickname;
        
        cell.cellLongTapRetrunBlock = ^(BOOL isDel) {
            NSLog(@"del===%@",indexPath);
            
            
            UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"取消",@"确定",] title:@"您确定要删除吗？" message:nil cancel:NO cancelBlock:^{
                
            } itemBlock:^(NSUInteger index) {
                [CATransaction begin];
                [CATransaction setCompletionBlock:^{
                    [self.tableView reloadData];
                }];
                [tableView beginUpdates];
                if (index == 1) {
                    if (self.searchController.active) {
                        if ([self.searchData[indexPath.section] count] == 1) {
                            XLBFriendModel *deleModel = self.searchData[indexPath.section][indexPath.row];
                            NSString *indexStr = self.indexArr[indexPath.section];
                            [self.searchData removeObjectAtIndex:indexPath.section];
                            [self.indexArr removeObjectAtIndex:indexPath.section];
                            
                            [self.dataArr enumerateObjectsUsingBlock:^(NSMutableArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [obj enumerateObjectsUsingBlock:^(XLBFriendModel *friendModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                    NSString *friendID = [NSString stringWithFormat:@"%@",friendModel.friendId];
                                    NSString *deleID = [NSString stringWithFormat:@"%@",deleModel.friendId];
                                    if ([friendID isEqualToString:deleID]) {
                                        if (obj.count == 1) {
                                            [self.dataArr removeObject:obj];
                                            [self.indexArray removeObject:indexStr];
                                        }else {
                                            [obj removeObject:friendModel];
                                        }
                                    }
                                }];
                            }];
                            [self.indexArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([indexStr isEqualToString:obj]) {
                                    [self.indexArray removeObject:obj];
                                }
                            }];
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                        }else {
                            XLBFriendModel *deleModel = self.searchData[indexPath.section][indexPath.row];
                            [self.dataArr enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [obj enumerateObjectsUsingBlock:^(XLBFriendModel *friendModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                    NSString *friendID = [NSString stringWithFormat:@"%@",deleModel.friendId];
                                    NSString *deleID = [NSString stringWithFormat:@"%@",friendModel.friendId];
                                    if ([friendID isEqualToString:deleID]) {
                                        [obj removeObject:friendModel];
                                    }
                                }];
                                [self.dataArr replaceObjectAtIndex:idx withObject:obj];
                                
                            }];
                            [self.searchData[indexPath.section] removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                        }
                    }else {
                        if ([self.dataArr[indexPath.section] count]==1) {
                            [self.dataArr removeObjectAtIndex:indexPath.section];
                            [self.indexArray removeObjectAtIndex:indexPath.section];
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                        }else {
                            [self.dataArr[indexPath.section] removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                        }
                    }
                    [tableView endUpdates];
                    [CATransaction commit];
                    [self delFriends:[model.ID stringValue]];
                }
            }];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        };
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.isMe == YES) {
        XLBFriendModel *model;
        if (self.searchController.active) {
            model = self.searchData[indexPath.section][indexPath.row];
        }else {
            model = self.dataArr[indexPath.section][indexPath.row];
        }
        if (self.searchController.active) {
            [self performSelector:@selector(pushOwnerViewController:) withObject:[model.friendId stringValue] afterDelay:0.3];
        }else{
            [self pushOwnerViewController:[model.friendId stringValue]];
        }
    }else {
        if ([self.type isEqualToString:@"2"]) {
            GroupMemberModel *model;
            if (self.searchController.active) {
                model = self.searchData[indexPath.section][indexPath.row];
            }else {
                model = self.dataArr[indexPath.section][indexPath.row];
            }
            if (self.searchController.active) {
                [self performSelector:@selector(pushOwnerViewController:) withObject:[model.membersId stringValue] afterDelay:0.3];
            }else{
                [self pushOwnerViewController:[model.membersId stringValue]];
            }
        }else {
            XLBFriendModel *model;
            if (self.searchController.active) {
                model = self.searchData[indexPath.section][indexPath.row];
            }else {
                model = self.dataArr[indexPath.section][indexPath.row];
            }
            if (self.searchController.active) {
                [self performSelector:@selector(pushChatViewControllerWithID:) withObject:model afterDelay:0.3];
            }else{
                [self pushChatViewControllerWithID:model];
            }
        }
    }
}


- (void)pushChatViewControllerWithID:(XLBFriendModel *)model {
    self.searchController.active = NO;

    NSString *friend = [NSString stringWithFormat:@"%@",model.friendId];
    
    XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:friend conversationType:EMConversationTypeChat];
    chat.hidesBottomBarWhenPushed = YES;
    chat.nickname = model.nickname;
    chat.avatar = model.img;
    chat.userId = friend;
    [self.navigationController pushViewController:chat animated:YES];
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

- (void) filterBySubstring:(NSString*) subStr {
    NSLog(@"----filterBySubstring------");
    [self.indexArr removeAllObjects];
    [self.searchData removeAllObjects];
    kWeakSelf(self)
//    [XLBMsgRequestModel requestMyFriendWithfriendLike:subStr :^(NSArray<NSString *> *indexs, NSArray<NSArray<XLBFriendModel *> *> *models) {
//        [self.tableView.mj_footer endRefreshing];
//        [weakSelf.indexArr addObjectsFromArray:indexs];
//        [weakSelf.searchData addObjectsFromArray:models];
//        [weakSelf.tableView reloadData];
//        if (models.count==0) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    } failure:^(NSString *error) {
//        [self.tableView.mj_footer endRefreshing];
//        [MBProgressHUD showError:error];
//    }];
    if ([self.type isEqualToString:@"2"]) {
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
        [XLBMsgRequestModel requestMyFriendWithfriendLike:subStr type:@"0" menberList:nil :^(NSArray<NSString *> *indexs, NSArray<NSArray<XLBFriendModel *> *> *models) {
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
    
//    [XLBMsgRequestModel requestMyFriendWithfriendLike:nil :^(NSArray<NSString *> *indexs, NSArray<NSArray<XLBFriendModel *> *> *models) {
//        [self.tableView.mj_footer endRefreshing];
//        if (models.count==0) {
//            self.errorV.hidden = NO;
//            self.tableView.tableHeaderView = nil;
//            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
//            [weakSelf.tableView.mj_header endRefreshing];
//        }else {
//            self.errorV.hidden = YES;
//            [weakSelf.tableView.mj_header endRefreshing];
//            [weakSelf.indexArray addObjectsFromArray:indexs];
//            [weakSelf.dataArr addObjectsFromArray:models];
//            [weakSelf.tableView reloadData];
//        }
//        if (models.count==0||models.count ==weakSelf.dataArr.count) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    } failure:^(NSString *error) {
//        [self.tableView.mj_footer endRefreshing];
//        self.errorV.hidden = NO;
//        [self.dataArr removeAllObjects];
//        [self.tableView reloadData];
//        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
//        [weakSelf.tableView.mj_header endRefreshing];
//    }];

    
    if ([self.type isEqualToString:@"2"]) {
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
    }else {
        [XLBMsgRequestModel requestMyFriendWithfriendLike:nil type:@"0" menberList:nil :^(NSArray<NSString *> *indexs, NSArray<NSArray<XLBFriendModel *> *> *models) {
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



- (void)delFriends:(NSString *)string {
    
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kDelFriend params:@{@"id":string} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 删除好友 %@",result);
        [weakSelf hideHud];
        [MBProgressHUD showError:@"删除好友成功"];
        
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"删除好友失败"];
        
    }];
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
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
