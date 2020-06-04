//
//  BaseScrollPage.m
//  nxh
//
//  Created by smilelu on 15/9/10.
//  Copyright (c) 2015年 speed. All rights reserved.
//

#import "BaseScrollPage.h"

#import <MJRefresh/MJRefresh.h>
#import "XLBRefreshGifHeader.h"

@interface BaseScrollPage ()

@end

@implementation BaseScrollPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//ios9以下scrollView及其子类不预留顶部空白
    
    _autoRefresh = YES;

    if(self.navigationController && !self.translucentNav) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
    }else {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    _scrollView.tag = 999;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _scrollView.height+1);
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view insertSubview:_scrollView aboveSubview:self.naviBar];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_autoRefresh) {
        if (self.scrollView.mj_header){
            [self startRefresh];
        }
        _autoRefresh = NO;
    }
}

- (void)setAllowRefresh:(BOOL)allowRefresh {
    if(allowRefresh) {
        __weak BaseScrollPage *weakSelf = self;
        self.scrollView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refresh];
        }];
    }
}

- (void)setAllowLoadMore:(BOOL)allowLoadMore {
    if (allowLoadMore) {
        __weak BaseScrollPage *weakSelf = self;
        self.scrollView.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
    }
}

-(void)refresh {
    
}

- (void)startRefresh {
    [self.scrollView.mj_header beginRefreshing];
}

-(void)endRefresh {
    [self.scrollView.mj_header endRefreshing];
}

-(void)loadMore {
    
}

-(void)endLoadMore {
    [self.scrollView.mj_footer endRefreshing];
}

- (void)tapRefreshView:(UITapGestureRecognizer *)sender {
//    [super tapRefreshView:sender];
    [self refresh];
}

-(void)dealloc {
    self.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
