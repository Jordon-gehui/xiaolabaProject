//
//  ImageReviewViewController.m
//  ImageReview
//
//  Created by gyf on 16/5/3.
//  Copyright © 2016年 owen. All rights reserved.
//

#import "ImageReviewViewController.h"
#import "UIImageCollectionViewCell.h"
#import "XLBShowImgView.h"
#import "XLBAlertController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface ImageReviewViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,ImageCellClickDelegate>
{
    UIButton *_closeBtn;
    UIButton *_deleBtn;
    NSInteger deleIndex;
}
@property (nonatomic, strong) UICollectionView *collectionContentView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end
@implementation ImageReviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (_isDelect == YES && _setImage == YES && [self.currentIndex isEqualToString:@"0"]) {
//        _deleBtn.hidden = YES;
////        _closeBtn.hidden = YES;
//    }else {
////        _closeBtn.hidden = !self.setImage;
//    }
    _deleBtn.hidden = !self.isDelect;

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.currentIndex);
    [self buildCollectionView];

//    _closeBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
//    _closeBtn.frame = CGRectMake(0, 30, 100, 44);
//    [_closeBtn setTitle:@"设置头像" forState:(UIControlStateNormal)];
//    [_closeBtn addTarget:self action:@selector(closeViewAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    _deleBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    _deleBtn.frame = CGRectMake(kSCREEN_WIDTH - 60, 30, 44, 44);
    [_deleBtn setTitle:@"删除" forState:(UIControlStateNormal)];
    [_deleBtn setTitleColor:[UIColor shadeStartColor] forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(deleBtnImageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_deleBtn];
    
    [self.view addSubview:_closeBtn];
    [self.collectionContentView reloadData];
}

- (void)buildCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.collectionContentView.delegate = self;
    self.collectionContentView.dataSource = self;
    self.collectionContentView.showsHorizontalScrollIndicator = NO;
    [self.collectionContentView registerClass:[UIImageCollectionViewCell class] forCellWithReuseIdentifier:@"imagecell"];
    self.collectionContentView.pagingEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCo:)];
    [self.collectionContentView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.collectionContentView];
    
}

- (void)tapCo:(UIGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    }];
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.img = self.imageArray[indexPath.row];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    deleIndex = indexPath.item;
//    self.pageControl.currentPage = indexPath.item;
//    if (_getUser == YES) {
//        _deleBtn.hidden = NO;
//        _closeBtn.hidden = NO;
//        if (indexPath.item == 0) {
//            _deleBtn.hidden = YES;
//            _closeBtn.hidden = YES;
//        }
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/kSCREEN_WIDTH;
    NSLog(@"%li",index);
    deleIndex = index;
    self.pageControl.currentPage = index;
//    if (_getUser == YES) {
//        _deleBtn.hidden = NO;
//        _closeBtn.hidden = NO;
//        if (index == 0) {
//            _deleBtn.hidden = YES;
//            _closeBtn.hidden = YES;
//        }
//    }
}

- (void)ImageCellDidClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    }];
}
//- (void)deleBtnImageClick:(UIButton *)sender {
//    
//    [self.imagesArray removeObjectAtIndex:deleIndex];
//    [self.collectionContentView reloadData];
//}

// 删除头像
- (void)deleBtnImageClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(delectPictureWithIndex:)]) {
        [self.delegate delectPictureWithIndex:deleIndex];
        [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
        }];
    }
}

- (void)saveImgWithImg:(UIImage *)img {
    UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"确定"] title:@"是否保存到手机相册？" message:nil cancel:YES cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        if (index == 0) {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            [MBProgressHUD showError:@"已保存到本地相册"];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
//设置头像
- (void)closeViewAction {
    if ([self.delegate respondsToSelector:@selector(addUserHeaderImageWihtIndex:)]) {
        [self.delegate addUserHeaderImageWihtIndex:deleIndex];
        [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
            
        }];
    }
}

- (void)setCurrentIndex:(NSString *)currentIndex {
    deleIndex = [currentIndex integerValue];
    _currentIndex = currentIndex;
    self.collectionContentView.contentOffset = CGPointMake(kSCREEN_WIDTH * deleIndex, 0);
}


//设置数据源
- (void)setImageArray:(NSArray *)imageArray {
    self.pageControl.numberOfPages = imageArray.count;
    _imageArray = imageArray;
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.width = self.view.width - 36;
        _pageControl.height = 10;
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];// 设置非选中页的圆点颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor]; // 设置选中页的圆点颜色
        _pageControl.center = CGPointMake(self.view.width / 2, self.view.height - 18);
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_pageControl];
        [self.view insertSubview:_pageControl aboveSubview:self.view];
    }
    return _pageControl;
}
@end
