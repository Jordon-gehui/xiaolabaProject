//
//  GroupHeadPortraitView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "GroupHeadPortraitView.h"

@interface GroupHeadPortraitView ()

@property (nonatomic, strong) UIView *imgBg;
@property (nonatomic, strong) UIImageView *oneImg;
@property (nonatomic, strong) UIImageView *twoImg;
@property (nonatomic, strong) UIImageView *threeImg;
@property (nonatomic, strong) UIImageView *fourImg;
@property (nonatomic, strong) UIImageView *fiveImg;
@property (nonatomic, strong) UIImageView *sixImg;
@property (nonatomic, strong) UIImageView *sevenImg;
@property (nonatomic, strong) UIImageView *eightImg;
@property (nonatomic, strong) UIImageView *nineImg;


@end

@implementation GroupHeadPortraitView
- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 300, 300);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        [self setSubViewsWithArray:array];
    }
    return self;
}

- (void)setSubViewsWithArray:(NSArray *)array {
    for (int i = 0; i < array.count; i++) {
        UIImageView *imgView = [UIImageView new];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[i] Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 5;
        [self addSubview:imgView];
        

        if (i == 0) {
            self.oneImg = imgView;
        }else if (i==1) {
            self.twoImg = imgView;
        }else if (i==2){
            self.threeImg = imgView;
        }else if (i==3){
            self.fourImg = imgView;
        }else if (i==4){
            self.fiveImg = imgView;
        }else if (i==5){
            self.sixImg = imgView;
        }else if (i==6){
            self.sevenImg = imgView;
        }else if (i==7){
            self.eightImg = imgView;
        }else {
            self.nineImg = imgView;
        }
    }
    
    if (array.count == 1) {
        self.oneImg.frame = CGRectMake(0, 0, 150, 150);
        self.oneImg.center = self.center;
    }else if (array.count == 2) {
        self.oneImg.frame = CGRectMake(0, 0, 150, 150);
        self.oneImg.centerY = self.centerY;
        self.twoImg.frame = CGRectMake(self.oneImg.right, 0, 150, 150);
        self.twoImg.centerY = self.centerY;
    }else if (array.count == 3) {
        self.oneImg.frame = CGRectMake(0, 0, 150, 150);
        self.oneImg.centerX = self.centerX;
        self.twoImg.frame = CGRectMake(0, self.oneImg.bottom, 150, 150);
        self.threeImg.frame = CGRectMake(self.twoImg.right, self.twoImg.y, 150, 150);
    }else if (array.count == 4) {
        self.oneImg.frame = CGRectMake(0, 0, 150, 150);
        self.twoImg.frame = CGRectMake(self.oneImg.right, self.oneImg.y, 150, 150);
        self.threeImg.frame = CGRectMake(0, self.oneImg.bottom, 150, 150);
        self.fourImg.frame = CGRectMake(self.threeImg.right, self.threeImg.y, 150, 150);
    }else if (array.count == 5) {
        self.oneImg.frame = CGRectMake(self.centerX - 100, self.centerY - 100, 100, 100);
        self.twoImg.frame = CGRectMake(self.oneImg.right, self.oneImg.y, 100, 100);
        self.threeImg.frame = CGRectMake(0, self.centerY, 100, 100);
        self.fourImg.frame = CGRectMake(self.threeImg.right, self.threeImg.y, 100, 100);
        self.fiveImg.frame = CGRectMake(self.fourImg.right, self.threeImg.y, 100, 100);
    }else if (array.count == 6) {
        self.oneImg.frame = CGRectMake(0, self.centerY - 100, 100, 100);
        self.twoImg.frame = CGRectMake(0, self.oneImg.y, 100, 100);
        self.twoImg.centerX = self.centerX;
        self.threeImg.frame = CGRectMake(self.twoImg.right, self.oneImg.y, 100, 100);
        self.fourImg.frame = CGRectMake(0, self.centerY, 100, 100);
        self.fiveImg.frame = CGRectMake(0, self.fourImg.y, 100, 100);
        self.fiveImg.centerX = self.centerX;
        self.sixImg.frame = CGRectMake(self.fiveImg.right, self.fourImg.y, 100, 100);
        
    }else if (array.count == 7) {
        self.oneImg.frame = CGRectMake(0, 0, 100, 100);
        self.oneImg.centerX = self.centerX;
        self.twoImg.frame = CGRectMake(0, 0, 100, 100);
        self.twoImg.centerY = self.centerY;
        self.threeImg.frame = CGRectMake(0, self.twoImg.y, 100, 100);
        self.threeImg.centerX = self.centerX;
        self.fourImg.frame = CGRectMake(self.threeImg.right, self.twoImg.y, 100, 100);
        
        self.fiveImg.frame = CGRectMake(0, self.threeImg.bottom, 100, 100);
        self.sixImg.frame = CGRectMake(0, self.fiveImg.y, 100, 100);
        self.sixImg.centerX = self.centerX;
        self.sevenImg.frame = CGRectMake(self.sixImg.right, self.fiveImg.y, 100, 100);
    }else if (array.count == 8) {
        self.oneImg.frame = CGRectMake(self.centerY - 100, 0, 100, 100);
        self.twoImg.frame = CGRectMake(self.oneImg.right, self.oneImg.y, 100, 100);
        self.threeImg.frame = CGRectMake(0, 0, 100, 100);
        self.threeImg.centerY = self.centerY;
        self.fourImg.frame = CGRectMake(0, 0, 100, 100);
        self.fourImg.center = self.center;
        self.fiveImg.frame = CGRectMake(self.fourImg.right, 0, 100, 100);
        self.fiveImg.centerY = self.centerY;
        
        self.sixImg.frame = CGRectMake(0, self.threeImg.bottom, 100, 100);
        self.sevenImg.frame = CGRectMake(self.sixImg.right, self.sixImg.y, 100, 100);
        self.eightImg.frame = CGRectMake(self.sevenImg.right, self.sixImg.y, 100, 100);
    }else {
        self.oneImg.frame = CGRectMake(0, 0, 100, 100);
        self.twoImg.frame = CGRectMake(0, self.oneImg.y, 100, 100);
        self.twoImg.centerX = self.centerX;
        self.threeImg.frame = CGRectMake(self.twoImg.right, self.oneImg.y, 100, 100);
        self.fourImg.frame = CGRectMake(0, 0, 100, 100);
        self.fourImg.centerY = self.centerY;
        self.fiveImg.frame = CGRectMake(0, 0, 100, 100);
        self.fiveImg.center = self.center;
        self.sixImg.frame = CGRectMake(self.fiveImg.right, self.fourImg.y, 100, 100);
        self.sevenImg.frame = CGRectMake(0, self.fourImg.bottom, 100, 100);
        self.eightImg.frame = CGRectMake(0, self.sevenImg.y, 100, 100);
        self.eightImg.centerX = self.centerX;
        self.nineImg.frame = CGRectMake(self.eightImg.right, self.sevenImg.y, 100, 100);
    }
}

- (UIImage*)imageWithUIView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}

@end
