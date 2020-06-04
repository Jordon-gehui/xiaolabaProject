//
//  LittleHornViewController.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TableViewTag) {
    FaceWallTableTag = 1000,
    FaceScrollDefault,
    FaceCollectionVTag,
};

typedef NS_ENUM(NSUInteger, HeaderButtonTag) {
    RecommendBtnTag = 100,
    InformationBtnTag,
    VoiceActorBtnTag,
    DynamicBtnTag,
    FaceWallBtnTag,
    RankingBtnTag,
};

#import "LittleHornViewController.h"
#import "SLCycleScrollView.h"
#import "XLBIdentityViewController.h"
#import "BaseWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "XLBLocation.h"
#import "XLBCompleteViewController.h"
#import "XLBIdentSuccessViewController.h"
#import "XLBRDViewController.h"
#import "MomentsCell.h"
#import "LittleHeadView.h"
#import "LittleDetailViewController.h"
#import "LittleHeadModel.h"
#import "ScroHeadView.h"
#import "ScroHeadModel.h"
#import "XLBAlertController.h"
#import "LoginView.h"
#import "XLBLoginViewController.h"

#import "XLBFaceView.h"
#import "XLBFaceWallView.h"
#import "XLBVoiceActorView.h"
#import "VoiceCallEndView.h"
#import "XLBRecommendViewController.h"
#import "XLBInformationViewController.h"
#import "VoiceActorOwnerViewController.h"
#import "VoiceActorViewController.h"
#import "XLBDynamicViewController.h"
#import "XLBFriendDynamicVC.h"
#import "XLBFollowDynamicViewController.h"
#import "XLBFaceViewController.h"
#import "XLBRankingListViewController.h"
#import "MainHeaderView.h"
#import "XLBMessageSheetView.h"
#import "XLBMainDynamicViewController.h"
#import "ScanViewController.h"

#import "JXCategoryView.h"
#import "JXCategoryTitleVerticalZoomView.h"
#import "JXCategoryFactory.h"

@interface LittleHornViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, UIGestureRecognizerDelegate,XLBMessageSheetViewDelegate>

{
    UIImageView *navBarHairlineImageView;
    NSArray *headerTitleArr;
}


@property (nonatomic, strong)NSArray *blackList;

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIScrollView *bgScrollV;

@property (nonatomic, strong) XLBRecommendViewController *recommendVC;
@property (nonatomic, strong) XLBInformationViewController *informationVC;
@property (nonatomic, strong) VoiceActorViewController *voiceActorVC;
@property (nonatomic, strong) XLBDynamicViewController *dynamicVC;
@property (nonatomic, strong) XLBFriendDynamicVC *friendDynamicVC;
@property (nonatomic, strong) XLBFollowDynamicViewController *followDynamicVC;
@property (nonatomic, strong) XLBFaceViewController *faceWallVC;
@property (nonatomic, strong) XLBRankingListViewController *rankingListVC;

@property (nonatomic, strong) UIButton *recommendBtn;
@property (nonatomic, strong) UIButton *informationBtn;
@property (nonatomic, strong) UIButton *voiceActorBtn;
@property (nonatomic, strong) UIButton *dynamicBtn;
@property (nonatomic, strong) UIButton *faceWallBtn;
@property (nonatomic, strong) UIButton *rankingBtn;
@property (nonatomic, strong) UILabel *lineLabel;


@property (nonatomic, strong) MainHeaderView *headerView;
@property (nonatomic, strong) XLBMessageSheetView *alertSheetView;



@property (nonatomic, strong) JXCategoryTitleVerticalZoomView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, assign) CGFloat minCategoryViewHeight;
@property (nonatomic, assign) CGFloat maxCategoryViewHeight;
@property (nonatomic, strong) id interactivePopGestureRecognizerDelegate;
@property (nonatomic, strong) UIButton *rightBtn;


@end



@implementation LittleHornViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        _blackList=[[XLBCache cache]cache:@"BlackList"];
    }else{
        _blackList=@[];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    CGFloat topStatusBarHeight = 20;
    
    if (iPhoneX) {
        self.minCategoryViewHeight = 64;
        self.maxCategoryViewHeight = 80;
    }else {
        self.minCategoryViewHeight = 44;
        self.maxCategoryViewHeight = 80;
    }
    self.categoryView = [[JXCategoryTitleVerticalZoomView alloc] init];
    self.categoryView.frame = CGRectMake(0, topStatusBarHeight, self.view.bounds.size.width, self.maxCategoryViewHeight);
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titleSelectedColor = [UIColor buttonTitleColor];
    self.categoryView.titles = @[@"推荐", @"好友",@"关注"];
    self.categoryView.delegate = self;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    self.categoryView.titleColorGradientEnabled = NO;
    self.categoryView.contentEdgeInsetLeft = 30;
    self.categoryView.cellSpacing = 30;
    self.categoryView.maxVerticalCellSpacing = 30;
    self.categoryView.minVerticalCellSpacing = 20;
    self.categoryView.maxVerticalFontScale = 2;
    self.categoryView.minVerticalFontScale = 1.3;
    self.categoryView.maxVerticalContentEdgeInsetLeft = 30;
    self.categoryView.minVerticalContentEdgeInsetLeft = 15;
    [self.view addSubview:self.categoryView];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 8;
    lineView.indicatorLineViewColor = [UIColor buttonTitleColor];
    lineView.indicatorLineWidth = 8;
    lineView.indicatorLineViewHeight = 4;
    lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
    self.categoryView.indicators = @[lineView];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.categoryView.bounds.size.height - 1, self.categoryView.bounds.size.width, 1)];
    separatorLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    separatorLine.backgroundColor = [UIColor viewBackColor];
    [self.categoryView addSubview:separatorLine];
    
    self.rightBtn = [UIButton new];

    [self.rightBtn setImage:[UIImage imageNamed:@"icon_fx_fb"] forState:UIControlStateNormal];
    self.rightBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
        make.width.height.mas_equalTo(22);
    }];

    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    self.listContainerView.frame = CGRectMake(0, topStatusBarHeight + self.maxCategoryViewHeight, self.view.bounds.size.width, self.view.bounds.size.height - topStatusBarHeight - self.maxCategoryViewHeight);
    self.listContainerView.backgroundColor = [UIColor whiteColor];
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

- (void)listScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        //用户交互引起的滚动才处理
        return;
    }
    if (self.categoryView.isHorizontalZoomTransitionAnimating) {
        //当前cell正在进行动画过渡
        return;
    }
    //用于垂直方向滚动时，视图的frame调整
    if ((self.categoryView.bounds.size.height < self.maxCategoryViewHeight) && scrollView.contentOffset.y < 0) {
        //当前属于缩小状态且往下滑动
        //列表往下移动、categoryView高度增加
        CGRect categoryViewFrame = self.categoryView.frame;
        categoryViewFrame.size.height -= scrollView.contentOffset.y;
        categoryViewFrame.size.height = MIN(self.maxCategoryViewHeight, categoryViewFrame.size.height);
        self.categoryView.frame = categoryViewFrame;
        
        self.listContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.categoryView.frame));
        
        if (self.categoryView.bounds.size.height == self.maxCategoryViewHeight) {
            //从小缩放到最大，将其他列表的contentOffset重置
            self.categoryView.titleLabelVerticalOffset = 10;
            [_alertSheetView updateTopImgFrame:self.categoryView.bottom - 10];
            for (id<JXCategoryListContentViewDelegate>list in self.listContainerView.validListDict.allValues) {
                if ([list listScrollView] != scrollView) {
                    [[list listScrollView] setContentOffset:CGPointZero animated:NO];
                }
            }
        }
        scrollView.contentOffset = CGPointZero;
    }else if (((self.categoryView.bounds.size.height < self.maxCategoryViewHeight) && scrollView.contentOffset.y >= 0 && self.categoryView.bounds.size.height > self.minCategoryViewHeight) ||
              (self.categoryView.bounds.size.height >= self.maxCategoryViewHeight && scrollView.contentOffset.y >= 0)) {
        //当前属于缩小状态且往上滑动且categoryView的高度大于minCategoryViewHeight 或者 当前最大高度状态且往上滑动
        //列表往上移动、categoryView高度减小
        CGRect categoryViewFrame = self.categoryView.frame;
        categoryViewFrame.size.height -= scrollView.contentOffset.y;
        categoryViewFrame.size.height = MAX(self.minCategoryViewHeight, categoryViewFrame.size.height);
        self.categoryView.frame = categoryViewFrame;
        self.listContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.categoryView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.categoryView.frame));
        if (iPhoneX) {
            self.categoryView.titleLabelVerticalOffset = 1;
        }else {
            self.categoryView.titleLabelVerticalOffset = -2;
        }
        [_alertSheetView updateTopImgFrame:self.categoryView.bottom];
        scrollView.contentOffset = CGPointZero;
    }
    //必须调用
    CGFloat percent = (self.categoryView.bounds.size.height - self.minCategoryViewHeight)/(self.maxCategoryViewHeight - self.minCategoryViewHeight);
    [self.categoryView listDidScrollWithVerticalHeightPercent:percent];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    NSLog(@"偏移缩放%f",ratio);
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    if (index == 0) {
        XLBMainDynamicViewController *dynamicVC = [[XLBMainDynamicViewController alloc] init];
        dynamicVC.didScrollCallback = ^(UIScrollView *scrollView) {
            [weakSelf listScrollViewDidScroll:scrollView];
        };
        [self addChildViewController:dynamicVC];
        return dynamicVC;
    }else if (index == 1) {
        XLBFriendDynamicVC *friendVC = [[XLBFriendDynamicVC alloc] init];
        friendVC.didScrollCallback = ^(UIScrollView *scrollView) {
            [weakSelf listScrollViewDidScroll:scrollView];
        };
        [self addChildViewController:friendVC];
        return friendVC;
    }else {
        XLBFollowDynamicViewController *followDynamicVC = [[XLBFollowDynamicViewController alloc] init];
        followDynamicVC.didScrollCallback = ^(UIScrollView *scrollView) {
            [weakSelf listScrollViewDidScroll:scrollView];
        };
        [self addChildViewController:followDynamicVC];
        return followDynamicVC;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}


- (void)rightBtnClick:(UIButton *)sender {
    NSLog(@"发布动态");
    [MobClick event:@"ActiveServerPage"];
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
    
    [self rightAlertSheetViewWithAlpha:1];
}

- (void)didSeletedMessageSheetViewBtnClick:(UIButton *)sender {
    [self rightAlertSheetViewWithAlpha:0];
    switch (sender.tag) {
        case AlertSheetPublishDynamicBtnTag: {
            NSInteger  num = [[XLBUser user].userModel.status integerValue];
            if (num < 10 ) {
                
                [MBProgressHUD showError:@"请完善信息"];
                XLBCompleteViewController * com = [XLBCompleteViewController new];
                com.rightItemTag = @"1";
                com.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:com animated:YES];
                
            }else{
                [[CSRouter share]push:@"XLBRDViewController" Params:nil hideBar:YES];
            }
        }
            break;
        case MessageSheetScanBtnTag: {
            ScanViewController *scanVC = [[ScanViewController alloc] init];
            scanVC.type = @"2";
            scanVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scanVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)rightAlertSheetViewWithAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.2 animations:^{
        self.alertSheetView.alpha = alpha;
    }];
}

- (XLBMessageSheetView *)alertSheetView {
    if (!_alertSheetView) {
        _alertSheetView = [[XLBMessageSheetView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:AlertSheetTypeMain];
        _alertSheetView.alpha = 0;
        _alertSheetView.delegate = self;
        [self.view.window addSubview:_alertSheetView];
    }
    return _alertSheetView;
}

#pragma mark -- 2.0

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
