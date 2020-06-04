//
//  XLBChatGroupViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseUI/EaseUI.h>

@interface XLBChatGroupViewController : EaseMessageViewController

@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *nickName;
@end
