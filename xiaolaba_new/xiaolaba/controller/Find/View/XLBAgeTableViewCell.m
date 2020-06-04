//
//  XLBAgeTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBAgeTableViewCell.h"

@interface XLBAgeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation XLBAgeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = [UIColor lineColor];
}

- (void)setTitles:(NSString *)titles {
    self.title.text = titles;
    _titles = titles;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
