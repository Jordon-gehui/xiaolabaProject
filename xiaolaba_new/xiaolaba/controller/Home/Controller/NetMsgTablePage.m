//
//  NetMsgTablePage.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/10/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "NetMsgTablePage.h"
#import "NetMsgCell.h"

@interface NetMsgTablePage ()<UITextFieldDelegate>
{
    XLBUserModel *userModel;
    NSTimer *countDownTimer;
}
@property (retain,nonatomic) UIView * littView;
@property (retain,nonatomic) UIView *bottomView;
@property (retain,nonatomic) UITextField *inputField;
@property (retain,nonatomic) UIButton *sendBu;
@end

@implementation NetMsgTablePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"来自网页端";
    self.naviBar.slTitleLabel.text = @"来自网页端";
    userModel = [XLBUser user].userModel;
    [UIColor viewBackColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    if (iPhoneX) {
        self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-124-20);
    }else{
        self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-124);
    }
    [self.tableView reloadData];
    [self creatInputView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self showHudWithText:nil];
    [self performSelector:@selector(HttpgetData) withObject:nil afterDelay:1.0];
    
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [countDownTimer invalidate];

}
-(void)HttpgetData {
    [self HttpGetList:YES];
    self.data = [NSMutableArray array];
    if (!_isFinishMove) {
        self.inputField.placeholder = @" 回复信息";
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(HttpGetList:) userInfo:nil repeats:YES];
    }else{
        self.inputField.placeholder = @"挪车已完成 无法继续发送消息";
        [self.bottomView setUserInteractionEnabled:NO];
    }
    
}
-(void)HttpGetList:(BOOL)isAll{
    kWeakSelf(self);
    NSMutableDictionary *params = [@{@"id":_carId,@"self":userModel.ID} mutableCopy];
    if (!isAll) {
        if (kNotNil(_createUser)) {
            [params setValue:_createUser forKey:@"createUser"];
        }else{
            [params setValue:@"" forKey:@"createUser"];
        }
    }
    NSLog(@"%@",params);
    [[NetWorking network] POST:kNetMessageList params:params cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 获取回复列表 %@",result);
        [weakSelf hideHud];
        if ([[params allKeys] containsObject:@"createUser"]) {
            [self.data addObjectsFromArray:(NSArray*)result];
        }else{
            self.data = [(NSArray*)result mutableCopy];
        }
        [self.tableView reloadData];
        if (self.data.count>0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.data count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"回复列表获取失败"];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];
    }];
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatInputView{
    
    self.bottomView = [UIView new];
    if (iPhoneX) {
        self.bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 60-20 , kSCREEN_WIDTH, 60);
    }else
    self.bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 60 , kSCREEN_WIDTH, 60);
    self.bottomView.backgroundColor = RGB(229, 229, 229);
    [self.view addSubview:self.bottomView];
    
    self.inputField = [UITextField new];
    self.inputField.frame = CGRectMake(20, 10, kSCREEN_WIDTH - 110, 40);
    self.inputField.backgroundColor = [UIColor whiteColor];
    self.inputField.returnKeyType = UIReturnKeyDone;
    self.inputField.delegate = self;
    self.inputField.layer.cornerRadius =3;
    self.inputField.layer.masksToBounds = YES;
    self.inputField.font = [UIFont systemFontOfSize:14];
    self.inputField.textColor = [UIColor colorWithR:102 g:101 b:101];
    [self.inputField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bottomView addSubview:self.inputField];

    self.sendBu = [UIButton new];
    self.sendBu.frame =CGRectMake(self.inputField.right + 10,10, 70, 40);
    [self.sendBu setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBu addTarget:self action:@selector(sendMes:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBu.clipsToBounds = YES;
    self.sendBu.layer.cornerRadius = 8;
    self.sendBu.tag = 5;
    self.sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
    [self.bottomView addSubview:self.sendBu];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NetMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NetMsgCell class])];
    if (cell == nil) {
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        NSString *creatUser =[NSString stringWithFormat:@"%@",dic[@"createUser"]];
        if (![creatUser isEqualToString:[userModel.ID stringValue]]) {
            cell = [[NetMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NetMsgCell1"];
        }else {
            cell = [[NetMsgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NetMsgCell2"];
        }
    }
    [cell setDate:self.data[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 发送信息
- (void)sendMes:(UIButton *)bu{
    [self.inputField resignFirstResponder];
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kMoveCarsDetailMessageReply params:@{@"id":_carId,@"message":self.inputField.text} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 挪车详情 %@",result);
        [weakSelf hideHud];
        NSDictionary *dic = @{@"nickname":userModel.nickname,@"message":self.inputField.text,@"noticeDate":@"刚刚",@"img":userModel.img,@"createUser":userModel.ID};
        [self.data addObject:dic];
        self.inputField.text = nil;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.data count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"消息发送失败"];
    }];
}
- (UIView*)littView{
    if (!_littView) {
        _littView = [UIView new];
        [self.view addSubview:_littView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [_littView addGestureRecognizer:tap];
    }
    return _littView;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        if (iPhoneX) {
            self.bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 60-20 , kSCREEN_WIDTH, 60);
        }else
            self.bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 60 , kSCREEN_WIDTH, 60);
        
    } completion:^(BOOL finished) {
    }];
    [self.inputField resignFirstResponder];
    [self.littView removeFromSuperview];
    _littView = nil;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
        [self.sendBu setTitleColor:[UIColor whiteColor] forState:0];
        [self.sendBu setEnabled:NO];
    }else {
        self.sendBu.backgroundColor = [UIColor lightColor];
        [self.sendBu setTitleColor:[UIColor blackColor] forState:0];
        [self.sendBu setEnabled:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputField resignFirstResponder];
    [self.littView removeFromSuperview];
    _littView = nil;
    return YES;
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    self.littView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-height);
    [UIView animateWithDuration:0.3f animations:^{
        if (iPhoneX) {
            self.bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 60-20 , kSCREEN_WIDTH, 60);
        }else
            self.bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 60 , kSCREEN_WIDTH, 60);
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)onTap:(UITapGestureRecognizer *)sender{
    [self.inputField resignFirstResponder];
    [self.littView removeFromSuperview];
    _littView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
