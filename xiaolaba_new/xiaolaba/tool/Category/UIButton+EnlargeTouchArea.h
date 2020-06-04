//
//  UIButton+EnlargeTouchArea.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/11/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
//放大点击范围
- (void)setEnlargeEdge:(CGFloat) size;

@end
