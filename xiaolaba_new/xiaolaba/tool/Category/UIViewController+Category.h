//
//  UIViewController+Category.h
//  SAIC
//
//  Created by jackzhang on 2017/3/3.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)


/**
 *  设置导航条左按钮
 *
 *  @param title  显示的文字
 *  @param action 点击事件
 */
- (void)setLeftBarButtonWithImageTitle:(NSString *)title action:(SEL)action;


/**
 *  设置导航条右按钮
 *
 *  @param title  显示的文字
 *  @param action 点击事件
 */
- (void)setRightBarButtonWithImageTitle:(NSString *)title action:(SEL)action;


/**
 *  设置导航条字体大小和颜色
 *
 *  @param title  显示的文字
 *
 */
- (void)setBarTitle:(NSString *)title color:(UIColor *)color;

//隐藏导航条
- (void)hiddenNaviBar:(BOOL)animated;
- (void)showNaviBar:(BOOL)animated;

@end



@interface UIViewController (Exception)

@end

