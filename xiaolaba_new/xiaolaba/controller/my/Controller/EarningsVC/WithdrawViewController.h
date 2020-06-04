//
//  WithdrawViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBWithdrawView.h"

@interface WithdrawViewController : BaseViewController
@property (nonatomic, copy) NSString *residueMoney;
@property (nonatomic, copy) NSString *aliNickname;
@property (nonatomic, copy) NSString *aliUserId;
@property (nonatomic, strong) XLBWithdrawView *withdrawV;

@end
