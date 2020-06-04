//
//  XLBAccountDetailCollectionViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/21.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBAccountDetailCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *subPriceLabel;
@property (nonatomic, strong) UILabel *discountsLabel;
@property (nonatomic, strong) UILabel *customPrice;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) NSDictionary *dict;
+ (NSString *)accountDetailCellId;
@end
