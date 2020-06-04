//
//  XLBPriceViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"

@protocol XLBPriceViewControllerDelegate <NSObject>

- (void)didSelectedWithDictionary:(NSDictionary *)dict withCarPrice:(NSString *)carPrice withCarPriceValue:(NSString *)value;

@end

@interface XLBPriceViewController : BaseTablePage

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDictionary *seleedDic;
@property (nonatomic, copy) NSString *carPri;
@property (nonatomic, assign) BOOL isAge;
@property (nonatomic, weak) id <XLBPriceViewControllerDelegate>delegate;

@end
