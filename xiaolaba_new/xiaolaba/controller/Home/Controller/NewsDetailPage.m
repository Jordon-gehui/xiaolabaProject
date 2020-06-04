//
//  NewsDetailPage.m
//  xiaolaba
//
//  Created by cs on 2018/4/20.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "NewsDetailPage.h"
#import <WebKit/WebKit.h>
#import "XLBCompleteViewController.h"
#import "LittleHornTableViewModel.h"
#import "HCEmojiKeyboard.h"
#import "LittleDetailModel.h"
#import "DetailTableViewCell.h"
#import "LittleDetailTwoViewController.h"
#import "LoginView.h"
#import "CMInputView.h"
#import "XLBLoginViewController.h"

@interface NewsDetailPage ()<WKNavigationDelegate,XLBShareViewDelegate,DetailTableViewCellDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSString *title;
    NSString *content;
    NSDictionary *dic;
    NSArray *imgsList;
    NSString *listCount;
    CGFloat kheight;
}
@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, retain) UILabel *titleL;
@property (nonatomic, retain) UILabel *datesourceL;
@property (nonatomic, retain) UILabel *timeL;
@property (nonatomic, retain) UIView *lineV;

@property (nonatomic, retain) WKWebView *contentWebView;
@property (nonatomic, retain) UIImageView *seeImg;
@property (nonatomic, retain) UILabel *seeLbl;
@property (nonatomic, retain) UITableView *tableView;

@property (strong,nonatomic) UIView * littView;

@property (retain,nonatomic) UIView *bottomView;
@property (retain,nonatomic) CMInputView *inputText;
//@property (retain,nonatomic) UITextField *inputField;
@property (retain,nonatomic) UIButton *sendBu;

@property (nonatomic,strong) LittleHornTableViewModel *detailModel;
@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic) NSInteger curr;
@property (nonatomic,strong)NSMutableArray *pinglunArr;
@property (nonatomic,strong)NSMutableArray *pinglunDeatilArr;
@property (retain,nonatomic)UILabel *countLable;

@property (strong,nonatomic) UILabel *nilLabel;

@end

static NSString *emoji = @"Resources.bundle/emoji";
static NSString *keyboard = @"Resources.bundle/keyboard";


static NSString *Identifier = @"detail";
static NSString *NoDetailIdentifier = @"nodetail";

NSString *shareUrl = @"http://www.xiaolaba.net.cn/wechat/news/";

#define maxWords 100
@implementation NewsDetailPage

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _contentWebView.navigationDelegate = self;
    [self creatInputView];
    if (iPhoneX) {
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20)-20 , kSCREEN_HEIGHT, self.inputText.height+20+20);
        
    }else{
        self.bottomView.frame = CGRectMake(0, self.view.size.height - (self.inputText.height+20) , kSCREEN_HEIGHT, self.inputText.height+20);
    }
    [self.inputText resignFirstResponder];
    [self.littView setHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _contentWebView.navigationDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热点资讯";
    self.naviBar.slTitleLabel.text = @"热点资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    if (!kNotNil(self.webId)) {
        [MBProgressHUD showError:@"找不到资讯了"];
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.8];
        return;
    }
    [[NetWorking network] POST:kZXDetails params:@{@"id":self.webId} cache:NO success:^(id result) {
        NSLog(@"%@",result);
        title = [result objectForKey:@"title"];
        content = [result objectForKey:@"content"];
        imgsList = [result objectForKey:@"imgs"];
        dic = result;
        [self initViews];
        [self refreshViews];
    } failure:^(NSString *description) {
        if (description.length<50) {
            [MBProgressHUD showError:@"找不到资讯了"];
        }else{
            [MBProgressHUD showError:@"网络服务器连接错误"];
        }
        [self performSelector:@selector(pop) withObject:nil afterDelay:0.8];
        return;
    }];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.scrollView addSubview:self.progressView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
-(void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"icon_fx"];
    [rightItem setImage:image forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    [self.naviBar setRightItem:rightItem];
    
    if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        [rightItem setHidden:YES];
    }else {
        [rightItem setHidden:NO];
    }
}

- (void)rightClick {
    [self shareNews];
}

- (void) initViews {
    _bgView = [UIView new];
    [self.scrollView addSubview:_bgView];
    
    _titleL = [UILabel new];
    _titleL.font = [UIFont systemFontOfSize:23];
    _titleL.textColor = [UIColor commonTextColor];
    _titleL.numberOfLines = 0;
    [_bgView addSubview:_titleL];
    
    _datesourceL = [UILabel new];
    _datesourceL.font = [UIFont systemFontOfSize:16];
    _datesourceL.textColor = [UIColor commonTextColor];
    [_bgView addSubview:_datesourceL];
    
    _timeL = [UILabel new];
    _timeL.font = [UIFont systemFontOfSize:14.0];
    _timeL.textColor = [UIColor annotationTextColor];
    [_bgView addSubview:_timeL];
    
    
    _datesourceL.textAlignment = NSTextAlignmentLeft;
    _timeL.textAlignment = NSTextAlignmentLeft;
    
    _lineV = [UIView new];
    _lineV.backgroundColor = [UIColor lineColor];
    [_bgView addSubview:_lineV];
    
    //网页自适应大小
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:@"" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    wkWebConfig.preferences = preferences;
    
    _contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    _contentWebView.scrollView.scrollEnabled = NO;
    [_contentWebView setBackgroundColor:[UIColor clearColor]];
    [_contentWebView setOpaque:NO];
    [_bgView addSubview:_contentWebView];
    _contentWebView.navigationDelegate = self;
    _contentWebView.UIDelegate = self;
    [_contentWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_contentWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    
    _seeImg = [UIImageView new];
    _seeImg.image = [UIImage imageNamed:@"icon_kan"];
    _seeImg.hidden = YES;
    [_bgView addSubview:_seeImg];
    
    _seeLbl = [UILabel new];
    _seeLbl.font = [UIFont systemFontOfSize:13];
    _seeLbl.textColor = [UIColor textRightColor];
    _seeLbl.hidden = YES;
    [_bgView addSubview:_seeLbl];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.hidden = YES;
    [_bgView addSubview:_tableView];
    [_tableView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:Identifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NoDetailIdentifier];
    
    //加载更多刷新
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _curr ++;
        [self getDataFromServer:_curr];
        
    }];
    
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _curr = 1;
        [self.pinglunArr removeAllObjects];
        [self.pinglunDeatilArr removeAllObjects];
        [self getDataFromServer:_curr];
        
    }];
    [self setLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _contentWebView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.
        
        UIScrollView *scrollView = _contentWebView.scrollView;
        [_contentWebView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(scrollView.contentSize.height);
        }];
        NSLog(@"New contentSize: %f x %f", scrollView.contentSize.width, scrollView.contentSize.height);
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = _contentWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}

- (void) setLayout {
    kWeakSelf(self)
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.top.left.mas_equalTo(weakSelf.scrollView);
        make.bottom.mas_equalTo(weakSelf.scrollView);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bgView).with.offset(15);
        make.left.mas_equalTo(weakSelf.bgView).with.offset(15);
        make.centerX.mas_equalTo(weakSelf.bgView);
    }];
    
    [_datesourceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleL.mas_bottom).with.offset(15);
        make.left.mas_equalTo(15);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.datesourceL);
        make.left.mas_equalTo(weakSelf.datesourceL.mas_right).with.offset(5);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).with.offset(-15);
    }];
    
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.datesourceL.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1);
        make.left.mas_equalTo(weakSelf.bgView).with.offset(15);
        make.right.mas_equalTo(weakSelf.bgView).with.offset(-15);
    }];
    
    [_contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.lineV.mas_bottom).with.offset(5);
        make.left.mas_equalTo(weakSelf.bgView).with.offset(15);
        make.right.mas_equalTo(weakSelf.bgView).with.offset(-15);
        make.height.mas_equalTo(@400);
    }];
    [_seeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_contentWebView.mas_bottom);
    }];
    [_seeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(_seeLbl.mas_left).with.offset(-10);
        make.centerY.mas_equalTo(_seeLbl);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seeImg.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(_bgView);
        make.height.mas_equalTo(HEIGHT - 50 -self.naviBar.bottom);
        make.bottom.mas_equalTo(weakSelf.bgView).with.offset(-50);
    }];
}

- (void) refreshViews {
    _titleL.text = title;
    
    _datesourceL.text = [dic objectForKey:@"fromName"];
    NSString *timeStr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"pushTime"]];
    if (kNotNil(timeStr)) {
        _timeL.text = timeStr;
    }
    NSString *seeStr = [NSString stringWithFormat:@"浏览量(%@)",[dic objectForKey:@"views"]];

    _seeLbl.text =  seeStr;
    NSString *contentStr;
    if ([content hasPrefix:@"<"]) {
        contentStr = content;
    } else {
        contentStr = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        contentStr = [NSString stringWithFormat:@"<html> <body bgcolor=\"#f5f5f5\"><p><font>%@</font></p></body></html>", contentStr];
    }
    
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"<img onclick=\"previewImg()\"" withString:@"<img "];
    
    [_contentWebView loadHTMLString:contentStr baseURL:nil];
    //资讯查看
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",kZXkan,self.webId];
    [[NetWorking network] POST:urlStr params:nil cache:NO success:^(id result) {
    } failure:^(NSString *description) {
    }];
}

#pragma -mark --WKNavigationDelegate
-(void)webViewDidFinishLoad:(UIWebView*) webView {
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"]floatValue];
    CGRect frame = webView.frame;
    frame.size.height = documentHeight;
    webView.frame = frame;
}
- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}
- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
    //禁止复制粘贴
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    //禁止长按
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    //图片
    NSString *js = @"function addImgClickEvent() { var imgs = document.getElementsByTagName('img'); for (var i = 0; i < imgs.length; ++i) { var img = imgs[i]; img.onclick = function () { window.location.href = 'xsq-image:' + this.src; }; } }";
    // 注入JS代码
    [webView evaluateJavaScript:js completionHandler:nil];
    // 执行所注入的JS代码
    [webView evaluateJavaScript:@"addImgClickEvent()" completionHandler:nil];

    if (iPhoneX) {
        [self.scrollView setContentOffset:CGPointMake(0, -20) animated:NO];
    }
    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];
    [_tableView setHidden:NO];
    [_seeImg setHidden:NO];
    [_seeLbl setHidden:NO];
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.scrollView bringSubviewToFront:self.progressView];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"++++++++%s",__FUNCTION__);
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"xsq-image"]) {
        
        // 获取原始图片的完整URL
        
        NSString *src = [URL.absoluteString stringByReplacingOccurrencesOfString:@"xsq-image:" withString:@""];
        
        if (src.length > 0) {
         
            NSLog(@"所点击的HTML中的img标签的图片的URL为：%@", src);
            NSArray *array = @[src];
            ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
            vc.imageArray = [array mutableCopy];
            vc.currentIndex = @"0";
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:^{
            }];
        }
    }
  
    if ([scheme isEqualToString:@"haleyaction"]) {

//        [self handleCustomAction:URL];

        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
        if (iPhoneX) {
            self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20)-20 , kSCREEN_WIDTH, self.inputText.height+20+20);
        }else{
            self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20) , kSCREEN_WIDTH, self.inputText.height+20);
        }
    }];
    
    self.inputText.maxNumberOfLines = 4;
    self.inputText.delegate = self;
    [self.bottomView addSubview:self.inputText];
    [self.inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceBtn.mas_right).with.offset(10);
        if (iPhoneX) {
            make.bottom.mas_equalTo(self.bottomView.mas_bottom).with.offset(-20);
        }else{
            make.centerY.mas_equalTo(self.bottomView);
        }
        make.width.mas_equalTo(kSCREEN_WIDTH - 130);
        make.height.mas_greaterThanOrEqualTo(33);
        make.top.mas_equalTo(10);
    }];
    
    UIButton *sendBu = [UIButton new];
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
//    [self creatWindow];
    [self.littView setHidden:NO];
    //iPhone键盘高度216，iPad的为352
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (iPhoneX) {
        self.bottomView.frame = CGRectMake(0, self.view.frame.size.height - (self.inputText.height+20)-20 , kSCREEN_WIDTH, self.inputText.height+20+20);
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
        [MBProgressHUD showError:@"请先登录再评论"];
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [MBProgressHUD showError:@"请先登录再评论"];
//        [LoginView addLoginView];
//        return;
//    }
    
    if (!kNotNil(self.inputText.text)) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        return ;
    }
    NSDictionary *dict = @{@"momentId":self.webId,@"discussion":self.inputText.text};
    //
    bu.enabled = NO;
    [[NetWorking network] POST:kNewsDiscu params:dict cache:NO success:^(id result) {
        self.inputText.text = @"";
        self.sendBu.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
        [self.sendBu setTitleColor:[UIColor whiteColor] forState:0];
        [self.sendBu setEnabled:NO];
        self.detailModel.discussCount =  [NSString stringWithFormat:@"%li",[self.detailModel.discussCount integerValue]+1];
        //获取数据
        [self.littView setHidden:YES];

        _curr = 1;
        [self getDataFromServer:_curr];
        
        bu.enabled = YES;
    } failure:^(NSString *description) {
        bu.enabled = YES;
        [MBProgressHUD showError:@"评论失败"];
    }];
}
- (void)getDataFromServer:(NSInteger)current{
     NSDictionary *dict = @{@"page":@{@"curr":@(current),@"size":@"10"},@"momentId":self.webId ,@"orderCond":@"date"};
    if ([XLBUser user].isLogin &&kNotNil([XLBUser user].token)) {
        NSString *userId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
        dict = @{@"createUser":userId,@"page":@{@"curr":@(current),@"size":@"10"},@"momentId":self.webId ,@"orderCond":@"date"};
    }
    
    [[NetWorking network] POST:kNewsDisList params:dict cache:NO success:^(id result) {
        
        NSLog(@"-------------------评论--%@",result);
        NSArray *twoArr = result[@"list"];
        listCount = [NSString stringWithFormat:@"%@",result[@"total"]];
        for (NSDictionary * dicLittle in twoArr ) {

            LittleDetailModel *littleDetailModel = [LittleDetailModel mj_objectWithKeyValues:dicLittle];
            [self.pinglunArr addObject:littleDetailModel];
            //            NSString *string = [NSString]
            NSDictionary * discussion =   [NetWorking dictionaryWithJsonString:dicLittle[@"discussion"]];
            DetailModel *detailLittleModel = [DetailModel mj_objectWithKeyValues:discussion];
            if (detailLittleModel) {
                [self.pinglunDeatilArr addObject:detailLittleModel];
            }

        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        if (current ==1&&self.pinglunArr.count!=0) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            });
        }
        if (self.pinglunArr.count ==0) {
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_seeImg.mas_bottom).with.offset(10);
                make.left.right.mas_equalTo(_bgView);
                make.height.mas_equalTo(300);
                make.bottom.mas_equalTo(self.bgView).with.offset(-50);
            }];
        }else{
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_seeImg.mas_bottom).with.offset(10);
                make.left.right.mas_equalTo(_bgView);
                make.height.mas_equalTo(HEIGHT - 50 -self.naviBar.bottom);
                make.bottom.mas_equalTo(self.bgView).with.offset(-50);
            }];
        }
        if (twoArr.count <10) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];

        }
    } failure:^(NSString *description) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.inputText resignFirstResponder];
    [self.littView setHidden:YES];
    
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.pinglunArr.count==0) {
        return 1;
    }
    return self.pinglunArr.count;
}
#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pinglunArr.count ==0) {
        return 200;
    }else{
        DetailTableViewCell *cell = (DetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return [cell cellHeight];
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 10)];
    lineV.backgroundColor = [UIColor lineColor];
    [headerView addSubview:lineV];
    UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kSCREEN_WIDTH, 1)];
    lineV2.backgroundColor = [UIColor lineColor];
    [headerView addSubview:lineV2];
    
    UIImageView *countImageView= [UIImageView new];
    countImageView.frame =CGRectMake(15, 22.5, 25, 25);
    countImageView.image = [UIImage imageNamed:@"icon_pl"];
    [headerView addSubview:countImageView];
    
    UILabel *countLable = [UILabel new];
    countLable.frame =CGRectMake(55, 22.5, kSCREEN_WIDTH-70, 25);
    countLable.textColor = [UIColor colorWithR:153 g:153 b:153];
    countLable.font = [UIFont systemFontOfSize:14];;
    if (self.pinglunArr.count==0) {
        countLable.text = [NSString stringWithFormat:@"(0)"];
    }else{
        countLable.text = [NSString stringWithFormat:@"(%@)",listCount];
    }
    countLable.textAlignment = 0;
    [headerView addSubview:countLable];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pinglunArr.count >0) {
        DetailTableViewCell *detailCell = [_tableView dequeueReusableCellWithIdentifier:Identifier];
        detailCell.DetailDelegate = self;
        [detailCell.detailtwoArr removeAllObjects];
        [detailCell.discusstwoArr removeAllObjects];
        detailCell.twoModel = self.pinglunArr[indexPath.row];
        return detailCell;
        
    }else {
        UITableViewCell *nodetailCell = [_tableView dequeueReusableCellWithIdentifier:NoDetailIdentifier];
        [nodetailCell.contentView addSubview:self.nilLabel];
        nodetailCell.backgroundColor = [UIColor clearColor];
        return nodetailCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.pinglunArr.count >0) {
        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
            [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
            return;
        }
//        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//            [LoginView addLoginView];
//            return;
//        }
        LittleDetailModel *model = self.pinglunArr[indexPath.row];
        DetailModel *detailModel = [DetailModel mj_objectWithKeyValues:model.discussion];
        
        LittleDetailTwoViewController *two = [LittleDetailTwoViewController new];
        two.hidesBottomBarWhenPushed = YES;
        two.moreStr = @"1";
        two.dissID = model.ID;
        two.momentID = model.momentId;
        two.detailLittleModel = detailModel;
        [self.navigationController pushViewController:two animated:YES];
        
    }
}
#pragma maek - 查看更多
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
    
    NSDictionary *dict = @{@"momentId":self.webId,@"discussId":discussId};

    [[NetWorking network] POST:kPubErjiZanlish params:dict cache:NO success:^(id result) {
        //
        [clickDetailZan.detailZanBu setBackgroundImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        for (LittleDetailModel *model in self.pinglunArr) {
            if ([model.ID isEqualToString:discussId]) {
                model.likes = [NSString stringWithFormat:@"%li",[model.likes integerValue]+1];
                model.liked = @"1";
                clickDetailZan.detailZanLabel.text = [NSString stringWithFormat:@"%@",model.likes];
            }

        }
        [self.tableView reloadData];
    } failure:^(NSString *description) {

    }];
}

- (void)clickDetailDel:(DetailTableViewCell*)clickDetailDel withID:(NSString *)delID{
    //    //如果按钮是加在cell上的contentView上
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    NSIndexPath *myIndex=[self.tableView indexPathForCell:(DetailTableViewCell*)[[clickDetailDel.detailReportBu superview]superview]];
    NSLog(@"myIndex.section==%ld",myIndex.section);
    NSLog(@"myIndex.row==%ld",myIndex.row);
    //
    NSDictionary *dict = @{@"id":delID};
    
    [[NetWorking network] POST:kPubErDellish params:dict cache:NO success:^(id result) {
        //21414628718297088
        
        NSLog(@"评论删除 == %@",result);
        
        if (self.pinglunArr.count > 0) {
            [self.pinglunArr removeObjectAtIndex:[myIndex row]];
            [MBProgressHUD showError:@"删除成功"];
            [self.tableView reloadData];
            listCount = [NSString stringWithFormat:@"%li",[listCount integerValue]-1];
            self.countLable.text = [NSString stringWithFormat:@"(%@)",listCount];
        }
    } failure:^(NSString *description) {
        
        
    }];
}
#pragma mark - share
- (void)shareNews {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
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
    shareModel.urlString = [NSString stringWithFormat:@"%@wechat/news/%@",kDomainUrl,self.webId];
    shareModel.title = @"小喇叭-热点资讯！！";
    shareModel.describe = title;
    
    UIImage *imag;
    if (kNotNil(imgsList) && imgsList.count > 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:[imgsList firstObject] Withtype:IMGNormal]]];
        imag = [UIImage imageWithData:data];
        imag = [JXutils compressImageQuality:imag toByte:30];
    }else {
        imag = [UIImage imageNamed:@"abc"];
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
}

-(NSMutableArray *)pinglunArr {
    if (_pinglunArr==nil) {
        _pinglunArr = [NSMutableArray array];
    }
    return _pinglunArr;
}
-(NSMutableArray *)pinglunDeatilArr {
    if (_pinglunDeatilArr==nil) {
        _pinglunDeatilArr = [NSMutableArray array];
    }
    return _pinglunDeatilArr;
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
- (void)dealloc {
    [_contentWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [_contentWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
