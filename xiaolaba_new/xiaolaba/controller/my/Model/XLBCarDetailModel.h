//
//  XLBCarDetailModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

/**
 汽车品牌及子型号模型
 */
@class XLBCarDetailChildModel;
@interface XLBCarDetailModel : NSObject

@property (nonatomic, strong) NSArray <XLBCarDetailChildModel *>*children;
@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger parentId;

@end


@interface XLBCarDetailChildModel : NSObject

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger parentId;
@property (nonatomic, copy) NSString *priceDesc;

@end



@interface XLBMeCarQRCodeModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *encrypt;
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *updateUser;
@property (nonatomic, copy) NSString *userId;


@end

@interface XLBMeCarDetailModel : NSObject

/*
 {
 "id": 28685693626617856,
 "createUser": 24234055599939584,
 "createDate": 1507718229000,
 "updateDate": 1508820497000,
 "userId": 24234055599939584,
 "vehicleAreaId": 342,
 "owner": "潘小信",
 "plateNumber": "皖A8Y408",
 "engineNumber": "1425167",
 "vin": "LDC943X20B2756984",
 "model": "东风标致牌DC7204DTB",
 "vehicleType": "小型轿车",
 "useCharacter": "非营运",
 "issueDate": 1302825600000,
 "registerDate": 1302825600000,
 "status": "0",
 "imgId": "20171011183704_6a7aa76ee7b0c2c323c8ee99db2ace08",
 "delFlag": "0",
 "vehicleAreaName": "标致"
 }
 */

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, copy) NSString *engineNumber;
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *imgId;
@property (nonatomic, copy) NSString *issueDate;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *registerDate;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *useCharacter;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *vehicleAreaId;
@property (nonatomic, copy) NSString *vehicleType;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *vehicleAreaName;
@property (nonatomic, copy) NSString *model;


@end
