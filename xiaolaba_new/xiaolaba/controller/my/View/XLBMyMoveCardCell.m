//
//  XLBMyMoveCardCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyMoveCardCell.h"
#import "UIColor+Utils.h"

@interface XLBMyMoveCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIImageView *qrImg;
@property (weak, nonatomic) IBOutlet UILabel *cardLab;
@property (weak, nonatomic) IBOutlet UIImageView *moveCarStrImg;


@end

@implementation XLBMyMoveCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(NSDictionary *)model {
    if (kNotNil(model) && kNotNil([model objectForKey:@"index"]) && kNotNil([model objectForKey:@"card"])) {
        if ([[model objectForKey:@"index"] isEqualToString:@"0"]) {
            self.cardLab.text = [NSString stringWithFormat:@"No.%@",[model objectForKey:@"card"]];
            self.qrImg.image = [model objectForKey:@"qrImg"];
        }
    }
    _model = model;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(moveCardCell:didTouchBan:)]) {
        
        [self.delegate moveCardCell:self didTouchBan:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
