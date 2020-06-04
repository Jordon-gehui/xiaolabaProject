//
//  LittleDetailViewController.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleHornTableViewModel.h"
#import "BaseViewController.h"

@interface LittleDetailViewController :BaseViewController

@property (nonatomic,strong) LittleHornTableViewModel *detailModel;
@property (nonatomic,copy) NSString *type;
@end
