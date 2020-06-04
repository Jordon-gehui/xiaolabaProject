//
//  XLBMeRequestModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//
#import "NetWorking.h"
#import "XLBMeRequestModel.h"
#import "XLBFllowFansModel.h"
#import "XLBMoveRecordsModel.h"
#import "XLBUser.h"
#import "XLBInviteModel.h"
#import "PraiseListModel.h"

@implementation XLBMeRequestModel

+ (void)requestCarDetail:(NSDictionary *)params success:(void(^)(NSArray <XLBCarDetailModel *>*cars))success failure:(void(^)(NSString *error))failure {
    
    [[NetWorking network] POST:kSeries params:params cache:YES success:^(id result) {
        NSMutableArray <XLBCarDetailModel *>*all = [NSMutableArray array];
        NSArray *data = (NSArray *)result;
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBCarDetailModel *model = [XLBCarDetailModel mj_objectWithKeyValues:obj];
            model.ID = [[obj objectForKey:@"id"] integerValue];
            
            NSMutableArray *child = [NSMutableArray array];
            NSArray *arr = [obj objectForKey:@"children"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                XLBCarDetailChildModel *mo = [XLBCarDetailChildModel mj_objectWithKeyValues:obj];
                mo.ID = [[obj objectForKey:@"id"] integerValue];
                [child addObject:mo];
            }];
            model.children = child;
            [all addObject:model];
        }];
        success(all);
    } failure:^(NSString *description) {
        failure(description);

    }];
    
}

+ (void)requsetInviteFriendsParams:(NSDictionary *)params success:(void(^)(NSArray <XLBInviteModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    
    [[NetWorking network] POST:kFriends params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <XLBInviteModel *>*dataSource = [NSMutableArray array];
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XLBInviteModel *model = [XLBInviteModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestSystemList:(NSDictionary *)params success:(void(^)(NSArray <XLBSystemMsgModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    [[NetWorking network] POST:kSystemMessage params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <XLBSystemMsgModel *>*dataSoure = [NSMutableArray array];
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XLBSystemMsgModel *model = [XLBSystemMsgModel mj_objectWithKeyValues:obj];
            [dataSoure addObject:model];
        }];
        
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSoure);
    } failure:^(NSString *description) {
        failure(description);

    }];
}

+ (void)requestFindFollowOrFocus:(BOOL )fans notice:(BOOL)notice params:(NSDictionary *)params success:(void(^)(NSArray <XLBFllowFansModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    
    [[NetWorking network] POST:fans ? kfwer:kFindFollow params:params cache:YES success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <XLBFllowFansModel *>*dataSource = [NSMutableArray array];
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (notice == NO) {
//                    if (![[obj objectForKey:@"type"] isEqualToString:@"2"]) {
//                        XLBFllowFansModel *model = [XLBFllowFansModel mj_objectWithKeyValues:obj];
//                        model.ID = [obj objectForKey:@"id"];
//                        model.user.ID = [[obj objectForKey:@"user"] objectForKey:@"id"];
//                        NSMutableArray *tags = [NSMutableArray array];
//                        [model.user.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                            UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
//                            [tags addObject:tag];
//                        }];
//                        model.user.tags = tags;
//                        [dataSource addObject:model];
//                    }
//                }else{
                    XLBFllowFansModel *model = [XLBFllowFansModel mj_objectWithKeyValues:obj];
                    model.ID = [obj objectForKey:@"id"];
                    model.user.ID = [[obj objectForKey:@"user"] objectForKey:@"id"];
                    NSMutableArray *tags = [NSMutableArray array];
                    [model.user.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
                        [tags addObject:tag];
                    }];
                    model.user.tags = tags;
                    [dataSource addObject:model];
//                }
                
            }];
        
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);

    }];
}
+ (void)requsetFriendsNotice:(BOOL)praise params:(NSDictionary *)params success:(void(^)(NSArray <MsgNoticeModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    [[NetWorking network] POST:kSociaMessage params:params cache:NO success:^(id result) {
        NSLog(@"-------------------    消息通知  %@",result);
        NSMutableArray <MsgNoticeModel *>*dataSource = [NSMutableArray array];
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MsgNoticeModel *model = [MsgNoticeModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSource);
        
    } failure:^(NSString *description) {
        failure(description);

    }];
}

+ (void)requestPraiseListParams:(NSDictionary *)params success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    [[NetWorking network] POST:kLikedList params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <PraiseListModel *>*dataSource = [NSMutableArray array];

        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PraiseListModel *model = [PraiseListModel mj_objectWithKeyValues:obj];
            NSMutableArray *tags = [NSMutableArray array];
            [model.tags enumerateObjectsUsingBlock:^(UserTagsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UserTagsModel *tagModel = [UserTagsModel mj_objectWithKeyValues:obj];
                [tags addObject:tagModel];
            }];
            model.tags = tags;
            [dataSource addObject:model];
        }];
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requsetPraiseOrComment:(BOOL)praise params:(NSDictionary *)params success:(void(^)(NSArray <PraiseModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    
    [[NetWorking network] POST:praise ? kPraise:kComment params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <PraiseModel *>*dataSource = [NSMutableArray array];
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PraiseModel *model = [PraiseModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}
+ (void)requsetFeedBackList:(NSDictionary *)params success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure more:(void (^)(BOOL))more {
    
    [[NetWorking network] POST:@"base-data/feed/feeds" params:params cache:YES success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray *dataSoure = [NSMutableArray array];
        if([[result allKeys] containsObject:@"list"]) {
            [dataSoure addObjectsFromArray:[result objectForKey:@"list"]];
        }
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        success(dataSoure);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestInfo:(void(^)(XLBUser *user))success failure:(void(^)(NSString *error))failure {
    [[NetWorking network] POST:kInfo params:nil cache:YES success:^(id result) {
        
        NSLog(@"%@",result);
        
        XLBUserModel *userModel = [XLBUserModel mj_objectWithKeyValues:result];
        userModel.ID = [result objectForKey:@"id"];
        NSMutableArray *tags = [NSMutableArray array];
        [[result objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
            [tags addObject:tag];
        }];
        userModel.tags = tags;
        [XLBUser user].userModel = userModel;
        success([XLBUser user]);
    } failure:^(NSString *description) {
        failure(description);

    }];
}

+ (void)reviseInfo:(NSDictionary *)params error:(void(^)(NSString *error))error {
    NSLog(@"%@",params);
    [[NetWorking network] POST:kRevise params:params cache:NO success:^(id result) {
        error(nil);
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        error(description);

    }];
}

+ (void)addsPicks:(NSDictionary *)params error:(void(^)(NSString *error))error {
    [[NetWorking network] POST:kAll params:params cache:NO success:^(id result) {
        error(nil);

    } failure:^(NSString *description) {
        error(description);

    }];
    
}

+ (void)changePhone:(NSDictionary *)params error:(void(^)(NSString *error))error {
    
    [[NetWorking network] POST:kPhone params:params cache:NO success:^(id result) {
        error(nil);
    } failure:^(NSString *description) {
        error(description);
    }];
}


+ (void)requestMyMoveList:(NSDictionary *)params success:(void(^)(NSArray <XLBMoveRecordsModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    
    [[NetWorking network] POST:kFindAll params:params cache:YES success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <XLBMoveRecordsModel *>*dataSource = [NSMutableArray array];
        NSArray <NSDictionary *>*list = [result objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBMoveRecordsModel *model = [XLBMoveRecordsModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        success(dataSource);
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        
    } failure:^(NSString *description) {
        
        failure(description);
    }];
}
+ (void)requestMoveCarNotList:(NSDictionary *)params success:(void(^)(NSArray <XLBMoveRecordsModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    
    [[NetWorking network] POST:kMoveCarNot params:params cache:YES success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <XLBMoveRecordsModel *>*dataSource = [NSMutableArray array];
        NSArray <NSDictionary *>*list = [result objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBMoveRecordsModel *model = [XLBMoveRecordsModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        success(dataSource);
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        
    } failure:^(NSString *description) {
        
        failure(description);
    }];
}

+ (void)requestPublishMove:(void(^)(NSArray <NSDictionary *>*list))success failure:(void(^)(NSString *error))failure {
    
    [[NetWorking network] POST:kMoves params:nil cache:NO success:^(id result) {
        
        NSDictionary *data = [result firstObject];
        success([data objectForKey:@"listDict"]);
        
    } failure:^(NSString *description) {
        
        failure(description);
    }];
}

+ (void)publishMove:(NSDictionary *)params error:(void(^)(NSString *error))error {
    
    [[NetWorking network] POST:kMoveDetails params:params cache:NO success:^(id result) {
        
        error(nil);
    } failure:^(NSString *description) {
        
        error(description);
    }];
}

+ (void)identify:(NSDictionary *)params success:(void(^)(NSDictionary *result))success failure:(void(^)(NSString *error))failure {
    
    [[NetWorking network] POST:kOv params:params cache:NO success:^(id result) {
        
        success(result);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestMeCarQRCode:(void (^)(NSArray<XLBMeCarQRCodeModel *> *))success failure:(void (^)(NSString *))failure {
    [[NetWorking network] POST:kMeCar params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <XLBMeCarQRCodeModel *>*dataSource = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XLBMeCarQRCodeModel *mecar = [XLBMeCarQRCodeModel mj_objectWithKeyValues:obj];
            mecar.carId = [obj objectForKey:@"id"];
            [dataSource addObject:mecar];
        }];
        success(dataSource);
     
    } failure:^(NSString *description) {
        failure(description);
    }];
}


+ (void)requestCarInfo:(NSDictionary *)params success:(void(^)(NSArray <XLBMeCarDetailModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    [[NetWorking network] POST:kCarDetail params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        /*createDate = 1506180525000;
         createUser = 21381387097497600;
         delFlag = 0;
         engineNumber = 2425167;
         id = 22236097333432320;
         imgId = "20170923232831_88b8fe9b36427ee587cb23819ea3d601";
         issueDate = 20110000;
         owner = "\U6f58\U5c0f\U4fe1";
         plateNumber = "\U7696A8Y408";
         registerDate = 20110000;
         status = 0;
         useCharacter = "\U975e\U8425\U8fd0";
         userId = 21381387097497600;
         vehicleAreaId = 342;
         vehicleType = "\U5c0f\U578b\U8f7f\U8f66";
         vin = LDC943X20B27569855;
         */
        NSMutableArray *data = [NSMutableArray array];
        NSArray <NSDictionary *>*list = [result objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XLBMeCarDetailModel *model = [XLBMeCarDetailModel mj_objectWithKeyValues:obj];
            [data addObject:model];
        }];
        success(data);
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
        
    } failure:^(NSString *description) {
        failure(description);

    }];
}
/**
 获取订单记录
 */
+ (void)requestCallOrderInfo:(NSDictionary *)params isSY:(NSInteger)isSY success:(void(^)(NSArray <CallOrderModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    NSString *url = isSY==1? kSYCalling:kSYCalled;
    [[NetWorking network] POST:url params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray *data = [NSMutableArray array];
        NSArray <NSDictionary *>*list = [result objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CallOrderModel *model = [CallOrderModel mj_objectWithKeyValues:obj];
            model.userId = [obj objectForKey:@"id"];
            [data addObject:model];
        }];
        success(data);
        BOOL next = [[result objectForKey:@"next"] boolValue];
        more(next);
    } failure:^(NSString *description) {
        failure(description);
        
    }];
}

+ (void)requestPayDetail:(NSDictionary *)params isPay:(BOOL)isPay success:(void (^)(NSArray<EarningsListModel *> *models))success recharge:(void (^)(NSString *recharge))recharge failure:(void (^)(NSString *error))failure more:(void (^)(BOOL))more {
    [[NetWorking network] POST:isPay ? kPayChongzhi : kPayTixian params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSString *rechar;
        if (isPay) {
             rechar = [NSString stringWithFormat:@"%@",[result objectForKey:@"recharge"]];
        }else {
            rechar = [NSString stringWithFormat:@"%@",[result objectForKey:@"transfer"]];
        }
        NSMutableArray *data = [NSMutableArray array];
        NSArray <NSDictionary *>*list = [result objectForKey:@"page"][@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EarningsListModel *model = [EarningsListModel mj_objectWithKeyValues:obj];
            [data addObject:model];
        }];
        success(data);
        recharge(rechar);
        BOOL next = [[result objectForKey:@"page"][@"next"] boolValue];
        more(next);
    } failure:^(NSString *description) {
        failure(description);
    }];
}
@end







