//
//  XLBAddGroupMemberCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAddGroupMemberCollectionViewCell.h"

@interface XLBAddGroupMemberCollectionViewCell ()

@end

@implementation XLBAddGroupMemberCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 25;
    self.img.image = [UIImage imageNamed:@"weitouxiang"];
    [self.contentView addSubview:self.img];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

+ (NSString *)addGroupCollectionCellID {
    return @"addGroupCollectionCellID";
}
@end
