//
//  FindCardView.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "FindCardView.h"

@interface FindCardView () <UIScrollViewDelegate>
{
    CGFloat card_spacing;   // 卡片间距
    CGFloat card_width;     // 卡片宽度
    CGFloat card_height;    // 卡片高度
    BOOL isRight;
    int beganX;
}

#define CC_CYCLEINDEX_CALCULATE(x,y) (x+y)%y  //计算循环索引
#define CC_DEFAULT_DURATION_TIME 2.0f         //默认持续时间
#define CC_DEFAULT_DURATION_FRAME CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/4)

@property (nonatomic, strong) UIScrollView *contentScroll;

@property (nonatomic, readwrite, strong)FindCard * leftView;
@property (nonatomic, readwrite, strong)FindCard * middleView;
@property (nonatomic, readwrite, strong)FindCard * rightView;
@property NSUInteger currentNumber;
@end

@implementation FindCardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        _contentScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScroll.backgroundColor = [UIColor clearColor];
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.delegate = self;
        _contentScroll.scrollEnabled = NO;
        _contentScroll.pagingEnabled= NO;
        [self addSubview:_contentScroll];
        
        card_width = self.width * 0.9;
        card_height = self.height;
        card_spacing = self.width * 0.02;
        
        _contentScroll.contentSize = CGSizeMake(3*_contentScroll.frame.size.width, 0);
        //显示中间图片
        _contentScroll.contentOffset = CGPointMake(_contentScroll.frame.size.width, _contentScroll.frame.origin.y);
        
        self.leftView  = [[FindCard alloc]initWithFrame:CGRectMake(self.width*0.12+card_width*0.2, _contentScroll.frame.size.height*0.1  , card_width*0.8, _contentScroll.frame.size.height*0.8)];

        self.middleView = [[FindCard alloc]initWithFrame:CGRectMake(_contentScroll.frame.size.width+self.width*0.05, 0  , card_width, _contentScroll.frame.size.height)];

        self.rightView = [[FindCard alloc]initWithFrame:CGRectMake(2*_contentScroll.frame.size.width-card_spacing, _contentScroll.frame.size.height*0.1, card_width*0.8, _contentScroll.frame.size.height*0.8)];

        [_contentScroll addSubview:_leftView];
        [_contentScroll addSubview:_rightView];
        [_contentScroll addSubview:_middleView];

    }
    return self;
}
#pragma mark - 手势使用
-(UIView*)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    [super hitTest:point withEvent:event];

    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    beganX = point.x;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    if (x-beganX>10) {
        [self handleSwipeFrom:1];
    }else if(x-beganX<-10){
        [self handleSwipeFrom:0];
    }else {
        point = [self.middleView.layer convertPoint:point fromLayer:self.layer];
        if ([self.middleView.layer containsPoint:point]) {
            point = [self.middleView.avatar.layer convertPoint:point fromLayer:self.middleView.layer];
            if ([self.middleView.avatar.layer containsPoint:point]) {
                NSLog(@"点击头像预览");
                [self avatarClick];
            }else{
                NSLog(@"点击进入主页");
                [self userClick];
            }
        }
    }
}
/////----------------------

- (void)cycleViewModelConfig{
    if ([self.dataSource count] == 0) {
        NSLog(@"cycleImageViewConfig:images is empty!");
        return;
    }
    _currentNumber = 0;
    if (self.currentNumber ==0) {
        [self.leftView setHidden:YES];
    }else {
        [self.leftView setHidden:NO];
    }
    if (self.currentNumber == self.dataSource.count-1) {
        [self.rightView setHidden:YES];
    }else {
        [self.rightView setHidden:NO];
    }
    _middleView.model = _dataSource[CC_CYCLEINDEX_CALCULATE(_currentNumber,_dataSource.count)];
    _leftView.model = _dataSource[CC_CYCLEINDEX_CALCULATE(_currentNumber-1,_dataSource.count)];
    _rightView.model = _dataSource[CC_CYCLEINDEX_CALCULATE(_currentNumber+1,_dataSource.count)];
    
}
//- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
- (void)handleSwipeFrom:(BOOL )recognizer{
    if(recognizer) { //-1
        isRight =NO;
        if (_currentNumber ==0){
            [MBProgressHUD showError:@"这是第一张了"];
            return;
        }
        self.currentNumber = CC_CYCLEINDEX_CALCULATE(_currentNumber  - 1,self.dataSource.count);
        [self.rightView setHidden:NO];

        [UIView animateWithDuration:0.3f animations:^{
            self.middleView.transform = CGAffineTransformMake(0.8f, 0, 0, 0.8f, 0, 0);
            self.leftView.transform = CGAffineTransformMake(1.25f, 0, 0, 1.25f, 0, 0);
            [self.contentScroll setContentOffset:CGPointMake(self.width*0.07+card_width*0.1, 0) animated:NO];

        } completion:^(BOOL finished) {
            self.middleView.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);
            self.leftView.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);

            [self scrollEndWithAnimation];
            if (self.currentNumber ==0) {
                [self.leftView setHidden:YES];
            }
        }];
    }else{
        isRight =YES;
        if (_currentNumber ==self.dataSource.count-1) {
            [MBProgressHUD showError:@"没有更多了"];
            return;
        }
        self.currentNumber = CC_CYCLEINDEX_CALCULATE(_currentNumber  + 1,self.dataSource.count);
        [self.leftView setHidden:NO];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.middleView.transform = CGAffineTransformMake(0.8f, 0, 0, 0.8f, 0, 0);
            self.rightView.transform = CGAffineTransformMake(1.25f, 0, 0, 1.25f, 0, 0);
            [self.contentScroll setContentOffset:CGPointMake(2*self.contentScroll.frame.size.width-self.width*0.07-card_width*0.1, 0) animated:NO];

        } completion:^(BOOL finished) {
            self.middleView.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);
            self.rightView.transform = CGAffineTransformMake(1.0f, 0, 0, 1.0f, 0, 0);

            [self scrollEndWithAnimation];
            if (self.currentNumber ==self.dataSource.count-1) {
                [self.rightView setHidden:YES];
            }
        }];
    }
}

- (void)avatarClick {
    
    if([self.delegate respondsToSelector:@selector(cardView:didTouchCardImages:)]) {
        NSLog(@"%@ %li",self.dataSource,_currentNumber);
        XLBFindUserModel *model = self.dataSource[CC_CYCLEINDEX_CALCULATE(_currentNumber,self.dataSource.count)];
        
        NSArray <NSString *>*images = [model.picks componentsSeparatedByString:@","];
        [self.delegate cardView:self.middleView didTouchCardImages:images];
    }
}

- (void)userClick {
    
    if([self.delegate respondsToSelector:@selector(cardView:card:didSelectAtIndex:)]) {
        
        XLBFindUserModel *model = self.dataSource[CC_CYCLEINDEX_CALCULATE(_currentNumber,self.dataSource.count)];
        [self.delegate cardView:self.middleView card:model didSelectAtIndex:_currentNumber];
    }
}


#pragma mark - ScrollView  Delegate
-(void)scrollEndWithAnimation {
    [self changeImageViewWith:self.currentNumber];
    self.contentScroll.contentOffset = CGPointMake(_contentScroll.frame.size.width, _contentScroll.frame.origin.y);
    if([self.delegate respondsToSelector:@selector(cardView:didScrollAtIndex:direction:)]) {
        [self.delegate cardView:self.middleView didScrollAtIndex:self.currentNumber direction:isRight];
    }
}

#pragma mark - iamgeView cycle changed
/**
 *  改变轮播的图片
 *
 *  @param imageNumber 设置当前，前，后的图片
 */
- (void)changeImageViewWith:(NSInteger)imageNumber {
    self.middleView.model = self.dataSource[CC_CYCLEINDEX_CALCULATE(imageNumber,self.dataSource.count)];
    self.leftView.model = self.dataSource[CC_CYCLEINDEX_CALCULATE(imageNumber-1,self.dataSource.count)];
    self.rightView.model = self.dataSource[CC_CYCLEINDEX_CALCULATE(imageNumber+1,self.dataSource.count)];
    NSLog(@"=====%@",self.middleView.model.nickname);
}

#pragma mark - page change animation type
- (void)pageChangeAnimationType:(NSInteger)animationType
{
    if (animationType == 0) {
        return;
    }else if (animationType == 1) {
        [self.contentScroll setContentOffset:CGPointMake(2*self.contentScroll.frame.size.width, 0) animated:NO];
    }else if (animationType == 2){
        self.contentScroll.contentOffset = CGPointMake(2*self.frame.size.width, 0);
        [UIView animateWithDuration:0 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
        }];
        
    }
    
    
}

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
