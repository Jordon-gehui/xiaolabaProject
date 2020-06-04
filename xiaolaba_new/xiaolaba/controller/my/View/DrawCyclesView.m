//
//
//
#import "DrawCyclesView.h"

#define kBorderWith 5

@implementation DrawCyclesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//可以用对比性的方法来理解CGContextFillRect，CGContextFillPath，CGContextStrokePath

-(void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /**
     *  画空心圆
     */
    CGRect bigRect = CGRectMake(rect.origin.x + kBorderWith,
                                rect.origin.y+ kBorderWith,
                                rect.size.width - kBorderWith*2,
                                rect.size.height - kBorderWith*2);
    
    //设置空心圆的线条宽度
    CGContextSetLineWidth(ctx, kBorderWith);
    //以矩形bigRect为依据画一个圆
    CGContextAddEllipseInRect(ctx, bigRect);
    //填充当前绘画区域的颜色
    [RGB(174,181,194) set];
    //(如果是画圆会沿着矩形外围描画出指定宽度的（圆线）空心圆)/（根据上下文的内容渲染图层）
    CGContextStrokePath(ctx);
    
    
    // 设置线条端点为圆角
    CGContextSetLineCap(ctx, kCGLineCapRound);
    // 设置画笔颜色
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGFloat originX = rect.size.width / 2;
    CGFloat originY = rect.size.height / 2;
    // 计算半径
    CGFloat radius = MIN(originX, originY) - kBorderWith;
    // 逆时针画一个圆弧
    CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, 0, -M_PI * 2/5.0, 1);
    
    // 2. 创建一个渐变色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.7,1};
    // 渐变色的颜色
    NSArray *colorArr = @[
                          (id)(RGBA(46,48,51,0)).CGColor,
                          (id)(RGB(46,48,51)).CGColor
                          ];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArr, locations);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    
    // CGContextReplacePathWithStrokedPath
    // 将context中的路径替换成路径的描边版本，使用参数context去计算路径（即创建新的路径是原来路径的描边）。用恰当的颜色填充得到的路径将产生类似绘制原来路径的效果。你可以像使用一般的路径一样使用它。例如，你可以通过调用CGContextClip去剪裁这个路径的描边
    CGContextReplacePathWithStrokedPath(ctx);
    // 剪裁路径
    CGContextClip(ctx);
    
    // 4. 用渐变色填充
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, rect.size.height / 2), CGPointMake(rect.size.width, rect.size.height / 2), 0);
    // 释放渐变色
    CGGradientRelease(gradient);
    
}
 - (void)startBtnAction{
    // 创建一个基础动画
    CABasicAnimation *animation = [CABasicAnimation new];
    // 设置动画要改变的属性
    animation.keyPath = @"transform.rotation.z";
    // 动画的最终属性的值
    animation.toValue = @(M_PI*2);
    // 动画的播放时间
    animation.duration = 3;
    // 动画效果慢进慢出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    // 解决动画结束后回到原始状态的问题
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
     animation.repeatCount= HUGE_VALF;
    // 将动画添加到视图bgImgV的layer上
    [self.layer addAnimation:animation forKey:@"rotation"];
}
//暂停动画

- (void)pauseAnimation {
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    self.layer.timeOffset = pauseTime;
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    self.layer.speed = 0;
}
//恢复动画

- (void)resumeAnimation {
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = self.layer.timeOffset;
    //2.计算出开始时
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [self.layer setTimeOffset:0];
    [self.layer setBeginTime:begin];
    self.layer.speed = 1;
    
}
@end
