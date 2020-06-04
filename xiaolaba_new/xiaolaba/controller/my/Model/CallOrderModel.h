//
//  CallOrderModel.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/20.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallOrderModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *huanxinTime;
@property (nonatomic, copy) NSString *calledId;

//0代表未完成，1完成 2未接通
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *callingImg;
@property (nonatomic, copy) NSString *calledImg;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *remarks;

@end
