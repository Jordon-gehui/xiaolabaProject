//
//  VoiceImpressModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/27.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceImpressTypeModel : NSObject

@property (nonatomic, copy) NSString *impressionCount;
@property (nonatomic, copy) NSString *impressionName;
@property (nonatomic, copy) NSString *type;

@end

@interface VoiceImpressContentModel : NSObject

@property (nonatomic, copy) NSString *callingNickname;
@property (nonatomic, copy) NSString *callingImg;
@property (nonatomic, copy) NSString *callingId;
@property (nonatomic, copy) NSString *assess;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *remarks;

@end

@interface VoiceImpressModel : NSObject
/*
 createDate = "<null>";
 createUser = "<null>";
 id = "<null>";
 impressionCount = 8;
 impressionName = "\U58f0\U97f3\U751c\U7f8e";
 page = "<null>";
 type = 1;
 updateDate = "<null>";
 updateUser = "<null>";
 userId = "<null>";
 
 
 account = "<null>";
 assess = "<null>";
 calledAccount = "<null>";
 calledId = 86989340479086592;
 calledImg = "<null>";
 calledNickname = "<null>";
 callingAccount = "<null>";
 callingId = 28249245421166592;
 callingImg = "<null>";
 callingNickname = "<null>";
 createDate = 1524108851000;
 createUser = 28249245421166592;
 delFlag = 0;
 huanxinNo = 282492454211665921524107657815;
 huanxinTime = 0;
 id = 97427940744105984;
 impressionType = "1,2,3,4,5,6";
 money = 2;
 nickname = "<null>";
 orderStatus = "<null>";
 page = "<null>";
 praiseStar = 0;
 remarks = "<null>";
 status = 1;
 type = 1;
 updateDate = 1524107703000;
 
 */

@property (nonatomic, strong) NSArray <VoiceImpressTypeModel*>*imprss;

@property (nonatomic, strong) NSArray <VoiceImpressContentModel*>*contentModel;


@end
