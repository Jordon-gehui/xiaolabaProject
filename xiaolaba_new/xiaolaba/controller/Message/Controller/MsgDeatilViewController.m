//
//  MsgDeatilViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MsgDeatilViewController.h"
#import "MsgDeatilCell.h"
#import "ReportChatViewController.h"

@interface MsgDeatilViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
@end

@implementation MsgDeatilViewController

- (void)viewDidLoad {
    self.isGrouped = YES;
    [super viewDidLoad];
    self.title = @"消息详情";
    self.naviBar.slTitleLabel.text = @"消息详情";
    //@"消息免打扰",
    if (_isFriend ==2) {
        self.data = (NSMutableArray*)@[@[@"11"],@[@"屏蔽该用户"],@[@"举报该用户"],@[@"清空聊天记录"]];
    }else{
        self.data = (NSMutableArray*)@[@[@"11"],@[@"屏蔽该用户"],@[@"举报该用户"]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgDeatilCell *cell = [tableView dequeueReusableCellWithIdentifier:[MsgDeatilCell reuseIdentifier]];
    if (!cell) {
        cell = [[MsgDeatilCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MsgDeatilCell reuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section ==0) {
        [cell setViewData:_userDic With:HeaderCellStyle];
    }else if (indexPath.section==1){
        [cell setViewData:self.data[indexPath.section][indexPath.row] With:SwitchCellStyle];
        [cell.switchV addTarget:self action:@selector(switchVClick:) forControlEvents:UIControlEventValueChanged];
        [cell.switchV setOn:self.isBlack];
        cell.switchV.tag = indexPath.row;
    }else {
        [cell setViewData:self.data[indexPath.section][indexPath.row] With:DefaultCellStyle];
    }
    if (indexPath.row ==1) {
        [cell.lineV setHidden:NO];
    }else {
        [cell.lineV setHidden:YES];
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;//section头部高度
}
//section头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        //车主主页
        OwnerViewController *owner = [OwnerViewController new];
        owner.userID = [_userDic objectForKey:@"ID"];
        owner.delFlag = 0;
        [self.navigationController pushViewController:owner animated:YES];
    }else if(indexPath.section ==1) {
       
    }else if (indexPath.section ==2) {
        //举报用户
        ReportChatViewController *chat = [ReportChatViewController new];
        chat.hidesBottomBarWhenPushed = YES;
        chat.reportType = @"4";
        chat.detailID = [_userDic objectForKey:@"ID"];
        [self.navigationController pushViewController:chat animated:YES];
    }else if (indexPath.section==3) {
        //清空聊天记录
        [self alertViewShow:@"你确定要删除聊天记录么?" Withcancle:@"取消" withTag:3];
    }
}
-(void)switchVClick:(UISwitch*)swit{
    if (swit.tag ==0) {//屏蔽用户
        if (self.retrunBlackListBlock) {
            self.retrunBlackListBlock(swit.isOn);
        }
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==1) {
        if (alertView.tag ==3) {
            if (self.retrunDelAllBlock) {
                self.retrunDelAllBlock(YES);
            }
        }
    }
}

-(void)alertViewShow:(NSString*)string Withcancle:(NSString*)canStr withTag:(NSInteger)tag{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:canStr otherButtonTitles:@"确定", nil];
    alert.tag =tag;
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

\

@end
