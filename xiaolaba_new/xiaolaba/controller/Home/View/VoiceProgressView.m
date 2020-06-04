//
//  VoiceProgressView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceProgressView.h"

@interface VoiceProgressView ()
@property (nonatomic, strong) UIView *progressV;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation VoiceProgressView
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setSubViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    //727789  158160165
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor colorWithR:228 g:236 b:242];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius =7;
    [self addSubview:self.bgView];
    
    self.progressV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bgView.height)];
    self.progressV.backgroundColor = [UIColor textBlackColor];
    self.progressV.layer.masksToBounds = YES;
    self.progressV.layer.cornerRadius = 7;
    [self.bgView addSubview:self.progressV];

}

- (void)setTime:(float)time {
    _time = time;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.progressV.backgroundColor = progressColor;
}

- (void)setProgressBackColor:(UIColor *)progressBackColor {
    _progressBackColor = progressBackColor;
    self.bgView.backgroundColor = progressBackColor;
}

- (void)setProgressValue:(NSString *)progressValue {
    if (!_time) {
        _time = 3.0f;
    }
    _progressValue = progressValue;
    
    [UIView animateWithDuration:_time animations:^{
        self.progressV.frame = CGRectMake(self.progressV.frame.origin.x, self.progressV.frame.origin.y, self.bgView.frame.size.width*[progressValue floatValue], self.progressV.frame.size.height);
    }];
    
    [self.progressV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor colorWithR:72 g:77 b:89] end:[UIColor colorWithR:158 g:160 b:165] size:CGSizeMake(self.bgView.frame.size.width*[progressValue floatValue], self.progressV.frame.size.height)]]];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithR:72 g:77 b:89].CGColor, (__bridge id)[UIColor colorWithR:158 g:160 b:165].CGColor];
//    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(self.progressV.frame.origin.x, self.progressV.frame.origin.y, self.bgView.frame.size.width*[progressValue floatValue], self.progressV.frame.size.height);
    [self.progressV.layer addSublayer:gradientLayer];

}

@end
