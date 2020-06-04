//
//  RootNavigationController.m
//  IMMPapp
//
//  Created by hjl on 2017/7/4.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation RootNavigationController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    [self.interactivePopGestureRecognizer setEnabled:NO];
    
    // Do any additional setup after loading the view.
}

//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
//    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
//    CGPoint translation = [panGesture translationInView:self.view];
//    NSLog(@"  * self.frame  = %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"  * translation = %@", NSStringFromCGPoint(translation));
//    NSLog(@"  * velocity    = %@", NSStringFromCGPoint([panGesture velocityInView:self.view]));
//    NSLog(@"  * location    = %@", NSStringFromCGPoint([panGesture locationInView:self.view]));
//
//    NSLog(@"  * superview.frame  = %@", NSStringFromCGRect(self.view.superview.frame));
//    NSLog(@"  * supertranslation = %@", NSStringFromCGPoint([panGesture translationInView:self.view.superview]));
//    NSLog(@"  * supervelocity    = %@", NSStringFromCGPoint([panGesture velocityInView:self.view.superview]));
//    NSLog(@"  * superlocation    = %@", NSStringFromCGPoint([panGesture locationInView:self.view.superview]));
//    CGPoint point = [panGesture velocityInView:self.view];
//    NSLog(@"  * point    = %f==%f", point.x,point.y);

    //解决与左滑手势冲突
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return NO;
    }
    if (self.interactivePopGestureRecognizer.isEnabled) {
        return NO;
    }else {
        return self.childViewControllers.count == 1 ? NO : YES;
    }
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    /**
//     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
//     */
//    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
//    CGPoint translation = [panGesture translationInView:self.view];
//    NSLog(@"  * self.frame  = %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"  * translation = %@", NSStringFromCGPoint(translation));
//    NSLog(@"  * velocity    = %@", NSStringFromCGPoint([panGesture velocityInView:self.view]));
//    NSLog(@"  * location    = %@", NSStringFromCGPoint([panGesture locationInView:self.view]));
//    
//    NSLog(@"  * superview.frame  = %@", NSStringFromCGRect(self.view.superview.frame));
//    NSLog(@"  * supertranslation = %@", NSStringFromCGPoint([panGesture translationInView:self.view.superview]));
//    NSLog(@"  * supervelocity    = %@", NSStringFromCGPoint([panGesture velocityInView:self.view.superview]));
//    NSLog(@"  * superlocation    = %@", NSStringFromCGPoint([panGesture locationInView:self.view.superview]));
//    CGPoint point = [panGesture velocityInView:self.view];
//    if (point.x < 0) {
//        return NO;
//    }
//    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (app.notPop){
//        return NO;
//    }
//    
//    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
