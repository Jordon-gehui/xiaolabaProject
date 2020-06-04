//
//  XLBAlert.h
//  xiaolaba
//
//  Created by lin on 2017/8/2.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBAlertController : NSObject

+ (UIAlertController *)alertControllerWith:(UIAlertControllerStyle )style items:(NSArray <NSString *>*)items title:(NSString *)title message:(NSString *)message cancel:(BOOL )cancel cancelBlock:(void(^)())cancelBlock itemBlock:(void(^)(NSUInteger index))itemBlock;

@end
