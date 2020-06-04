//
//  VoiceSreenCollectionViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceSreenCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) NSDictionary *priceDict;
+ (NSString *)voiceScreenCellID;
@end
