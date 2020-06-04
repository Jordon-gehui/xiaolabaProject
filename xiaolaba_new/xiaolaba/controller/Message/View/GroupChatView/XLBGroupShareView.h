//
//  XLBGroupShareView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBGroupModel.h"
@interface XLBGroupShareView : UIView

@property (nonatomic, strong) UIImageView *codeImg;
@property (nonatomic, strong) XLBGroupModel *model;

- (UIImage*)imageWithUIView:(UIView *)view;
@end
