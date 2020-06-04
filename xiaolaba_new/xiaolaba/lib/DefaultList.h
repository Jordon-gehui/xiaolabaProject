//
//  DefaultList.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/1.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultList : NSObject

+(NSArray*)initControllers;

+(NSArray*)initOthersHomeList;

+(NSArray*)initMsgList;

+(NSArray*)initMeList;

+(NSArray*)initMeSubList;

+(NSArray*)initMyInfoList;

+(NSArray*)initMeInfoList;

+ (NSArray*)initMoveCarControllerList;

+ (NSArray *)initCarQRCodeList;

+ (NSArray *)initScreenCarInfoList;

+(NSArray*)initMeCarList;

+ (NSArray *)initAccountList;

+ (NSArray *)initGroupChatListWithType:(NSString *)type;

@end
