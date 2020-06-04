//
//  WeiBoViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/11.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "WeiBoViewController.h"
#import <WeiboSDK/WeiboSDK.h>
#import "FriendCell.h"
#import "FriendModel.h"

@interface WeiBoViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FriendCellDelegate,WBHttpRequestDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic,retain)NSDictionary *httpDic;
@property (nonatomic,retain)NSMutableArray *searchList;
@property (nonatomic,retain)NSMutableArray *weiboList;
@property (nonatomic,retain)NSString*weiboIds;
@end
static NSString * const cellIdentifier = @"weiboCell";
static NSString * const weiboKey = @"weiboSdkKey";
static NSString *WeiboURL = @"https://api.weibo.com/2/friendships/friends.json";

@implementation WeiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新浪微博好友";
    self.naviBar.slTitleLabel.text = @"新浪微博好友";
#ifdef DEBUG
    [WeiboSDK enableDebugMode:YES];
#else
    [WeiboSDK enableDebugMode:NO];
#endif
    [WeiboSDK registerApp:SINA_APPKEY];
    [self stupView];
    [self showHudWithText:nil];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:weiboKey];

    if (kNotNil([[NSUserDefaults standardUserDefaults] objectForKey:weiboKey])) {
        self.httpDic = [[NSUserDefaults standardUserDefaults] objectForKey:weiboKey];
        [WBHttpRequest requestWithURL:WeiboURL httpMethod:@"GET" params:@{@"access_token":[self.httpDic objectForKey:@"weibo_token"],@"uid":[self.httpDic objectForKey:@"uid"],@"count":@"100",@"cursor":[NSString stringWithFormat:@"%li",self.page],@"trim_status":@"0"} delegate:self withTag:@"0319"];
    }else{
        [[BQLAuthEngine sharedAuthEngine] getGuanZhu_auth_sina_login:^(id response) {
            NSDictionary *dic = (NSDictionary*)response;
            NSLog(@"新浪关注=%@",dic);
            [[NSUserDefaults standardUserDefaults] setValue:dic forKey:weiboKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.httpDic = dic;
            [WBHttpRequest requestWithURL:WeiboURL httpMethod:@"GET" params:@{@"access_token":[self.httpDic objectForKey:@"weibo_token"],@"uid":[self.httpDic objectForKey:@"uid"],@"count":@"100",@"cursor":[NSString stringWithFormat:@"%li",self.page],@"trim_status":@"0"} delegate:self withTag:@"0319"];
        } failure:^(NSString *error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}
-(void)stupView {
    self.page = 0;
    self.weiboIds = @"";
    if (!self.searchList) {
        self.searchList = [NSMutableArray array];
    }
    if (!self.searchList) {
        self.data = [NSMutableArray array];
    }
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = [self addHeaderView];
    [self.tableView registerClass:[FriendCell class] forCellReuseIdentifier:cellIdentifier];
    self.allowLoadMore = YES;
}
-(void)loadMore {
    if (kNotNil([[NSUserDefaults standardUserDefaults] objectForKey:weiboKey])) {
        self.weiboIds = @"";
        self.page ++;
        self.httpDic = [[NSUserDefaults standardUserDefaults] objectForKey:weiboKey];
        [WBHttpRequest requestWithURL:WeiboURL httpMethod:@"GET" params:@{@"access_token":[self.httpDic objectForKey:@"weibo_token"],@"uid":[self.httpDic objectForKey:@"uid"],@"count":@"100",@"cursor":[NSString stringWithFormat:@"%li",self.page],@"trim_status":@"0"} delegate:self withTag:@"0319"];
    }
}
-(UIView*)addHeaderView{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor grayColor];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.returnKeyType =  UIReturnKeyDone;
    _searchBar.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
    for (UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                UITextField *textField = [subView.subviews objectAtIndex:0];
                textField.backgroundColor = [UIColor whiteColor];

                //设置输入框边框的颜色
                textField.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
                textField.layer.borderWidth = 1;
                textField.layer.cornerRadius = 15;

                //设置输入字体颜色
                textField.textColor = [UIColor textBlackColor];

                //设置默认文字颜色
                UIColor *color = [UIColor grayColor];
                [textField setAttributedPlaceholder:
                 [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:color}]];
                //修改默认的放大镜图片
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = [UIImage imageNamed:@"fangdajing"];
                textField.leftView = imageView;
            }
        }
    }

    return _searchBar;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.data objectAtIndex:section];
    return array.count;
}
-(UIView*)tableviewHeaderView:(NSString*)title{
    UIView *headView = [UIView new];
    [headView setBackgroundColor:[UIColor whiteColor]];
    headView.backgroundColor = [UIColor viewBackColor];
    UILabel*tipLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, kSCREEN_WIDTH-30, 30)];
    tipLbl.font = [UIFont systemFontOfSize:13];
    tipLbl.text = title;
    tipLbl.textColor = [UIColor commonTextColor];
    [headView addSubview:tipLbl];
    [headView sizeToFit];
    return headView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *array = [self.data objectAtIndex:section];
    if (section ==0) {
        if (self.searchList.count ==0) {
            return  [self tableviewHeaderView:[NSString stringWithFormat:@"%li个好友可邀请加入小喇叭",array.count]];
        }
        return  [self tableviewHeaderView:[NSString stringWithFormat:@"%li个好友已加入小喇叭",array.count]];
    }else{
        return  [self tableviewHeaderView:[NSString stringWithFormat:@"%li个好友可邀请加入小喇叭",array.count]];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0||1) {
        return  44;
    }
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *array= [self.data objectAtIndex:indexPath.section];
    FriendModel *dic = [array objectAtIndex:indexPath.row];
    [cell setDelegate:self];
    if (indexPath.section ==1) {
        [cell setFriendweiboDic:dic status:FriendCellNone];
    }else{
        if (self.searchList.count ==0) {
            [cell setFriendweiboDic:dic status:FriendCellNone];
        }else{
            [cell setFriendweiboDic:dic status:FriendCellNoneGuanZhu];
        }
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0&&self.searchList.count !=0) {
        NSArray*arr = [self.data objectAtIndex:indexPath.section];
        FriendModel*dic = [arr objectAtIndex:indexPath.row];
        OwnerViewController *ownerVC= [OwnerViewController new];
        ownerVC.userID =[NSString stringWithFormat:@"%@",dic.userId];
        ownerVC.delFlag = 0;
        [self.navigationController pushViewController:ownerVC animated:YES];
    }
}

-(void)friendCell:(FriendCell *)cell addFriendDic:(FriendModel *)userDic {
    if ([cell.rightBtn.titleLabel.text isEqualToString:@"未关注"]) {
//        [self showHudWithText:nil];
        NSString *userId = [NSString stringWithFormat:@"%@",userDic.userId];
        kWeakSelf(self)
        [[NetWorking network] POST:kAddFollow params:@{@"followId":userDic.userId} cache:NO success:^(NSDictionary* result) {
            [weakSelf hideHud];
            NSLog(@"---------------------------  车主 加关注  %@",result);
            [MBProgressHUD showError:@"关注成功"];
            [cell.rightBtn setTitle:@"已关注" forState:0];
            for (FriendModel*dic in self.searchList) {
                if ([dic.userId isEqualToString:userId]) {
                    dic.follows = @"1";
                }
            }
            [self.data replaceObjectAtIndex:0 withObject:self.searchList];
            [self.tableView reloadData];
            [self btnAnimate:cell.rightBtn];
            [cell.rightBtn setEnabled:YES];

        } failure:^(NSString *description) {
            [weakSelf hideHud];
            [cell.rightBtn setEnabled:YES];
        }];
    }else if([cell.rightBtn.titleLabel.text isEqualToString:@"邀请"]) {
        [cell.rightBtn setEnabled:YES];
        BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:nil];
        //http://www.xiaolaba.net.cn/
        shareModel.urlString = [NSString stringWithFormat:@"http://t.cn/RQXH215"];
        shareModel.title = @"小喇叭-高端交友！！";
        shareModel.text = [NSString stringWithFormat:@"在小喇叭看到的俊男靓女我很喜欢，快来看看呦~ @%@",userDic.nickname];
        shareModel.image = [UIImage imageNamed:@"icon-50"];
        [[BQLAuthEngine sharedAuthEngine] auth_sina_share_link:shareModel success:^(id response) {
            [MBProgressHUD showError:@"邀请成功"];
        } failure:^(NSString *error) {
            [MBProgressHUD showError:@"邀请失败"];
        }];
    }else{ //已关注
//        [self showHudWithText:nil];
        NSString *userId = [NSString stringWithFormat:@"%@",userDic.userId];
        kWeakSelf(self)
        [[NetWorking network] POST:kCancleFollow params:@{@"followId":userDic.userId} cache:NO success:^(NSDictionary* result) {
            [weakSelf hideHud];
            NSLog(@"---------------------------  车主 加关注  %@",result);
            [MBProgressHUD showError:@"取消关注成功"];
            [cell.rightBtn setTitle:@"未关注" forState:0];
            for (FriendModel*dic in self.searchList) {
                if ([dic.userId isEqualToString:userId]) {
                    dic.follows = @"0";
                }
            }
            [self.data replaceObjectAtIndex:0 withObject:self.searchList];
            [self.tableView reloadData];
            [self btnAnimate:cell.rightBtn];
            [cell.rightBtn setEnabled:YES];
        } failure:^(NSString *description) {
            [weakSelf hideHud];
            [cell.rightBtn setEnabled:YES];
        }];
    }
}
-(void)btnAnimate:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                btn.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if(userInfo) {
        NSArray *arr = [userInfo objectForKey:@"users"];
        [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{@"weiboId":[NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]],@"nickname":[obj objectForKey:@"screen_name"],@"img":[obj objectForKey:@"profile_image_url"]};
            FriendModel *model = [FriendModel mj_objectWithKeyValues:dic];
            NSString *sring = [NSString stringWithFormat:@"%@",model.weiboId];
            NSRange range = [self.weiboIds rangeOfString:sring];
            if (range.location == NSNotFound){
                [self.weiboList addObject:model];
                if (kNotNil(self.weiboIds)) {
                    self.weiboIds = [NSString stringWithFormat:@"%@,%@",self.weiboIds,model.weiboId];
                }else{
                    self.weiboIds = [NSString stringWithFormat:@"%@",model.weiboId];
                }
            }
        }];
        if (self.page % 4 !=0||self.page ==0) {
            self.page ++;
//            NSString *string = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"next_cursor"]];
            NSString *string =[NSString stringWithFormat:@"%li",self.page];
            [WBHttpRequest requestWithURL:WeiboURL httpMethod:@"GET" params:@{
                                        @"access_token":[self.httpDic objectForKey:@"weibo_token"],
                                        @"uid":[self.httpDic objectForKey:@"uid"],
                                        @"count":@"5",
                                        @"cursor":string,
                                        @"trim_status":@"0"} delegate:self withTag:@"0319"];
        }else{
            [self getSinaFriendsData];
        }
    }else {
        [self hideHud];
        [self.tableView reloadData];
    }
}
-(void)getSinaFriendsData {
    if (!kNotNil(self.weiboIds)) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self hideHud];
        [self.tableView reloadData];
        return;
    }
    [[NetWorking network] POST:ksearchWeibo params:@{@"weiboIds":self.weiboIds} cache:NO success:^(id result) {
        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
        [result enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!kNotNil([obj objectForKey:@"nickname"])) {
                [obj setValue:@"" forKey:@"nickname"];
            }
            if (!kNotNil([obj objectForKey:@"img"])) {
                [obj setValue:@"" forKey:@"img"];
            }
            NSDictionary*dic = @{@"nickname":[obj objectForKey:@"nickname"],
                                         @"follows":[obj objectForKey:@"follows"],
                                         @"img":[obj objectForKey:@"img"],
                                         @"weiboId":[NSString stringWithFormat:@"%@",[obj objectForKey:@"weiboId"]],
                                         @"userId":[NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]]};
            FriendModel *model = [FriendModel mj_objectWithKeyValues:dic];
            [self.weiboList enumerateObjectsUsingBlock:^(FriendModel * _Nonnull tempobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([tempobj.weiboId isEqualToString:model.weiboId]) {
                    [self.weiboList removeObject:tempobj];
                }
            }];
            
            [self.searchList addObject:model];
        }];
        if (self.data.count ==2||self.data.count ==1) {
            if (self.data.count==1 &&self.searchList.count >0) {
                [self.data replaceObjectAtIndex:0 withObject:self.searchList];
                [self.data addObject:self.weiboList];
            }else if (self.data.count ==1&&self.searchList.count==0){
                [self.data replaceObjectAtIndex:0 withObject:self.weiboList];
            }else{
                [self.data replaceObjectAtIndex:0 withObject:self.searchList];
                [self.data replaceObjectAtIndex:1 withObject:self.weiboList];
            }
        }else{
            if (self.searchList.count >0) {
                [self.data addObject:self.searchList];
            }
            [self.data addObject:self.weiboList];

        }
        [self.tableView reloadData];
    }failure:^(NSString *description) {
        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UISearchBarDelegate 协议
#pragma mark - 👀 这里主要处理实时搜索的配置 👀 💤
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (kNotNil(searchText)) {
        [self searchPredicateText:searchText];
    }else{
        self.data = [NSMutableArray array];
        if (self.searchList.count >0) {
            [self.data addObject:self.searchList];
        }
        [self.data addObject:self.weiboList];
        [self.tableView reloadData];
    }
}
-(void)searchPredicateText:(NSString*)text{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self.nickname contains %@ || self.name contains %@ || self.account contains %@", text, text, text];

    if (self.searchList.count>0) {
        NSMutableArray *seaList = [[self.searchList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        if (seaList.count>0) {
            self.data = [NSMutableArray array];
            [self.data addObject:seaList];
            NSMutableArray *seaList2 = [[self.weiboList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
            if (seaList2.count>0) {
                [self.data addObject:seaList2];
            }
        }else{
            NSMutableArray *seaList2 = [[self.weiboList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
            if (seaList.count>0) {
                self.data = seaList2;
            }else{
                self.data = [NSMutableArray array];
            }
        }
    }else{
        NSMutableArray *seaList2 = [[self.weiboList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        if (seaList2.count>0) {
            self.data = [NSMutableArray array];
            [self.data addObject:seaList2];
            
        }else{
            self.data = [NSMutableArray array];
        }
    }
    [self.tableView reloadData];
}
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    self.data = [NSMutableArray array];
    if (self.searchList.count >0) {
        [self.data addObject:self.searchList];
    }
    [self.data addObject:self.weiboList];
    [self.tableView reloadData];
}

// 键盘中，完成按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    if (kNotNil(searchBar.text)) {
        [self searchPredicateText:searchBar.text];
    }
}
/**
 *  开始编辑的时候，显示搜索结果控制器
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;       //显示“取消”按钮
}

-(NSMutableArray*)searchList {
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}
-(NSMutableArray*)weiboList {
    if (!_weiboList) {
        _weiboList = [NSMutableArray array];
    }
    return _weiboList;
}
@end
