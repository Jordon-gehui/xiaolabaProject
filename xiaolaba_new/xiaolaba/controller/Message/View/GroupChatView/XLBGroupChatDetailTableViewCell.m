//
//  XLBGroupChatDetailTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupChatDetailTableViewCell.h"

@interface XLBGroupChatDetailTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UISwitch *cellSwitch;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation XLBGroupChatDetailTableViewCell

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",titleStr];
    if ([titleStr isEqualToString:@"群头像"]) {
        self.cellSwitch.hidden = YES;
        self.subLabel.hidden = YES;
    }else if ([titleStr isEqualToString:@"群名称"]) {
        self.cellSwitch.hidden = YES;
        self.imgView.hidden = YES;
    }else if ([titleStr isEqualToString:@"群公告"]) {
        self.cellSwitch.hidden = YES;
        self.subLabel.hidden = YES;
        self.imgView.hidden = YES;
    }else if ([titleStr isEqualToString:@"分享群"]) {
        self.cellSwitch.hidden = YES;
        self.subLabel.hidden = YES;
    }else if ([titleStr isEqualToString:@"我的群昵称"]) {
        self.cellSwitch.hidden = YES;
        self.imgView.hidden = YES;
    }else if ([titleStr isEqualToString:@"置顶该消息"]) {
        self.rightImg.hidden = YES;
        self.subLabel.hidden = YES;
        self.imgView.hidden = YES;

    }else if ([titleStr isEqualToString:@"消息免打扰"]) {
        self.rightImg.hidden = YES;
        self.subLabel.hidden = YES;
        self.imgView.hidden = YES;
    }else if ([titleStr isEqualToString:@"设置管理员"]) {
        self.subLabel.hidden = YES;
        self.imgView.hidden = YES;
        self.cellSwitch.hidden = YES;
    }else if ([titleStr isEqualToString:@"允许群被搜索"]) {
        self.rightImg.hidden = YES;
        self.subLabel.hidden = YES;
        self.imgView.hidden = YES;
    }else if ([titleStr isEqualToString:@"允许群成员拉人进群"]) {
        self.rightImg.hidden = YES;
        self.subLabel.hidden = YES;
        self.imgView.hidden = YES;
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = [NSString stringWithFormat:@"%@",content];
}
- (void)setRow:(NSInteger)row {
    
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
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor textBlackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.rightImg = [UIImageView new];
    self.rightImg.image = [UIImage imageNamed:@"icon_wd_fh"];
    [self.contentView addSubview:self.rightImg];
    
    self.subLabel = [UILabel new];
    self.subLabel.textColor = [UIColor textBlackColor];
    self.subLabel.font = [UIFont systemFontOfSize:15];
    self.subLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.subLabel];
    
    self.imgView = [UIImageView new];
    self.imgView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.imgView];
    
    self.cellSwitch = [UISwitch new];
    [self.contentView addSubview:self.cellSwitch];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = [UIColor textBlackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.line];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(15);
    }];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightImg.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.right.mas_equalTo(self.rightImg.mas_left).with.offset(-5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-11);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(0);
        make.height.mas_equalTo(0.7);
    }];
}

//- (void)layoutSubviews {
//
//}

+ (NSString *)groupChatDetailCellID {
    return @"groupChatDetailCellID";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
