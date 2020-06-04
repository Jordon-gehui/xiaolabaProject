//
//  ChangePhoneView.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/1.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneView : UIView

@property (nonatomic, retain) UILabel *hintL;

@property (nonatomic, retain) UITextField *phoneTextField;

@property (nonatomic, retain) UITextField *validTextField;

@property (nonatomic,retain) UIButton *sendBtn;

- (void) startCountDown;

- (void)stopTimer;
@end
