//
//  VoiceImpressCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceImpressCollectionViewCell.h"
@interface VoiceImpressCollectionViewCell ()



@end


@implementation VoiceImpressCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    
    
    
    self.impressLabel = [UILabel new];
    self.impressLabel.text = @"声音甜美";
    self.impressLabel.layer.masksToBounds = YES;
    self.impressLabel.layer.cornerRadius = 5;
    self.impressLabel.textColor = [UIColor minorTextColor];
    self.impressLabel.font = [UIFont systemFontOfSize:14];
    self.impressLabel.textAlignment = NSTextAlignmentCenter;
    self.impressLabel.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.contentView addSubview:self.impressLabel];
    
    self.impressImg = [UIImageView new];
    self.impressImg.image = [UIImage imageNamed:@"btn_xz_h"];
    [self.contentView addSubview:self.impressImg];
    
    
}

- (void)layoutSubviews {
    
    [self.impressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(1);
        make.bottom.right.mas_equalTo(-1);

    }];
    
    [self.impressImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

+ (NSString *)voiceImpressCellID {
    return @"voiceImpressCellID";
}
@end
