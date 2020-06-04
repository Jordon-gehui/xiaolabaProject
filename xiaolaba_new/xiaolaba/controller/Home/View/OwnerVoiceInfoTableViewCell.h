//
//  OwnerVoiceInfoTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBOwnerModel.h"
@interface OwnerVoiceInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) XLBVoiceActorModel *owner;

+ (NSString *)cellID;
@end
