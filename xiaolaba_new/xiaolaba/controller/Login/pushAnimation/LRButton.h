//
//  LRButton.h
//  自定义登录界面
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 lurong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LRButton;
@protocol clickDegate <NSObject>
- (void)clickDegate:(LRButton *)lr;

@end
typedef void(^finishBlock)();

@interface LRButton : UIView

@property (nonatomic,copy) finishBlock translateBlock;
@property (nonatomic,assign) id<clickDegate> delegate;

-(void)setButtonTitle:(NSString *)title;
-(void)setButtonTitleColor:(UIColor*)color;

@end
