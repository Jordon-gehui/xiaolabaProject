//
//  CallOrderDetailsCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/30.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallOrderDetailsCell : UITableViewCell

-(void)setViewData:(id)dic;

+(NSString *)cellReuseIdentifier;
@end
