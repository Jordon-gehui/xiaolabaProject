//
//  ShareView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView
@synthesize shareWB,shareWXpeo,shareWXpyq,shareWBLa,shareWXpeoLa,shareWXpyqLa,closeBu;
- (instancetype)init{
    

    self = [super initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 200, kSCREEN_WIDTH, 200)];
    if (self) {
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, self.width, self.height);
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];

        
        shareWXpeo = [UIButton new];
        shareWXpeo.frame = CGRectMake(0 , 0, 60, 60);
        shareWXpeo.center = CGPointMake(view.width/4, view.height/3);
        [shareWXpeo setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        
        [shareWXpeo addTarget:self action:@selector(shareClickBu:) forControlEvents:UIControlEventTouchUpInside];
        shareWXpeo.tag = 20;
        [self addSubview:shareWXpeo];
        
        
        
        
        //线条
        shareWXpeoLa = [UILabel new];
        shareWXpeoLa.frame = CGRectMake(shareWXpeo.left, shareWXpeo.bottom + 10, shareWXpeo.width , 20);
        shareWXpeoLa.text = @"微信好友";
        shareWXpeoLa.textAlignment = 1;

        shareWXpeoLa.font = [UIFont systemFontOfSize:12];
        [self addSubview:shareWXpeoLa];

        
        
        shareWXpyq = [UIButton new];
        shareWXpyq.frame = CGRectMake(0 , 0, 60, 60);
        shareWXpyq.center = CGPointMake(view.width/2, view.height/3);
        [shareWXpyq setBackgroundImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
        
        [shareWXpyq addTarget:self action:@selector(shareClickBu:) forControlEvents:UIControlEventTouchUpInside];
        shareWXpyq.tag = 21;
        [self addSubview:shareWXpyq];
        
        //线条
        shareWXpyqLa = [UILabel new];
        shareWXpyqLa.frame = CGRectMake(shareWXpyq.left, shareWXpyq.bottom + 10, shareWXpyq.width, 20);
        shareWXpyqLa.text = @"朋友圈";
        shareWXpyqLa.font = [UIFont systemFontOfSize:12];

        shareWXpyqLa.textAlignment = 1;
        [self addSubview:shareWXpyqLa];
        
        
        shareWB = [UIButton new];
        shareWB.frame = CGRectMake(0 , 0, 60, 60);
        shareWB.center = CGPointMake(view.width/4 * 3, view.height/3);
        [shareWB setBackgroundImage:[UIImage imageNamed:@"xinlang"] forState:UIControlStateNormal];
        
        [shareWB addTarget:self action:@selector(shareClickBu:) forControlEvents:UIControlEventTouchUpInside];
        shareWB.tag = 22;
        [self addSubview:shareWB];
        
        //线条
        shareWBLa = [UILabel new];
        shareWBLa.frame = CGRectMake(shareWB.left, shareWB.bottom + 10, shareWB.width, 20);
        shareWBLa.text = @"新浪微博";
        shareWBLa.textAlignment = 1;

        shareWBLa.font = [UIFont systemFontOfSize:12];

        [self addSubview:shareWBLa];
        
                //线条
        UILabel *Line = [UILabel new];
        Line.frame = CGRectMake(0, shareWBLa.bottom + 10, self.width, 0.2);
        Line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:Line];
        

        
        closeBu = [UIButton new];
        closeBu.frame = CGRectMake(self.width/2 - 25 , view.bottom - 50, 50, 50);
        closeBu.center = CGPointMake(view.width/2, view.height/6*5);
        [closeBu setTitle:@"取消" forState:UIControlStateNormal];
        [closeBu setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [closeBu addTarget:self action:@selector(shareClickBu:) forControlEvents:UIControlEventTouchUpInside];
        closeBu.tag = 23;
        [self addSubview:closeBu];

        
    }
    return self;
}

- (void)show{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor textBlackColor];
    self.bgView.alpha = 0.4;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.bgView addGestureRecognizer:tap];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self];
    
}

- (void)tap:(UITapGestureRecognizer *)tap{
    
    [self close];
}


- (void)shareClickBu:(UIButton *)bu{


    switch (bu.tag) {
        case 20:
            [self.addDelegate shareWXpro:self];
            
            break;
        case 21:
            [self.addDelegate shareWXpyq:self];
            
            break;
        case 22:
            [self.addDelegate shareWB:self];
            
            break;
        case 23:
            
            [self close];
            break;
            
        default:
            break;
    }
    
    [self close];
}

- (void)close{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self removeFromSuperview];
    }];
}


@end
