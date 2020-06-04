//
//  ReportChatCollectionViewCell.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ReportChatCollectionViewCell.h"

@implementation ReportChatCollectionViewCell

@synthesize reportLable;
-(void)setReportModel:(ReportChatModel *)reportModel{

    reportLable = [[UILabel alloc] init];
    reportLable.frame = CGRectMake(0, 0, self.width, self.height);
    reportLable.text = reportModel.label;
    reportLable.textColor = [UIColor colorWithR:92 g:95 b:102];
    reportLable.textAlignment = NSTextAlignmentCenter;
    reportLable.font = [UIFont systemFontOfSize:13];
    
//    reportLable.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:reportLable];
}

@end
