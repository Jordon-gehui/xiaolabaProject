//
//  VoiceActorCollectionViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceListModel.h"

@protocol VoiceActorCollectionViewCellDelegate<NSObject>

- (void)voiceActorCellDidSetedWith:(UIButton *)sender voiceActorModel:(VoiceActorListModel *)model voiceImg:(UIImageView *)voiceImg;
@end
@interface VoiceActorCollectionViewCell : UICollectionViewCell


@property (nonatomic, weak) id<VoiceActorCollectionViewCellDelegate>delegate;
@property (nonatomic, strong) VoiceActorListModel *model;
@property (nonatomic, strong) UIImageView *videoImg;

+ (NSString *)voiceActorID;
@end
