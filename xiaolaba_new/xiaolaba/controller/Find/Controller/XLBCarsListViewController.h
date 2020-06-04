//
//  XLBCarsListViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/5.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"

@protocol XLBCarsListViewControllerDelegate <NSObject>

- (void)seletedCarSeableWithDict:(NSMutableDictionary *)seableDic;

@end

@interface XLBCarsListViewController : BaseViewController

@property (nonatomic, weak) id <XLBCarsListViewControllerDelegate>delegate;

@property (nonatomic, strong) NSDictionary *seleDic;

@property (nonatomic, strong) NSArray *items;

@end
