//
//  InviteView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/7.
//  Copyright © 2017年 jackzhang. All rights reserved.
//
#import <UIKit/UIKit.h>
@class InviteView;
@protocol InviteViewDelegate <NSObject>

@optional
-(void) dpBeginInput:(InviteView *)pass;
-(void) dpFinishedInput:(InviteView *)pass;
-(void) passwordDidChanged:(InviteView *)pass;
@end
@interface InviteView : UIView

@property (assign, nonatomic) id<InviteViewDelegate> delegate;
@property (nonatomic,copy)NSMutableString *passText;
@property (nonatomic, assign) BOOL keyBoard;
-(void) initPassWord;
@end
