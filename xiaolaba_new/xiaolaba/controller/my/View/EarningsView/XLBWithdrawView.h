//
//  XLBWithdrawView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//
typedef NS_ENUM(NSUInteger, WithdrawBtnTag) {
    WithdrawRemindBtnTag = 100,
    WithdrawAccountBtnTag,
    WithdrawWithdrawBtnTag,
};

#import <UIKit/UIKit.h>

@protocol XLBWithdrawViewDelegate <NSObject>
- (void)withdrawButtonClick:(UIButton *)sender;
@end

@interface XLBWithdrawView : UIView
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UITextField *nickTextField;
@property (nonatomic, strong) UITextField *accountTextField;
//@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, copy) NSString *residueMoney;
@property (nonatomic, copy) NSString *aliUserId;
@property (nonatomic, copy) NSString *aliNickname;
@property (nonatomic, weak)id <XLBWithdrawViewDelegate>delegate;

@end
