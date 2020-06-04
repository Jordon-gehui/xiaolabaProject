//
//  XLBGroupDetailTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/1.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupDetailTableViewCell.h"

@interface XLBGroupDetailTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation XLBGroupDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setAnnouncementStr:(NSString *)announcementStr {
    _announcementStr = announcementStr;
    if (kNotNil(announcementStr)) {
        self.announcement.text = [NSString stringWithFormat:@"%@",announcementStr];
    }else {
        self.announcement.text = @"";
    }
}
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.titleLabel.text = dict[@"title"];
    if ([dict[@"title"] isEqualToString:@"群头像"]) {
        self.switchCell.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.rightImg.hidden = NO;
        self.img.layer.borderWidth = 1;
        self.img.layer.borderColor = [UIColor colorWithR:174 g:181 b:194].CGColor;
    }else if ([dict[@"title"] isEqualToString:@"群名称"]) {
        self.switchCell.hidden = YES;
        self.img.hidden = YES;
        self.rightImg.hidden = NO;
    }else if ([dict[@"title"] isEqualToString:@"群公告"]) {
        self.switchCell.hidden = YES;
        self.rightImg.hidden = NO;
        self.img.hidden = YES;
        self.subTitleLabel.hidden = YES;
    }else if ([dict[@"title"] isEqualToString:@"分享群"]) {
        self.switchCell.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.rightImg.hidden = NO;
        self.img.layer.borderColor = [UIColor whiteColor].CGColor;
    }else if ([dict[@"title"] isEqualToString:@"我的群昵称"]) {
        self.switchCell.hidden = YES;
        self.img.hidden = YES;
        self.rightImg.hidden = NO;
    }else if ([dict[@"title"] isEqualToString:@"置顶该消息"]) {
        self.img.hidden = YES;
        self.rightImg.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.switchCell.hidden = NO;
    }else if ([dict[@"title"] isEqualToString:@"消息免打扰"]) {
        self.img.hidden = YES;
        self.rightImg.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.switchCell.hidden = NO;
    }else if ([dict[@"title"] isEqualToString:@"设置管理员"]) {
        self.img.hidden = YES;
        self.switchCell.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.rightImg.hidden = NO;
    }else if ([dict[@"title"] isEqualToString:@"允许群被搜索"]) {
        self.img.hidden = YES;
        self.rightImg.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.switchCell.hidden = NO;

    }else if ([dict[@"title"] isEqualToString:@"允许群成员拉人进群"]) {
        self.img.hidden = YES;
        self.rightImg.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.switchCell.hidden = NO;
    }
}
- (void)setSubViews {
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor commonTextColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.rightImg = [UIImageView new];
    self.rightImg.image = [UIImage imageNamed:@"icon_wd_fh"];
    [self.contentView addSubview:self.rightImg];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = [UIFont systemFontOfSize:15];
    self.subTitleLabel.textColor = [UIColor minorTextColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.subTitleLabel];
    
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 20;
    self.img.image = [UIImage imageNamed:@"xlbdl"];
    [self.contentView addSubview:self.img];
    
    self.announcement = [UILabel new];
    self.announcement.font = [UIFont systemFontOfSize:15];
    self.announcement.textColor = [UIColor minorTextColor];
    self.announcement.numberOfLines = 2;
    [self.contentView addSubview:self.announcement];

    self.switchCell = [UISwitch new];
    self.switchCell.on = YES;
    [self.contentView addSubview:self.switchCell];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.line];
    

    
}

- (void)layoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13.5);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).with.offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.announcement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-25);
    }];
    
    [self.switchCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
        make.right.mas_equalTo(0);
    }];
}


+ (NSString *)groupDetailCellID {
    return @"groupDetailCellID";
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
