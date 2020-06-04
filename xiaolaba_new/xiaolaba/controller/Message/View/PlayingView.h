//
//  PlayingView.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/6/5.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingView : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;

-(instancetype)initWithSize:(CGSize)size lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;
@end
