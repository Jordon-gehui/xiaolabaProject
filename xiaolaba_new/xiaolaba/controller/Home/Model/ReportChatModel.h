//
//  ReportChatModel.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportChatModel : NSObject

@property (nonatomic, copy) NSString *label;//名字
@property (nonatomic, copy) NSString *value;//

+(NSMutableArray *)getData;

@end
