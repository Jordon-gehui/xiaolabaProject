//
//  XLBShowImgView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/1.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBShowImgView.h"

@interface XLBShowImgView ()
@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation XLBShowImgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [self setSubView];
    }
    return self;
}

- (void)setSubView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.imageView];
}

- (void)setImg:(UIImage *)img {
    
//    CGFloat x = kSCREEN_HEIGHT/kSCREEN_WIDTH;
//    CGFloat y = img.size.height/img.size.width;
//    //x为屏幕尺寸，y为图片尺寸，通过两个尺寸的比较，重置imageview的frame
//    if (y>x) {
//        self.imageView.frame = CGRectMake(0, 0, kSCREEN_HEIGHT/y, kSCREEN_HEIGHT);
//    }else
//    {
//        self.imageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH*y);
//    }
//    self.imageView.center = CGPointMake(kSCREEN_WIDTH/2, kSCREEN_HEIGHT/2);
    self.imageView.image = img;
    _img = img;
}



@end
