//
//  XLBSRadarView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBSRadarView : UIView
@property (nonatomic, strong)UIColor * color;
@property (nonatomic, strong)UIColor * borderColor;
@property (nonatomic, assign)float  borderWidth;
@property (nonatomic, assign)double pulsingCount;           //雷达上波纹的条数
@property (nonatomic, assign)double duration;              //动画时间
@property (nonatomic, assign)float repeatCount;
@property (nonatomic, strong)CALayer * pulsingLayer;

- (void)animation;
@end
