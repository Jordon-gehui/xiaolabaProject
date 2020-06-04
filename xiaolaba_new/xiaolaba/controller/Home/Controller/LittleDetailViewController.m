//
//  LittleDetailViewController.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleDetailViewController.h"
#import "DetailModel.h"
#import "XLBCompleteViewController.h"
#import "LittleDetailTwoViewController.h"
#import "DetailTableViewCell.h"
#import "ReportChatViewController.h"
#import "LittleDetailModel.h"
#import "DetailHeadView.h"
#import "HCEmojiKeyboard.h"
#import "CMInputView.h"
#import "LoginView.h"
#import "DetailImageModel.h"
#import "XLBLoginViewController.h"


static NSString *emoji = @"Resources.bundle/emoji";
static NSString *keyboard = @"Resources.bundle/keyboard";
@class DetailTwoModel;
@class DiscussDiscussList;
@interface LittleDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DetailTableViewCellDelegate,UIScrollViewDelegate,UITextViewDelegate,XLBShareViewDelegate,DetailHeadViewDelegate,DetailImageViewDelegate>
{
    CGFloat kheight;
}
#define maxWords 100

@property (strong,nonatomic) UITableView *detailTableView;
@property (strong,nonatomic) UIView * littView;
@property (strong,nonatomic) DetailHeadView *headView;
@property (strong,nonatomic) NSMutableArray *detailArr;
@property (strong,nonatomic) DetailModel *detailLittleModel;
@property (strong,nonatomic) DetailTwoModel *detailTwoModel;
@property (strong,nonatomic) LittleDetailModel *littleDetailModel;
@property (strong,nonatomic) DiscussDiscussList *discussDiscussListModel;
@property (strong,nonatomic) NSMutableArray *littleDetailModelArr;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) NSMutableArray *imageArr;
@property (strong,nonatomic) DetailImageModel *detailImageModel;
@property (strong,nonatomic) DetailImageView * imageView;
@property (retain,nonatomic) UIView *bottomView;
@property (retain,nonatomic) CMInputView *inputText;
//@property (retain,nonatomic) UITextField *inputField;
@property (retain,nonatomic) UIButton *sendBu;
@property (nonatomic) NSInteger curr;
@property (strong,nonatomic) NSMutableArray *twoArr;
@property (strong,nonatomic) UILabel *nilLabel;
@property (copy,nonatomic) NSString *preTag;
@property (copy,nonatomic) NSString *total;
@property (copy,nonatomic) NSString *nilImageTag;
@property (strong,nonatomic) UITableView *littleScroView;
@property (assign,nonatomic)BOOL isHeadrRefresh;
@property (strong,nonatomic) UIView *chooseView;

@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;

@end

static NSString *Identifier = @"detail";
static NSString *NoDetailIdentifier = @"nodetail";

@implementation LittleDetailViewController

- (void)initNaviBar {
    [super initNaviBar];
    UIButton *reportItem = [UIButton new];
    [reportItem setImage:[UIImage imageNamed:@"icon_fx"] forState:UIControlStateNormal];
    [reportItem addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    reportItem.tag = 500;

    UIButton *rightItem = [UIButton new];
    [rightItem setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
    rightItem.tag = 501;
    [rightItem addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]){
        [self.naviBar setRightItem:rightItem];
    }else{
        [self.naviBar setRightItems:@[rightItem,reportItem]];
    }
}

- (void)rightClick:(UIButton *)bu{

    switch (bu.tag) {
        case 500:
            //分享到微信
            [self shareWechat];
            
            break;
        case 501:
            
            //举报
            [self reportChat];
            
            
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.returnBlock) {
        self.returnBlock(self.detailModel);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    self.naviBar.slTitleLabel.text = @"动态";
    [self initNaviBar];
    [MobClick event:@"Dynamic_Detail"];
    self.imageArr = [NSMutableArray new];
    self.twoArr = [NSMutableArray new];
    self.preTag = [NSString new];
    self.total = [NSString new];
    self.nilImageTag = [NSString new];
    [self emojiKeyboard];
    //创建tableview
    [self creatTableView];
    //获取数据
    [self creatRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //获取数据
    [self creatImageRefresh];    
}


- (void)creatImageRefresh{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        return;
    }
    NSDictionary *dict = @{@"id":self.detailModel.ID};
    [[NetWorking network] POST:kHomeReportLikeList params:dict cache:NO success:^(id result) {
        
        NSLog(@"---------喜欢人数--%@--dic = %@",result,dict);
        
            for (NSDictionary * dict in result) {
                self.detailImageModel = [DetailImageModel mj_objectWithKeyValues:dict];
                [self.imageArr addObject:self.detailImageModel];

            }
        self.imageView.imageModelArr = self.imageArr;
        } failure:^(NSString *description) {
            
    }];

}

- (void)creatRefresh{
    
    
    //加载更多刷新
    self.detailTableView.mj_footer=[XLBRefreshFooter footerWithRefreshingBlock:^{
        self.nilImageTag = @"1";
        _curr ++;
        [self getDataFromServer:_curr];
        
    }];
    
    
    
    //下拉刷新
    self.detailTableView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        _curr = 1;
        [self.detailArr removeAllObjects];
        [self.littleDetailModelArr removeAllObjects];
        [self getDataFromServer:_curr];
    }];
    // 马上进入刷新状态
    [ self.detailTableView.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self creatInputView];
    if (iPhoneX) {
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20)-20 , kSCREEN_HEIGHT, self.inputText.height+20);
        
    }else{
        self.bottomView.frame = CGRectMake(0, self.view.size.height - (self.inputText.height+20) , kSCREEN_HEIGHT, self.inputText.height+20);
    }

    if ([self.preTag isEqualToString:@"1"]) {

        return;
    }
    [self.inputText resignFirstResponder];
    [self.littView setHidden:YES];
}

- (void)getDataFromServer:(NSInteger)current{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [self.detailTableView reloadData];
        [self.detailTableView.mj_header endRefreshing];
        [self.detailTableView.mj_footer endRefreshing];
        return;
    }
    NSDictionary *dict = @{@"page":@{@"curr":@(current),@"size":@"10"},@"momentId":self.detailModel.ID ,@"orderCond":@"date"};
    
    [[NetWorking network] POST:kHomeDetailList params:dict cache:NO success:^(id result) {
        
        NSLog(@"-------------------评论--%@--dic = %@",result,dict);
        self.twoArr = result[@"list"];
        
        for (NSDictionary * dicLittle in self.twoArr ) {

            self.littleDetailModel = [LittleDetailModel mj_objectWithKeyValues:dicLittle];
            [self.littleDetailModelArr addObject:self.littleDetailModel];
//            NSString *string = [NSString]
            NSDictionary * discussion =   [NetWorking dictionaryWithJsonString:dicLittle[@"discussion"]];
            self.detailLittleModel = [DetailModel mj_objectWithKeyValues:discussion];
            if (self.detailLittleModel) {
                [self.detailArr addObject:self.detailLittleModel];
            }
            
        }

        [self.detailTableView reloadData];
        [self.detailTableView.mj_header endRefreshing];
        [self.detailTableView.mj_footer endRefreshing];
        
        if (_isHeadrRefresh) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.detailTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            });
            
            _isHeadrRefresh = NO;
            
        }
        
        BOOL nextHome = [result[@"next"] boolValue];
        if (nextHome == NO || nextHome == 0) {
            [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
    } failure:^(NSString *description) {
        
        [self.detailTableView.mj_header endRefreshing];
        [self.detailTableView.mj_footer endRefreshing];
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (kNotNil(self.type)) {
            [self.detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            self.type = nil;
        }
    });
}
- (UILabel *)nilLabel {
    if (!_nilLabel) {
        _nilLabel = [UILabel new];
        _nilLabel.frame = CGRectMake((kSCREEN_WIDTH-150)/2.0, 50, 150, 150);
        _nilLabel.text = @"快来发表你的评论吧~";
        _nilLabel.textAlignment = NSTextAlignmentCenter;
        _nilLabel.font = [UIFont systemFontOfSize:16];
        _nilLabel.textColor = RGB(174,181,194);
    }
    return _nilLabel;
}

- (void)creatInputView{
    if (self.bottomView!=nil) {
        return;
    }
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.view addSubview:self.bottomView];
    
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

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    kheight = keyboardRect.size.height;
    if (iPhoneX) {
        self.littView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-(self.inputText.height+20)-kheight-20);
    }else {
        self.littView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-(self.inputText.height+20)-kheight);
    }
    [UIView animateWithDuration:0.3f animations:^{
        NSLog(@"%lf",self.view.size.height -(self.inputText.height+20) - kheight);
        self.bottomView.frame = CGRectMake(0, self.view.size.height -(self.inputText.height+20) - kheight, kSCREEN_WIDTH, self.inputText.height+20);
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    } completion:^(BOOL finished) {
        [UIView commitAnimations];
    }];
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self.littView setHidden:NO];
    //iPhone键盘高度216，iPad的为352
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
    [self.littView setHidden:YES];
    return YES;
}
- (UIView*)littView{
    if (_littView==nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _littView = [UIView new];
        [window addSubview:_littView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        
        [_littView addGestureRecognizer:tap];
    }
    return _littView;
}
- (void)onTap:(UITapGestureRecognizer *)sender{
    [self.inputText resignFirstResponder];
    [self.littView setHidden:YES];
}

#pragma mark - 发送信息
- (void)sendMes:(UIButton *)bu{

    [self.inputText resignFirstResponder];
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    NSInteger  num = [[XLBUser user].userModel.status integerValue];
    
    if (num < 10 ) {
        
        [MBProgressHUD showError:@"请完善信息"];
        XLBCompleteViewController * com = [XLBCompleteViewController new];
        com.rightItemTag = @"1";
        com.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:com animated:YES];
        
    }else{
        NSLog(@"发送信息");
        if (!kNotNil(self.inputText.text)) {
            [MBProgressHUD showError:@"评论内容不能为空"];
            return ;
        }
        NSDictionary *dict = @{@"momentId":self.detailModel.ID,@"discussion":self.inputText.text};
        //
        bu.enabled = NO;
        [[NetWorking network] POST:kHomeDiscu params:dict cache:NO success:^(id result) {
            self.inputText.text = @"";
            self.sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
            [self.sendBu setTitleColor:[UIColor whiteColor] forState:0];
            [self.sendBu setEnabled:NO];
            self.detailModel.discussCount =  [NSString stringWithFormat:@"%li",[self.detailModel.discussCount integerValue]+1];
            [self.detailArr removeAllObjects];
            [self.littleDetailModelArr removeAllObjects];
            //获取数据
    //        [ self.detailTableView.mj_header beginRefreshing];
            [self.littView removeFromSuperview];
            _isHeadrRefresh = YES;
            
            _curr = 1;
            [self getDataFromServer:_curr];
            
            self.imageView.countLable.text = [NSString stringWithFormat:@"(%@)",self.detailModel.discussCount];
            bu.enabled = YES;
        } failure:^(NSString *description) {
            bu.enabled = YES;
            [MBProgressHUD showError:@"评论失败"];
        }];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.inputText resignFirstResponder];
    [self.littView setHidden:YES];
//    [self.bottomView removeFromSuperview];

}

- (void)creatTableView{
    
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom - 50 ) style:UITableViewStyleGrouped];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.separatorStyle = NO;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.detailTableView];
    
    
    self.headView = [DetailHeadView new];
    self.headView.littleModel = self.detailModel;
    self.headView.height =[self.headView cellHeight];
    [self.detailTableView setTableHeaderView:self.headView];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.imageDelegate = self;
    

}

#pragma mark - 图片点击

- (void)imageBu:(DetailHeadView*)imageBu withURL:(NSURL *)URL withIndex:(NSInteger )index{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.preTag = @"1";
    ImageReviewViewController *im = [[ImageReviewViewController alloc] init];
    im.imageArray = self.detailModel.imgs;
    im.currentIndex = [NSString stringWithFormat:@"%li",(long)index];
    im.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:im animated:YES completion:nil];
}
-(void)headImageHeadSize:(CGFloat)height {
    self.headView.height =height;
    [self.detailTableView setTableHeaderView:self.headView];
}
#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.littleDetailModelArr.count ==0) {
        return 1;
    }
    return self.littleDetailModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 75 + 50;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.imageView = [[DetailImageView alloc]init];
    self.imageView.imageModelArr = self.imageArr;
    self.imageView.delegate =self;
    [self.imageView.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.littleDetailModelArr.count==0) {
        if ([self.detailModel.discussCount isEqualToString:@""]  || self.detailModel.discussCount == nil) {
            self.imageView.countLable.text = @"(0)";
            self.imageView.nilTagsLabel.hidden = NO;
        }else {
            self.imageView.countLable.text = [NSString stringWithFormat:@"(%@)",self.detailModel.discussCount];
        }
    }else{
        self.imageView.countLable.text = [NSString stringWithFormat:@"(%li)",(unsigned long)self.littleDetailModelArr.count];

    }
    if ([self.detailModel.liked isEqualToString:@"1"]) {
        [self.imageView.likeBu setBackgroundImage:[UIImage imageNamed:@"icon_fx_dz_s"] forState:UIControlStateNormal];
    }else {
        [self.imageView.likeBu setBackgroundImage:[UIImage imageNamed:@"icon_fx_dz_n"] forState:UIControlStateNormal];
    }
    if (self.imageArr.count > 0) {
        
        NSString * str = [NSString stringWithFormat:@"%li",[self.detailModel.likes integerValue]];
        self.imageView.likeLable.text = [NSString stringWithFormat:@"%@人点赞",str];
        if (self.imageArr.count > 0) {
            self.imageView.likeLable.text = [NSString stringWithFormat:@"%li人点赞",self.imageArr.count];

        }
        self.imageView.nilTagsLabel.hidden = YES;

    }
    return self.imageView;
}

- (void)praiseBtnClick:(UIButton *)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    if (kNotNil(self.detailModel.createUser)&&kNotNil(self.detailModel.ID)) {
        [[CSRouter share]push:@"XLBPraiseListViewController" Params:@{@"createUser":self.detailModel.createUser,@"momentId":self.detailModel.ID,} hideBar:YES];
    }
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.littleDetailModelArr.count ==0) {
        return 200;
    }else{
        DetailTableViewCell *cell = (DetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return [cell cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.indexPath = indexPath;
    DetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    UITableViewCell *nodetailCell = [tableView dequeueReusableCellWithIdentifier:NoDetailIdentifier];
    if (self.littleDetailModelArr.count >0) {
        if (!detailCell) {
            detailCell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
            
        }
        detailCell.DetailDelegate = self;
        [detailCell.detailtwoArr removeAllObjects];
        [detailCell.discusstwoArr removeAllObjects];
        detailCell.twoModel = self.littleDetailModelArr[indexPath.row];
        return detailCell;

    }else {
        if (!nodetailCell) {
            nodetailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NoDetailIdentifier];
            nodetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [nodetailCell.contentView addSubview:self.nilLabel];
            nodetailCell.backgroundColor = [UIColor clearColor];
        }
        return nodetailCell;
    }


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.littleDetailModelArr.count >0) {
        self.preTag = @"";
        LittleDetailTwoViewController *two = [LittleDetailTwoViewController new];
        two.hidesBottomBarWhenPushed = YES;
        two.detailLittleModel = self.detailArr[indexPath.row];
        two.littleDetailModel = self.littleDetailModelArr[indexPath.row];
        two.dissID = self.littleDetailModel.ID;
        [self.navigationController pushViewController:two animated:YES];
    }
}
#pragma maek - headViEW代理
- (void)likeBu:(DetailImageView*)likeBu{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubZanlish,self.detailModel.ID];
    
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        
        [likeBu.likeBu setBackgroundImage:[UIImage imageNamed:@"icon_fx_dz_s"] forState:UIControlStateNormal];
        DetailImageModel *model =[DetailImageModel new];
        model.avatar =[XLBUser user].userModel.img;
        model.userId = [[XLBUser user].userModel.ID stringValue];
        [self.imageArr addObject:model];
        likeBu.likeLable.text = [NSString stringWithFormat:@"%ld人点赞",self.imageArr.count];
        self.detailModel.liked = @"1";
        self.detailModel.likes = [NSString stringWithFormat:@"%li",[self.detailModel.likes integerValue]+1];
        likeBu.nilTagsLabel.hidden = YES;
        self.imageView.imageModelArr = self.imageArr;
        
    } failure:^(NSString *description) {
        
        [MBProgressHUD showError:@"不能重复点赞"];
        
    }];
    
}

#pragma maek - 查看更多
- (void)clickBu:(DetailTableViewCell*)clickBu withID:(NSString *)discussId withID:(NSString *)momentId withModel:(DetailModel *)buDetailModel
{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    LittleDetailTwoViewController *two = [LittleDetailTwoViewController new];
    two.hidesBottomBarWhenPushed = YES;
    two.moreStr = @"1";
    two.dissID = discussId;
    two.momentID = momentId;
    two.detailLittleModel = buDetailModel;
    [self.navigationController pushViewController:two animated:YES];
    
}

- (void)clickDetailReply:(DetailTableViewCell*)clickDetailReply withID:(NSString *)discussId withID:(NSString *)momentId withModel:(DetailModel *)buDetailModel{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    LittleDetailTwoViewController *two = [LittleDetailTwoViewController new];
    two.hidesBottomBarWhenPushed = YES;
    two.moreStr = @"1";
    two.dissID = discussId;
    two.momentID = momentId;
    two.detailLittleModel = buDetailModel;
    
    
    [self.navigationController pushViewController:two animated:YES];
}
//头试图头像点击
- (void)headImageBu:(DetailHeadView*)headImageBu withId:(NSString *)userID{
    
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    OwnerViewController * oner = [OwnerViewController new];
    oner.userID = userID;
    oner.delFlag = 0;
    oner.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oner animated:YES];
    
}

//点赞头像点击
- (void)ownerImgBtnClickWithId:(NSString *)userId {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    if (kNotNil(userId)) {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":userId,@"delFlag":@0,} hideBar:YES];
    }
}

//cell上头像点击
- (void)cellImageBu:(DetailTableViewCell*)headImageBu withId:(NSString *)userID{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    OwnerViewController * oner = [OwnerViewController new];
    oner.userID = userID;
    oner.delFlag = 0;
    oner.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oner animated:YES];
    
}

- (void)clickDetailZan:(DetailTableViewCell*)clickDetailZan withID:(NSString *)discussId{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    
    NSDictionary *dict = @{@"momentId":self.detailModel.ID,@"discussId":discussId};

    [[NetWorking network] POST:kPubErjiZanlish params:dict cache:NO success:^(id result) {
//
        NSInteger zanCount = [self.littleDetailModel.likes integerValue]+1;
        [clickDetailZan.detailZanBu setBackgroundImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        clickDetailZan.detailZanLabel.text = [NSString stringWithFormat:@"%ld",zanCount];
        for (LittleDetailModel *model in self.littleDetailModelArr) {
            if ([model.ID isEqualToString:discussId]) {
                model.likes = [NSString stringWithFormat:@"%li",[model.likes integerValue]+1];
                model.liked = @"1";
            }
            
        }
        [self.detailTableView reloadData];
    } failure:^(NSString *description) {
        
        
    }];
}

#pragma marlk - 点击最右边的三个小点
- (void)clickDetailReport:(DetailTableViewCell*)clickDetailReport withID:(NSString *)delID{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    ReportChatViewController *chat = [ReportChatViewController new];
    chat.hidesBottomBarWhenPushed = YES;
    chat.reportType = @"2";
    chat.detailID = self.detailModel.ID;
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (void)clickDetailDel:(DetailTableViewCell*)clickDetailDel withID:(NSString *)delID{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    
//    //如果按钮是加在cell上的contentView上
    NSIndexPath *myIndex=[self.detailTableView indexPathForCell:(DetailTableViewCell*)[[clickDetailDel.detailReportBu superview]superview]];
    NSLog(@"myIndex.section==%ld",myIndex.section);
    NSLog(@"myIndex.row==%ld",myIndex.row);
//
       NSDictionary *dict = @{@"id":delID};

        [[NetWorking network] POST:kPubErDellish params:dict cache:NO success:^(id result) {
            //21414628718297088

            NSLog(@"评论删除 == %@",result);
        
        if (self.littleDetailModelArr.count > 0) {
            [self.littleDetailModelArr removeObjectAtIndex:[myIndex row]];
            [MBProgressHUD showError:@"删除成功"];
            [self.detailTableView reloadData];
            self.detailModel.discussCount = [NSString stringWithFormat:@"%li",self.littleDetailModelArr.count];
            self.imageView.countLable.text = [NSString stringWithFormat:@"(%li)",self.littleDetailModelArr.count];
        }
        
        NSLog(@"评论删除 == %@",result);
        } failure:^(NSString *description) {


        }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.littView setHidden:YES];
}

#pragma mark - 举报
- (void)reportChat{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.preTag = @"1";
    ReportChatViewController *chat = [ReportChatViewController new];
    chat.hidesBottomBarWhenPushed = YES;
    chat.reportType = @"1";
    chat.detailID = self.detailModel.ID;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark -分享到微信


- (void)shareWechat{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    self.preTag = @"1";
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [self setShareViewWithHidden:ShareBtnWeChatHidden];
    }else if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]){
        [self setShareViewWithHidden:ShareBtnWeiBoHidden];
    }else {
        [self setShareViewWithHidden:3];
    }
}

- (void)setShareViewWithHidden:(ShareBtnHidden)hidden {
    XLBShareView *shareView = [[XLBShareView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:ShareViewDefault isHidden:hidden];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];
}
#pragma mark - share
- (void)shareViewBtnClickWithTag:(UIButton *)sender {
    switch (sender.tag) {
        case ShareViewWeChatBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneSession isWeiBo:NO];
        }
            break;
        case ShareViewWeChatPyqBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneTimeline isWeiBo:NO];
        }
            break;
        case ShareViewWeiBoBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneSession isWeiBo:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)shareViewWithWeChatType:(WechatShareScene)weChatType isWeiBo:(BOOL)weibo{
    BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:nil];
    shareModel.urlString = [NSString stringWithFormat:@"%@wechat/moment?id=%@",kDomainUrl,self.detailModel.ID];
    shareModel.title = [NSString stringWithFormat:@"来自%@的小喇叭动态",self.detailModel.nickName];
    if (kNotNil(self.detailModel.moment) && [self.detailModel.moment hasSuffix:@"\n"]) {
        NSString *b = [self.detailModel.moment stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        if (weibo == YES) {
            shareModel.text = b;
        }else {
            shareModel.describe = b;
        }
    }else {
        if (weibo == YES) {
            shareModel.text = self.detailModel.moment;
        }else {
            shareModel.describe = self.detailModel.moment;
        }
    }
    
    UIImage *imag;
    if (kNotNil(self.detailModel.imgs) && self.detailModel.imgs.count > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:self.detailModel.imgs[0] Withtype:IMGAvatar]]];
        imag = [UIImage imageWithData:data];
    }else {
        if (weibo == YES) {
            imag = [UIImage imageNamed:@"pic_m"];
        }else {
            imag = [UIImage imageNamed:@"abc"];
        }
    }
    shareModel.image = imag;
    
    if (weibo == YES) {
        [[BQLAuthEngine sharedAuthEngine] auth_sina_share_link:shareModel success:^(id response) {
        } failure:^(NSString *error) {
        }];
    }else {
        [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_link:shareModel scene:weChatType success:^(id response) {
        } failure:^(NSString *error) {
        }];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubSharelish,self.detailModel.ID];
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        NSString * str = [NSString stringWithFormat:@"%li",[self.detailModel.shares integerValue] + 1];
        self.detailModel.shares = str;
        self.headView.shareLable.text = [NSString stringWithFormat:@"分享(%@)",str];
    } failure:^(NSString *description) {
    }];
}

- (NSMutableArray *)littleDetailModelArr{
    
    if (!_littleDetailModelArr) {
        _littleDetailModelArr = [NSMutableArray array];
    }
    return _littleDetailModelArr;
}

- (NSMutableArray *)detailArr{
    
    if (!_detailArr) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
