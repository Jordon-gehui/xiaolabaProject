//
//  XLBMyInfoSubCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyInfoSubCell.h"

@implementation XLBMyInfoSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.autoresizingMask =
    //UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    //UIViewAutoresizingFlexibleRightMargin |
    //UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight
    //UIViewAutoresizingFlexibleBottomMargin
    ;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
}

- (void)setUser:(XLBUser *)user {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
