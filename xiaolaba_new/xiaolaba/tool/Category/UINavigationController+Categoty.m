//
//  UINavigationController+Categoty.m
//  IMMPapp
//
//  Created by jackzhang on 2017/7/4.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "UINavigationController+Categoty.h"

@implementation UINavigationController (Categoty)



- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    item.backBarButtonItem = back;
    
    return YES;
    
}
@end
