//
//  FirstLaunchPage.h
//  xiaolaba
//
//  Created by cs on 17/9/22.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "FirstLaunchPage.h"
#import "AppDelegate.h"

@interface FirstLaunchPage ()<UIScrollViewDelegate> {
    NSArray *imgAry;
}

@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) UIButton *enterBtn;

@end

@implementation FirstLaunchPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.hidden = YES;
    imgAry = @[@"1", @"2", @"3",@"4",];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*imgAry.count, kSCREEN_HEIGHT);
    
    for (int i = 0; i < imgAry.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        iv.image = [UIImage imageNamed:imgAry[i]];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        [self.scrollView addSubview:iv];
    }

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 100)/2, kSCREEN_HEIGHT - 70, 100, 10)];
    self.pageControl.numberOfPages = imgAry.count;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor viewBackColor];
    [self.view addSubview:self.pageControl];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset_x = scrollView.contentOffset.x;
    
    NSInteger pageIndex = offset_x/kSCREEN_WIDTH;
    self.pageControl.currentPage = pageIndex;
    if (pageIndex == imgAry.count - 1) {
        [self showEnterBtn];
    }else {
        [self removeEnterBtn];
    }
    
    if (offset_x < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else if (offset_x > (imgAry.count-1)*kSCREEN_WIDTH) {
        [scrollView setContentOffset:CGPointMake((imgAry.count-1)*kSCREEN_WIDTH, 0) animated:NO];
    }
}

- (void)showEnterBtn {
    if (!_enterBtn) {
        _enterBtn = [[UIButton alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH-110)/2, kSCREEN_HEIGHT-120, 110, 40)];
        _enterBtn.layer.cornerRadius = 10.0;
        _enterBtn.layer.borderWidth = 1.0;
        _enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _enterBtn.clipsToBounds = YES;
        [_enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_enterBtn addTarget:self action:@selector(enterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.enterBtn];
}

- (void)removeEnterBtn {
    [self.enterBtn removeFromSuperview];
}

- (void)enterBtnClick:(UIButton *)sender {
    [XLBUser setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [(AppDelegate *)[UIApplication sharedApplication].delegate createTabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
