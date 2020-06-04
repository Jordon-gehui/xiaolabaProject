//
//  UITextField+HXTextField.m
//  ConsumerFinance
//
//  Created by jack on 16/7/11.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "UITextField+Category.h"
#import <objc/runtime.h>
#import "UIViewExt.h"
//主屏幕的高度
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
//主屏幕的宽度
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
static void *strKey = &strKey;

@implementation UITextField (Category)
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
-(void)creatSureButtonOnTextView{
    
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

-(void)keyBoardDiss{

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
    
    //动画
    [UIView animateWithDuration:0.5 animations:^{

        if ([self.superview isKindOfClass:[UIView class]]) {
            
            self.superview.superview.superview.frame = CGRectMake(0, -300 , self.superview.superview.superview.width, self.superview.superview.superview.frame.size.height);
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
            
            self.superview.superview.superview.frame = CGRectMake(0, 64, self.superview.superview.superview.frame.size.width, self.superview.superview.superview.frame.size.height);
            
        }//
    }];
    
}

-(void)keyBoardEvent{
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

- (BOOL)valueChangeValueString:(NSString *)string shouldChangeCharactersInRange:(NSRange)range {
    NSString *text = self.text;
    NSCharacterSet *charaterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[charaterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *newString = @"";
    NSString *subString = [text substringToIndex:MIN(text.length, 3)];
    newString = [newString stringByAppendingString:subString];
    if (subString.length == 3) {
        newString = [newString stringByAppendingString:@" "];
    }
    text = [text substringFromIndex:MIN(text.length, 3)];
    if (text.length > 0) {
        NSString *subString2 = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString2];
        if (subString2.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        NSString *subString3 = [text substringFromIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString3];
        
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[charaterSet invertedSet]];
    
    if (newString.length >= 14) {
        return NO;
    }
    [self setText:newString];
    return NO;
}
@end
