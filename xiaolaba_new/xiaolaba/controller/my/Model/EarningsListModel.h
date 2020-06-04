//
//  EarningsListModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarningsListModel : NSObject


/*createDate = 1524650472000;
 delFlag = 0;
 id = 1;
 paymentDetails = 200;
 ticketSum = 500;
 type = 1;
 userId = 28249245421166592;*/

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *delFlag;
@property (nonatomic, strong) NSString *paymentDetails;
@property (nonatomic, strong) NSString *ticketSum;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *earningListId;

@end
