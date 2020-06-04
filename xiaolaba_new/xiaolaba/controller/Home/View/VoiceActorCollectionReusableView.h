//
//  VoiceActorCollectionReusableView.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/3.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface VoiceActorCollectionReusableView : UICollectionReusableView
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *accountSubLabel;
+ (NSString *)voiceActorHeaderView;
@end
