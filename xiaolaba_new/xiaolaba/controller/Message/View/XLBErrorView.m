//
//  XLBErrorView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBErrorView.h"

@interface XLBErrorView ()

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation XLBErrorView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _imgV = [[UIImageView alloc]init];
        [self addSubview:_imgV];
        
        _remindLabel = [[UILabel alloc]init];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.numberOfLines = 0;
        _remindLabel.font = [UIFont systemFontOfSize:18];
        _remindLabel.textColor = [UIColor tipTextColor];
        [self addSubview:_remindLabel];
    }
    return self;
}

- (void)setSubViewsWithImgName:(NSString *)imgName remind:(NSString *)reminds {
    
    NSLog(@"%@",reminds);
    if (kNotNil(reminds) && [reminds isEqualToString:@"网络错误，点击重试"]) {
        _imgV.frame = CGRectMake((self.frame.size.width-80*kiphone6_ScreenWidth)/2.0, (self.frame.size.height-80*kiphone6_ScreenWidth)/2.0-30, 80*kiphone6_ScreenWidth, 80);
        _imgV.image = [UIImage imageNamed:@"pic_wsj"];
        _remindLabel.frame = CGRectMake(0, _imgV.bottom+15, self.frame.size.width, 20);
        _remindLabel.text = reminds;
    }else {
        if (!kNotNil(reminds)) {
            _imgV.frame = CGRectMake((self.frame.size.width - 240*kiphone6_ScreenWidth)/2, (self.frame.size.height-80*kiphone6_ScreenWidth)/2.0-30, 240*kiphone6_ScreenWidth, 43);
            _imgV.image = [UIImage imageNamed:@"pic_kb"];
            _remindLabel.text = @"";
        }else {
            _imgV.frame = CGRectMake((self.frame.size.width-80*kiphone6_ScreenWidth)/2.0, (self.frame.size.height-80*kiphone6_ScreenWidth)/2.0-30, 80*kiphone6_ScreenWidth, 80);
            _imgV.image = [UIImage imageNamed:@"pic_wsj"];
            _remindLabel.frame = CGRectMake(0, _imgV.bottom+15, self.frame.size.width, 20);
            _remindLabel.text = reminds;
        }
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(retryHttp)];
    [self addGestureRecognizer:tap];
}


- (void)retryHttp {
    if ([self.delegate respondsToSelector:@selector(errorViewTap)]) {
        [self.delegate errorViewTap];
    }
}

-(void)showErrorView {
    if (self.hidden == YES) {
        self.hidden = NO;
    }
}
-(void)hideErrorView {
    if (self.hidden == NO) {
        self.hidden = YES;
    }
}

@end
