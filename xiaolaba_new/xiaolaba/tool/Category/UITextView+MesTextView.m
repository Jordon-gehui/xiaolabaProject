//
//  UITextView+MesTextView.m
//  JSCapp
//
//  Created by jackzhang on 2017/5/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "UITextView+MesTextView.h"

#import <objc/runtime.h>
#import "UIViewExt.h"
//主屏幕的高度
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
//主屏幕的宽度
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width

static void *strKey = &strKey;

@implementation UITextView (MesTextView)

-(void)setKeyBoardHeight:(CGFloat )keyBoardHeight
{
    NSString *str = [NSString stringWithFormat:@"%f",keyBoardHeight];
    objc_setAssociatedObject(self, & strKey, str, OBJC_ASSOCIATION_COPY);
}

-(CGFloat )keyBoardHeight
{
    
    NSString *str = objc_getAssociatedObject(self, &strKey);
    CGFloat height = [str floatValue];
    return height;
}
#pragma mark-键盘确定按钮
-(void)creatViewSureButtonOnMesTextView{
    
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 50, 44)];
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,5)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn setTitleColor:[UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(hidKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[spaceItem,item];
    self.inputAccessoryView = toolBar;
}
//点击空白处隐藏键盘
-(void)hidKeyboard{
    
    [self.superview endEditing:YES];
}

-(void)ViewkeyBoardMesDiss{
    
    //注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShownDiss:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘隐藏的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasHideDiss:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    /**
     *  点击空白处隐藏键盘
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyboard)];
    [self.superview addGestureRecognizer:tap];
    self.superview.userInteractionEnabled = YES;
    
}

//键盘出现
-(void)keyboardWasShownDiss:(NSNotification*)info{
    
    
    NSLog(@"---%@",[self.superview class]);
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        
        if ([self.superview isKindOfClass:[UIView class]]) {
            
            self.superview.frame = CGRectMake(0, -490 , self.superview.superview.superview.width, self.superview.superview.superview.frame.size.height);
            //
        }
    } completion:^(BOOL finished) {
        
        
    }];
    
}

//键盘隐藏
-(void)keyboardWasHideDiss:(NSNotification*)info{
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        
        if ([self.superview isKindOfClass:[UIView class]]) {
            
            self.superview.frame = CGRectMake(0, 0, self.superview.superview.superview.frame.size.width, self.superview.superview.superview.frame.size.height);
            
        }//
    }];
    
}

-(void)ViewkeyBoardMesEvent{
    //注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘隐藏的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasHide:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    /**
     *  点击空白处隐藏键盘
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyboard)];
    [self.superview addGestureRecognizer:tap];
    self.superview.userInteractionEnabled = YES;
    
}
//键盘出现
-(void)keyboardWasShown:(NSNotification*)info{
    
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        if ([self.superview isKindOfClass:[UITableViewCell class]]) {
            self.superview.superview.frame = CGRectMake(0, 0, self.superview.width, self.superview.frame.size.height-self.keyBoardHeight);
            
            UIView* subView = nil;
            if ([NSStringFromClass(self.superview.class) isEqualToString:@"UITableViewCellContentView"]) {
                subView = self.superview.superview.superview;
                while (subView != nil) {
                    if ([subView.superview isKindOfClass:[UITableView class]]) {
                        subView = subView.superview;
                        break;
                    }
                    subView = subView.superview;
                }
                UITableView* tableView = (UITableView*)subView;
                
                tableView.frame = CGRectMake(0, 0, self.superview.width, self.superview.frame.size.height-self.keyBoardHeight);
            }
        }else{
            self.superview.frame = CGRectMake(0, -self.keyBoardHeight, self.superview.frame.size.width, self.superview.frame.size.height);
        }
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
}
//键盘隐藏
-(void)keyboardWasHide:(NSNotification*)info{
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        if ([self.superview isKindOfClass:[UITableViewCell class]]){
            
            UIView* subView = nil;
            if ([NSStringFromClass(self.superview.class) isEqualToString:@"UITableViewCellContentView"]) {
                subView = self.superview.superview.superview;
                while (subView != nil) {
                    if ([subView.superview isKindOfClass:[UITableView class]]) {
                        subView = subView.superview;
                        break;
                    }
                    subView = subView.superview;
                }
                UITableView* tableView = (UITableView*)subView;
                
                tableView.frame = CGRectMake(0, 0, self.superview.width, self.superview.frame.size.height);
            }
        }else{
            self.superview.frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
        }
        
    }];
    
}

@end
