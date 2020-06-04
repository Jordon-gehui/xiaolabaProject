//
//  XLBGroupListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/16.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupListViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "XLBChatGroupViewController.h"
#import "GroupListTableViewCell.h"
#import "XLBGroupModel.h"
#import "XLBMsgRequestModel.h"
@interface XLBGroupListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation XLBGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的群聊";
    self.naviBar.slTitleLabel.text = @"我的群聊";
    [self.tableView registerClass:[GroupListTableViewCell class] forCellReuseIdentifier:[GroupListTableViewCell groupListTableViewCellID]];
    [self fetchGroupsWithPage:1 isHeader:YES];
}

- (void)fetchGroupsWithPage:(NSInteger)aPage isHeader:(BOOL)aIsHeader {
    
    kWeakSelf(self);
    
    [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:aPage pageSize:-1 completion:^(NSArray <EMGroup *>*aList, EMError *aError) {
        if (!aError) {
            NSMutableArray *arr = [NSMutableArray array];
            [aList enumerateObjectsUsingBlock:^(EMGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:obj.groupId];
            }];
            NSDictionary *dict =@{@"userIds":@"",@"groupIds":[arr componentsJoinedByString:@","],};
            [XLBMsgRequestModel requestGroupListWithParameter:dict success:^(id respones) {
                NSArray *array = (NSArray *)respones;
                [weakSelf.data addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            } error:^(id error) {
                
            }];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    EMGroup *group = self.data[indexPath.row];
    XLBGroupListModel *model = self.data[indexPath.row];
    GroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[GroupListTableViewCell groupListTableViewCellID]];
//    cell.group = group;
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBGroupListModel *model = self.data[indexPath.row];
    XLBChatGroupViewController *chat = [[XLBChatGroupViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",model.groupID] conversationType:EMConversationTypeGroupChat];
    chat.hidesBottomBarWhenPushed = YES;
    chat.groupID = model.groupID;
    chat.nickName = model.nickname;
    [self.navigationController pushViewController:chat animated:YES];
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
