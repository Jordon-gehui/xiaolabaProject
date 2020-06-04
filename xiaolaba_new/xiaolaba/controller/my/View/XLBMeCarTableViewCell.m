//
//  XLBMeCarTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/10/27.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMeCarTableViewCell.h"

@interface XLBMeCarTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation XLBMeCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle= UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)setMeCarList:(NSDictionary *)meCarList {
    
    self.titleLabel.text = meCarList[@"title"];
    _meCarList = meCarList;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            self.subTitleLabel.text = self.meCarList[@"owner"];
        }
            break;
        case 1: {
            self.subTitleLabel.text = self.meCarList[@"plateNumber"];
        }
            break;
        case 2: {
            self.subTitleLabel.text = self.meCarList[@"vehicleAreaName"];
        }
            break;
        case 3: {
            self.subTitleLabel.text = self.meCarList[@"model"];
        }
            break;
            
        default:
            break;
    }
}
- (void)setSubViews {
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#3c3c3c"];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.textColor = RGB(166, 166, 166);
    self.subTitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.subTitleLabel];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.lineV];

}

- (void)layoutSubviews {
    
    kWeakSelf(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
        make.bottom.mas_equalTo(0);
    }];
}

+ (NSString *)cellMeCarID {
    return @"cellMeCarID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
