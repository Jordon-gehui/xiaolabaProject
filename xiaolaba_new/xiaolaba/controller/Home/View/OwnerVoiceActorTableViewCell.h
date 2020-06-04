//
//  OwnerVoiceActorTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBOwnerModel.h"

@interface OwnerVoiceActorTableViewCell : UITableViewCell

@property (nonatomic, strong) XLBVoiceActorModel *voiceModel;
@property (nonatomic, strong) UIButton *checkBtn;

+ (NSString *)voiceAcotrTableViewCellID;
@end
