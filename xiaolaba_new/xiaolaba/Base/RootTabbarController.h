//
//  RootTabbarController.h
//  IMMPapp
//
//  Created by jackzhang on 2017/7/3.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabbarController : UITabBarController

+ (instancetype)sharedRootBar;
+ (void)deallocRootBar;
- (void)addTabbar;

+ (void)transformRootControllerFrom:(UIViewController *)fromController
                                 to:(UIViewController *)toControlle;
@end
