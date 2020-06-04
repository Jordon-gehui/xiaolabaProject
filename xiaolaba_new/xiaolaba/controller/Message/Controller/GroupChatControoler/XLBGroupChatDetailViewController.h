//
//  XLBGroupChatDetailViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseUI/EaseUI.h>
#import "BaseScrollPage.h"

@interface XLBGroupChatDetailViewController : BaseViewController

@property (nonatomic, strong) EMGroup *groupDetail;
@property (nonatomic, copy) NSString *groupID;
@end
