//
//  XLBAddManagerViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import <EaseUI/EaseUI.h>

@interface XLBAddManagerViewController : SearchViewController

@property (nonatomic, strong) EMGroup *groupDetail;
@property (nonatomic, strong) NSArray *memberList;
@end
