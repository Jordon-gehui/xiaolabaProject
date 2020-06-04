//
//  UIView+Category.h
//  YCYRBank
//
//  Created by 侯荡荡 on 16/4/28.
//  Copyright © 2016年 Hou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Complete)(void);

@interface UIView (Category)
/**
 *  坐标系
 */
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
/**
 *  view所在的ViewController
 */
@property (nonatomic, readonly) UIViewController *viewController;
/**
 *  设置在父视图的中心
 */
- (void)centerInSuperView;
- (void)aestheticCenterInSuperView;

- (UIImage *)imageForView;
@end



@interface UIView (MotionEffect)
- (void) addCenterMotionEffectsXYWithOffset:(CGFloat)offset;
@end


@interface UIView (Shake)
/**
 *  实现UIView抖动效果
 */
- (void) shakeAnimation;
@end

@interface UIView (Animation)
/**
 *  实现UIView弹出效果
 */
- (void) bounceAnimation;
//- (void) showAnimation;
//- (void) moveToRightItemComplete:(Complete)complete;
@end



@interface UIView (Screenshot)
/**
 *  截图
 *
 *  @return 截图后的UIImage对象
 */
- (UIImage *)screenshot;
/**
 *  截图
 *
 *  @param contentOffset 内容偏移
 *
 *  @return 截图后的UIImage对象
 */
- (UIImage *)screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;
/**
 *  截图
 *
 *  @param frame 在某个区域内
 *
 *  @return 截图后的UIImage对象
 */
- (UIImage *)screenshotInFrame:(CGRect)frame;
@end




@interface UIView (Display)

/**
 *  提示框（默认时长2s，默认位置居下）
 *
 *  @param message 提示信息文本
 */
- (void)displayMessage:(NSString *)message;

/**
 *  提示框
 *
 *  @param message  提示信息文本
 *  @param interval 显示时长（单位：s）
 *  @param position 显示位置（top、bottom、center）
 */
- (void)displayMessage:(NSString *)message duration:(CGFloat)interval position:(id)position;

/**
 *  提示框（默认时长2s，默认位置居下）
 *
 *  message error信息
 */
- (void)displayError:(NSString *)error;

/**
 *  提示框（从导航条下划出）
 *
 *  @param error  提提示错误文本信息
 *  @param interval 显示时长（单位：s）
 */
- (void)displayError:(NSString *)error duration:(CGFloat)interval;

@end

