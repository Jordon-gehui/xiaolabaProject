//
//  XLBJoinGroupViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/9.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseScrollPage.h"
#import <EaseUI/EaseUI.h>
@interface XLBJoinGroupViewController : BaseScrollPage

@property (nonatomic, strong) EMGroup *groupDetail;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *owner;

@end
