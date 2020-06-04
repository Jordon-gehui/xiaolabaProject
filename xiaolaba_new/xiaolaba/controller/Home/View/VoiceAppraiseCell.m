//
//  VoiceAppraiseCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceAppraiseCell.h"

@interface VoiceAppraiseCell ()

@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *line;

@end

@implementation VoiceAppraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(VoiceImpressContentModel *)model {
    _model = model;
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.callingImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = 5; // 行距
    muParagraph.paragraphSpacing = 20; // 段距
    NSRange range = NSMakeRange(0, model.assess.length);
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:model.assess];
    [contentText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithR:102 g:102 b:102] range:NSMakeRange(0, model.assess.length)];
    [contentText addAttribute:NSParagraphStyleAttributeName value:muParagraph range:range];
    [contentText addAttribute:NSKernAttributeName value:@(2) range:range];
    self.contentLabel.attributedText = contentText;
    self.nickNameLabel.text = model.callingNickname;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[ZZCHelper dateStringFromNow:model.updateDate]];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubViews];
    }
    return self;
}

- (void)tapUserImgWithModel:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didSeletedUserImgWithModel:)]) {
        [self.delegate didSeletedUserImgWithModel:self.model];
    }
}
- (void)setSubViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.userImg = [UIImageView new];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 18;
    self.userImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self.contentView addSubview:self.userImg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapUserImgWithModel:)];
    [self.userImg addGestureRecognizer:tap];
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.text = @"鹿晗";
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    self.nickNameLabel.textColor = [UIColor assistColor];
    [self.contentView addSubview:self.nickNameLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = [UIColor colorWithR:174 g:181 b:194];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.text = @"6小时前";
    [self.contentView addSubview:self.dateLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    

    
    self.line = [UILabel new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.line];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(20);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.width.height.mas_equalTo(36);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userImg.mas_right).with.offset(10);
        make.top.mas_equalTo(self.userImg.mas_top).with.offset(0);
        make.width.mas_equalTo(kSCREEN_WIDTH - 10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.nickNameLabel.mas_left).with.offset(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.nickNameLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-21);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(0);
        make.left.mas_equalTo(self.nickNameLabel.mas_left);
        make.height.mas_equalTo(@1);
    }];
}

//- (void)layoutSubviews {
//
//}
+ (NSString *)voiceAppraiseCellID {
    return @"voiceAppraiseCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
