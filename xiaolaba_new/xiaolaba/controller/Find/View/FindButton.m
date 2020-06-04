//
//  FindButton.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "FindButton.h"

@interface FindButton()
{
    UIView *whiteView;
    UITapGestureRecognizer *tap;
}
@end
@implementation FindButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButton:frame.size.width/2.0];
    }
    return self;
}

-(void) setImage:(UIImage *)img {
    self.imageView.image = img;
}

- (void)addBtnTarget:(id)target action:(SEL)action {
    [tap addTarget:target action:action];
}

- (void)initButton:(CGFloat)radiusWidth {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.cornerRadius = radiusWidth*kiphone6_ScreenHeight;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = NO;
    
//    whiteView = [UIView new];
//    whiteView.backgroundColor = [UIColor whiteColor];

//    __block CGFloat whiteWidth = radiusWidth==40 ?radiusWidth-8:radiusWidth-6;
//    whiteView.layer.masksToBounds = YES;
//    whiteView.layer.cornerRadius = radiusWidth*kiphone6_ScreenHeight;

//    [self addSubview:whiteView];
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    tap = [[UITapGestureRecognizer alloc]init];
    [self addGestureRecognizer:tap];
    kWeakSelf(self);
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(kScreenHeight * 0.6+iphone6_ScreenHeight *30+15));
//        make.width.height.mas_equalTo(2*width*iphone6_ScreenHeight);
//        make.centerX.mas_equalTo(weakSelf);
//    }];
//    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(weakSelf);
////        make.width.height.mas_equalTo(weakSelf);
//        make.top.left.right.bottom.mas_equalTo(weakSelf);
//    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
    }];
 
}
-(void)initView {
    
}

@end
