//
//  MBProgressHUD+SLUtils.h
//  Pods
//
//  Created by smilelu on 16/5/10.
//
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SLUtils)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
+ (void)show:(NSString *)text icon:(NSString *)icon delay:(float)delay view:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end

