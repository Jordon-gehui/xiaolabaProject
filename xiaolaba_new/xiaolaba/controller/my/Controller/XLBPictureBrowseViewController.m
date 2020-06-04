//
//  XLBPictureBrowseViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/9.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBPictureBrowseViewController.h"

@interface XLBPictureBrowseViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *contentScroll;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *userPictureBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation XLBPictureBrowseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.deleteBtn.hidden = !self.isDelect;
    self.userPictureBtn.hidden = !self.setImage;

}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor lightGrayColor];
    self.naviBar.hidden = YES;
    self.contentScroll.delegate = self;
    [self setupSubView:self.imageArray];
    
    [self performSelector:@selector(performSelectorClick) withObject:nil afterDelay:0.2];
}

- (void)setupSubView:(NSArray *)items {
    
    self.pageControl.numberOfPages = items.count;
    // 设置滚动范围
    self.contentScroll.contentSize = CGSizeMake(kSCREEN_WIDTH * self.imageArray.count, kSCREEN_HEIGHT);
    // 填充图片
    if ((kNotNil(self.imageArray) && [self.imageArray[0] isKindOfClass:[NSDictionary class]])) {
        [self setPictureShowImageViewWithArrayContainIsDictionary];
    }
    else if ((kNotNil(self.imageArray) && [self.imageArray[0] isKindOfClass:[UIImage class]])){
        [self setPictureShowImageViewWithArrayContainIsImage];
        
    }
    else{
        [self setPictureShowImageViewWithArrayContainIsString];
    }


}

- (void)performSelectorClick {
    
    [self.contentScroll setContentOffset:CGPointMake(kSCREEN_WIDTH * _currentIndex, 0) animated:NO];

}

//加载字典中图片
- (void)setPictureShowImageViewWithArrayContainIsDictionary {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (kNotNil(obj) && [obj isKindOfClass:[NSDictionary class]]) {
            if (obj) {
                UIImageView *contentView = [[UIImageView alloc] init];
                contentView.tag = idx;
                [self.contentScroll addSubview:contentView];
                
                dispatch_group_async(group, queue, ^{
                    
                    UIImage *image;
                    if ((kNotNil(obj[@"picks"]) && [obj[@"picks"] isKindOfClass:[NSString class]])) {
                        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:obj[@"picks"] Withtype:IMGNormal]]]];
                    }
                    if ((kNotNil(obj[@"picks"]) && [obj[@"picks"] isKindOfClass:[UIImage class]])) {
                        image = obj[@"picks"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        contentView.image = image;
                        contentView.width = kSCREEN_WIDTH;
                        if (image.size.height / image.size.width > kSCREEN_HEIGHT / kSCREEN_WIDTH) {
                            contentView.height = floor(image.size.height / (image.size.width /kSCREEN_WIDTH));
                        } else {
                            CGFloat height = image.size.height / image.size.width * kSCREEN_WIDTH;
                            if (height < 1 || isnan(height)) height = kSCREEN_HEIGHT;
                            height = floor(height);
                            contentView.height = height;
                        }
                        if (contentView.height > kSCREEN_HEIGHT && contentView.height - kSCREEN_HEIGHT <= 1) {
                            contentView.height = kSCREEN_HEIGHT;
                        }
                        contentView.left = 0 + (self.contentScroll.width * idx);
                        contentView.top = (self.contentScroll.height - contentView.height) * 0.5;
                        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                        contentView.image = image;
                        NSLog(@"%f %f",contentView.height,contentView.width);

                    });
                });
            }
        }
        
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });

}
// 加载数组中网络图片
- (void)setPictureShowImageViewWithArrayContainIsString {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (kNotNil(obj) && [obj isKindOfClass:[NSString class]]) {
            NSLog(@"%@",obj);

            UIImageView *contentView = [[UIImageView alloc] init];
            contentView.tag = idx;
            [self.contentScroll addSubview:contentView];
            dispatch_group_async(group, queue, ^{
                UIImage *image;
                
                NSString *imageUrl;
                if ([obj hasPrefix:@"http://wx.qlogo.cn/"]) {
                    imageUrl = obj;
                }else {
                    imageUrl = [JXutils judgeImageheader:obj Withtype:IMGNormal];
                }
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    contentView.image = image;
                    contentView.width = kSCREEN_WIDTH;
                    if (image.size.height / image.size.width > kSCREEN_HEIGHT / kSCREEN_WIDTH) {
                        contentView.height = floor(image.size.height / (image.size.width /kSCREEN_WIDTH));
                    } else {
                        CGFloat height = image.size.height / image.size.width * kSCREEN_WIDTH;
                        if (height < 1 || isnan(height)) height = kSCREEN_HEIGHT;
                        height = floor(height);
                        contentView.height = height;
                    }
                    if (contentView.height > kSCREEN_HEIGHT && contentView.height - kSCREEN_HEIGHT <= 1) {
                        contentView.height = kSCREEN_HEIGHT;
                    }
                    contentView.left = 0 + (self.contentScroll.width * idx);
                    contentView.top = (self.contentScroll.height - contentView.height) * 0.5;
                    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    contentView.image = image;
                    NSLog(@"%f %f",contentView.height,contentView.width);

                });
            });
        }
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });
}

- (void)setPictureShowImageViewWithArrayContainIsImage {
    if (!self.imageArray) return;
    [self.imageArray enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        
        contentView.contentMode = UIViewContentModeScaleAspectFit;
        
        contentView.image = obj;
        
        [self.contentScroll addSubview:contentView];

        
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat floatPage = scrollView.contentOffset.x / kSCREEN_WIDTH;
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= self.imageArray.count ? (int)self.imageArray.count - 1 : intPage;

    self.pageControl.currentPage = intPage;
    self.currentIndex = intPage;
    
}

- (UIScrollView *)contentScroll {
    
    if(!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] init];
        _contentScroll.backgroundColor = [UIColor clearColor];
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.pagingEnabled = YES;
        _contentScroll.frame = self.view.bounds;
        _contentScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_contentScroll addGestureRecognizer:tap];
        [self.view addSubview:_contentScroll];
    }
    return _contentScroll;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if ([tap isKindOfClass:[UITapGestureRecognizer class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
        [self.contentScroll addSubview:_pageControl];
        [self.view insertSubview:_pageControl aboveSubview:self.contentScroll];
    }
    return _pageControl;
}
- (UIButton *)deleteBtn {
    
    if(!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:0];
        [_deleteBtn setTitle:@"删除" forState:0];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:0];
        _deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view insertSubview:_deleteBtn aboveSubview:self.contentScroll];
        
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(40);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
        }];
    }
    return _deleteBtn;
}
- (UIButton *)userPictureBtn {
    if(!_userPictureBtn) {
        _userPictureBtn = [UIButton buttonWithType:0];
        [_userPictureBtn setTitle:@"设为头像" forState:0];
        [_userPictureBtn setTitleColor:[UIColor whiteColor] forState:0];
        _userPictureBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view insertSubview:_userPictureBtn aboveSubview:self.contentScroll];
        
        [_userPictureBtn addTarget:self action:@selector(addUserPictureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
    }
    return _userPictureBtn;
}

- (void)deleteBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(delectPictureWithIndex:)]) {
        [self.delegate delectPictureWithIndex:self.currentIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addUserPictureBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addUserHeaderImageWihtIndex:)]) {
        [self.delegate addUserHeaderImageWihtIndex:self.currentIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
