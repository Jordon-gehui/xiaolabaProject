//
//  XLBCallView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBCallView : UIVisualEffectView
@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, copy) NSString *deviceNo;

@property (nonatomic, strong) UIButton *defaultBtn;
- (instancetype)initWithEffect:(UIVisualEffect *)effect;
@end
