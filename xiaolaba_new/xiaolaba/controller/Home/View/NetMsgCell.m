//
//  NetMsgCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/10/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "NetMsgCell.h"

@interface NetMsgCell()
{
    UIImageView *headImg;
    UILabel *nickName;
    UILabel *dataLbl;
    UIImageView *backImg;
    UILabel *contentLbl;
    UIImage * senderImg;
    UIImage * chaterImg;
    UITableViewCellStyle cellStyle;
}
@end

//UITableViewCellStyleDefault 收到消息
//其他是发送消息

@implementation NetMsgCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViewWith:style];
        cellStyle = style;
    }
    return self;
}
-(void)initViewWith:(UITableViewCellStyle)style{
    if (style ==UITableViewCellStyleDefault) {
        chaterImg = [UIImage imageNamed:@"chat_receiver_bg"];
        headImg = [UIImageView new];
        headImg.layer.cornerRadius = 20;
        headImg.layer.masksToBounds = YES;
        [self addSubview:headImg];
        
        nickName = [UILabel new];
        nickName.textColor = [UIColor grayColor];
        nickName.font = [UIFont systemFontOfSize:10];
        [self addSubview:nickName];
        
        dataLbl = [UILabel new];
        dataLbl.textColor = [UIColor grayColor];
        dataLbl.font = [UIFont systemFontOfSize:10];
        [self addSubview:dataLbl];
        
        backImg = [UIImageView new];
        
        UIImage *image = chaterImg;
        NSInteger leftCapWidth = image.size.width * 0.5;
        NSInteger topCapHeight = image.size.height * 0.5;
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        backImg.image =newImage;
        [self addSubview:backImg];
        
        contentLbl = [UILabel new];
        contentLbl.font = [UIFont systemFontOfSize:15];
        contentLbl.textColor = [UIColor blackColor];
        contentLbl.numberOfLines = 0;
        [backImg addSubview:contentLbl];
    }else {
        senderImg = [UIImage imageNamed:@"chat_sender_bg"];
        
        headImg = [UIImageView new];
        headImg.layer.cornerRadius = 20;
        headImg.layer.masksToBounds = YES;
        [self addSubview:headImg];
        
        nickName = [UILabel new];
        nickName.textColor = [UIColor grayColor];
        nickName.textAlignment = NSTextAlignmentRight;
        nickName.font = [UIFont systemFontOfSize:10];
        [self addSubview:nickName];
        
        dataLbl = [UILabel new];
        dataLbl.textColor = [UIColor grayColor];
        dataLbl.font = [UIFont systemFontOfSize:10];
        dataLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:dataLbl];
        
        backImg = [UIImageView new];
        
        UIImage *image = senderImg;
        NSInteger leftCapWidth = image.size.width * 0.5;
        NSInteger topCapHeight = image.size.height * 0.5;
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        backImg.image =newImage;
        [self addSubview:backImg];
        
        contentLbl = [UILabel new];
        contentLbl.font = [UIFont systemFontOfSize:15];
        contentLbl.textColor = [UIColor blackColor];
        contentLbl.numberOfLines = 0;
        contentLbl.textAlignment = NSTextAlignmentRight;
        [backImg addSubview:contentLbl];
    }
}
-(void)setDate:(NSDictionary*)dic {
    if (kNotNil(dic[@"nickname"])) {
        nickName.text = dic[@"nickname"];
    }else{
        nickName.text = @"匿名";
    }
    if (kNotNil(dic[@"img"])) {
        [headImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:dic[@"img"] Withtype:IMGAvatar]]];
    }else
    headImg.image = [UIImage imageNamed:@"weitouxiang"];
    
    if (kNotNil(dic[@"noticeDate"])) {
        dataLbl.text = dic[@"noticeDate"];
    }else{
        dataLbl.text = @"";

    }
    contentLbl.text = dic[@"message"];
    
    [self layoutIfNeeded];
}

-(void)layoutSubviews {
    if (cellStyle == UITableViewCellStyleDefault) {
        [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self).with.offset(10);
            make.width.height.mas_equalTo(40);
        }];
        [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headImg.mas_right).with.offset(5);
            make.top.mas_equalTo(self).with.offset(10);
        }];
        [dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nickName);
            make.left.mas_equalTo(nickName.mas_right).with.offset(15);
        }];
        
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nickName).with.offset(15);
            make.top.mas_equalTo(nickName.mas_bottom).with.offset(15);
            make.right.lessThanOrEqualTo(self).with.offset(-25);
        }];
        [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nickName);
            make.top.mas_equalTo(nickName.mas_bottom).with.offset(5);
            make.right.mas_equalTo(contentLbl).with.offset(10);
            make.bottom.mas_equalTo(contentLbl).with.offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
        }];
    }else {
        [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).with.offset(10);
            make.right.mas_equalTo(self).with.offset(-10);
            make.width.height.mas_equalTo(40);
        }];
        [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headImg.mas_left).with.offset(-5);
            make.top.mas_equalTo(self).with.offset(10);
        }];
        [dataLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nickName);
            make.right.mas_equalTo(nickName.mas_left).with.offset(-15);
        }];
        
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(nickName).with.offset(-15);
            make.top.mas_equalTo(nickName.mas_bottom).with.offset(15);
            make.left.greaterThanOrEqualTo(self).with.offset(25);
        }];
        [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(nickName);
            make.top.mas_equalTo(nickName.mas_bottom).with.offset(5);
            make.left.mas_equalTo(contentLbl).with.offset(-10);
            make.bottom.mas_equalTo(contentLbl).with.offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-5);
        }];
    }
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
