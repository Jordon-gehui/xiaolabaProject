//
//  XLBMyInfoCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyInfoCollectionViewCell.h"

@implementation XLBMyInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 5;
}

@end
