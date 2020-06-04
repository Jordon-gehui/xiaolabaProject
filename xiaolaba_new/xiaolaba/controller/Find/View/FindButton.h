//
//  FindButton.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindButton : UIView
@property (nonatomic,retain)UIImageView *imageView;

- (void)initButton:(CGFloat)width;
-(void) setImage:(UIImage *)img;

- (void)addBtnTarget:(id)target action:(SEL)action;
@end
