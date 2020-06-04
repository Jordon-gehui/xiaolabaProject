//
//  SLNavigationBar.h
//  Micfunding
//
//  Created by smilelu on 16/8/13.
//  Copyright © 2016年 smilelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBarButtonItem.h"

@interface SLNavigationBar : UIView

@property (nonatomic, retain) UIView *slTitleView;

@property (nonatomic, retain) UILabel *slTitleLabel;

@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) UIView *leftItem;

@property (nonatomic, retain) NSArray *leftItems;

@property (nonatomic, retain) UIView *rightItem;

@property (nonatomic, retain) NSArray *rightItems;

@property (nonatomic, retain) UIColor *naviBgColor;
@property (nonatomic, retain) UIColor *naviTintColor;

@end
