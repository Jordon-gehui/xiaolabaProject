//
//  BaseWebViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/8.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<WKNavigationDelegate>

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    self.naviBar.slTitleLabel.text = _titleStr;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
//    [self.view insertSubview:_webView belowSubview:self.navigationController.view];
    [self.view addSubview:_webView];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
    [_webView loadRequest:request];

    
    NSLog(@"%@", _urlStr);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _webView.navigationDelegate = nil;
    [_webView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - WKWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%@",webView.title);
//    self.bql_title = webView.title;
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (_titleStr == nil) {
            self.title  = _webView.title;
            self.naviBar.slTitleLabel.text = _webView.title;
        }
    }
}

- (void) webviewDidFinishNavigation {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
