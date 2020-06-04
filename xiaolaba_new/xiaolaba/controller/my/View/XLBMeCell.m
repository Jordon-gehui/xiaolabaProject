//
//  XLBMeCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/19.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMeCell.h"

@interface XLBMeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end

@implementation XLBMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    _topLine.backgroundColor = RGB(243, 243, 243);
    [_topLine setHidden:YES];
    [self addSubview:_topLine];
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 52.0f*kiphone6_ScreenHeight-1, kSCREEN_WIDTH, 1)];
    _bottomLine.backgroundColor = RGB(243, 243, 243);
    [_bottomLine setHidden:YES];
    [self addSubview:_bottomLine];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.title.font = [UIFont systemFontOfSize:14];
    self.subTitle.font = [UIFont systemFontOfSize:14];
    self.title.textColor = [UIColor minorTextColor];
}

- (void)setKeyValue:(NSDictionary *)keyValue {
    
    self.image.image = [UIImage imageNamed:[keyValue objectForKey:@"icon"]];
    self.title.text = [keyValue objectForKey:@"title"];
    if(kNotNil([keyValue objectForKey:@"subtitle"])) {
        self.subTitle.text = [keyValue objectForKey:@"subtitle"];
        self.subTitle.hidden = NO;
    }
    else {
        self.subTitle.hidden = YES;
    }
    if(kNotNil([keyValue objectForKey:@"subtitle_color"])) {
        self.subTitle.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"0x%@",[keyValue objectForKey:@"subtitle_color"]]];
    }
    _keyValue = keyValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
