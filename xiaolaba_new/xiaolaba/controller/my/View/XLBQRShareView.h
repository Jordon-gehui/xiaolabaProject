//
//  XLBQRShareView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBQRShareView : UIView
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *inviteLabel;
- (UIImage*)imageWithUIView:(UIView *)view;
@end
