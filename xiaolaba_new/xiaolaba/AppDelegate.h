//
//  AppDelegate.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)createTabBarController;

-(void)showMoveOverViewWithMoveCarID:(NSString*)carId;
@end

