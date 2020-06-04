//
//  XLBTimingView.m
//  xiaolaba
//
//  Created by lin on 2017/7/13.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBTimingView.h"
#import <QuartzCore/QuartzCore.h>

@interface XLBTimingView ()
{
    dispatch_source_t _timer;
    CALayer * animationLayer;
    NSInteger secondsCountDown;
    NSTimer *countDownTimer;
}

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation XLBTimingView

- (instancetype)initWithFrame:(CGRect)frame time:(NSUInteger )time {
    
    if(self = [super initWithFrame:frame]) {
        
        [self setupSubViews:time];
    }
    return self;
}

- (void)setupSubViews:(NSUInteger )time {
    
    self.backgroundColor = RGB(255, 222, 2);
    self.layer.cornerRadius = self.width / 2.0;
    secondsCountDown = time;
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    self.timeLabel.text = format_time;
    self.hintLabel.text = @"请稍等...";
    // animation
    NSInteger pulsingCount = 3;
    double animationDuration = 3;
    animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(self.width * 0.15, self.height * 0.15, self.width * 0.7, self.height * 0.7);
        pulsingLayer.borderColor = [RGB(255, 222, 2) CGColor];
        pulsingLayer.borderWidth = 8;
        pulsingLayer.cornerRadius = self.height * 0.7 / 2;
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.removedOnCompletion = NO; //执行动画后不要移除
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.4;
        scaleAnimation.toValue = @1.9;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
    
    [self startAnimation:time];
}
#pragma mark 动画的代理方法 动画开始的时候调用
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart");
}
#pragma mark 动画结束的时候调用
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");
}

- (void)startAnimation:(NSUInteger)time {
    secondsCountDown = time;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
//    __block int timeout = (int)time; //倒计时时间-----这里如果是三位数看下面
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0 ,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout <= 0){ //倒计时结束，关闭
//            if(_timer) {
//                dispatch_source_cancel(_timer);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    self.timeLabel.text = @"0";
//                    if (self.timeOverBlock) {
//                        self.timeOverBlock(0);
//                    }
//                });
//            }
//        }
//        else{
//            int seconds = timeout;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds]; //----- 要对应位数
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSInteger second = [strTime integerValue];
//                if (second>60) {
//                    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(second%3600)/60];
//                    NSString *str_second = [NSString stringWithFormat:@"%02ld",second%60];
//                    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
//                    if (self.timeLabel) {
//                        [self.timeLabel setText:format_time];
//                    }
//                }else {
//                    self.timeLabel.text = strTime;
//
//                }
//
//            });
//            timeout--;
//        }
//    });
//    dispatch_resume(_timer);
}
-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    if (secondsCountDown>60) {
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        if (self.timeLabel) {
            [self.timeLabel setText:format_time];
        }
    }else {
        self.timeLabel.text = [NSString stringWithFormat:@"%02ld",secondsCountDown];
    }
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        self.timeLabel.text = @"0";
        if (self.timeOverBlock) {
            self.timeOverBlock(0);
        }
    }
}
- (void)stopTime {
    if (countDownTimer) {
        [countDownTimer invalidate];
    }
    self.timeLabel.text = @"0";
}
- (void)stopAnimation {
    [self stopTime];
//    if(_timer) {
//        dispatch_source_cancel(_timer);
//    }
    [self removeAllSublayers];
    [self.layer removeAllAnimations];
}

- (void)removeAllSublayers {
    while (self.layer.sublayers.count) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
}

- (UILabel *)timeLabel {
    
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:40];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //make.center.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).dividedBy(1.1);
        }];
    }
    return _timeLabel;
}

- (UILabel *)hintLabel {
    
    if(!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_hintLabel];
        [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.timeLabel);
            make.top.equalTo(self.timeLabel.mas_bottom).with.offset(0.f);
        }];
    }
    return _hintLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
