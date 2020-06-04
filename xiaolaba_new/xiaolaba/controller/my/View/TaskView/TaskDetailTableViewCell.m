//
//  TaskDetailTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/27.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "TaskDetailTableViewCell.h"
@interface TaskDetailTableViewCell()
@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation TaskDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor viewBackColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.bgV = [UIView new];
    self.bgV.layer.masksToBounds = YES;
    self.bgV.layer.cornerRadius = 5;
    self.bgV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgV];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.text = @"首次充值";
    self.contentLabel.textColor = [UIColor textBlackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    [self.bgV addSubview:self.contentLabel];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"+ 2.0车币";
    self.moneyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.moneyLabel.textColor = [UIColor redColor];
    [self.bgV addSubview:self.moneyLabel];
    
    self.countLabel = [UILabel new];
    self.countLabel.text = @"1次/天";
    self.countLabel.textColor = [UIColor textBlackColor];
    self.countLabel.font = [UIFont systemFontOfSize:12];
    [self.bgV addSubview:self.countLabel];
    
//    self.line = [UIView new];
//    self.line.backgroundColor = [UIColor lineColor];
//    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(10);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-5);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.contentLabel.mas_left).with.offset(0);
    }];
    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.mas_equalTo(0);
//        make.left.mas_equalTo(15);
//        make.height.mas_equalTo(0.7);
//    }];
}
+ (NSString *)taskDetailCell {
    return @"taskDetailCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
