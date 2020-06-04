//
//  BaseScrollPage.h
//  nxh
//
//  Created by smilelu on 15/9/10.
//  Copyright (c) 2015年 speed. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseScrollPage : BaseViewController

@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL allowRefresh;
@property (nonatomic, assign) BOOL allowLoadMore;

@property (nonatomic, assign) BOOL autoRefresh;

- (void)refresh;
- (void)loadMore;

- (void)endRefresh;
- (void)endLoadMore;

@end
