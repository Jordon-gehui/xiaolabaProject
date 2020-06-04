//
//  VoiceSreenCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceSreenCollectionViewCell.h"
@interface VoiceSreenCollectionViewCell ()

@property (nonatomic, strong) UILabel *priceLabel;


@end
@implementation VoiceSreenCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setPriceDict:(NSDictionary *)priceDict {
    _priceDict = priceDict;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",priceDict[@"label"]];
}
- (void)setSubViews {
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"200-300";
    self.priceLabel.textColor = [UIColor minorTextColor];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.layer.masksToBounds = YES;
    self.priceLabel.layer.cornerRadius = 5;
    self.priceLabel.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.contentView addSubview:self.priceLabel];
    
    self.img = [UIImageView new];
    self.img.image = [UIImage imageNamed:@"btn_xz_h"];
    [self.contentView addSubview:self.img];
    

    
}
- (void)layoutSubviews {
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(1);
        make.right.bottom.mas_equalTo(-1);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}
+ (NSString *)voiceScreenCellID {
    return @"voiceScreenCellID";
}
@end
