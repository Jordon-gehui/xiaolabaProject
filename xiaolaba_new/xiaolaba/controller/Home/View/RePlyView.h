//
//  RePlyView.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/19.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface RePlyView : UIView

@property (nonatomic,strong)SZTextView *textView;

@property (nonatomic,strong)UIButton *sendBtn;
@property (nonatomic,strong)UIButton *closeBtn;

- (instancetype)initWithArr:(NSArray*)array;

@end
