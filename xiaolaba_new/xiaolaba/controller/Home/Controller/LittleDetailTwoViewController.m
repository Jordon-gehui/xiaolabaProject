//
//  LittleDetailTwoViewController.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleDetailTwoViewController.h"
#import "LittleDetilTwoTableViewCell.h"
#import "XLBCompleteViewController.h"
#import "LittleTwoHeadView.h"
#import "ReportChatViewController.h"
#import "LittleTwoModel.h"
#import "HCEmojiKeyboard.h"
#import "CMInputView.h"

static NSString *emoji = @"Resources.bundle/emoji";
static NSString *keyboard = @"Resources.bundle/keyboard";

@class LittltDetailTwoModel;
@interface LittleDetailTwoViewController ()<UITableViewDelegate,
                                            UITableViewDataSource,
                                            UITextViewDelegate,
                                            LittleDetilTwoTableViewCellDelegate>
{
    CGFloat kheight;

}
#define maxWords 100

//详情列表
@property (nonatomic,strong)UITableView *twoTableView;
@property (nonatomic,strong)LittleTwoHeadView *twoHeadView;
@property (nonatomic,strong)LittltDetailTwoModel *littltDetailTwoModel;
@property (strong,nonatomic) NSMutableArray *littltDetailTwoModelArr;

@property (strong,nonatomic) LittleTwoModel *littleTwoModel;

@property (retain,nonatomic) UIView *bottomView;
@property (retain,nonatomic) CMInputView *inputText;
//@property (retain,nonatomic) UITextField *inputField;
@property (retain,nonatomic) UIButton *sendBu;

@property (strong,nonatomic) NSMutableArray *littleTwoModelArr;
@property (nonatomic) NSInteger curr;
@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;


@end

@implementation LittleDetailTwoViewController
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (iPhoneX) {
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20)-20 , kSCREEN_HEIGHT, self.inputText.height+20);
        
    }else{
        self.bottomView.frame = CGRectMake(0, self.view.size.height - (self.inputText.height+20) , kSCREEN_HEIGHT, self.inputText.height+20);
    }
    [self.inputText resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithR:247 g:248 b:250];

    //注册键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    self.littleTwoModelArr = [NSMutableArray new];
    self.title = @"查看更多";
    self.naviBar.slTitleLabel.text = @"查看更多";
    self.littltDetailTwoModelArr = [NSMutableArray new];
    //创建tableview
    [self emojiKeyboard];
    [self creatTableView];
    [self bottomView];
    _curr = 1;
    
    //获取数据
    [self creatRefresh];
    
    //先不删除  后期要用
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti1" object:nil];
    


}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.inputText resignFirstResponder];
    //    [self.bottomView removeFromSuperview];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.inputText resignFirstResponder];
}

- (void)creatTableView{
    self.twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64 , kSCREEN_WIDTH, kSCREEN_HEIGHT - 64-55 ) style:UITableViewStyleGrouped];
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    self.twoTableView.separatorStyle = NO;
    self.twoTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.twoTableView];
    
    
    self.twoHeadView = [[LittleTwoHeadView alloc]init];
    self.twoHeadView.backgroundColor = [UIColor whiteColor];
    self.twoHeadView.detaiTwoModel = self.detailLittleModel;
    self.twoHeadView.height = [self.twoHeadView cellHeight];;
    self.twoTableView.tableHeaderView = self.twoHeadView;
    
}

-(UIView*)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
//        _bottomView.frame = CGRectMake(0, VIEW_HEIGHT - 60 , VIEW_WIDTH, 60);
        _bottomView.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
        [self.view addSubview:_bottomView];
        
        UIButton *faceBtn = [UIButton new];
        faceBtn.tag = 0;
        [faceBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [faceBtn setBackgroundImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
        [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [faceBtn setEnlargeEdge:10];
        [self.bottomView addSubview:faceBtn];
        [faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.bottomView);
        }];
        self.inputText = [[CMInputView alloc]initWithFrame:CGRectMake(100, 100, 300, 33)];
        
        self.inputText.font = [UIFont systemFontOfSize:14];
        self.inputText.placeholder = @"评论内容";
        
        self.inputText.cornerRadius = 4;
        self.inputText.placeholderColor = RGB(174,181,194);
        // 设置文本框最大行数
        [self.inputText textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            CGRect frame = self.inputText.frame;
            frame.size.height = textHeight;
            self.inputText.frame = frame;
            self.bottomView.frame = CGRectMake(0, self.view.size.height -(self.inputText.height+20) - kheight, kSCREEN_WIDTH, self.inputText.height+20);
            
        }];
        
        self.inputText.maxNumberOfLines = 4;
        self.inputText.delegate = self;
        [self.bottomView addSubview:self.inputText];
        [self.inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(faceBtn.mas_right).with.offset(10);
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(kSCREEN_WIDTH - 130);
            make.height.mas_greaterThanOrEqualTo(33);
            make.top.mas_equalTo(10);
        }];
        
        UIButton *sendBu = [UIButton new];
        //    sendBu.frame =CGRectMake(self.inputField.right + 10, self.inputField.top, 70, 40);
        [sendBu setTitle:@"发送" forState:UIControlStateNormal];
        [sendBu addTarget:self action:@selector(sendMes:) forControlEvents:UIControlEventTouchUpInside];
        sendBu.clipsToBounds = YES;
        sendBu.layer.cornerRadius = 8;
        sendBu.tag = 5;
        sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
        self.sendBu = sendBu;
        [self.bottomView addSubview:sendBu];
        [self.sendBu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.inputText.mas_right).with.offset(10);
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(33);
        }];
    }
    return _bottomView;
}

#pragma mark - Emoji键盘
- (HCEmojiKeyboard*)emojiKeyboard {
    if (_emojiKeyboard==nil) {
        _emojiKeyboard = [HCEmojiKeyboard sharedKeyboard];
        _emojiKeyboard.showAddBtn = NO;
        [_emojiKeyboard addBtnClicked:^{
            NSLog(@"clicked add btn");
        }];
        [_emojiKeyboard sendEmojis:^{
            //赋值
            [self.inputText resignFirstResponder];
            //                _showLab.text = _textWindow.text;
        }];
    }
    return _emojiKeyboard;
}
- (void)clickedFaceBtn:(UIButton *)button{
    if (button.tag == 1){
        self.inputText.inputView = nil;
        [button setBackgroundImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:keyboard] forState:UIControlStateNormal];
        [self.emojiKeyboard setTextInput:self.inputText];
    }
    [self.inputText reloadInputViews];
    button.tag = (button.tag+1)%2;
    [self.inputText becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length < (maxWords + 1)) {
    }
    //    else {
    //        self.textView.text = [textView.text substringToIndex:maxWords];
    //    }
    //    self.sign = self.textView.text;
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > maxWords)
            {
                textView.text = [toBeString substringToIndex:maxWords];
                
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > maxWords)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxWords];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:maxWords];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxWords)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    if (textView.text.length == 0) {
        self.sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
        [self.sendBu setTitleColor:[UIColor whiteColor] forState:0];
        [self.sendBu setEnabled:NO];
    }else {
        self.sendBu.backgroundColor = [UIColor lightColor];
        [self.sendBu setTitleColor:[UIColor blackColor] forState:0];
        [self.sendBu setEnabled:YES];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (iPhoneX) {
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20)-20 , kSCREEN_WIDTH, self.inputText.height+20);
    }else{
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20) , kSCREEN_WIDTH, self.inputText.height+20);
    }
    [self.inputText resignFirstResponder];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.inputText resignFirstResponder];
    return YES;
}


//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    kheight = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.bottomView.frame = CGRectMake(0, self.view.size.height -(self.inputText.height+20) - kheight, kSCREEN_WIDTH, self.inputText.height+20);
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    } completion:^(BOOL finished) {
        [UIView commitAnimations];
    }];
    
}


#pragma mark - 发送信息
- (void)sendMes:(UIButton *)bu{
    
    
    [self.inputText resignFirstResponder];
    
    NSInteger  num = [[XLBUser user].userModel.status integerValue];
    
    if (num < 10 ) {
        
        [MBProgressHUD showError:@"请完善信息"];
        XLBCompleteViewController * com = [XLBCompleteViewController new];
        com.rightItemTag = @"1";
        com.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
        
    }else{
    //    NSLog(@"发送信息");
        if (!kNotNil(self.inputText.text)) {
            [MBProgressHUD showError:@"评论内容不能为空"];
            return ;
        }
        NSDictionary *dict;
        if (self.isNews) {
            if (![self.moreStr isEqualToString:@"1"]) {
                dict = @{@"momentId":self.littleDetailModel.momentId,@"discussion":self.inputText.text,@"discussId":self.littleDetailModel.ID};

                if ([XLBUser user].isLogin &&kNotNil([XLBUser user].token)) {
                    NSString *userId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
                dict = @{@"createUser":userId,@"momentId":self.littleDetailModel.momentId,@"discussion":self.inputText.text,@"discussId":self.littleDetailModel.ID};
                }
                
            }else{
                dict = @{@"discussion":self.inputText.text,@"momentId":self.momentID,@"discussId":self.dissID};
                if ([XLBUser user].isLogin &&kNotNil([XLBUser user].token)) {
                    NSString *userId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
                    dict = @{@"createUser":userId,@"discussion":self.inputText.text,@"momentId":self.momentID,@"discussId":self.dissID};
                }
            }
        }else{
            if (![self.moreStr isEqualToString:@"1"]) {
                dict = @{@"momentId":self.littleDetailModel.momentId,@"discussion":self.inputText.text,@"discussId":self.littleDetailModel.ID};
                
            }else{
                dict = @{@"discussion":self.inputText.text,@"momentId":self.momentID,@"discussId":self.dissID};
            }
        }
        
        bu.enabled = NO;
        NSString *urlStr = self.isNews ?kNewsDiscuTwo:kDiscuTwo;
        [[NetWorking network] POST:urlStr params:dict cache:NO success:^(id result) {
            self.inputText.text = @"";
            self.sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
            [self.sendBu setTitleColor:[UIColor whiteColor] forState:0];
            [self.sendBu setEnabled:NO];
            //获取数据
            [self.littleTwoModelArr removeAllObjects];
            
            [self getDataFromServer:_curr];
            bu.enabled = YES;
        } failure:^(NSString *description) {
            
            bu.enabled = YES;
            [MBProgressHUD showError:@"评论失败"];
        }];
        
    }
}

- (void)creatRefresh{
    //加载更多刷新
    self.twoTableView.mj_footer=[XLBRefreshFooter footerWithRefreshingBlock:^{
        
        _curr ++;
        [self getDataFromServer:_curr];
        
    }];

    //下拉刷新
    self.twoTableView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        _curr = 1;
        [self.littleTwoModelArr removeAllObjects];

        [self getDataFromServer:_curr];
        
    }];
    // 马上进入刷新状态
    [ self.twoTableView.mj_header beginRefreshing];
}

- (void)getDataFromServer:(NSInteger)current{
    
    NSDictionary *dict;
    
    if (![self.moreStr isEqualToString:@"1"]) {
        
        dict = @{@"page":@{@"curr":@(current),@"size":@"10"},@"momentId":self.littleDetailModel.momentId,@"discussId":self.littleDetailModel.ID};
    }else{
        dict =@{@"page":@{@"curr":@(current),@"size":@"10"},@"momentId":self.momentID,@"discussId":self.dissID};

    }
//
    [[NetWorking network] POST:kHomeDisList params:dict cache:NO success:^(id result) {
        
        NSLog(@"-------------------详细评论--%@--dic = %@",result,dict);
        
        
        NSArray *listArr = result[@"list"];
        
        self.littleTwoModelArr = [LittleTwoModel mj_objectArrayWithKeyValuesArray:listArr];

//     
        [self.twoTableView reloadData];
        [self.twoTableView.mj_header endRefreshing];
        [self.twoTableView.mj_footer endRefreshing];
        
        BOOL nextHome = [result[@"next"] boolValue];
        if (nextHome == NO || nextHome == 0) {
            
            [self.twoTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
            
        }

    } failure:^(NSString *description) {

        [self.twoTableView.mj_header endRefreshing];
        [self.twoTableView.mj_footer endRefreshing];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [UIView new];
//    headView.backgroundColor = [UIColor lineColor];
    headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 15);
    
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LittleDetilTwoTableViewCell *cell = (LittleDetilTwoTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [cell cellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.littleTwoModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"detail";
    
    LittleDetilTwoTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!detailCell) {
        detailCell = [[LittleDetilTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        
    }
    detailCell.detailDelegate = self;
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.littleTwoModelArr.count > 0) {
        detailCell.detaiTwoModel = self.littleTwoModelArr[indexPath.row];

    }
    

    return detailCell;
    
}


#pragma mark - 代理


- (void)clickDetailReport:(LittleDetilTwoTableViewCell*)clickDetailReport withID:(NSString *)cellID{
    ReportChatViewController *chat = [ReportChatViewController new];
    chat.hidesBottomBarWhenPushed = YES;
    chat.reportType = @"6";
    chat.detailID = cellID;
    [self.navigationController pushViewController:chat animated:YES];
    
}
- (void)clickDetailDel:(LittleDetilTwoTableViewCell*)clickDetailDel withID:(NSString *)cellID{
    
    //    //如果按钮是加在cell上的contentView上
    NSIndexPath *myIndex=[self.twoTableView indexPathForCell:(LittleDetilTwoTableViewCell*)[[clickDetailDel.detailReportBu superview]superview]];
    NSLog(@"myIndex.section==%ld",myIndex.section);
    NSLog(@"myIndex.row==%ld",myIndex.row);
    //
    NSDictionary *dict = @{@"id":cellID};
    [[NetWorking network] POST:kPubErDelDellish params:dict cache:NO success:^(id result) {
        //21414628718297088

        NSLog(@"评论删除 == %@",result);

        [self.twoTableView beginUpdates];
        if (self.littleTwoModelArr.count > 0) {
            [self.littleTwoModelArr removeObjectAtIndex:[myIndex row]];
            [self.twoTableView deleteRowsAtIndexPaths:@[myIndex] withRowAnimation:UITableViewRowAnimationRight];
        }
        [MBProgressHUD showError:@"删除成功"];
        [self.twoTableView endUpdates];

        NSLog(@"评论删除 == %@",result);
    } failure:^(NSString *description) {


    }];
}


- (void)clickDetailReport:(LittleDetilTwoTableViewCell*)clickDetailReport{
    
    ReportChatViewController *chat = [ReportChatViewController new];
    chat.hidesBottomBarWhenPushed = YES;
    chat.reportType = @"6";
    chat.detailID = self.littleDetailModel.ID;
    [self.navigationController pushViewController:chat animated:YES];
    
}

@end
