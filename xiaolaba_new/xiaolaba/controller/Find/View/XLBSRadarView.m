//
//  XLBSRadarView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBSRadarView.h"

@implementation XLBSRadarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = [UIColor colorWithRed:255 / 255.0 green:218 / 255.0 blue:69 / 255.0 alpha:1];
        _borderColor = [UIColor colorWithRed:255 / 255.0 green:218 / 255.0 blue:69 / 255.0 alpha:1];
        _borderWidth = 3.0;
        _pulsingCount = 2;
        _duration = 1.5;
        _repeatCount = HUGE_VALF;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.cornerRadius = self.frame.size.height / 2.0; 
    self.clipsToBounds = YES;
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx,1,218 / 255.0,69 / 255.0,1);//画笔线的颜色
    CGContextSetLineWidth(ctx, 2.0);//线的宽度
    CGContextAddArc(ctx, self.center.x, self.center.y, self.frame.size.height / 2.0, 0, 2 *M_PI, 1); //添加一个圆
    CGContextDrawPath(ctx, kCGPathStroke); //绘制路径
    // 3.显示所绘制的东西
    CGContextStrokePath(ctx);
    
    [self animation];
}

- (void)animation
{
    CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.fillMode = kCAFillModeBoth;
    //因为雷达中每个圆圈的大小不一致，故需要他们在一定的相位差的时刻开始运行。
    animationGroup.beginTime = CACurrentMediaTime() + 1 * _duration / _pulsingCount;
    animationGroup.duration = _duration;//每个圆圈从生成到消失的时长，也即动画组每轮动画持续的时长
    animationGroup.repeatCount = 1;//0表示动画组持续时间为无限大，也即动画无限循环。
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.autoreverses = NO;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = NO;
    
    CABasicAnimation * scaleAnimation = [[CABasicAnimation alloc] init];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(0.2);
    scaleAnimation.toValue = @(1.0);
    scaleAnimation.autoreverses = NO;
    
    CAKeyframeAnimation * opacityAnimation = [[CAKeyframeAnimation alloc] init];
    opacityAnimation.keyPath = @"opacity";
    //雷达运行四个阶段不同的透明度。
    opacityAnimation.values = @[@1.0, @0.75, @0.5, @0.25, @0.0];
    //雷达运行的不同的四个阶段，为0.0表示刚运行，0.5表示运行了一半，1.0表示运行结束。
    opacityAnimation.keyTimes = @[@0.0, @0.25, @0.5,@2.75, @1.0];
    opacityAnimation.autoreverses = NO;
    opacityAnimation.removedOnCompletion = NO;
    
    //将两组动画（大小比率变化动画，透明度渐变动画）组合到一个动画组。
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [self.layer addAnimation:animationGroup forKey:@"pulsing"];
    
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.alpha = 0;
    [self.layer removeAnimationForKey:@"pulsing"];
    [self removeFromSuperview];
    
}


@end
