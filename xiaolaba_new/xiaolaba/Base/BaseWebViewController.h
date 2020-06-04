//
//  BaseWebViewController.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/8.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, retain) NSString *urlStr;

@property (nonatomic, retain) NSString *titleStr;

- (void) webviewDidFinishNavigation;
@end
