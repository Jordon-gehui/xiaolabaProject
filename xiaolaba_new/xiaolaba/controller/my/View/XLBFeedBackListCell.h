//
//  XLBFeedBackListCell.h
//  xiaolaba
//
//  Created by lin on 2017/8/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBFeedBackListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *feed_avatar;
@property (weak, nonatomic) IBOutlet UILabel *feed_nick;
@property (weak, nonatomic) IBOutlet UILabel *feed_type;
@property (weak, nonatomic) IBOutlet UILabel *feed_time;
@property (weak, nonatomic) IBOutlet UILabel *feed_source;
@property (weak, nonatomic) IBOutlet UILabel *feed_content;

@property (nonatomic,strong) NSDictionary *data;
@end
