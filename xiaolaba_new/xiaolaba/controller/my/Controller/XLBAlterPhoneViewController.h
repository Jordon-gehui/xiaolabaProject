//
//  XLBAlterPhoneViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^RetrunBlock)(id telePhone);

@interface XLBAlterPhoneViewController : BaseViewController

@property (nonatomic, copy)NSString *telePhone;

@property (nonatomic,copy)RetrunBlock block;

@end
