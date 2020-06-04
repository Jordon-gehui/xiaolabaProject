//
//  LittleHeadView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleHeadView.h"
@interface LittleHeadView()
@end

@implementation LittleHeadView

@synthesize leftButton,rightButton,imageView,scroHeadView,leftImageView,leftImageLabel,rightImageView,rightImageLabel,scre,scroImageView,scroImageLabel;
#define BannerHeight (kSCREEN_WIDTH * 2 / 5)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _csView = [[SLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, BannerHeight)];
        [self addSubview:_csView];

      
        //加载图片
        leftButton = [UIButton new];
        leftButton.frame = CGRectMake(15, _csView.bottom+15, (kSCREEN_WIDTH-50)/2, (kSCREEN_WIDTH-50)/4);
//        NSLog(@"---------%lf--%lf",(kSCREEN_WIDTH-50)/2,kSCREEN_HEIGHT/8);
        [leftButton setBackgroundImage:[UIImage imageNamed:@"矩形2拷贝2"] forState:UIControlStateNormal];
        [leftButton.layer setMasksToBounds:YES];
        [leftButton.layer setCornerRadius:10];
        [self addSubview:leftButton];
        
        
        leftImageView = [UIImageView new];
        leftImageView.frame = CGRectMake(((kSCREEN_WIDTH-50)/2-125)/2.0, 0, 25, 25);
        leftImageView.centerY = leftButton.height/2;
        leftImageView.image = [UIImage imageNamed:@"扫码icon"];
        [leftButton addSubview:leftImageView];
        
        
        leftImageLabel= [UILabel new];
        leftImageLabel.frame  = CGRectMake(leftImageView.right, 0, 100, 20);
        leftImageLabel.text = @"扫码找车主";
        leftImageLabel.textColor = [UIColor whiteColor];
        leftImageLabel.font = [UIFont systemFontOfSize:16];
        leftImageLabel.centerY = leftButton.height/2;
        leftImageLabel.textAlignment = 1;
        [leftButton addSubview:leftImageLabel];
        
        rightButton = [UIButton new];
        [rightButton.layer setMasksToBounds:YES];
        [rightButton.layer setCornerRadius:10];
        rightButton.frame = CGRectMake(15 +(kSCREEN_WIDTH-50)/2+20, _csView.bottom+ 15, (kSCREEN_WIDTH-50)/2, (kSCREEN_WIDTH-50)/4);
        [rightButton setBackgroundImage:[UIImage imageNamed:@"矩形2拷贝3-1"] forState:UIControlStateNormal];
        [self addSubview:rightButton];
        
        
        rightImageView = [UIImageView new];
        rightImageView.frame = CGRectMake(((kSCREEN_WIDTH-50)/2-125)/2.0, 0, 25, 25);
        rightImageView.centerY = rightButton.height/2;
        rightImageView.image = [UIImage imageNamed:@"绑定"];
        [rightButton addSubview:rightImageView];
        
        
        rightImageLabel= [UILabel new];
        rightImageLabel.frame  = CGRectMake(rightImageView.right, 0, 100, 20);
        rightImageLabel.text = @"绑定挪车贴";
        rightImageLabel.textAlignment = 1;

        rightImageLabel.textColor = [UIColor whiteColor];
        rightImageLabel.font = [UIFont systemFontOfSize:16];
        rightImageLabel.centerY = rightButton.height/2;
        [rightButton addSubview:rightImageLabel];
        
        
    }
    return self;
}


@end
