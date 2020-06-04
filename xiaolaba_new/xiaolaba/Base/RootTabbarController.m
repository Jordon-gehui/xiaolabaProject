//
//  RootTabbarController.m
//  IMMPapp
//
//  Created by jackzhang on 2017/7/3.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "RootTabbarController.h"
#import <QuartzCore/QuartzCore.h>

static RootTabbarController *rootTabbar;

@interface RootTabbarController ()

@end

@implementation RootTabbarController

- (void)addTabbar
{
    NSMutableArray *controllers = [NSMutableArray array];
    NSArray *titles = @[@[@"LittleHorn",@"发现",@"icon_xlb"],
                        @[@"Find",@"车友",@"icon_cheyou_n"],
                        @[@"Car",@"挪车",@"icon_xcy"],
                        @[@"XLBMessage",@"消息",@"icon_xiao"],
                        @[@"XLBMe",@"我的",@"icon_wd"]];
    for (NSUInteger i=0; i<titles.count; i++) {
        //拼接视图控制器类名
        NSString *name = [NSString stringWithFormat:@"%@ViewController", titles[i][0]];
        //转换为Class变量
        Class cls = NSClassFromString(name);
        BaseViewController *vc = [[cls alloc] init];
        
        //创建tabBarItem
        NSString *imageName = [NSString stringWithFormat:@"%@", titles[i][2]];
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //创建选中状态的图片
        NSString *selectedImageName = [NSString stringWithFormat:@"%@_selected", titles[i][2]];

        UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tbi = [[UITabBarItem alloc] initWithTitle:titles[i][1] image:image selectedImage:selectedImage];
//        //设置字体及颜色

        UIColor *normalColor = UIColorFromRGB(0xa5a6bb);
        [tbi setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
        UIColor *selectedColor = UIColorFromRGB(0x3d424d);

        [tbi setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:selectedColor} forState:UIControlStateSelected];
        
        vc.tabBarItem = tbi;
        RootNavigationController *nc = [[RootNavigationController alloc] initWithRootViewController:vc];
        
        //将视图控制器保存到数组中
        [controllers addObject:nc];
        
   
    }
    self.viewControllers = controllers;

}

+ (instancetype)sharedRootBar {
    if(!rootTabbar) {
        rootTabbar = [[RootTabbarController alloc] init];
    }
    return rootTabbar;
}
+ (void)deallocRootBar {
    rootTabbar = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //设置tabBar的背景图片
    [self addTabbar];
    
}

+ (void)transformRootControllerFrom:(UIViewController *)fromController
                                 to:(UIViewController *)toController {
    
    [[UIApplication sharedApplication].delegate.window.rootViewController removeFromParentViewController];
    [UIApplication sharedApplication].delegate.window.rootViewController = toController;
    
//    [fromController presentViewController:toController animated:YES completion:^{
//
//
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
