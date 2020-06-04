//
//  XLBGroupAddManagerTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMemberModel.h"
@protocol XLBGroupAddManagerTableViewCellDelegate<NSObject>

- (void)didSeletedAddManagerWithUserId:(NSString *)userId;

- (void)didSeletedDelManagerWithUserId:(NSString *)userId;
@end

@interface XLBGroupAddManagerTableViewCell : UITableViewCell

@property (nonatomic, weak) id <XLBGroupAddManagerTableViewCellDelegate>delegate;
@property (nonatomic, strong) GroupMemberModel *groupModel;
@property (nonatomic, copy) NSString *groupId;
+ (NSString *)AddManagerTableViewCellID;
@end
