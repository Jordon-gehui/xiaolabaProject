//
//  VoiceActorOwnerBottomView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/11.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceActorOwnerBottomView.h"
@interface VoiceActorOwnerBottomView ()

@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UILabel *addFriendLabel;
@property (nonatomic, strong) UILabel *callLabel;
@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, strong) UIView *line;


@end
@implementation VoiceActorOwnerBottomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setMoney:(NSString *)money {
    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
        self.callLabel.text = @"呼叫";
    }else {
        self.callLabel.text = [NSString stringWithFormat:@"%@车币/分钟",money];
    }
    _money = money;
}

- (void)setModel:(XLBVoiceActorModel *)model {
    if ([model.user.friends isEqualToString:@"0"]) {
        self.sendLabel.text = @"打招呼";
    }else {
        self.sendLabel.text = @"发消息";
    }
    if ([model.user.follows isEqualToString:@"0"]) {
        self.fllowLabel.text = @"加关注";
        [self.addFlow setImage:[UIImage imageNamed:@"icon_gz_v"] forState:UIControlStateNormal];
    }else {
        self.fllowLabel.text = @"已关注";
        [self.addFlow setImage:[UIImage imageNamed:@"icon_ygz"] forState:UIControlStateNormal];
    }
    
    _model = model;
}
- (void)setSubViews {
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self addSubview:self.line];
    
    self.callBtn = [UIButton new];
    self.callBtn.layer.masksToBounds = YES;
    self.callBtn.layer.cornerRadius = 60;
    [self.callBtn setImage:[UIImage imageNamed:@"btn_th_h"] forState:UIControlStateNormal];
    [self.callBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.callBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.callBtn];
    self.callBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.callBtn setImageEdgeInsets:UIEdgeInsetsMake(-15.0, self.callBtn.imageView.bounds.size.width + 5,0.0, -self.callBtn.titleLabel.bounds.size.width)];
    [self.callBtn setTitleEdgeInsets:UIEdgeInsetsMake(60.0,-self.callBtn.imageView.bounds.size.width, 0.0,0.0)];
    self.sendBtn = [UIButton new];

    [self.sendBtn setTitleColor:[UIColor colorWithR:165 g:166 b:187] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.sendBtn setImage:[UIImage imageNamed:@"icon_dzh_v"] forState:UIControlStateNormal];
    [self addSubview:self.sendBtn];

    self.addFriend = [UIButton new];
    [self.addFriend setImage:[UIImage imageNamed:@"icon_jhy"] forState:UIControlStateNormal];
    [self.addFriend setTitleColor:[UIColor colorWithR:165 g:166 b:187] forState:UIControlStateNormal];
    self.addFriend.titleLabel.font = [UIFont systemFontOfSize:11];

    [self addSubview:self.addFriend];

    self.addFlow = [UIButton new];
    [self.addFlow setImage:[UIImage imageNamed:@"icon_gz_v"] forState:UIControlStateNormal];
    [self.addFlow setTitleColor:[UIColor colorWithR:165 g:166 b:187] forState:UIControlStateNormal];
    self.addFlow.titleLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.addFlow];

    self.shareBtn = [UIButton new];
    [self.shareBtn setImage:[UIImage imageNamed:@"icon_fx_v"] forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor colorWithR:165 g:166 b:187] forState:UIControlStateNormal];

    [self addSubview:self.shareBtn];
    
    self.callLabel = [UILabel new];
    self.callLabel.textColor = [UIColor textBlackColor];
    self.callLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.callLabel];
    
    self.sendLabel = [UILabel new];
    self.sendLabel.textColor = [UIColor colorWithR:165 g:166 b:187];
    self.sendLabel.font = [UIFont systemFontOfSize:11];
    self.sendLabel.text = @"打招呼";
    [self addSubview:self.sendLabel];
    
    self.addFriendLabel = [UILabel new];
    self.addFriendLabel.textColor = [UIColor colorWithR:165 g:166 b:187];
    self.addFriendLabel.font = [UIFont systemFontOfSize:11];
    self.addFriendLabel.text = @"加好友";
    [self addSubview:self.addFriendLabel];
    
    self.fllowLabel = [UILabel new];
    self.fllowLabel.textColor = [UIColor colorWithR:165 g:166 b:187];
    self.fllowLabel.font = [UIFont systemFontOfSize:11];
    self.fllowLabel.text = @"加关注";
    [self addSubview:self.fllowLabel];
    
    self.shareLabel = [UILabel new];
    self.shareLabel.textColor = [UIColor colorWithR:165 g:166 b:187];
    self.shareLabel.font = [UIFont systemFontOfSize:11];
    self.shareLabel.text = @"分享";
    [self addSubview:self.shareLabel];
}

- (void)layoutSubviews {
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
        make.width.mas_equalTo(self.mas_width).with.offset(0);
        make.height.mas_equalTo(0.7);
    }];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.line.mas_centerY).with.offset(10);
        make.width.height.mas_equalTo(120);
        make.centerX.mas_equalTo(self.mas_centerX).with.offset(0);
    }];

    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(-5);
        make.right.mas_equalTo(self.callBtn.mas_left).with.offset(5);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.addFriend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(-5);
        make.right.mas_equalTo(self.sendBtn.mas_left).with.offset(-10);
        make.width.height.mas_equalTo(self.sendBtn);
    }];
    
    [self.addFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(-5);
        make.left.mas_equalTo(self.callBtn.mas_right).with.offset(-5);
        make.width.height.mas_equalTo(self.sendBtn);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(-5);
        make.left.mas_equalTo(self.addFlow.mas_right).with.offset(10);
        make.width.height.mas_equalTo(self.sendBtn);
    }];
    
    [self.callLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.callBtn.mas_centerX).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sendBtn.mas_centerX).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
    }];
    
    [self.addFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.addFriend.mas_centerX).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
    }];
    
    [self.fllowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.addFlow.mas_centerX).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
    }];
    
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.shareBtn.mas_centerX).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
    }];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.callBtn convertPoint:point fromView:self];
    if ([self.callBtn pointInside:buttonPoint withEvent:event]) {
        return self.callBtn;
    }
    return result;
}
@end
