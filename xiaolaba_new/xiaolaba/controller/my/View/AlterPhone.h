//
//  ChangePhoneView.h
//  xiaolaba
//
//
//  Created by 戴葛辉 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  AlterPhone: UIView

@property (nonatomic, retain) UILabel *hintL;

@property (nonatomic, retain) UITextField *phoneTextField;

@property (nonatomic, retain) UITextField *validTextField;

@property (nonatomic,retain) UIButton *sendBtn;

- (void) startCountDown;

- (void)stopTimer;
@end
