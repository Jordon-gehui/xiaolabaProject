//
//  XLBUpdateInfoViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/24.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBUpdateInfoViewController.h"
#import "SZTextView.h"
//#import "BQLSheetView.h"
#import "XLBAlertController.h"
#import "XLBMeRequestModel.h"
#import "XLBUser.h"

#import "HCEmojiKeyboard.h"
static NSString *emoji = @"Resources.bundle/emoji";
static NSString *keyboard = @"Resources.bundle/keyboard";

static NSInteger maxWords = 50;
#define MAX_STARWORDS_LENGTH 10

@interface XLBUpdateInfoViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, strong) UITextField *nickTextfield;
@property (nonatomic, assign) UpdateType seletedType;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) NSArray *sex_array;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) XLBUserModel *model;
@property (nonatomic, strong) UILabel *leftWord;

//键盘
@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;
@property(nonatomic,assign) BOOL keyBoardlsVisible;
@property(nonatomic,retain)UIView *intefaceView;

@end

@implementation XLBUpdateInfoViewController

- (instancetype)initWithType:(UpdateType )type string:(NSString *)string{
    
    if(self = [super init]) {
        self.title = [self typeWithString:type string:string];
        self.naviBar.slTitleLabel.text = [self typeWithString:type string:string];
        self.view.backgroundColor = [UIColor viewBackColor];

        self.seletedType = type;
        self.model = [XLBUser user].userModel;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    switch (self.seletedType) {
        case UpdateTypeSign: {
            [_delegate updateInfoSuccess:self.textView.text type:UpdateTypeSign];
        }
            break;
        case UpdateTypeNick: {
            [_delegate updateInfoSuccess:self.nickTextfield.text type:UpdateTypeNick];
        }
            break;
        case UpdateTypeGroupNickName: {
            [_delegate updateInfoSuccess:self.nickTextfield.text type:UpdateTypeGroupNickName];
        }
            break;
        case UpdateTypeGroupAnnounct: {
            [_delegate updateInfoSuccess:self.textView.text type:UpdateTypeGroupAnnounct];
        }
            break;
            
        case UpdateTypeMeGroupNickName: {
            [_delegate updateInfoSuccess:self.nickTextfield.text type:UpdateTypeMeGroupNickName];
        }
            break;
        default:
            break;
    }
}

- (void)initNaviBar {
    UIButton *leftNavItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftNavItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftNavItem setImage:[UIImage imageNamed:@"icon_fh_z"] forState:UIControlStateNormal];
    [leftNavItem addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setLeftItem:leftNavItem];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavItem];
}

- (void)setupSignViewWithString:(NSString *)type {

    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(8.f, 10.0f, 8.f, 10.0f);
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.naviBar.mas_bottom).offset(10);

        make.height.mas_equalTo(120);
    }];
    self.leftWord = [[UILabel alloc] init];
    self.leftWord.textColor = RGB(180, 180, 180);
    self.leftWord.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.leftWord];
    [self.leftWord mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self.textView.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(18);
    }];

//    [self createEmojiView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    _intefaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    [_intefaceView setBackgroundColor:[UIColor whiteColor]];
    [_intefaceView setHidden:YES];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
    [line setBackgroundColor:[UIColor lineColor]];
    [_intefaceView addSubview:line];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kSCREEN_WIDTH, 0)];
    [line2 setBackgroundColor:[UIColor lineColor]];
    [_intefaceView addSubview:line2];
    UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 4, 32, 32)];
    faceBtn.tag = 0;
    [faceBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    [faceBtn setBackgroundImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_intefaceView addSubview:faceBtn];
    if ([type isEqualToString:@"2"]) {
        if (kNotNil(self.sign)) {
            self.textView.text = self.sign;
            self.leftWord.text = [NSString stringWithFormat:@"%li/%li",self.sign.length,maxWords];
        }else {
            self.textView.placeholder = @"请输入个性签名";
            self.leftWord.text = [NSString stringWithFormat:@"0/%li",maxWords];
        }
    }else {
        if (kNotNil(self.groupAnnounct)) {
            self.textView.text = self.groupAnnounct;
            self.leftWord.text = [NSString stringWithFormat:@"%li/%li",self.sign.length,maxWords];
        }else {
            self.textView.placeholder = @"请输入群公告";
            self.leftWord.text = [NSString stringWithFormat:@"0/%li",maxWords];
        }
    }
}

- (void)setupNickViewWithType:(NSString *)type {
    if ([type isEqualToString:@"昵称"]) {
        if (kNotNil(self.nick)) {
            self.nickTextfield.text = self.nick;
        }else {
            self.nickTextfield.placeholder = @"请输入昵称";
        }
    }else if ([type isEqualToString:@"群昵称"]) {
        if (kNotNil(self.groupNickName)) {
            self.nickTextfield.text = self.groupNickName;
        }else {
            self.nickTextfield.placeholder = @"请输入群昵称";
        }
    }else {
        if (kNotNil(self.groupMeNickName)) {
            self.nickTextfield.text = self.groupMeNickName;
        }else {
            self.nickTextfield.placeholder = @"请输入您的群昵称";
        }
    }
    [self.nickTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}

- (void)clearClick {
    
    self.textView.text = @"";
    self.textView.placeholder = kNotNil(self.nick) ? self.nick:@"请输入昵称";
}

- (SZTextView *)textView {
    
    if(!_textView) {
        _textView = [SZTextView new];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = RGB(66, 66, 66);
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UITextField *)nickTextfield {
    
    if(!_nickTextfield) {
        _nickTextfield =[[UITextField alloc] init];
        _nickTextfield.borderStyle = UITextBorderStyleNone;
        _nickTextfield.backgroundColor = [UIColor whiteColor];
        _nickTextfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        _nickTextfield.leftViewMode = UITextFieldViewModeAlways;
        _nickTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_nickTextfield];
    }
    return _nickTextfield;
}

- (NSString *)typeWithString:(UpdateType )type string:(NSString *)string {
    
    switch (type) {
        case UpdateTypeSign: {
            self.sign = string;
            maxWords = 50;
            [self setupSignViewWithString:@"2"];

            return @"个性签名";
        }
            break;
        case UpdateTypeNick: {
            self.nick = string;
            [self setupNickViewWithType:@"昵称"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification" object:self.nickTextfield];
            return @"昵称";
        }
            break;
        case UpdateTypeGroupNickName: {
            self.groupNickName = string;
            [self setupNickViewWithType:@"群昵称"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification" object:self.nickTextfield];
            return @"群名称";
        }
            break;
        case UpdateTypeGroupAnnounct: {
            self.groupAnnounct = string;
            maxWords = 100;
            [self setupSignViewWithString:@"1"];
            return @"群公告";
        }
            break;
        case UpdateTypeMeGroupNickName: {
            self.groupMeNickName = string;
            [self setupNickViewWithType:@"我的群昵称"];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification" object:self.nickTextfield];
            return @"我的群昵称";
        }
            break;
            
        default:
            return @"error";
            break;
    }
}

- (NSMutableDictionary *)params {
    
    if(!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length < (maxWords + 1)) {
        self.leftWord.text = [NSString stringWithFormat:@"%li/%ld",textView.text.length,maxWords];
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
                self.sign = [toBeString substringToIndex:maxWords];

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
                self.sign = [toBeString substringToIndex:maxWords];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxWords)];
                textView.text = [toBeString substringWithRange:rangeRange];
                self.sign = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

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
#pragma mark - Emoji键盘
- (void)createEmojiView {
    
    _emojiKeyboard = [HCEmojiKeyboard sharedKeyboard];
    _emojiKeyboard.showAddBtn = NO;
    [_emojiKeyboard addBtnClicked:^{
        NSLog(@"clicked add btn");
    }];
    [_emojiKeyboard sendEmojis:^{
        //赋值
        [_textView resignFirstResponder];
        //        _showLab.text = _textWindow.text;
    }];
}
//改变键盘状态
- (void)clickedFaceBtn:(UIButton *)button{
    if (button.tag == 1){
        self.textView.inputView = nil;
        [button setBackgroundImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:keyboard] forState:UIControlStateNormal];
        [_emojiKeyboard setTextInput:self.textView];
    }
    [self.textView reloadInputViews];
    button.tag = (button.tag+1)%2;
    [_textView becomeFirstResponder];
}
//  键盘弹出触发该方法
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"键盘弹出");
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat endHeight = frame.size.height;
    _intefaceView.frame = CGRectMake(0, kSCREEN_HEIGHT-endHeight-40, kSCREEN_WIDTH, 40);
    _intefaceView.hidden = NO;
    _keyBoardlsVisible =YES;
    [self.view setUserInteractionEnabled:YES];
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide:(NSNotification *)notification
{
    NSLog(@"键盘隐藏");
    _keyBoardlsVisible =NO;
    _intefaceView.hidden = YES;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.nickTextfield];

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
