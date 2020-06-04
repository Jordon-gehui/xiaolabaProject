//
//  XLBGuidanceViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/23.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBGuidanceViewController.h"

@interface XLBGuidanceViewController ()<UIScrollViewDelegate>

{
    NSArray *imgAry;
    NSInteger index;
}
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) UIButton *enterBtn;
@property (nonatomic, retain) UIButton *endBtn;

@end

@implementation XLBGuidanceViewController
- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];
    
    imgAry = @[@"1_2", @"2_2", @"3_2", @"4_2", @"5_2", @"6_2",];
    index = 0;
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*imgAry.count, kSCREEN_HEIGHT);
    self.scrollView.scrollEnabled = NO;
    for (int i = 0; i < imgAry.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        if (iPhoneX) {
            UIImage *img = [UIImage imageNamed:imgAry[i]];
            if (i == 0 || i == 3) {
                img = [img stretchableImageWithLeftCapWidth:0 topCapHeight:floor(img.size.height-20)];
            }else {
                img = [img stretchableImageWithLeftCapWidth:0 topCapHeight:floorf(img.size.height)];
            }
            iv.image = img;

        }else {
            iv.image = [UIImage imageNamed:imgAry[i]];
            iv.contentMode = UIViewContentModeScaleAspectFill;
        }
        [self.scrollView addSubview:iv];
    }
    
//    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 100)/2, kSCREEN_HEIGHT - 70, 100, 10)];
//    self.pageControl.numberOfPages = imgAry.count;
//    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    self.pageControl.currentPageIndicatorTintColor = [UIColor viewBackColor];
//    [self.view addSubview:self.pageControl];
    
    [self showEnterBtn];
    
}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat offset_x = scrollView.contentOffset.x;
//    
//    NSInteger pageIndex = offset_x/kSCREEN_WIDTH;
//    self.pageControl.currentPage = pageIndex;
//    if (pageIndex == imgAry.count - 1) {
//        [self showEnterBtn];
//    }else {
//        [self removeEnterBtn];
//    }
//    
//    if (offset_x < 0) {
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    }else if (offset_x > (imgAry.count-1)*kSCREEN_WIDTH) {
//        [scrollView setContentOffset:CGPointMake((imgAry.count-1)*kSCREEN_WIDTH, 0) animated:NO];
//    }
//}

- (void)showEnterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _enterBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);

//        if (iPhoneX) {
//        }else {
//            _enterBtn.frame = CGRectMake((kSCREEN_WIDTH-140), kSCREEN_HEIGHT-200, 100, 80);
//        }
//        _enterBtn.layer.cornerRadius = 4.0;
//        _enterBtn.layer.borderWidth = 1.0;
//        _enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _enterBtn.clipsToBounds = YES;
//        
//        [_enterBtn setTitle:@"下一步" forState:UIControlStateNormal];
//        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_enterBtn addTarget:self action:@selector(enterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.enterBtn];
    
    
}

- (void)addEndBtn {
    if (!_endBtn) {
        _endBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _endBtn.frame = CGRectMake((kSCREEN_WIDTH-100)/3, 60*kiphone6_ScreenHeight, 200, 100*kiphone6_ScreenHeight);
        _endBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);

        [_endBtn addTarget:self action:@selector(endBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.endBtn];
}
- (void)enterBtnClick:(UIButton *)sender {
    
    index++;
    [self.scrollView setContentOffset:CGPointMake(index*kSCREEN_WIDTH, 0) animated:NO];
//    self.pageControl.currentPage = index;
//    if (index == 4) {
//        _enterBtn.frame = CGRectMake((kSCREEN_WIDTH-140), 60*kiphone6_ScreenHeight, 100, 80);
//    }
    if (index == 5) {
        self.enterBtn.hidden = YES;
        [self addEndBtn];
    }

}

- (void)endBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeEnterBtn {
    [self.enterBtn removeFromSuperview];
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
