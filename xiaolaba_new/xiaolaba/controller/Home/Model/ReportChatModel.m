//
//  ReportChatModel.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ReportChatModel.h"

@implementation ReportChatModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
}

+(NSMutableArray *)getData{
    
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    ReportChatModel *model = [[ReportChatModel alloc] init];
    model.label = @"采购审批";
    [mArr addObject:model];
    
    ReportChatModel *model1 = [[ReportChatModel alloc] init];
    model1.label = @"财务审批";
    [mArr addObject:model1];
    
    
    
    ReportChatModel *model2 = [[ReportChatModel alloc] init];
    model2.label = @"运行";
    [mArr addObject:model2];
    
    
    
    ReportChatModel *mode3 = [[ReportChatModel alloc] init];
    mode3.label = @"采购";
    [mArr addObject:mode3];
    
    return mArr;
    
}

@end
