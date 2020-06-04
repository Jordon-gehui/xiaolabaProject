//
//  BaseViewController.h
//  IMMPapp
//
//  Created by jackzhang on 2017/7/3.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLNavigationBar.h"
#import "MBProgressHUD+SLUtils.h"
#import "CSRouter.h"
#import "NetWorking.h"
#import "XLBRefreshGifHeader.h"

typedef void (^RetrunBlock)(id data);

@interface BaseViewController : UIViewController

@property (nonatomic, retain) SLNavigationBar *naviBar;

@property (nonatomic, assign) BOOL translucentNav;//是否设置透明导航栏
@property (nonatomic, assign) BOOL hiddenNav;

@property (nonatomic, copy)RetrunBlock returnBlock;

/**
 *初始化导航栏按钮
 **/
-(void)initNaviBar;

-(void)backClick:(id)sender;

- (void) showHudWithText:(NSString *)text;

- (void) hideHud;
@end
