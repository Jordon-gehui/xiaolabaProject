//
//  MsgSystemImgCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MsgSystemImgCell.h"
#import <WebKit/WebKit.h>
@interface MsgSystemImgCell()

@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation MsgSystemImgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor viewBackColor];
        [self setSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModel:(XLBSystemMsgModel *)model {
    CGFloat height = [model.summary sizeWithMaxWidth:(kSCREEN_WIDTH-60) font:[UIFont systemFontOfSize:13]].height;
    if (kNotNil(model.img)) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).with.offset(15);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
            make.height.mas_equalTo(235 + height);
            make.bottom.mas_equalTo(5);
        }];
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateLabel.mas_bottom).with.offset(8);
            make.left.mas_equalTo(self.topLabel.mas_left).with.offset(0);
            make.right.mas_equalTo(self.dateLabel.mas_right);
        }];
    }else {
        [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).with.offset(15);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
            make.height.mas_equalTo(85 + height);
            make.bottom.mas_equalTo(5);
        }];
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateLabel.mas_bottom).with.offset(8);
            make.left.mas_equalTo(self.topLabel.mas_left).with.offset(0);
            make.right.mas_equalTo(self.dateLabel.mas_right);
        }];
    }
    
    self.contentLabel.text = model.summary;
    self.dateLabel.text = model.createDate;
    self.topLabel.text = model.title;
    [self layoutIfNeeded];
}

- (void)setSubViews {
    self.bgV = [UIView new];
    self.bgV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgV];
    
    self.topLabel = [UILabel new];
    self.topLabel.text = @"新版本更新";
    self.topLabel.font = [UIFont systemFontOfSize:15];
    self.topLabel.textColor = [UIColor blackColor];
    self.topLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgV addSubview:self.topLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textColor = [UIColor annotationTextColor];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.text = @"8-20 09:00";
    [self.bgV addSubview:self.dateLabel];
    

    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.textColor = [UIColor minorTextColor];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.text = @"据说还没有批诏安嘎达苏大叔哒哒哒哒是大 sad大叔哒哒哒";
    self.contentLabel.numberOfLines = 0;
    [self.bgV addSubview:self.contentLabel];
    
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 5;
    [self.bgV addSubview:self.img];
    
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor lineColor];
    [self.bgV addSubview:self.lineV];
    
    self.bottomLabel = [UILabel new];
    self.bottomLabel.textColor = [UIColor annotationTextColor];
    self.bottomLabel.text = @"查看详情";
    self.bottomLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomLabel.font = [UIFont systemFontOfSize:13];
    [self.bgV addSubview:self.bottomLabel];
    
    self.rightImg = [UIImageView new];
    self.rightImg.image = [UIImage imageNamed:@"icon_right"];
    [self.bgV addSubview:self.rightImg];
}

- (void)layoutSubviews {
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgV.mas_top).with.offset(15);
        make.left.mas_equalTo(self.bgV.mas_left).with.offset(15);
        make.right.lessThanOrEqualTo(self.dateLabel.mas_left).with.offset(3);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgV.mas_top).with.offset(15);
        make.right.mas_equalTo(self.bgV.mas_right).with.offset(-15);
    }];
    
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(self.topLabel.mas_left).with.offset(0);
        make.right.mas_equalTo(self.dateLabel.mas_right).with.offset(0);
        make.centerX.mas_equalTo(self.bgV.mas_centerX);
        make.height.mas_equalTo(140);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(self.bgV.mas_left).with.offset(0);
        make.right.mas_equalTo(self.bgV.mas_right).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineV.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.bgV.mas_left).with.offset(15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.bgV.mas_bottom).with.offset(-10);
    }];
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomLabel.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.bgV.mas_right).with.offset(-15);
        make.width.height.mas_equalTo(15);
    }];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (NSString *)msgSystemImgCellID {
    return @"msgSystemImgCellID";
}

@end
