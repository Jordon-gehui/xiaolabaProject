//
//  XLBGroupDetailViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/1.
//  Copyright © 2018年 jackzhang. All rights reserved.
//
#define btnnumber 5 //每行几个

#import "XLBGroupDetailViewController.h"
#import "XLBGroupDetailTableViewCell.h"
#import "XLBUpdateInfoViewController.h"
#import "XLBAlertController.h"
#import "GroupHeadPortraitView.h"
#import "XLBMsgRequestModel.h"
@interface XLBGroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XLBUpdateInfoViewControllerDelegate,UIImagePickerControllerDelegate,EMGroupManagerDelegate>
{
    NSString *groupNickName;
    NSString *meNickName;
    NSString *announct;
    
    NSString *pullPeople; // 是否可以拉人 0 不可以 1 可以
    NSString *isAdmin;  //是否是管理员 0 不是 1 是
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UIImageView *groupImgV;
@property (nonatomic,assign)NSInteger rowNuber;
@property (nonatomic,assign)NSInteger MaxCount;
@property (nonatomic, strong) NSMutableArray *userArr;
//@property (nonatomic, strong) XLBGroupModel *groupModel;
@property (nonatomic, strong) GroupHeadPortraitView *groupImg;

@property (nonatomic, strong) NSMutableArray *stickGroupList;
@property (nonatomic, strong) NSMutableArray *distrubGroupList;

@end

@implementation XLBGroupDetailViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSDictionary *dict = @{@"title":groupNickName,@"meNickName":meNickName,};
    self.returnBlock(dict);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isGrouped = YES;
    if (self.groupDetail.subject.length > 15) {
        self.naviBar.slTitleLabel.text = [NSString stringWithFormat:@"%@...",[self.groupDetail.subject substringWithRange:NSMakeRange(0, 15)]];
        groupNickName = [NSString stringWithFormat:@"%@...",[self.groupDetail.subject substringWithRange:NSMakeRange(0, 15)]];
    }else {
        self.naviBar.slTitleLabel.text = self.groupDetail.subject;
        groupNickName = [NSString stringWithFormat:@"%@",self.groupDetail.subject];
    }
    [self setGroupInfoRequest];
    _stickGroupList=[[[XLBCache cache]cache:@"stickGroupList"] mutableCopy];
    _distrubGroupList=[[[XLBCache cache]cache:@"distrubGroupList"] mutableCopy];
    [self.tableView registerClass:[XLBGroupDetailTableViewCell class] forCellReuseIdentifier:[XLBGroupDetailTableViewCell groupDetailCellID]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUp];
}

- (void)setGroupInfoRequest {
    if (kNotNil(self.model.subModel.membersName)) {
        meNickName = self.model.subModel.membersName;
    }else {
        meNickName = @"";
    }
    if (![[[XLBUser user].userModel.ID stringValue] isEqualToString:self.groupDetail.owner]) {
        if (kNotNil(self.groupDetail.adminList) && self.groupDetail.adminList.count > 0) {
            [self.groupDetail.adminList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //是否群管理
                if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:obj]) {
                    isAdmin = @"1";
                    pullPeople = @"1";
                }else {
                    isAdmin = @"0";
                    if ([self.model.pullPeople isEqualToString:@"0"]) {
                        pullPeople = @"1";
                    }else {
                        pullPeople = @"0";
                    }
                }
            }];
        }else {
            isAdmin = @"0";
            if ([self.model.pullPeople isEqualToString:@"0"]) {
                pullPeople = @"1";
            }else {
                pullPeople = @"0";
            }
        }
    }else {
        //群主
        isAdmin = @"2";
        pullPeople = @"1";
    }
    [self.tableView reloadData];
}
- (void)setUp {
    [[EMClient sharedClient].groupManager getGroupAnnouncementWithId:self.groupDetail.groupId completion:^(NSString *aAnnouncement, EMError *aError) {
        if (!aError) {
            announct = [NSString stringWithFormat:@"%@",aAnnouncement];
            [self.tableView reloadData];
        }
    }];
    if ([isAdmin isEqualToString:@"1"]) {
        //管理员
        [self memberListWithType:@"2"];
    }else if([isAdmin isEqualToString:@"2"]){
        [self memberListWithType:@"2"];
    }else {
        [self memberListWithType:@"3"];
    }
    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:self.groupDetail.owner]) {
        [self.data addObjectsFromArray:[DefaultList initGroupChatListWithType:@"1"]];
    }else {
        [self.data addObjectsFromArray:[DefaultList initGroupChatListWithType:@"0"]];
    }
    [self.tableView reloadData];
    
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
    vi.backgroundColor = [UIColor viewBackColor];
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor textBlackColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    if (![[[XLBUser user].userModel.ID stringValue] isEqualToString:self.groupDetail.owner]) {
        [btn setTitle:@"退出群聊" forState:0];
    }else {
        [btn setTitle:@"解散群聊" forState:0];
    }
    [btn addTarget:self action:@selector(quitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:btn];
    self.tableView.tableFooterView = vi;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
    }];
}

- (void)memberListWithType:(NSString *)type {
    [self.userArr removeAllObjects];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.groupDetail.memberList];
    [arr addObjectsFromArray:self.groupDetail.adminList];
    if (arr.count != 0) {
        [[NetWorking network] POST:kGroupAll params:@{@"groupHuanxin":self.groupDetail.groupId,@"membersIds":[arr componentsJoinedByString:@","],} cache:NO success:^(id result) {
            NSLog(@"%@",result);
            NSMutableArray <NSDictionary *>*arr = [NSMutableArray arrayWithArray:result];
            NSMutableArray *dataArr = [NSMutableArray array];
            [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj objectForKey:@"type"] isEqualToString:@"3"]) {
                    [arr removeObject:obj];
                }
            }];
            if (arr.count > 30) {
                for (int i = 0; i < 30; i++) {
                    [dataArr addObject:arr[i]];
                }
                [self.userArr addObjectsFromArray:dataArr];
            }else {
                [self.userArr addObjectsFromArray:arr];
            }
            if ([type isEqualToString:@"2"]) {
                [self.userArr addObject:@{@"img":@"icon_ql_tjhy",@"membersName":@"",}];
                [self.userArr addObject:@{@"img":@"icon_ql_schy",@"membersName":@"",}];
                [self addheaderGroupMemberWithmemberlist:self.userArr];
            }else {
                [self addheaderGroupMemberWithmemberlist:self.userArr];
            }
        } failure:^(NSString *description) {
            if ([type isEqualToString:@"2"]) {
                [self.userArr addObject:@{@"img":@"icon_ql_tjhy",@"membersName":@"",}];
                [self.userArr addObject:@{@"img":@"icon_ql_schy",@"membersName":@"",}];
                [self addheaderGroupMemberWithmemberlist:self.userArr];
            }else {
                [self addheaderGroupMemberWithmemberlist:self.userArr];
            }
        }];
    }else {
        if ([type isEqualToString:@"2"]) {
            [self.userArr addObject:@{@"img":@"icon_ql_tjhy",@"membersName":@"",}];
            [self.userArr addObject:@{@"img":@"icon_ql_schy",@"membersName":@"",}];
            [self addheaderGroupMemberWithmemberlist:self.userArr];
        }else {
            [self addheaderGroupMemberWithmemberlist:self.userArr];
        }
    }
}

- (void)quitBtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"退出群聊"]) {
        //退出群聊
        [[EMClient sharedClient].groupManager leaveGroup:self.groupDetail.groupId completion:^(EMError *aError) {
            if (!aError) {
                NSLog(@"退出成功");
                [[NetWorking network] POST:kDelMember params:@{@"groupHuanxin":self.groupDetail.groupId,@"membersIds":[[XLBUser user].userModel.ID stringValue],} cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                } failure:^(NSString *description) {
                }];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }else {
                [MBProgressHUD showError:@"解散失败"];
            }
        }];

    }else {
        //解散群组
        [[EMClient sharedClient].groupManager destroyGroup:self.groupDetail.groupId finishCompletion:^(EMError *aError) {
            if (!aError) {
                NSLog(@"解散成功");
                [[NetWorking network] POST:kDelGroup params:@{@"groupHuanxin":self.groupDetail.groupId,} cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                } failure:^(NSString *description) {

                }];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }else {
                [MBProgressHUD showError:@"解散失败"];
            }
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kNotNil(announct)) {
       CGFloat height = [announct sizeWithMaxWidth:kSCREEN_WIDTH - 45 font:[UIFont systemFontOfSize:15]].height;
        if (indexPath.section == 0 && indexPath.row == 2) {
            return height + 55;
        }
        return 50;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.data[section];
    return arr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 10)];
    vie.backgroundColor = [UIColor viewBackColor];
    return vie;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBGroupDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBGroupDetailTableViewCell groupDetailCellID]];
    cell.dict = self.data[indexPath.section][indexPath.row];
    cell.switchCell.tag = (indexPath.section * 10) + indexPath.row;
    [cell.switchCell addTarget:self action:@selector(switchCellClick:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.model.groupImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        self.groupImgV = cell.img;
        if (![isAdmin isEqualToString:@"2"]) {
            cell.rightImg.hidden = YES;
        }
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@",groupNickName];
        if (![isAdmin isEqualToString:@"2"]) {
            cell.rightImg.hidden = YES;
        }
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        cell.announcementStr = announct;
        if ([isAdmin isEqualToString:@"2"] || [isAdmin isEqualToString:@"1"]) {
            cell.rightImg.hidden = NO;
        }else {
            cell.rightImg.hidden = YES;
        }
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@",meNickName];
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.switchCell.on = [self.model.subModel.status boolValue];
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        cell.switchCell.on = [self.model.subModel.disturb boolValue];
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        cell.switchCell.on = ![self.model.isSearch boolValue];
    }else if (indexPath.section == 3 && indexPath.row == 2) {
        cell.switchCell.on = ![self.model.pullPeople boolValue];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!kNotNil(self.model)) return;
    NSString *titleStr = self.data[indexPath.section][indexPath.row][@"title"];
    if ([titleStr isEqualToString:@"群头像"]) {
        if (![isAdmin isEqualToString:@"2"]) {
            [MBProgressHUD showError:@"您没有修改群头像权限"];
            return;
        }else {
            [self updateGroupImg];
        }
    }else if ([titleStr isEqualToString:@"群名称"]) {
        if (![isAdmin isEqualToString:@"2"]) {
            [MBProgressHUD showError:@"您没有修改群名称权限"];
            return;
        }else {
            [self updateClick:UpdateTypeGroupNickName string:groupNickName];
        }
    }else if ([titleStr isEqualToString:@"群公告"]) {
        if ([isAdmin isEqualToString:@"2"] || [isAdmin isEqualToString:@"1"]) {
            [self updateClick:UpdateTypeGroupAnnounct string:announct];
        }else {
            [MBProgressHUD showError:@"您没有修改群公告权限"];
            return;
        }
    }else if ([titleStr isEqualToString:@"分享群"]) {
        [[CSRouter share] push:@"XLBGroupShareViewController" Params:@{@"model":self.model} hideBar:YES];
    }else if ([titleStr isEqualToString:@"我的群昵称"]) {
        [self updateClick:UpdateTypeMeGroupNickName string:meNickName];
    }else if ([titleStr isEqualToString:@"设置管理员"]) {
        [[CSRouter share] push:@"XLBAddManagerViewController" Params:@{@"groupDetail":self.groupDetail} hideBar:YES];
    }
}


- (void)switchCellClick:(UISwitch *)sender {
    switch (sender.tag) {
        case 20:{
            NSLog(@"置顶该消息");
            NSDictionary *dict = @{@"status":sender.on ? @(1) : @(0),@"groupHuanxin":self.groupDetail.groupId,};
            [self updateGroupDetailRequestWithDict:dict type:NO status:@"status"];
        }
            break;
        case 21:{
            NSLog(@"消息免打扰");
            NSDictionary *dict = @{@"disturb":sender.on ? @(1) : @(0),@"groupHuanxin":self.groupDetail.groupId,};
            EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:self.groupDetail.groupId ignore:sender.on];
            NSLog(@"%@",error.errorDescription);
            if (!error) {
                [self updateGroupDetailRequestWithDict:dict type:NO status:@"disturb"];
            }
        }
            break;
        case 31:{
            NSLog(@"允许群被搜索");
            NSDictionary *dict = @{@"isSearch":sender.on ? @(0) : @(1),@"groupHuanxin":self.groupDetail.groupId,};
            [self updateGroupDetailRequestWithDict:dict type:YES status:@"isSearch"];
        }
            break;
        case 32:{
            NSLog(@"允许群成员拉人进群");
            NSDictionary *dict = @{@"pullPeople":sender.on ? @(0) : @(1),@"groupHuanxin":self.groupDetail.groupId,};
            [self updateGroupDetailRequestWithDict:dict type:YES status:@"pullPeople"];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateInfoSuccess:(NSString *)updateInfoString type:(UpdateType)type {
    switch (type) {
        case UpdateTypeGroupNickName:{
            if ([updateInfoString isEqualToString:groupNickName]) return;
            groupNickName = updateInfoString;
            EMError *error = nil;
            // 修改群名称
            [[EMClient sharedClient].groupManager changeGroupSubject:updateInfoString forGroup:self.groupDetail.groupId error:&error];
            if (!error) {
                NSLog(@"修改成功");
                NSDictionary *dict = @{@"groupName":updateInfoString,@"groupHuanxin":self.groupDetail.groupId,};
                [self updateGroupDetailRequestWithDict:dict type:YES status:@"groupName"];
            }else {
                [MBProgressHUD showError:@"修改失败"];
            }
        }
            break;
        case UpdateTypeGroupAnnounct:{
            if ([updateInfoString isEqualToString:announct]) return;
            announct = updateInfoString;
            NSDictionary *dict = @{@"groupAnnouncement":updateInfoString,@"groupHuanxin":self.groupDetail.groupId,};
            
            [[EMClient sharedClient].groupManager updateGroupAnnouncementWithId:self.groupDetail.groupId announcement:updateInfoString completion:^(EMGroup *aGroup, EMError *aError) {
                if (!aError) {
                    [self updateGroupDetailRequestWithDict:dict type:YES status:@"groupAnnouncement"];
                }else {
                    [MBProgressHUD showError:@"修改失败"];
                }
            }];
        }
            break;
        case UpdateTypeMeGroupNickName:{
            if ([updateInfoString isEqualToString:meNickName]) return;
            meNickName = updateInfoString;
            NSDictionary *dict = @{@"membersName":updateInfoString,@"groupHuanxin":self.groupDetail.groupId,};
            [self updateGroupDetailRequestWithDict:dict type:NO status:@"membersName"];
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];

}
- (void)updateGroupDetailRequestWithDict:(NSDictionary *)dict type:(BOOL)type status:(NSString *)status {
    [[NetWorking network] POST:type ? kAddGroups : kUpdateGroup params:dict cache:NO success:^(id result) {
        NSLog(@"设置成功%@",result);
        if ([status isEqualToString:@"status"]) {
            self.model.status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            if ([[dict[@"status"] stringValue] isEqualToString:@"1"]) {
                [_stickGroupList addObject:self.groupDetail.groupId];
            }else {
                [_stickGroupList removeObject:self.groupDetail.groupId];
            }
            [[XLBCache cache] store:_stickGroupList key:@"stickGroupList"];
        }else if ([status isEqualToString:@"groupName"]) {
            self.naviBar.slTitleLabel.text = [dict objectForKey:@"groupName"];
        }else if ([status isEqualToString:@"disturb"]) {
            self.model.type = [NSString stringWithFormat:@"%@",dict[@"disturb"]];
            if ([[dict[@"disturb"] stringValue] isEqualToString:@"1"]) {
                [_distrubGroupList addObject:self.groupDetail.groupId];
            }else {
                [_distrubGroupList removeObject:self.groupDetail.groupId];
            }
            [[XLBCache cache] store:_distrubGroupList key:@"distrubGroupList"];
        }else if ([status isEqualToString:@"isSearch"]) {
            self.model.isSearch = [NSString stringWithFormat:@"%@",dict[@"isSearch"]];
        }else if ([status isEqualToString:@"pullPeople"]) {
            self.model.pullPeople = [NSString stringWithFormat:@"%@",dict[@"pullPeople"]];
        }else if ([status isEqualToString:@"membersName"]) {
        }
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"设置失败"];
    }];
}
- (void)buttonClick:(UIButton *)sender {
    if (!kNotNil(self.model) && !kNotNil(self.groupDetail)) {
        [MBProgressHUD showError:@"获取群信息失败"];
        return;
    }
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"icon_ql_tjhy"]]) {
        NSLog(@"添加好友");
        [[CSRouter share] push:@"XLBAddGroupMemberViewController" Params:@{@"titleStr":@"邀请新成员",@"type":@"2",@"menberList":self.groupDetail.occupants,@"groupDetail":self.groupDetail,@"groupModel":self.model} hideBar:YES];
    }else if ([sender.imageView.image isEqual:[UIImage imageNamed:@"icon_ql_schy"]]) {
        NSLog(@"删除好友");
        [[CSRouter share] push:@"XLBAddGroupMemberViewController" Params:@{@"titleStr":@"删除群成员",@"type":@"1",@"menberList":self.groupDetail.occupants,@"groupDetail":self.groupDetail,@"groupModel":self.model} hideBar:YES];
    }else {
        NSLog(@"好友头像");
        NSDictionary *dict = [self.userArr objectAtIndex:sender.tag];
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":dict[@"membersId"],@"delFlag":@"0",} hideBar:YES];
    }
}
- (void)updateGroupImg {
    kWeakSelf(self);
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"默认",@"拍照",@"从相册选取"] title:nil message:nil cancel:YES cancelBlock:^{
        
        NSLog(@"点击了取消");
    } itemBlock:^(NSUInteger index) {
        
        switch (index) {
            case 0: {
                NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
                if (kNotNil([userDe objectForKey:self.groupDetail.groupId])) {
                    NSString *img = [userDe objectForKey:self.groupDetail.groupId];
                    [self.groupImgV sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                    [self updateGroupImgWithImg:nil imgString:img];
                }
            }
                break;
            case 1: {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSLog(@"点击了拍照");
                    [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypeCamera];
                }
                else {
                    NSLog(@"模拟器打不开相机");
                }
            }
                break;
            case 2: {
                [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
                
            default:
                break;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];

}


- (void)chooseCameraOrAlbum:(UIImagePickerControllerSourceType )type {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = type;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.groupImgV.image = image;
    [self updateGroupImgWithImg:image imgString:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)updateGroupImgWithImg:(UIImage *)img imgString:(NSString *)imgString{
    if (kNotNil(imgString)) {
        NSDictionary *dict = @{@"groupImg":imgString,@"groupHuanxin":self.groupDetail.groupId,};
        [[NetWorking network] POST:kAddGroups params:dict cache:NO success:^(id result) {
            NSLog(@"%@",result);
        } failure:^(NSString *description) {
            [MBProgressHUD showError:@"修改失败"];
        }];
    }else {
        [[NetWorking network] asyncUploadImage:img avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
            if (names) {
                NSDictionary *dict = @{@"groupImg":names[0],@"groupHuanxin":self.groupDetail.groupId,};
                [[NetWorking network] POST:kAddGroups params:dict cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                } failure:^(NSString *description) {
                    [MBProgressHUD showError:@"修改失败"];
                }];
            }
        }];
    }
}

- (void)updateClick:(UpdateType )type string:(NSString *)string {
    XLBUpdateInfoViewController *update = [[XLBUpdateInfoViewController alloc] initWithType:type string:string];
    update.delegate = self;
    [self.navigationController pushViewController:update animated:YES];
}


- (void)addheaderGroupMemberWithmemberlist:(NSArray *)memberList{
    if (memberList.count == 0) return;
    CGFloat headerHeight;
    NSInteger row = memberList.count / 5;
    NSInteger remainder = memberList.count%5;
    if (row == 0 && remainder == 0) {
        headerHeight = 70;
    }else if (row > 0 && remainder == 0) {
        if (memberList.count > 29) {
            headerHeight = row * 80 + 20 + 51;
        }else {
            headerHeight = row * 80 + 20;
        }
    }else {
        if (memberList.count > 29) {
            headerHeight = (row + 1) * 70 + 51 + row * 10;
        }else {
            headerHeight = (row + 1) * 70 + 20 + row * 10;
        }
    }
    self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, headerHeight)];
    self.headerV.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerV;
    
    if (memberList.count > 10) {
        _MaxCount = 10;
    }else {
        _MaxCount = memberList.count;
    }
    _rowNuber =btnnumber;
    float kimgWidth = 50; //控件大小
    float kspace = (kSCREEN_WIDTH-20-50*_rowNuber)/(_rowNuber+1);
    float kHspace = 15;
    for (NSInteger i=0; i<memberList.count; i++) {
        NSInteger y = i/_rowNuber;
        NSInteger x = i-y*_rowNuber;
        NSLog(@"%ld",y);
        [self addBtnWithframe:CGRectMake((kspace+kimgWidth)*x+kspace, 10 + y*kHspace+y*(kHspace+kimgWidth), kimgWidth, kimgWidth) WithImageName:memberList[i][@"img"] WithTag:i withTitle:memberList[i][@"membersName"]];
    }
    
    if (memberList.count > 29) {
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight - 51, kSCREEN_WIDTH, 0.7)];
        lineV.backgroundColor = [UIColor lineColor];
        [self.headerV addSubview:lineV];
        
        lineV.centerX = self.headerV.centerX;
        
        
        UIButton * allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, headerHeight - 50, kSCREEN_WIDTH, 50)];
        allBtn.centerX = self.headerV.centerX;
        allBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [allBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerV addSubview:allBtn];
    }
}

-(void)addBtnWithframe:(CGRect)frame WithImageName:(NSString *)img WithTag:(NSInteger)tag withTitle:(NSString *)nickName{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    if ([img isEqualToString:@"icon_ql_tjhy"] || [img isEqualToString:@"icon_ql_schy"]) {
        [button setImage:[UIImage imageNamed:img] forState:0];
    }else {
        [button sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    button.imageView.contentMode =UIViewContentModeScaleAspectFill;
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerV addSubview:button];
    
    UILabel *label = [UILabel new];
    label.text = nickName;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor assistColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.headerV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).with.offset(3);
        make.centerX.mas_equalTo(button);
        make.width.mas_equalTo(button.width + 10);
    }];
}

- (void)allBtnClick:(UIButton *)sender {
    [[CSRouter share] push:@"XLBMyFriendsViewController" Params:@{@"type":@"2",@"groupDetail":self.groupDetail,} hideBar:YES];
}
- (NSMutableArray *)userArr {
    if (!_userArr) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
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
