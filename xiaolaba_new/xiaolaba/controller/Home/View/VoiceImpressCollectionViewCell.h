//
//  VoiceImpressCollectionViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceImpressCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *impressLabel;
@property (nonatomic, strong) UIImageView *impressImg;

+ (NSString *)voiceImpressCellID;
@end
