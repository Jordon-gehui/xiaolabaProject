//
//  BQLCodeButton.h
//  BQLDemo
//
//  Created by hao 好享购 on 16/7/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQLCodeButton;

@protocol BQLCodeButtonDelegate <NSObject>

@required
- (void)sendCode;

@end

@interface BQLCodeButton : UIView

@property (nonatomic, weak) id<BQLCodeButtonDelegate> delegate;

// 关闭计时
- (void)closeTimer;

@end
