//
//  XLBScreenSubTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBScreenSubTableViewCell.h"

@implementation XLBScreenSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSex:(NSString *)sex {
    if ([sex isEqualToString:@"男"]) {
        [self.manBtn setTitleColor:[UIColor lightColor] forState:UIControlStateNormal];
        [self.notBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
        [self.womanBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
    }
    if ([sex isEqualToString:@"女"]) {
        [self.womanBtn setTitleColor:[UIColor lightColor] forState:UIControlStateNormal];
        [self.notBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
        [self.manBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
    }
    if ([sex isEqualToString:@"不限"]) {
        [self.notBtn setTitleColor:[UIColor lightColor] forState:UIControlStateNormal];
        [self.manBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
        [self.womanBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
    }
}

- (IBAction)sexBtnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10: {
            [self.notBtn setTitleColor:[UIColor lightColor] forState:UIControlStateNormal];
            [self.manBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
            [self.womanBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(didSeletedSexWith:)]) {
                [self.delegate didSeletedSexWith:@""];
            }
        }
            break;
        case 20: {
            [self.manBtn setTitleColor:[UIColor lightColor] forState:UIControlStateNormal];
            [self.notBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
            [self.womanBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(didSeletedSexWith:)]) {
                [self.delegate didSeletedSexWith:@"1"];
            }
        }
            break;
        case 30: {
            [self.womanBtn setTitleColor:[UIColor lightColor] forState:UIControlStateNormal];
            [self.notBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
            [self.manBtn setTitleColor:RGB(9, 9, 9) forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(didSeletedSexWith:)]) {
                [self.delegate didSeletedSexWith:@"0"];
            }
        }
            break;
            
        default:
            break;
    }
}


@end
