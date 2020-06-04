//
//  InviteView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/7.
//  Copyright © 2017年 jackzhang. All rights reserved.
//
//
//  PassWordView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/11/7.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "InviteView.h"
@interface InviteView()<UIKeyInput,UITextInputTraits>
@end
@implementation InviteView

static NSInteger places = 6;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializer];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}
-(NSMutableString*)passText {
    if (!_passText) {
        _passText = [NSMutableString new];
    }
    return _passText;
}
-(void)initializer {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [RGB(204, 204, 204) CGColor];
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    
    [self becomeFirstResponder];
    [self setNeedsDisplay];
}
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeASCIICapable;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(void) initPassWord {
    self.passText = nil;
    [self becomeFirstResponder];
    [self setNeedsDisplay];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}
- (BOOL)becomeFirstResponder {
    if (self.delegate) {
        [self.delegate dpBeginInput:self];
    }
    return [super becomeFirstResponder];
}
- (BOOL)hasText {
    return self.passText.length>0;
    
}
-(void)insertText:(NSString *)text {
    NSString *regex = @"[~`!@#$%^&*()_+-=[]|{};':\",./<>?]{,}/•€£¥";
    if (self.passText.length==places || [text isEqualToString:@" "] || [regex containsString:text] == YES) {
        return;
    }
    [self.passText appendString:text];
    if (self.passText.length == places) {
        if (self.delegate) {
            [self.delegate dpFinishedInput:self];
        }
    }
    
    //呼唤重绘
    [self setNeedsDisplay];
}
- (void)deleteBackward {
    if ([self.passText length] == 0) {
        return;
    }
    NSRange theRange = NSMakeRange(_passText.length - 1, 1);
    [self.passText deleteCharactersInRange:theRange];
    if (self.delegate) {
        [self.delegate passwordDidChanged:self];
    }
    //呼唤重绘
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat width = rect.size.width / (CGFloat)places;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    //设置颜色
    CGContextSetFillColorWithColor(context, [RGB(204, 204, 204) CGColor]);
    CGContextSetStrokeColorWithColor(context, [RGB(204, 204, 204) CGColor]);
    
    CGContextBeginPath(context);
    for (int i = 1; i<=places; i++) {
        CGContextMoveToPoint(context, (CGFloat)i*width, 0);
        CGContextAddLineToPoint(context, (CGFloat)i*width, height);
        CGContextStrokePath(context);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetTextDrawingMode(context,kCGTextFill);
    
    for (int i = 1; i<=self.passText.length; i++) {
        UIFont *font = [UIFont fontWithName:@"Arial" size:20];
        CGPoint point = CGPointMake((CGFloat)i*width-width/2.0-5, height/2.0-10);
        if (_keyBoard == YES) {
            font = [UIFont fontWithName:@"Arial" size:30];
            point = CGPointMake((CGFloat)i*width-width/2.0-10, height/2.0-15);
        }
        NSString *tempStr = [self.passText substringWithRange:NSMakeRange(i-1, 1)];
        [tempStr drawAtPoint:point withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    }
    
}


@end

