//
//  XLBFeedBackListCell.m
//  xiaolaba
//
//  Created by lin on 2017/8/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFeedBackListCell.h"

@implementation XLBFeedBackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    self.feed_avatar.layer.cornerRadius = self.feed_avatar.frame.size.height/2;
    self.feed_avatar.layer.masksToBounds = YES;
}

- (void)setData:(NSDictionary *)data {
    
    NSString *temp = [data objectForKey:@"img"];
    self.feed_content.text = [data objectForKey:@"description"];
    [self.feed_avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:temp Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    if (kNotNil([data objectForKey:@"nickname"])) {
        self.feed_nick.text = [data objectForKey:@"nickname"];
    }
    if (kNotNil([data objectForKey:@"genre"])) {
        self.feed_type.text = [data objectForKey:@"genre"];
    }
    if (kNotNil([data objectForKey:@"createDate"])) {
        self.feed_time.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"createDate"]];
    }
    if (kNotNil([data objectForKey:@"origin"])) {
        self.feed_source.text = [data objectForKey:@"origin"];
    }
    if (kNotNil([data objectForKey:@"answer"])) {
        NSString *str = [data objectForKey:@"description"];
        NSString *string = [NSString stringWithFormat:@"%@\n小喇叭客服：%@",[data objectForKey:@"description"],[data objectForKey:@"answer"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8.f;
        paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor textBlackColor] range:NSMakeRange(str.length+1, 6)];
        self.feed_content.attributedText = attributedString;
    }
    _data = data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
