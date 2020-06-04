//
//  XLBMyInfoHeaderCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyInfoHeaderCollectionViewCell.h"

@implementation XLBMyInfoHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellView.clipsToBounds = YES;
    self.cellView.layer.cornerRadius = 5;
}

@end
