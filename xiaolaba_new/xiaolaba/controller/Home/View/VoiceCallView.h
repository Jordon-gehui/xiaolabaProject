//
//  VoiceCallView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceCallViewDelegate <NSObject>

@optional
- (void)startBtnClick;
- (void)goRecharge;

@end
@interface VoiceCallView : UIView
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, weak) id<VoiceCallViewDelegate>delegate;
- (void)changeStatus;
@end
