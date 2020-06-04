//
//  XLBAlert.m
//  xiaolaba
//
//  Created by lin on 2017/8/2.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBAlertController.h"

@implementation XLBAlertController

+ (UIAlertController *)alertControllerWith:(UIAlertControllerStyle )style items:(NSArray <NSString *>*)items title:(NSString *)title message:(NSString *)message cancel:(BOOL )cancel cancelBlock:(void(^)())cancelBlock itemBlock:(void(^)(NSUInteger index))itemBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            itemBlock(idx);
        }];
        [alertController addAction:alertAction];
    }];
    if(cancel) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            cancelBlock();
        }];
        [alertController addAction:cancel];
    }
    return alertController;
}

@end
