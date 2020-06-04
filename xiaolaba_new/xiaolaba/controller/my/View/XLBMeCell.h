//
//  XLBMeCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/19.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBMeCell : UITableViewCell

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSDictionary *keyValue;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *cer;

@end
