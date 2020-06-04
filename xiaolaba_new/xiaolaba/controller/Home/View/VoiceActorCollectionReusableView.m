//
//  VoiceActorCollectionReusableView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/3.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceActorCollectionReusableView.h"

@interface VoiceActorCollectionReusableView ()
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *remiV;
@property (nonatomic, strong) UILabel *reminde;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *rightLine;
@end

@implementation VoiceActorCollectionReusableView
- (id)init {
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.header = [UIView new];
    self.header.backgroundColor = [UIColor textBlackColor];
    [self addSubview:self.header];
    self.label = [UILabel new];
    self.label.text = @"我的账户";
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textColor = [UIColor whiteColor];
    [self.header addSubview:self.label];
    
    self.remiV = [UIView new];
    self.remiV.backgroundColor = [UIColor whiteColor];
    [self.header addSubview:self.remiV];
    
    self.accountLabel = [UILabel new];
    self.accountLabel.textColor = [UIColor lightColor];
    self.accountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:45];
    self.accountLabel.tag = 22;
    [self.header addSubview:self.accountLabel];
    
    self.accountSubLabel = [UILabel new];
    self.accountSubLabel.text = @"账户余额(车币)";
    self.accountSubLabel.textColor = [UIColor lightColor];
    self.accountSubLabel.font = [UIFont systemFontOfSize:15];
    [self.header addSubview:self.accountSubLabel];
    
    self.reminde = [UILabel new];
    self.reminde.text = @"请选择充值金额";
    self.reminde.textColor = [UIColor commonTextColor];
    self.reminde.font = [UIFont systemFontOfSize:15];
    [self.remiV addSubview:self.reminde];
    
    self.line = [UILabel new];
    self.line.backgroundColor = [UIColor annotationTextColor];
    [self.remiV addSubview:self.line];
    
    self.rightLine = [UILabel new];
    self.rightLine.backgroundColor = [UIColor annotationTextColor];
    [self.remiV addSubview:self.rightLine];
    
}

- (void)layoutSubviews {
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
            if (iPhoneX) {
                make.height.mas_equalTo(274);
            }else {
                make.height.mas_equalTo(250);
            }
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(self.header.mas_top).with.offset(54);
        }else {
            make.top.mas_equalTo(self.header.mas_top).with.offset(30);
        }
        make.centerX.mas_equalTo(self.header.mas_centerX).with.offset(0);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).with.offset(30);
        make.centerX.mas_equalTo(self.header.mas_centerX).with.offset(0);
    }];
    
    [self.accountSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountLabel.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.header.mas_centerX).with.offset(0);
    }];
    
    [self.remiV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.header.mas_bottom).with.offset(5);
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.header.mas_centerX);
    }];
    
    [self.reminde mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.remiV.mas_centerX).with.offset(0);
        make.centerY.mas_equalTo(self.remiV.mas_centerY).with.offset(0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remiV.mas_left).with.offset(25);
        make.right.mas_equalTo(self.reminde.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self.reminde.mas_centerY).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reminde.mas_right).with.offset(5);
        make.right.mas_equalTo(self.remiV.mas_right).with.offset(-25);
        make.centerY.mas_equalTo(self.reminde.mas_centerY).with.offset(0);
        make.height.mas_equalTo(1);
    }];
}
+ (NSString *)voiceActorHeaderView {
    return @"voiceActorHeaderView";
}
@end
