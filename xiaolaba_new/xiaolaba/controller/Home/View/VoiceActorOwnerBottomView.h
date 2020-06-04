//
//  VoiceActorOwnerBottomView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/11.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBOwnerModel.h"

@interface VoiceActorOwnerBottomView : UIView

@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIButton *addFriend;
@property (nonatomic, strong) UILabel *fllowLabel;
@property (nonatomic, strong) UIButton *addFlow;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) XLBVoiceActorModel *model;
@end
