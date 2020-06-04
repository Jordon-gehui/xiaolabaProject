//
//  UIImageCollectionViewCell.m
//  ImageReview
//
//  Created by gyf on 16/5/3.
//  Copyright © 2016年 owen. All rights reserved.
//

#import "UIImageCollectionViewCell.h"
#define MAXZOOMSCALE 3
#define MINZOOMSCALE 1
@interface UIImageCollectionViewCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;


@end
@implementation UIImageCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.minimumZoomScale = MINZOOMSCALE;
        self.scrollView.maximumZoomScale = MAXZOOMSCALE;
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self.scrollView addGestureRecognizer:tap];
        [self.contentView addSubview:self.scrollView];
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClickAction:)];
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        //优先触发双击手势
        [tap requireGestureRecognizerToFail:doubleTap];
        
        [self.scrollView addSubview:self.imageView];
        
        UILongPressGestureRecognizer *tapLong = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapLong:)];
        [self.imageView addGestureRecognizer:tapLong];
        
    }
    return self;
}

#pragma mark-保存图片

-(void)tapLong:(UILongPressGestureRecognizer *)tap{
    
    //直接return掉，不在开始的状态里面添加任何操作，则长按手势就会被少调用一次了
    if (tap.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveImgWithImg:)]) {
        [self.delegate saveImgWithImg:self.imageView.image];
    }
}


- (void)tapAction {
    
    [self.delegate ImageCellDidClick];
    
}

- (void)doubleClickAction:(UIGestureRecognizer *)gesture
{
    CGFloat k = MAXZOOMSCALE;
    UIScrollView *scrollView = (UIScrollView *)gesture.view.superview;
    CGFloat width = gesture.view.frame.size.width;
    CGFloat height = gesture.view.frame.size.height;
    CGPoint point = [gesture locationInView:gesture.view];
    //获取双击坐标，分4种情况计算scrollview的contentoffset
    if (point.x<=width/2 && point.y<=height/2) {
        point = CGPointMake(point.x*k, point.y*k);
        point = CGPointMake(point.x-kSCREEN_WIDTH/2>0?point.x-kSCREEN_WIDTH/2:0,point.y-kSCREEN_HEIGHT/2>0?point.y-kSCREEN_HEIGHT/2:0);
    }else if (point.x<=width/2 && point.y>height/2)
    {
        point = CGPointMake(point.x*k, (height-point.y)*k);
        point = CGPointMake(point.x-kSCREEN_WIDTH/2>0?point.x-kSCREEN_WIDTH/2:0,point.y>kSCREEN_HEIGHT/2?height*k-point.y-kSCREEN_HEIGHT/2:height*k>kSCREEN_HEIGHT?height*k-kSCREEN_HEIGHT:0);
    }else if (point.x>width/2 && point.y<=height/2)
    {
        point = CGPointMake((width-point.x)*k, point.y*k);
        point = CGPointMake(point.x>kSCREEN_WIDTH/2?width*k-point.x-kSCREEN_WIDTH/2:width*k>kSCREEN_WIDTH?width*k-kSCREEN_WIDTH:0, point.y-kSCREEN_HEIGHT/2>0?point.y-kSCREEN_HEIGHT/2:0);
    }else
    {
        point = CGPointMake((width-point.x)*k, (height-point.y)*k);
        point = CGPointMake(point.x>kSCREEN_WIDTH/2?width*k-point.x-kSCREEN_WIDTH/2:width*k>kSCREEN_WIDTH?width*k-kSCREEN_WIDTH:0, point.y>kSCREEN_HEIGHT/2?height*k-point.y-kSCREEN_HEIGHT/2:height*k>kSCREEN_HEIGHT?height*k-kSCREEN_HEIGHT:0);
    }
    
    
    if (scrollView.zoomScale == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = k;
            scrollView.contentOffset = point;
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = 1;
        }];
    }
}

- (void)setImg:(id)img {
    if (kNotNil(img)) {
        self.scrollView.zoomScale = 1;
        UIImage *image;
        if ([img isKindOfClass:[NSDictionary class]]) {
            if ((kNotNil(img[@"picks"]) && [img[@"picks"] isKindOfClass:[NSString class]])) {
                NSString *url = [JXutils judgeImageheader:img[@"picks"] Withtype:IMGNormal];
                [self imageWithURl:url];
            }
            if((kNotNil(img[@"picks"]) && [img[@"picks"] isKindOfClass:[UIImage class]])) {
                image = img[@"picks"];
                [self imageSizeWithImg:image];
            }
        }else if ([img isKindOfClass:[UIImage class]]) {
            [self imageSizeWithImg:img];
        }else if ([img isKindOfClass:[NSString class]]) {
            NSString *url = [JXutils judgeImageheader:img Withtype:IMGNormal];
            [self imageWithURl:url];
        }
    }
    _img = img;
}

- (void)imageSizeWithImg:(UIImage *)image {
    self.imageView.image = image;
    CGFloat x = kSCREEN_HEIGHT/kSCREEN_WIDTH;
    CGFloat y = image.size.height/image.size.width;
    //x为屏幕尺寸，y为图片尺寸，通过两个尺寸的比较，重置imageview的frame
    if (y>x) {
        self.imageView.frame = CGRectMake(0, 0, kSCREEN_HEIGHT/y, kSCREEN_HEIGHT);
    }else if(y == x){
        self.imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }else {
        self.imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * y);
    }
    self.imageView.center = CGPointMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2);
    [self performSelector:@selector(imgClick) withObject:self afterDelay:1];
}
- (void)imgClick {
    [self.imageView setNeedsLayout];
}
- (void)imageWithURl:(NSString *)url {
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    CGSize imageSize = cachedImage.size;
    CGFloat width  = kSCREEN_WIDTH;
    if (imageSize.width<kSCREEN_WIDTH) {
        width = imageSize.width;
    }
    CGFloat height = (cachedImage.size.height *width)/ cachedImage.size.width;
    
    if (cachedImage) {
        [self.imageView setImage:cachedImage];
        self.imageView.frame = CGRectMake(0, 0, width, height);
    }else {
        [self downloadImage:url];
    }
    self.imageView.center = CGPointMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2);
    [self.imageView setNeedsLayout];
}
//- (void)setImage:(UIImage *)images
//{
//    //重置zoomscale为1
//    self.scrollView.zoomScale = 1;
////    if (kNotNil(images)) {
////        
////    }
////    UIImage *image = [UIImage imageNamed:imageName];
//    self.imageView.image = images;
//
//    CGFloat x = SCREEN_HEIGHT/SCREEN_WIDTH;
//    CGFloat y = images.size.height/images.size.width;
//    //x为屏幕尺寸，y为图片尺寸，通过两个尺寸的比较，重置imageview的frame
//    if (y>x) {
//        self.imageView.frame = CGRectMake(0, 0, SCREEN_HEIGHT/y, SCREEN_HEIGHT);
//    }else
//    {
//        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*y);
//    }
//    self.imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//}

- (void)downloadImage:(NSString *)imageURL{
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // do nothing
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImg:image];
        });
    }];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    scrollView.subviews[0].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                                scrollView.contentSize.height * 0.5 + offsetY);
}
@end
