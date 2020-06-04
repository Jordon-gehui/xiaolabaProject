//
//  CSshowAnimationView.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CSshowAnimationView.h"
#import "VoiceCallView.h"

@interface CSshowAnimationView()<CAAnimationDelegate,VoiceCallViewDelegate>
{
    CAShapeLayer *arcLayer;
    VoiceCallView *_voiceCallV;
}
@end
#define colorRGBa(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
@implementation CSshowAnimationView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = colorRGBa(51, 51, 51, 0.3);
        [self setSubViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorRGBa(51, 51, 51, 0.3);
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}
-(void)showView {
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(100,300, 100, 100)];
    showView.tag = 1;
    [self addSubview:showView];
    [self changeStatus];
//    showView.alpha =0.5;
//    //bezier曲线
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100/2.f,100/2.f)radius:100/2.f startAngle:0 endAngle:M_PI *2 clockwise:YES];
//
//    //创建一个shapeLayer
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.frame = showView.bounds;
//    layer.strokeColor = [UIColor greenColor].CGColor; //边缘线的颜色
//    layer.fillColor = [UIColor clearColor].CGColor;   //闭环填充的颜色
//    layer.lineCap =kCALineCapSquare;                  //边缘线的类型
//    layer.path = path.CGPath;                         //从bezier曲线获取到的形状
//    layer.lineWidth =4.0f;                            //线条宽度
//    layer.strokeStart =0.0f;
//    layer.strokeEnd =0.0f;
//
//    //给这个layer添加动画效果
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration =1.0;
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue =[NSNumber numberWithFloat:1.f];
//    pathAnimation.repeatCount = 0;
//    //使视图保留到最新状态
//    pathAnimation.removedOnCompletion =NO;
//    pathAnimation.fillMode =kCAFillModeForwards;
//    [layer addAnimation:pathAnimation forKey:nil];
//    //将layer添加进图层
//    [showView.layer addSublayer:layer];
//    [self performSelector:@selector(changeStatus)withObject:layer afterDelay:1.5];
}
- (void)changeStatus{
//    UIView *showView = [self viewWithTag:1];
//    [showView removeFromSuperview];
    
    _voiceCallV = [VoiceCallView new];
    _voiceCallV.delegate = self;
    _voiceCallV.money = @"100";
    [self addSubview:_voiceCallV];
    UIView *backv1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 252, 20)];
    backv1.backgroundColor = _voiceCallV.bgView.backgroundColor;
    [_voiceCallV.bgView addSubview:backv1];
    UIView *backv2 = [[UIView alloc]initWithFrame:CGRectMake(0, 112, 252, 22)];
    backv2.backgroundColor = _voiceCallV.bgView.backgroundColor;
    [_voiceCallV.bgView addSubview:backv2];
    UIView *backv3 = [[UIView alloc]initWithFrame:CGRectMake(0, 136, 252, 18)];
    backv3.backgroundColor = _voiceCallV.bgView.backgroundColor;
    [_voiceCallV.bgView addSubview:backv3];
    [self textShow:backv1];
    [self performSelector:@selector(textShow:)withObject:backv2 afterDelay:0.4];
    [self performSelector:@selector(textShow:)withObject:backv3 afterDelay:0.4];
    
}
-(void)textShow:(UIView*)view{
    [UIView animateWithDuration:0.8 animations:^{
        view.frame = CGRectMake(view.width, view.y, 0, view.height);
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
