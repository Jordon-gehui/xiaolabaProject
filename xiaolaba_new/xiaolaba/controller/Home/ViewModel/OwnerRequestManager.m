//
//  OwnerRequestManager.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "OwnerRequestManager.h"
#import "XLBOwnerModel.h"
#import "XLBUserModel.h"
#import "FaceListModel.h"
@implementation OwnerRequestManager

+ (void)requestOwnerWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kOwner params:para cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *user = result[@"user"];
        NSMutableArray *tag = [NSMutableArray array];
        
        XLBOwnerModel *model = [XLBOwnerModel mj_objectWithKeyValues:user];
        
        [[user objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserTagsModel *tagsModel = [UserTagsModel mj_objectWithKeyValues:obj];
            [tag addObject:tagsModel];
        }];
        
        NSMutableArray *pickString = [NSMutableArray array];
        if (kNotNil([user objectForKey:@"picks"]) && [[user objectForKey:@"picks"] containsString:@","] == YES) {
            pickString = (NSMutableArray *)[[user objectForKey:@"picks"] componentsSeparatedByString:@","];
        }else {
            [pickString addObject:[user objectForKey:@"picks"]];
        }
        model.ID = user[@"id"];
        model.pick = pickString;
        NSDictionary *moment = result[@"moments"];
        model.momentCount = moment[@"momentCount"];
        model.momentsImg = moment[@"imgs"];
        model.tags = tag;
        
        success(model);
        
    } failure:^(NSString *description) {
        error(description);
    }];
}


+ (void)requestFaceParams:(NSDictionary *)params success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more total:(void(^)(int total))total{
    [[NetWorking network] POST:kAnonList params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <FaceListModel *>*dataSource = [NSMutableArray array];
        
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FaceListModel *model = [FaceListModel mj_objectWithKeyValues:obj];
            NSMutableArray *tags = [NSMutableArray array];
            [model.tags enumerateObjectsUsingBlock:^(UserTagsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UserTagsModel *tagModel = [UserTagsModel mj_objectWithKeyValues:obj];
                [tags addObject:tagModel];
            }];
            NSMutableArray *pickString = [NSMutableArray array];
            if (kNotNil([obj objectForKey:@"picks"]) && [[obj objectForKey:@"picks"] containsString:@","] == YES) {
                pickString = (NSMutableArray *)[[obj objectForKey:@"picks"] componentsSeparatedByString:@","];
            }else {
                [pickString addObject:[obj objectForKey:@"picks"]];
            }
            model.pick = pickString;
            model.tags = tags;
            [dataSource addObject:model];
        }];
        BOOL next = [[result objectForKey:@"next"] boolValue];
        
        more(next);
        total([[result objectForKey:@"pages"] intValue]);
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}


+ (void)requestFaceWallAllDataParams:(NSDictionary *)params isSY:(NSInteger)is_sy success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    NSString *url;
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        url = kRankMListNotLogin;
    }else {
        url = is_sy==1 ? kRankMSY:kRankMList;
    }
    [[NetWorking network] POST:url params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <FaceWallListModel *>*dataSource = [NSMutableArray array];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FaceWallListModel *model = [FaceWallListModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestFaceWallDayDataParams:(NSDictionary *)params isSY:(NSInteger)is_sy success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure {
    NSString *url = is_sy==1 ? kRankDaySY:kRankDayList;
    [[NetWorking network] POST:url params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <FaceWallListModel *>*dataSource = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FaceWallListModel *model = [FaceWallListModel mj_objectWithKeyValues:obj];
            [dataSource addObject:model];
        }];
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestVoiceActorDataParams:(NSDictionary *)params success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure more:(void(^)(BOOL more))more total:(void(^)(int total))total{
    [[NetWorking network] POST:kHomeVoiceActor params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray <VoiceActorListModel *>*dataSource = [NSMutableArray array];
        
        NSArray *data = (NSArray *)[result objectForKey:@"list"];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VoiceActorListModel *model = [VoiceActorListModel mj_objectWithKeyValues:obj];
            NSMutableArray *tags = [NSMutableArray array];
            [model.tags enumerateObjectsUsingBlock:^(UserTagsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UserTagsModel *tagModel = [UserTagsModel mj_objectWithKeyValues:obj];
                [tags addObject:tagModel];
            }];
            NSMutableArray *pickString = [NSMutableArray array];
            if (kNotNil([obj objectForKey:@"picks"]) && [[obj objectForKey:@"picks"] containsString:@","] == YES) {
                pickString = (NSMutableArray *)[[obj objectForKey:@"picks"] componentsSeparatedByString:@","];
            }else {
                [pickString addObject:[obj objectForKey:@"picks"]];
            }
            model.pick = pickString;
            model.tags = tags;
            [dataSource addObject:model];
        }];
        BOOL next = [[result objectForKey:@"next"] boolValue];
        
        more(next);
        total([[result objectForKey:@"pages"] intValue]);
        success(dataSource);
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestVoiceActorOwnerWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kVoiceActor params:para cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *user = result[@"user"];
        NSDictionary *akira = result[@"akira"];
        NSDictionary *akiraCount = result[@"akiraCount"];
        NSArray *visitor = result[@"visitor"];
        XLBOwnerModel *userModel = [XLBOwnerModel mj_objectWithKeyValues:user];
        UserAkiraModel *akiraModel = [UserAkiraModel mj_objectWithKeyValues:akira];
        NSMutableArray *akiraImg = [NSMutableArray array];
        if (kNotNil(akira)) {
            if (kNotNil([akira objectForKey:@"img"]) && [[akira objectForKey:@"img"] containsString:@","] == YES) {
                akiraImg = (NSMutableArray *)[[akira objectForKey:@"img"] componentsSeparatedByString:@","];
            }else {
                [akiraImg addObject:[akira objectForKey:@"picks"]];
            }
        }
        akiraModel.imgs = akiraImg;
        
        UserAkiraCountModel *akiraCountModel = [UserAkiraCountModel mj_objectWithKeyValues:akiraCount];
        NSMutableArray *tag = [NSMutableArray array];
        [[user objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserTagsModel *tagsModel = [UserTagsModel mj_objectWithKeyValues:obj];
            [tag addObject:tagsModel];
        }];
        
        NSMutableArray *pickString = [NSMutableArray array];
        if (kNotNil([user objectForKey:@"picks"]) && [[user objectForKey:@"picks"] containsString:@","] == YES) {
            pickString = (NSMutableArray *)[[user objectForKey:@"picks"] componentsSeparatedByString:@","];
        }else {
            [pickString addObject:[user objectForKey:@"picks"]];
        }
        userModel.ID = user[@"id"];
        userModel.pick = pickString;
        NSDictionary *moment = result[@"moments"];
        userModel.momentCount = moment[@"momentCount"];
        userModel.momentsImg = moment[@"imgs"];
        userModel.tags = tag;
        
        NSMutableArray *visitorAr = [NSMutableArray array];
        [visitor enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserAkiraVisitorModel *visitorModel = [UserAkiraVisitorModel mj_objectWithKeyValues:obj];
            [visitorAr addObject:visitorModel];
        }];
        
        XLBVoiceActorModel *model = [XLBVoiceActorModel new];
        model.visitorArr = visitorAr;
        model.user = userModel;
        model.akiraModel = akiraModel;
        model.akiraCountModel = akiraCountModel;
        success(model);
        
    } failure:^(NSString *description) {
        error(description);
    }];
}

+ (void)requestCallPayWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kVoiceCallPay params:para cache:NO success:^(id result) {
        NSLog(@"拨打电话成功：%@",result);
    } failure:^(NSString *description) {
        NSLog(@"拨打电话失败：---%@",description);
    }];
}

+ (void)requestCallPulseWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kVoiceCallPulse params:para cache:NO success:^(id result) {
        success(result);
        NSLog(@"拨打电话心跳成功%@",result);
    } failure:^(NSString *description) {
        error(description);
        NSLog(@"拨打电话心跳失败---%@",description);
    }];
}


+ (void)requestCallEndWithParameter:(NSDictionary *)para success:(void (^)(id))success error:(void (^)(id))error {
    [[NetWorking network] POST:kVoiceCallEnd params:para cache:NO success:^(id result) {
        NSLog(@"拨打结束%@",result);
        success(result);
    } failure:^(NSString *description) {
        error(description);
    }];
}

+ (void)requestImprassWithParameter:(NSDictionary *)para success:(void (^)(VoiceImpressModel *model))success failure:(void (^)(NSString *error))failure more:(void (^)(BOOL more))more {
    [[NetWorking network] POST:kVoiceImp params:para cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSArray *arr = result[@"imp"];
        NSMutableArray *typeArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VoiceImpressTypeModel *typeModel = [VoiceImpressTypeModel mj_objectWithKeyValues:obj];
            [typeArr addObject:typeModel];
        }];
        NSArray *orderArr = result[@"order"][@"list"];
        NSMutableArray *models = [NSMutableArray array];
        [orderArr enumerateObjectsUsingBlock:^(id  _Nonnull contentMo, NSUInteger idx, BOOL * _Nonnull stop) {
            VoiceImpressContentModel *contentModel = [VoiceImpressContentModel mj_objectWithKeyValues:contentMo];
            [models addObject:contentModel];
        }];
        VoiceImpressModel *model = [VoiceImpressModel new];
        model.imprss = typeArr;
        model.contentModel = models;
        success(model);
        BOOL next = [[result[@"order"] objectForKey:@"next"] boolValue];
        more(next);
        
    } failure:^(NSString *description) {
        failure(description);
    }];
}
@end
