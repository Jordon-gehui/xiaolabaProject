//
//  XLBMoveRecordsCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMoveRecordsCell.h"
#import <UIImageView+WebCache.h>
@interface XLBMoveRecordsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UIView *motherView;

@end

@implementation XLBMoveRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.motherView.layer.masksToBounds = YES;
    self.motherView.layer.cornerRadius = 3.f;
//    self.motherView.layer.shadowOpacity = 0.5;// 阴影透明度
//    self.motherView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
//    self.motherView.layer.shadowRadius = 1;// 阴影扩散的范围控制
//    self.motherView.layer.shadowOffset = CGSizeMake(1, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XLBMoveRecordsModel *)model {
//    [self.image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"homenor"]];
    self.name.text = model.nickname;
    if ([model.status isEqualToString:@"0"]) {
        self.status.text = @"待帮助";
    }
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"已完成";
    }
    self.time.text = model.noticeDate;
    self.content.text = model.message;
    _model = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
