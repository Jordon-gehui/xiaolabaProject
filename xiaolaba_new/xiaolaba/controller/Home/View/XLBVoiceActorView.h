//
//  XLBVoiceActorView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLBVoiceActorViewDelegate<NSObject>

- (void)voiceActorSeletedItemWithVoiceActorModel:(VoiceActorListModel *)voiceActorModel;
- (void)voiceActorNotLogin;
@end

@interface XLBVoiceActorView : UIView
@property (nonatomic, weak) id <XLBVoiceActorViewDelegate>delegate;
@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) NSMutableArray *data;
@end
