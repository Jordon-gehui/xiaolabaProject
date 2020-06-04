//
//  UITextField+HXTextField.h
//  ConsumerFinance
//
//  Created by jack on 16/7/11.
//  Copyright © 2016年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Category)

@property(nonatomic,assign)CGFloat keyBoardHeight;

/**
 *  键盘添加确定按钮
 */
-(void)creatSureButtonOnTextView;
/**
 *  键盘事件
 */
-(void)keyBoardEvent;

/**
 *  键盘事件
 */
-(void)keyBoardDiss;

- (BOOL)valueChangeValueString:(NSString *)string shouldChangeCharactersInRange:(NSRange)range;
@end
