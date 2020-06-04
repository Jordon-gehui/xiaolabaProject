//
//  XLBMsgSystemCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMsgSystemCell.h"

@interface XLBMsgSystemCell ()

@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@end

@implementation XLBMsgSystemCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
	
}

- (void)setModel:(XLBSystemMsgModel *)model {
	
	UIColor *color = nil;
	color = RGB(22, 22, 22);

    self.time.textColor = color;
	self.message.text = model.summary;
    
	self.time.text = model.createDate;
	self.message.textColor = [UIColor textBlackColor];

	_model = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

@end
