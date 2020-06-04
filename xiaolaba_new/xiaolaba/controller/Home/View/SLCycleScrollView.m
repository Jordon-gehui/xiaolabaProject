//
//  SLCycleScrollView.m
//  Micfunding
//
//  Created by cs on 2017/5/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SLCycleScrollView.h"

@implementation SLCycleScrollView {
    NSTimer *_timer;
}

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        
        rect.origin.x = (self.width - 60)/2;
        rect.size.width = 60;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
    }
    return self;
}

- (void)setDataource:(id<SLCycleScrollViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData {
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        _scrollView.scrollEnabled = NO;
        return;
    }
//    if(_totalPages ==1){
//        [_pageControl setHidden:YES];
//    }else{
//        [_pageControl setHidden:NO];
//
//    }
    _scrollView.scrollEnabled = YES;
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData {
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else {
        return;
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        if (_curViews.count>i) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
        
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    [self startTimer];
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:_curPage-1];
    NSInteger last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    if (self.datasource != nil) {
        [_curViews addObject:[self.datasource pageAtIndex:pre]];
        [_curViews addObject:[self.datasource pageAtIndex:page]];
        [_curViews addObject:[self.datasource pageAtIndex:last]];
    }
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    if (_timer == nil) {
        [self startTimer];
    }
}

- (void)startTimer{
    if(!_timer || ![_timer isValid]){
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)nextPage:(NSTimer *)sender {
    if (_curViews.count > 1) {
        [_scrollView scrollRectToVisible:CGRectMake(self.width*2, 0, self.width, self.height) animated:YES];
    }
}

- (void)dealloc {
    //    [self stopTimer];
    self.delegate = nil;
    self.datasource = nil;
}

@end
