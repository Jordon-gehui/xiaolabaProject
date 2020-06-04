//
//  PlayingView.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/6/5.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "PlayingView.h"

@implementation PlayingView
{
    float _lineWidth;
    UIColor *_lineColor;
    NSMutableArray *_lineArray;
}
static NSInteger lineCount = 3;

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        _lineArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self buildLayout];
    }
    return self;
}
-(instancetype)initWithSize:(CGSize)size lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor {
    self = [super init];
    if (self) {
        self.size = size;
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        _lineArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self buildLayout];
    }
    return self;
}
-(NSArray*)values
{
    return @[@[@1.0, @0.5, @0.1, @0.4, @0.7, @0.9, @1.0],
             @[@1.0, @0.8, @0.5, @0.1, @0.5, @0.7, @1.0],
             @[@1.0, @0.7, @0.4, @0.4, @0.7, @0.9, @1.0]];
}

-(NSArray*)durations
{
    return @[@(0.9),@(1.0),@(0.9)];
}


-(void)buildLayout
{
    float margin = (self.bounds.size.width - 3*_lineWidth)/4;
    float height = self.bounds.size.height;
    NSArray* layerHeight = @[@(0.6*height),@(0.8*height),@(0.9*height)];
    for (int i = 0; i < lineCount; i++) {
        //初始化layer
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineCap = kCALineCapRound;
        layer.strokeColor = _lineColor.CGColor;
        layer.frame = self.bounds;
        layer.lineWidth = _lineWidth;
        [self.layer addSublayer:layer];
        
        //设置layer的位置
        CGFloat pillarHeight = [layerHeight[i] floatValue];
        CGFloat x = (i+1)*margin + i*_lineWidth;
        CGPoint startPoint = CGPointMake(x, height);
        CGPoint toPoint = CGPointMake(x, height - pillarHeight);
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:toPoint];
        layer.path = path.CGPath;
        [_lineArray addObject:layer];
    }
    [self addAnimation];
}

-(void)addAnimation
{
    for (int i = 0; i<_lineArray.count; i++) {
        CALayer *layer = [_lineArray objectAtIndex:i];
        //设置动画
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        //        animation.delegate = self;
        animation.values = [self values][i];
        animation.duration = [[self durations][i] floatValue];
        animation.repeatCount = HUGE_VAL;
        animation.removedOnCompletion = false;//必须设为false否则会被销毁掉
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:animation forKey:@"ESSEQAnimation"];
    }
    
}

@end
