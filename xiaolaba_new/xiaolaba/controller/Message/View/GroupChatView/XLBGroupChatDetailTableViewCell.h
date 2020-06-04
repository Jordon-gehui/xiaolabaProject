//
//  XLBGroupChatDetailTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBGroupChatDetailTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger row;


+ (NSString *)groupChatDetailCellID;
@end
