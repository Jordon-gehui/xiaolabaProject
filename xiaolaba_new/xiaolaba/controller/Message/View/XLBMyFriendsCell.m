//
//  XLBMyFriendsCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyFriendsCell.h"

@implementation XLBMyFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _image.layer.cornerRadius = 14;
//    _image.layer.masksToBounds = YES;
//    [_image setUserInteractionEnabled:YES];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//    [_image addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapClick:)];
    longTap.minimumPressDuration = 1.0;

    [self addGestureRecognizer:longTap];
    // Initialization code
}
- (void)layoutSubviews {
    _image.layer.cornerRadius = (self.frame.size.height*0.7)/2;
    _image.layer.masksToBounds = YES;
}

-(void)tapClick:(UITapGestureRecognizer *)gesture {
    if (self.cellTapRetrunBlock) {
        self.cellTapRetrunBlock(YES);
    }
}

-(void)longTapClick:(UILongPressGestureRecognizer *)longPressRecognizer {
    
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) return ; // except multiple pressed it !
    if (self.cellLongTapRetrunBlock) {
        self.cellLongTapRetrunBlock(YES);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
