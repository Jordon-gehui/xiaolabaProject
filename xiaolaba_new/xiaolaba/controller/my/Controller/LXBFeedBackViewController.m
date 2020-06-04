//
//  LXBFeedBackViewController.m
//  xiaolaba
//
//  Created by lin on 2017/8/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "LXBFeedBackViewController.h"
#import "SZTextView.h"

#import "HCEmojiKeyboard.h"
static NSString *emoji = @"Resources.bundle/emoji";
static NSString *keyboard = @"Resources.bundle/keyboard";

@interface LXBFeedBackViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *adviceButton;
@property (weak, nonatomic) IBOutlet UIButton *crashButton;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIView *feedBackContentView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextfield;
@property (nonatomic, strong) SZTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (nonatomic, strong) UIButton *genreButton;
@property (nonatomic, assign) BOOL isText;

//键盘
@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;
@property(nonatomic,assign) BOOL keyBoardlsVisible;
@property(nonatomic,retain)UIView *intefaceView;

@end

@implementation LXBFeedBackViewController
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (iPhoneX) {
        self.top.constant = 107;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户反馈";
    self.naviBar.slTitleLabel.text = @"用户反馈";
    [self setup];
    
    [self createEmojiView];
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
    [self.view addSubview:_intefaceView];
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

- (void)setup {

    self.adviceButton.layer.masksToBounds = YES;
    self.adviceButton.layer.cornerRadius = 5;
    self.crashButton.layer.masksToBounds = YES;
    self.crashButton.layer.cornerRadius = 5;
    self.moveButton.layer.masksToBounds = YES;
    self.moveButton.layer.cornerRadius = 5;
    [self updateButton:@[self.adviceButton,self.crashButton] choosed:self.moveButton];
    self.genreButton = self.moveButton;
    
    _textView = [[SZTextView alloc] init];
    [self.feedBackContentView addSubview:_textView];
    _textView.placeholder = @"请描述具体操作步骤及问题，我们将为你不断改进";
    _textView.font = [UIFont systemFontOfSize:15];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)rightClick {
    
    // base-data/feed/addfeed 意见反馈
    if(kNotNil(self.textView.text)) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.textView.text forKey:@"description"];
        [params setObject:self.genreButton.titleLabel.text forKey:@"genre"];
        NSString *type = [UIDeviceHardware platformString];
        if(kNotNil(type)) {
            [params setObject:type forKey:@"origin"];
        }
        else {
            [params setObject:@"iOS" forKey:@"origin"];
        }
        if(kNotNil(self.contactTextfield.text)) {
            [params setObject:self.contactTextfield.text forKey:@"contactWay"];
        }
        kWeakSelf(self);
        [weakSelf showHudWithText:nil];
        [[NetWorking network] POST:@"base-data/feed/addfeed" params:params cache:NO success:^(id result) {
            [weakSelf hideHud];
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *description) {
            [weakSelf hideHud];
            [MBProgressHUD showError:@"提交失败"];
        }];
    }
    else {
//        [self showMsg:@"请填写反馈内容" bottom:YES];
        [MBProgressHUD showError:@"请填写反馈内容"];
    }
}

- (IBAction)feedBackTypeClick:(UIButton *)sender {
    
    self.genreButton = sender;
    NSMutableArray *array = [NSMutableArray array];
    if([sender isEqual:self.adviceButton]) {
        [array addObject:self.crashButton];
        [array addObject:self.moveButton];
    }
    else if ([sender isEqual:self.crashButton]) {
        [array addObject:self.adviceButton];
        [array addObject:self.moveButton];
    }
    else {
        [array addObject:self.adviceButton];
        [array addObject:self.crashButton];
    }
    [self updateButton:array choosed:sender];
}

- (void)updateButton:(NSArray <UIButton *>*)others choosed:(UIButton *)button {
    
    [others enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.layer.borderColor = [UIColor colorWithHexString:@"#f7f8fa"].CGColor;
        obj.layer.borderWidth = 1;
        obj.backgroundColor = [UIColor colorWithHexString:@"#f7f8fa"];
        [obj setTitleColor:[UIColor colorWithHexString:@"#5c5f66"] forState:0];
    }];
    button.layer.borderColor = [UIColor lightColor].CGColor;
    button.layer.borderWidth = 0.7;
    button.backgroundColor = [UIColor colorWithR:255 g:222 b:2 a:0.1];
    [button setTitleColor:[UIColor shadeEndColor] forState:0];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[UITextField class]]) {
        _isText = NO;
    }
    return YES;
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
    }
    else{
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
    if (_isText == NO) {
        
    }else {
        CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat endHeight = frame.size.height;
        _intefaceView.frame = CGRectMake(0, kSCREEN_HEIGHT-endHeight-40, kSCREEN_WIDTH, 40);
        _intefaceView.hidden = NO;
        _keyBoardlsVisible =YES;
        [self.view setUserInteractionEnabled:YES];
    }
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
