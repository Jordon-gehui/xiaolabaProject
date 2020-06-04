//
//  TaskDetailListTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/27.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "TaskDetailListTableViewCell.h"

@interface TaskDetailListTableViewCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation TaskDetailListTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews {
    self.statusLabel = [UILabel new];
    self.statusLabel.text = @"车币入账";
    self.statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    self.statusLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.statusLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.text = @"首次充值";
    self.contentLabel.textColor = [UIColor textBlackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.contentLabel];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"+ 200";
    self.moneyLabel.textColor = [UIColor redColor];
    self.moneyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [self.contentView addSubview:self.moneyLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = [UIColor annotationTextColor];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.text = @"2017年1月27日 13:30:20";
    [self.contentView addSubview:self.dateLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusLabel.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY).with.offset(0);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-15);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.statusLabel.mas_left).with.offset(0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
}
+ (NSString *)taskDetailListCell {
    return @"taskDetailListCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
