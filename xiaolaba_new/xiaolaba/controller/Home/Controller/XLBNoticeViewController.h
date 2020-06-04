//
//  XLBNoticeViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/13.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"

@interface XLBNoticeViewController : BaseViewController

@property (nonatomic,copy)NSString*userId;
@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,assign)NSUInteger timeDown;
@property (nonatomic,assign)BOOL isVerify;
@property (nonatomic,copy)NSString *moveCarId;

@end
