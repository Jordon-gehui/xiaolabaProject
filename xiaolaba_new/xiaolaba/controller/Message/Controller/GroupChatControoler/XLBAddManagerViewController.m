//
//  XLBAddManagerViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAddManagerViewController.h"
#import "BQLChineseString.h"
#import "XLBMyFriendsCell.h"
#import "EaseUI.h"
#import "XLBChatViewController.h"
#import "XLBMsgRequestModel.h"
#import "XLBAlertController.h"
#import "XLBErrorView.h"
#import "UITableView+CCPIndexView.h"
#import "XLBAddGroupMemberBottomView.h"
#import "GroupMemberModel.h"
#import "XLBGroupAddManagerTableViewCell.h"
@interface XLBAddManagerViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSMutableArray *indexArray; // 索引
@property (nonatomic, assign)BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchData;
@property (nonatomic, strong) XLBErrorView *errorV;
@property (nonatomic, strong) NSMutableArray *indexArr;

@property (nonatomic, strong) UIScrollView *scrollV;


@end

@implementation XLBAddManagerViewController
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
    
    [self refresh];
    [self setpUp];
    self.naviBar.slTitleLabel.text = @"设置管理员";
    kWeakSelf(self)
    
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
//            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                [weakSelf loadMore];
//            }];
            [weakSelf searchRequestData:searchText];
        }
        
        return weakSelf.dataArr;
    };
    
    self.tableView.sectionIndexColor = RGB(102, 102, 102);
    self.tableView.separatorColor = [UIColor whiteColor];
    [self.tableView registerClass:[XLBGroupAddManagerTableViewCell class] forCellReuseIdentifier:[XLBGroupAddManagerTableViewCell AddManagerTableViewCellID]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchData.count;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLBGroupAddManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBGroupAddManagerTableViewCell AddManagerTableViewCellID]];
    GroupMemberModel *model;
    NSString *value ;
    if (self.searchController.active) {
        model = self.searchData[indexPath.row];
        value = [NSString stringWithFormat:@"%@",model.membersId];
    }else {
        model = self.dataArr[indexPath.row];
        value = [NSString stringWithFormat:@"%@",model.membersId];
    }
    cell.groupId = [NSString stringWithFormat:@"%@",self.groupDetail.groupId];
    cell.groupModel = model;
    return cell;
}

-(void)pushOwnerViewController:(NSString*)ownerStr {
    self.searchController.active = NO;
    OwnerViewController *ownerVC= [OwnerViewController new];
    ownerVC.userID =ownerStr;
    ownerVC.delFlag = 0;
    [self.navigationController pushViewController:ownerVC animated:YES];
}

- (void) filterBySubstring:(NSString*) subStr {
    [self.searchData removeAllObjects];
    if (subStr.length > 0) {
        //清除搜索结果
        [self.searchData removeAllObjects];
        [self.dataArr enumerateObjectsUsingBlock:^(GroupMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([[obj.membersName lowercaseTranfrom:obj.membersName] containsString:[subStr lowercaseTranfrom:subStr]]) {
                [self.searchData addObject:obj];
            }
        }];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        NSLog(@"%@",_searchData);
    } else if (subStr.length == 0) {
        _searchData = [NSMutableArray arrayWithArray:self.dataArr];
    }

}

- (void)requestData:(BOOL )header {
    [self.dataArr removeAllObjects];
    kWeakSelf(self);
    if (self.groupDetail.memberList.count == 0) {
        self.errorV.hidden = NO;
        self.tableView.tableHeaderView = nil;
        [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
        [weakSelf.tableView.mj_header endRefreshing];
    }else {
        self.errorV.hidden = YES;
        [XLBMsgRequestModel requestSessionUserId:self.groupDetail.groupId admins:self.groupDetail.adminList type:@"1" success:^(NSMutableArray<GroupMemberModel *> *modes) {
            [self.dataArr addObjectsFromArray:modes];
            [self.tableView reloadData];
        } groupMenberList:^(NSArray<NSString *> *indexs, NSArray<NSArray<GroupMemberModel *> *> *models) {
            
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

- (NSMutableArray *)searchData {
    if(!_searchData) {
        _searchData = [NSMutableArray array];
    }
    return _searchData;
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
