//
//  SLCycleScrollView.h
//  Micfunding
//
//  Created by cs on 2017/5/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLCycleScrollViewDelegate;
@protocol SLCycleScrollViewDatasource;

@interface SLCycleScrollView : UIView<UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,weak,setter = setDataource:) id<SLCycleScrollViewDatasource> datasource;
@property (nonatomic, weak,setter = setDelegate:) id<SLCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

- (void)startTimer;
- (void)stopTimer;

@end

@protocol SLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(SLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol SLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
