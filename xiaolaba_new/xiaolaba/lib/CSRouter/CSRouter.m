//
//  CSRouter.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "CSRouter.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#define ios10_later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)

@implementation CSRouter

+ (instancetype)share {
    
    static CSRouter *cs_route;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        
        cs_route = [[self.class alloc] init];
    });
    return cs_route;
}

/**
 系统跳转 如跳转至appstore中的某个应用下载页面、打电话、跳转到其他app(需配置白名单)
 @param url url
 @return 打开成功or失败
 */
- (BOOL )open:(NSString *)url {
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        if(ios10_later) {
            
            __block BOOL isSuccess = NO;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) {
                isSuccess = success;
            }];
            return isSuccess;
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        return YES;
    }
    return NO;
}

#pragma mark - Push
/**
 控制器push跳转
 
 @param route 类似url的一个路径 例如跳转至XXController route=@"XXController"
 若带参数跳转如参数id=1001，参数type=1 则params = @{@"id":@"1001",@"type":@"1"}
 @return 能成功跳转返回YES 否则返回NO
 */
- (BOOL )push:(NSString *)route Params:(NSDictionary*)params hideBar:(BOOL )hide {
    //将字符串转化成类名
    Class class = NSClassFromString(route);
    if(class) {
        // 获取导航控制器
        UIViewController *presentController = [self getPresentedViewController];
        UINavigationController *pushClassStance = nil;
        if([presentController isKindOfClass:[UINavigationController class]]) {
            pushClassStance = (UINavigationController *)presentController;
        }else {
            UITabBarController *tabVC = (UITabBarController *)[self getCurrentVC];
            pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
        }
        UIViewController *route_ViewController = [self getInstance:route Params:params];
        if (![route_ViewController isKindOfClass:[UIViewController class]]) {
            return NO;
        }
        route_ViewController.hidesBottomBarWhenPushed = hide;
        [pushClassStance pushViewController:route_ViewController animated:YES];
        
        return YES;
    }
    return NO;
    
}

#pragma mark - Present
/**
 present跳转
 @param route 同上
 */
- (BOOL )present:(NSString *)route Params:(NSDictionary *)params{
    Class class = NSClassFromString(route);
    if(class) {
        
        UIViewController *viewController = [self getInstance:route Params:params];
        UIViewController *topmostVC = [self topViewController];
        [topmostVC presentViewController:viewController animated:YES completion:nil];
        return YES;
    }else {
        return NO;
    }
}
- (id )getInstance:(NSString *)route Params:(NSDictionary *)params {
    
    const char *className = [route cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass) {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    
    // 对该对象赋值属性
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 检测这个对象是否存在该属性
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            // 利用kvc赋值
            [instance setValue:obj forKey:key];
        }else{
            NSLog(@"error--%@该属性不存在",key);
        }
    }];
    return instance;
}

- (BOOL )checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

BOOL checkKeyValueNotNull(id object) {
    
    if ([object isKindOfClass:[NSNull class]] || object == nil) {
        return NO;
    }else {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)object;
            if ([str isEqualToString:@""]) {
                return NO;
            }else {
                return YES;
            }
        }else if ([object isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)object;
            if ([[NSString stringWithFormat:@"%@",url] isEqualToString:@""]) {
                return NO;
            }else {
                return YES;
            }
        }else if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)object;
            if (dic.count <= 0) {
                return NO;
            }else {
                return YES;
            }
        }else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)object;
            if (arr.count <= 0) {
                return NO;
            }else {
                return YES;
            }
        }else if ([object isKindOfClass:[NSNumber class]]) {
            return YES;
        }else {
            return NO;
        }
    }
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
- (UIViewController *)getPresentedViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (id)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end

