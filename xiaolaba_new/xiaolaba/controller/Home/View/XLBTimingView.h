//
//  XLBTimingView.h
//  xiaolaba
//
//  Created by lin on 2017/7/13.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimeOverReturnBlock)(NSInteger number);

@interface XLBTimingView : UIView
@property(nonatomic , copy)TimeOverReturnBlock timeOverBlock;
/**
 初始化方法

 @param frame frame
 @param time  计时开始时间(30s)

 @return XLBTimingView
 */
- (instancetype)initWithFrame:(CGRect)frame time:(NSUInteger )time;

- (void)startAnimation:(NSUInteger)time;
- (void)stopTime;
- (void)stopAnimation;

@end
