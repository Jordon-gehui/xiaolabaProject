//
//  VoiceActorHeaderView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "XLBDEvaluateView.h"
#import "XLBOwnerModel.h"

@protocol VoiceActorOwnerHeadViewDelegate <NSObject>

@optional
- (void)showImage;

@end
@interface VoiceActorHeaderView : UIView

@property (nonatomic, weak) id<VoiceActorOwnerHeadViewDelegate> delegate;

//@property (nonatomic, strong) UIButton *friendBtn;
//@property (nonatomic, strong) UIButton *imgBtn;
//@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIButton *portraitBtn;
@property (nonatomic, strong) UIImageView *ownerImg;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UILabel *praiseCountLabel;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIImageView *videoImg;

@property (nonatomic, strong) XLBVoiceActorModel *model;

@end
