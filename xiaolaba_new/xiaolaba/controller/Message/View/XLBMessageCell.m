//
//  XLBMessageCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/20.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMessageCell.h"
#import "masonry.h"

@interface XLBMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *msg;


@end

@implementation XLBMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image.layer.cornerRadius=65*0.35;
    self.image.layer.masksToBounds = YES;
    self.msg.layer.cornerRadius = 8;
    self.msg.layer.masksToBounds = YES;
}

-(void)setShowType:(NSString*)type {
    if (type.length >0) {
        self.msg.text = @"1";
        [self.msg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo( 20);
        }];
    }else {
        self.msg.text = @"";
    }
}

- (void)setModel:(XLBSessionModel *)model {
    if ([model.em_id containsString:@"type"]) {
        self.msg.hidden = NO;
        self.subTitle.text = model.em_lastMsg;
        self.msg.text = @"";
        self.time.text = @"";
        if (!kNotNil(model.em_lastMsg)) {
            self.subTitle.text = @"暂无新消息";
        }
        if (![model.em_date isEqualToString:@"2017-09-01 00:00"]) {
            self.time.text = model.em_time;
        }
        if (![model.em_unRead isEqualToString:@"0"] && kNotNil(model.em_unRead)) {
            self.msg.text = model.em_unRead;
            [self.msg mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo( 20);
            }];
        }
        if ([model.em_id isEqualToString:@"type0"]) {
            self.title.text = @"系统消息";
            self.image.image = [UIImage imageNamed:@"xitong1"];
        }
        if ([model.em_id isEqualToString:@"type1"]) {
            self.title.text = @"挪车通知";
            self.image.image = [UIImage imageNamed:@"nuoche1"];
        }
        if ([model.em_id isEqualToString:@"type2"]) {
            self.title.text = @"好友通知";
            self.image.image = [UIImage imageNamed:@"xiaoxi1"];
        }
        if ([model.em_id isEqualToString:@"type3"]) {
            self.title.text = @"关注";
            self.image.image = [UIImage imageNamed:@"guanz_1"];
        }
        if ([model.em_id isEqualToString:@"type4"]) {
            self.title.text = @"赞";
            self.image.image = [UIImage imageNamed:@"dianz_1"];
        }
        if ([model.em_id isEqualToString:@"type5"]) {
            self.title.text = @"评论";
            self.image.image = [UIImage imageNamed:@"pl_1"];
        }
        
    }else {
        self.msg.hidden = NO;
        if ([model.type isEqualToString:@"1"]) {
            self.image.layer.masksToBounds = YES;
            self.image.layer.borderColor = [UIColor colorWithR:174 g:181 b:194].CGColor;
            self.image.layer.borderWidth = 1;
        }
        [self.image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.em_avatar Withtype:IMGAvatar]] placeholderImage:nil];
        NSLog(@"%@",[JXutils judgeImageheader:model.em_avatar Withtype:IMGAvatar]);
        self.title.text = model.em_nickname;
        self.subTitle.text = model.em_lastMsg;
        self.time.text = model.em_time;
        if([model.em_unRead integerValue] > 0) {
            self.msg.text = model.em_unRead;
            [self.msg mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo( 20);
            }];
        }
        else {
            self.msg.text = @"";
        }
    }
    _model = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
