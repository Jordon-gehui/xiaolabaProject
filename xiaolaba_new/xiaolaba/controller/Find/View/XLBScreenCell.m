//
//  XLBScreenCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBScreenCell.h"

@interface XLBScreenCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation XLBScreenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = RGB(48, 48, 48);
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.subtitle.font = [UIFont systemFontOfSize:15];    
}

- (void)setItems:(NSArray *)items {
    if(!kNotNil(items)) return;
    NSString *str = [items componentsJoinedByString:@","];
    self.subtitle.text = str;
    _items = items;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
