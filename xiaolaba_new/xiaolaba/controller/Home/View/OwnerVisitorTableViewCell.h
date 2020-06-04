//
//  OwnerVisitorTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBOwnerModel.h"


@protocol OwnerVisitorCellDelegate <NSObject>

- (void)didSelectButtonWithModel:(UserAkiraVisitorModel *)voice;
@end

@interface OwnerVisitorTableViewCell : UITableViewCell

@property (nonatomic, weak) id <OwnerVisitorCellDelegate>delegate;
@property (nonatomic, strong) XLBVoiceActorModel *voiceModel;

+ (NSString *)visitorTableViewCellID;
@end
