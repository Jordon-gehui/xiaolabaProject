//
//  InformationCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationCell : UITableViewCell

-(void)setViewData:(id)dic;

+(NSString *)cellReuseIdentifier;

@end
