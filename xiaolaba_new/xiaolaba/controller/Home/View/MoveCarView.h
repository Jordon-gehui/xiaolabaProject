//
//  MoveCarView.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddImageView.h"
#import "SZTextView.h"

@interface MoveCarView : UIView
@property (nonatomic, strong) SZTextView *textView;

@property (nonatomic, strong) UITextField *carNoText;
@property (nonatomic, strong) UITextField *carLocText;

@property(nonatomic , strong)AddImageView *addImageView;

@property (nonatomic, strong) UIButton *carSureBtn;

@end
