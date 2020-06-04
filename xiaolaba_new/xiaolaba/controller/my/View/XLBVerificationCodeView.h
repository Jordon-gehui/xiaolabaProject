//
//  XLBVerificationCodeView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/8.
//  Copyright © 2017年 jackzhang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface XLBVerificationCodeView : UIView<UITextFieldDelegate>
@property (nonatomic, copy) void(^passwordBlock)(NSString *password);

/**
 *  清除密码
 */
- (void)clearUpPassword;

@end
