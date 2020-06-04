//
//  XLBGroupModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XLBGroupListModel : NSObject
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *nickname;

@end

@interface XLBGroupSubModel : NSObject
@property (nonatomic, copy) NSString *disturb;
@property (nonatomic, copy) NSString *groupHuanxin;
@property (nonatomic, copy) NSString *membersId;
@property (nonatomic, copy) NSString *membersName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;

@end


@interface XLBGroupModel : NSObject


/*
 group =     {
 createDate = 1528344862000;
 createUser = 96788306024488960;
 groupAnnouncement = "";
 groupDescription = "\U60a8\U597d\Uff0c\U6b22\U8fce\U52a0\U5165\U8fd9\U4e2a\U5927\U5bb6\U5ead\Uff0c\U5e0c\U671b\U6211\U4eec\U80fd\U591f\U5f00\U5fc3\U6109\U5feb";
 groupHuanxin = 51324085403649;
 groupImg = "moment/4E70C358-5695-4C8E-9B07-383D57813E01.jpg";
 groupName = "\U9152\U4e95\U9ad8\U5fb7,Gerhold,\U6d4b\U8bd5\U53cc,\U5065\U5eb7";
 id = 115200065433260032;
 isSearch = 0;
 membersIds = "<null>";
 page = "<null>";
 pullPeople = 0;
 status = 1;
 type = 1;
 updateDate = "<null>";
 updateUser = "<null>";
 };
 members =     {
 createDate = 1528344862000;
 createUser = 96788306024488960;
 disturb = 0;
 groupHuanxin = 51324085403649;
 id = 115200065512951808;
 img = "<null>";
 membersId = 96788306024488960;
 membersName = "\U9152\U4e95\U9ad8\U5fb7";
 page = "<null>";
 status = 0;
 type = 3;
 updateDate = "<null>";
 updateUser = "<null>";
 };
 
 */
@property (nonatomic, copy) NSString *groupAnnouncement;
@property (nonatomic, copy) NSString *groupDescription;
@property (nonatomic, copy) NSString *groupHuanxin;
@property (nonatomic, copy) NSString *groupImg;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *isSearch;
@property (nonatomic, copy) NSString *membersIds;
@property (nonatomic, copy) NSString *pullPeople;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) XLBGroupSubModel *subModel;
@end



