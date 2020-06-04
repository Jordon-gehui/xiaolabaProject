//
//  LionChooseView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LionChooseView.h"

@implementation LionChooseView
@synthesize allBu,fujinProBu;
- (instancetype)init{
    
    
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    if (self) {
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, self.width, self.height);
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        
        allBu = [UIButton new];
        allBu.frame = CGRectMake(0 , 10, 70, 20);
        [allBu setTitle:@"全部" forState:UIControlStateNormal];
        allBu.titleLabel.font = [UIFont systemFontOfSize:14];
        [allBu setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        
        [allBu addTarget:self action:@selector(shareClickBu:) forControlEvents:UIControlEventTouchUpInside];
        allBu.tag = 20;
        [view addSubview:allBu];
    
        
        
        fujinProBu = [UIButton new];
        fujinProBu.frame = CGRectMake(0 , allBu.bottom + 10, 70, 20);
        [fujinProBu setTitle:@"附近的人" forState:UIControlStateNormal];
        fujinProBu.titleLabel.font = [UIFont systemFontOfSize:14];

        [fujinProBu setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [fujinProBu addTarget:self action:@selector(shareClickBu:) forControlEvents:UIControlEventTouchUpInside];
        fujinProBu.tag = 21;
        [view addSubview:fujinProBu];
        
        
        
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
    
//    
}

- (void)tap:(UITapGestureRecognizer *)tap{
    
    [self close];
}


- (void)shareClickBu:(UIButton *)bu{
    
    
    switch (bu.tag) {
        case 20:
            [self.delegate allBu:self];
            
            break;
        case 21:
            [self.delegate fujinproBu:self];
            
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
        
        [self.bgTabView removeFromSuperview];
        self.bgTabView = nil;

        [self removeFromSuperview];
    }];
}

@end
