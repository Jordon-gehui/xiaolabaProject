//
//  NewWorking.h
//  xiaolaba
//
//  Created by cs on 2017/9/9.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UploadStatus) {
    
    UploadStatusSuccess,
    UploadStatusFailure
};

typedef NS_ENUM(NSInteger, NetworkCode) {
    
    NetworkCodeSuccess = 000000,            // 成功
    NetworkCodeSystemBusyError = 100000,    // 错误
    NetworkCodeSendNoteError = 100001,      // 非法参数
    NetworkCodeOtherLoginError = 200000,             //他人登录
};

typedef NS_ENUM(NSInteger, NetworkStatus) {
    
    StatusUnknown = 0,          // 未知状态
    StatusNotReachable,         // 无网状态
    StatusReachableViaWWAN,     // 2/3/4G网络
    StatusReachableViaWiFi,     // wifi网络
};

@interface NetWorking : NSObject

@property (nonatomic, assign, readonly) NetworkStatus netStatus;

/**
 *  实例化请求
 */
+ (instancetype)network;

/**
 *   监听网络状态的变化
 */
- (void)startMonitorNetwork;

/**
 通用POST请求
 
 @param url 请求地址
 @param params 请求参数
 @param cache 是否需要缓存数据
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POST:(NSString *)url params:(NSDictionary *)params cache:(BOOL )cache success:(void(^)(id result))success failure:(void(^)(NSString *description))failure;

/**
 *  通用GET请求
 
 @param url 请求地址
 @param params 请求参数
 @param cache 是否需要缓存数据
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GET:(NSString *)url params:(NSDictionary *)params cache:(BOOL )cache success:(void(^)(id result))success failure:(void(^)(NSString *description))failure;



/**
 *  通用GET请求
 用于外部链接。不需要拼接参数
 @param url 请求地址
 @param params 请求参数
 @param cache 是否需要缓存数据
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GET2:(NSString *)url params:(NSDictionary *)params cache:(BOOL )cache success:(void(^)(id result))success failure:(void(^)(NSString *description))failure ;

/**
 异步上传图片
 
 @param image    图片
 @param complete 完成回调（图片地址后缀名）
 */
- (void)asyncUploadImage:(UIImage *)image avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names, UploadStatus state))complete;

/**
 同步上传图片
 
 @param image    图片
 @param complete 完成回调（图片地址后缀名）
 */
- (void)syncUploadImage:(UIImage *)image avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names, UploadStatus state))complete;

/**
 异步批量上传图片
 
 @param images   图片数组
 @param complete 完成回调（图片地址后缀名）
 */
- (void)asyncUploadImages:(NSArray<UIImage *> *)images avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names,  UploadStatus state))complete;

/**
 同步批量上传图片
 
 @param images   图片数组
 @param complete 完成回调（图片地址后缀名）
 */
- (void)syncUploadImages:(NSArray<UIImage *> *)images avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names,  UploadStatus state))complete;

- (void)asyncUploadPicks:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names,  UploadStatus state))complete;

//异步上传数据文件
- (void)asyncUploadTheRecording:(NSString*)fullpath complete:(void(^)(NSString *name,  UploadStatus state))complete;
/*!
 * @brief 解析返回的数据
 * @return 正确返回ResponseModel对象，错误返回ErrorModel对象
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
