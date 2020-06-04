//
//  VoiceAppraiseCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceImpressModel.h"
@protocol VoiceAppraiseCellDelegate<NSObject>

- (void)didSeletedUserImgWithModel:(VoiceImpressContentModel *)model;
@end
@interface VoiceAppraiseCell : UITableViewCell

@property (nonatomic, copy) NSString *tes;
@property (nonatomic, weak) id<VoiceAppraiseCellDelegate>delegate;
@property (nonatomic, strong) VoiceImpressContentModel *model;
+ (NSString *)voiceAppraiseCellID;
@end
