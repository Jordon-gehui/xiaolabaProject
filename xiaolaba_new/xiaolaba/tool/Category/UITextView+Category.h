//
//  UITextView+Category.h
//  JSCapp
//
//  Created by jackzhang on 2017/4/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Category)

@property(nonatomic,assign)CGFloat keyBoardHeight;

/**
 *  键盘添加确定按钮
 */
-(void)creatViewSureButtonOnTextView;
/**
 *  键盘事件
 */
-(void)ViewkeyBoardEvent;

/**
 *  键盘事件
 */
-(void)ViewkeyBoardDiss;


@end
