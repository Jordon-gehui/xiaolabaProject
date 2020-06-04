//
//  CheTieCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/7/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheTieCell : UITableViewCell

-(void)setData:(NSDictionary*)dic;

+(NSString *)cellReuseIdentifier;
@end
