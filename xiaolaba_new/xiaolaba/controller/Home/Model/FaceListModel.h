//
//  FaceListModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/27.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceListModel : NSObject
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *likeSum;
@property (nonatomic, copy)NSString *liked;
@property (nonatomic, strong) NSArray <NSString *>*pick; // 背景图
@property (nonatomic, copy) NSString *picks;
@property (nonatomic, strong)NSArray<UserTagsModel *>*tags;
@end

@interface FaceWallListModel : NSObject

@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *ranking;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *likeSum;
@property (nonatomic, copy)NSString *follows;
@end

@interface VoiceActorListModel : NSObject
@property (nonatomic, copy)NSString *age;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *voiceId;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *img;
@property (nonatomic, copy)NSString *onlineType;//在线状态
@property (nonatomic, copy)NSString *priceAkira;//价格
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *signature;//个签
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *voiceAkira;//语音地址
@property (nonatomic, copy)NSString *voiceStatus;
@property (nonatomic, copy)NSString *voiceTime;//语音时间
@property (nonatomic, strong) NSArray <NSString *>*pick; // 背景图
@property (nonatomic, copy) NSString *picks;
@property (nonatomic, strong)NSArray<UserTagsModel *>*tags;
@end
