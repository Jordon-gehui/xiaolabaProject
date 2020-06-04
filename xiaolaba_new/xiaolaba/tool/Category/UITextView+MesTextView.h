//
//  UITextView+MesTextView.h
//  JSCapp
//
//  Created by jackzhang on 2017/5/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (MesTextView)


@property(nonatomic,assign)CGFloat keyBoardHeight;

/**
 *  键盘添加确定按钮
 */
-(void)creatViewSureButtonOnMesTextView;
/**
 *  键盘事件
 */
-(void)ViewkeyBoardMesEvent;

/**
 *  键盘事件
 */
-(void)ViewkeyBoardMesDiss;

@end
