//
//  UIViewController+Category.m
//  SAIC
//
//  Created by jackzhang on 2017/3/3.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)



- (void)setLeftBarButtonWithImageTitle:(NSString *)title action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 30);
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem4 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = barItem4;
    
}


- (void)setRightBarButtonWithImageTitle:(NSString *)title action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 30);
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem4 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barItem4;
    
}


- (void)setBarTitle:(NSString *)title color:(UIColor *)color{

    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:color}];

}

- (void)hiddenNaviBar:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)showNaviBar:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    
}

@end


@implementation UIViewController (Exception)



@end

