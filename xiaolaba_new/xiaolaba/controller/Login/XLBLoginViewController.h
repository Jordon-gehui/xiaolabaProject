//
//  XLBLoginViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/11.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"
#import "LRButton.h"

@interface XLBLoginViewController : BaseViewController

@property (nonatomic, copy) RetrunBlock closeBlock;
/**
 0：普通登陆页面1：第三方登陆页面
 */

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *isFind;
@property (nonatomic, copy) NSString *isSina;
- (IBAction)weChatClick:(UIButton *)sender;
- (IBAction)sinaClick:(UIButton *)sender;

- (XLBLoginViewController *) openWithController:(UIViewController *)vc Withtag:(NSInteger)tag;
- (XLBLoginViewController *) openWithController:(UIViewController *)vc returnBlock:(RetrunBlock) returnBlock;
@end
