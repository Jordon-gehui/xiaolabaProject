//
//  AdressBookViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/11.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "AdressBookViewController.h"
#import <AddressBook/AddressBook.h>
#import "FriendCell.h"
#import "XLBChatViewController.h"
#import <MessageUI/MessageUI.h>
#import "FriendModel.h"
#import "UITableView+CCPIndexView.h"
#import "BDChineseStor.h"

#define MAX_STARWORDS_LENGTH 20
@interface AdressBookViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FriendCellDelegate,MFMessageComposeViewControllerDelegate>
{
    UITextField *addTextField;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, retain)NSString* phoneStr;
@property (nonatomic, retain)NSString* smsContent;
@property (nonatomic, strong) NSMutableArray *addressList;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSArray *indexList;

//缓存数据源
@property (nonatomic,strong) NSArray *dataSoure;
//缓存address搜索数据
@property (nonatomic,strong) NSArray *addressSoure;


@property (nonatomic, retain)MFMessageComposeViewController *vc;
@end
static NSString * const cellIdentifier = @"addressCell";

@implementation AdressBookViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录好友";
    self.naviBar.slTitleLabel.text = @"通讯录好友";
    [self vc];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = [self addHeaderView];
    self.tableView.sectionIndexColor = RGB(102, 102, 102);
    [self.tableView registerClass:[FriendCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView ccpIndexView];
    [self getAddressBookClick];
    self.smsContent = [NSString stringWithFormat:@"我在小喇叭看到很多俊男靓女我很喜欢，快来看看吧~下载地址:%@",kShowAPPStore];
    [self getHttpSMSContent];
}
-(void)getHttpSMSContent{
    [[NetWorking network] POST:kSmsContent params:nil cache:NO success:^(id result) {
        NSDictionary *dic = result[0];
        self.smsContent = [dic objectForKey:@"description"];
    }failure:^(NSString *description) {
    }];
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

//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexList;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.searchList.count==0) {
        return index+1;
    }else{
        return index+2;
    }
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
    if (self.searchList.count ==0) {
        if (section == 0) {
            return  [self tableviewHeaderView:[NSString stringWithFormat:@"%li个好友可邀请加入小喇叭",self.addressSoure.count]];
        }else{
            return nil;
        }
    }else{
        if (section ==0) {
            if (array.count==0) {
                return  nil;
            }else{
                return  [self tableviewHeaderView:[NSString stringWithFormat:@"%li个好友已加入小喇叭",array.count]];
            }
        }else if(section ==1){
            return  [self tableviewHeaderView:[NSString stringWithFormat:@"%li个好友可邀请加入小喇叭",self.addressSoure.count]];
        }else{
            return nil;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchList.count ==0) {
        if (section == 0) {
            NSArray*array = [self.data lastObject];
            if (array.count ==0 ) {
                return 0.01;
            }
            return  45;
        }else{
            return 0.01;
        }
    }else{
        if (section ==0) {
            NSArray *arr = [self.data objectAtIndex:section];
            if (arr.count ==0 ) {
                return 0.01;
            }
            return  45;
        }else if(section ==1){
            NSArray*array = [self.data lastObject];
            if (array.count==0) {
                return 0.01;
            }
            return  45;
        }else{
            return 0.01;
        }
    }
        return  0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setDelegate:self];
    if (self.searchList.count ==0) {
        NSArray *array= [self.data objectAtIndex:indexPath.section];
        FriendModel *dic = [array objectAtIndex:indexPath.row];
        [cell setFriendDic:dic status:FriendCellNone];
        
    }else{
        NSArray *array= [self.data objectAtIndex:indexPath.section];
        FriendModel *dic = [array objectAtIndex:indexPath.row];
        if (indexPath.section ==0) {
            [cell setFriendDic:dic status:FriendCellContent];
        }else{
            [cell setFriendDic:dic status:FriendCellNone];
        }
        
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0&&self.searchList.count>0) {
        NSArray*arr = [self.data objectAtIndex:indexPath.section];
        FriendModel*dic = [arr objectAtIndex:indexPath.row];
        OwnerViewController *ownerVC= [OwnerViewController new];
        ownerVC.userID =[NSString stringWithFormat:@"%@",dic.userId];
        ownerVC.delFlag = 0;
        [self.navigationController pushViewController:ownerVC animated:YES];
    }
}
#pragma mark - FriendCellDelegate
-(void)friendCell:(FriendCell *)cell addFriendDic:(FriendModel *)userDic {
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
        // 设置短信内容
        self.vc.body = self.smsContent;
        // 设置收件人列表
        self.vc.recipients = @[userDic.account];
        // 设置代理
        self.vc.messageComposeDelegate = self;
        // 显示控制器
        [self presentViewController:self.vc animated:YES completion:nil];
        
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
        [cell.rightBtn setTitle:@"等待验证" forState:0];
        for (FriendModel*dic in self.searchList) {
            if ([[NSString stringWithFormat:@"%@",dic.userId] isEqualToString:userId]) {
                dic.friends = @"1";
            }
        }
        [self.data replaceObjectAtIndex:0 withObject:self.searchList];
        [self.tableView reloadData];
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [cell.rightBtn setEnabled:YES];
    }];
}
#pragma mark - MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    
    }else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出");
        
    } else {
        NSLog(@"发送失败");
        
    }
}
- (void)getAddressBookClick{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //用户授权
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {//首次访问通讯录
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (!error) {
                if (granted) {//允许
                    NSArray *contacts = [self fetchContactWithAddressBook:addressBook];
                    self.addressList =[NSMutableArray arrayWithArray:contacts];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"\n contacts:%@", contacts);
                        [self getHttpSearchPhone];
                    });
                }else{//拒绝
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    NSLog(@"拒绝");
                }
            }else{
                NSLog(@"错误!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        });
    }else{//非首次访问通讯录
        
        NSArray *contacts = [self fetchContactWithAddressBook:addressBook];
        self.addressList =[NSMutableArray arrayWithArray:contacts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"\n contacts:%@", contacts);
            [self getHttpSearchPhone];
        });
    }
}
-(void)getHttpSearchPhone {
    [[NetWorking network] POST:ksearchPhone params:@{@"phones":self.phoneStr} cache:NO success:^(id result) {
        [result enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!kNotNil([obj objectForKey:@"nickname"])) {
                [obj setValue:@"" forKey:@"nickname"];
            }
            if (!kNotNil([obj objectForKey:@"img"])) {
                [obj setValue:@"" forKey:@"img"];
            }
            NSMutableDictionary*dic = [@{@"nickname":[obj objectForKey:@"nickname"],
                                 @"account":[obj objectForKey:@"account"],
                                 @"createDate":[obj objectForKey:@"createDate"],
                                 @"friends":[obj objectForKey:@"friends"],
                                 @"img":[obj objectForKey:@"img"],
                                 @"userId":[obj objectForKey:@"id"]} mutableCopy];
            FriendModel *model = [FriendModel mj_objectWithKeyValues:dic];
            [self.addressList enumerateObjectsUsingBlock:^(FriendModel * _Nonnull tempobj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([tempobj.account isEqualToString:model.account]) {
                    [self.addressList removeObject:tempobj];
                    model.name = tempobj.name;
                }
            }];
            [self.searchList addObject:model];
        }];
        self.indexList = [BDChineseStor IndexWithArray:self.addressList Key:@"name"];
        self.addressSoure = self.addressList;
        NSArray *array = [NSMutableArray arrayWithArray:[BDChineseStor sortObjectArray:self.addressList Key:@"name"]];
        [self.data removeAllObjects];
        if (self.searchList.count >0) {
            [self.data addObject:self.searchList];
        }
        [self.data addObject:@[]];
        [self.data addObjectsFromArray:array];
        self.dataSoure = self.data;
        [self.tableView reloadData];
    }failure:^(NSString *description) {
        
    }];
}
- (NSMutableArray *)fetchContactWithAddressBook:(ABAddressBookRef)addressBook{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {////有权限访问
        //获取联系人数组
        NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            //获取联系人
            ABRecordRef people = CFArrayGetValueAtIndex((__bridge ABRecordRef)array, i);
            //获取联系人详细信息,如:姓名,电话,住址等信息
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            
            //判断姓名null
            NSString *allName;
            if (kNotNil(lastName) && kNotNil(firstName)) {
                allName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            }else if(kNotNil(firstName)){
                allName = firstName;
            }else if (kNotNil(lastName)){
                allName = lastName;
            }else{
                allName = @"";
            }
            
            ABMutableMultiValueRef phoneNumRef = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *phoneNumber =  ((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef)).lastObject;
            //判断手机号null
            NSString *phone;
            
            if (kNotNil(phoneNumber)) {
                phone = phoneNumber;
                if (!kNotNil(self.phoneStr)) {
                    self.phoneStr = phone;
                }else{
                    self.phoneStr = [NSString stringWithFormat:@"%@,%@",self.phoneStr,phone];
                }
            }else{
                phone = @"";
            }
            //获取头像
                if (kNotNil(allName)) {
                    FriendModel *model = [FriendModel new];
                    model.name = allName;
                    model.account = phone;
//                    @{@"name": allName, @"account": phone,@"img":image}
                    [contacts addObject:model];
                }

            
        }
        return contacts;
    }else{//无权限访问
        //提示授权
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置-隐私-通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return nil;
    }
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
        self.indexList = [BDChineseStor IndexWithArray:self.addressList Key:@"name"];
        self.data = [NSMutableArray arrayWithArray:self.dataSoure];
        self.addressSoure = self.addressList;
        [self.tableView reloadData];
    }
}
-(void)searchPredicateText:(NSString*)text{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self.nickname contains %@ || self.name contains %@ || self.account contains %@", text, text, text];

    if (self.searchList.count>0) {
        NSMutableArray *seaList = [[self.searchList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        
        self.addressSoure = [[self.addressList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        self.indexList = [BDChineseStor IndexWithArray:self.addressSoure Key:@"name"];
        NSArray *array = [NSMutableArray arrayWithArray:[BDChineseStor sortObjectArray:self.addressSoure Key:@"name"]];
        self.data = [NSMutableArray array];
        if (seaList.count>0) {
            [self.data addObject:seaList];
            if (self.addressSoure.count>0) {
                [self.data addObject:@[]];
                [self.data addObjectsFromArray:array];
            }
        }else{
            if (self.addressSoure.count>0) {
                [self.data addObject:@[]];
                [self.data addObjectsFromArray:array];
            }else{
                self.data = [NSMutableArray array];
            }
        }
    }else{
        self.addressSoure = [[self.addressList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        self.indexList = [BDChineseStor IndexWithArray:self.addressSoure Key:@"name"];
        NSArray *array = [NSMutableArray arrayWithArray:[BDChineseStor sortObjectArray:self.addressSoure Key:@"name"]];
        if (self.addressSoure.count>0) {
            self.data = [NSMutableArray array];
            [self.data addObject:@[]];
            [self.data addObjectsFromArray:array];

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
    self.indexList = [BDChineseStor IndexWithArray:self.addressList Key:@"name"];
    self.data = [NSMutableArray arrayWithArray:self.dataSoure];
    self.addressSoure = self.addressList;
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

-(NSMutableArray*)searchList{
    if (!_searchList) {
        _searchList= [NSMutableArray array];
    }
    return _searchList;
}
-(MFMessageComposeViewController *)vc {
    if (!_vc) {
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            _vc =[[MFMessageComposeViewController alloc] init];
        });
        return _vc;
    }
    return _vc;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:addTextField];
}
@end
