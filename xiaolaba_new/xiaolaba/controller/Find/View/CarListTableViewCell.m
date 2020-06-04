//
//  CarListTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/19.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "CarListTableViewCell.h"

@interface CarListTableViewCell ()



@property (nonatomic, strong)UILabel *line;
@end

@implementation CarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return  self;
}


- (void)setSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.line = [UILabel new];
    self.line.backgroundColor = [UIColor lineColor];
    [self addSubview:self.line];
    
    self.carImage = [UIImageView new];
//    self.carImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.carImage];
    
    self.carName = [UILabel new];
    [self addSubview:self.carName];
    
    self.seleImage = [UIImageView new];
    [self addSubview:self.seleImage];
    
    
}

- (void)layoutSubviews {
    kWeakSelf(self);
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [weakSelf.carImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    
    [weakSelf.carName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.carImage.mas_right).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.carImage.mas_centerY);
    }];
    
    [weakSelf.seleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-50);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(12);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
