//
//  PassWordView.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/11/7.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PassWordView;
@protocol PassWordViewDelegate <NSObject>

@optional
-(void) dpBeginInput:(PassWordView *)pass;
-(void) dpFinishedInput:(PassWordView *)pass;
-(void) passwordDidChanged:(PassWordView *)pass;
@end
@interface PassWordView : UIView

@property (assign, nonatomic) id<PassWordViewDelegate> delegate;
@property (nonatomic,copy)NSMutableString *passText;
-(void) initPassWord;
@end
