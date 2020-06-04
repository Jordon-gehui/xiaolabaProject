//
//  NewWorking.h
//  xiaolaba
//
//  Created by cs on 2017/9/9.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "NetWorking.h"
#import "XLBUser.h"
#import "XLBLoginViewController.h"
#import <AliyunOSSiOS/OSSService.h>
#import <Hyphenate/Hyphenate.h>

#define kCommonError @"服务器错误"
#define kNetworkStatusNotification @"kNetworkStatusNotification"    // 网络变化监测
#define kLocationChooseNotification @"locationChooseNotification" // 选择地理位置

static NSString *const BucketName = @"";
static NSString *const AliYunHost = @"";

static NSString *kAvatarFolder = @"avatar";
static NSString *kMomentFolder = @"moment";
static NSString *kPick = @"pick";

@interface NetWorking ()<UIAlertViewDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) OSSClient *client;

@property (nonatomic, retain)UIAlertView *alert;

@property (nonatomic, retain) UIViewController *result;
@end

@implementation NetWorking

- (AFHTTPSessionManager *)manager {
    
    if(!_manager) {
        
        // 打开状态栏的等待菊花
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HOSTNAME] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.requestSerializer.timeoutInterval = 5;
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/html",
                                                                                   @"text/json",
                                                                                   @"text/plain",
                                                                                   @"text/javascript",
                                                                                   @"text/xml",
                                                                                   @"image/*",
                                                                                   @"text/html"]];
    }
    return _manager;
}

- (NSMutableURLRequest *)request {
    
    if(!_request) {
        
        _request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"" parameters:nil error:nil];
        _request.timeoutInterval = 20;
        [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_request setValue:@"t" forHTTPHeaderField:@"mobile"];
    }
    return _request;
}

+ (instancetype)network {
    
    static NetWorking *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        client = [[self.class alloc] init];
    });
    return client;
}

- (void)startMonitorNetwork {
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                _netStatus = StatusUnknown;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                _netStatus = StatusNotReachable;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                _netStatus = StatusReachableViaWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                _netStatus = StatusReachableViaWiFi;
            }
                break;
                
            default:
                break;
        }
        [kNotificationCenter postNotification:[NSNotification notificationWithName:kNetworkStatusNotification object:nil userInfo:@{@"status":@(_netStatus)}]];
    }];
    [reachabilityManager startMonitoring];
}
- (void)POST:(NSString *)url params:(NSDictionary *)params cache:(BOOL )cache success:(void(^)(id result))success failure:(void(^)(NSString *description))failure {
    if ([url isEqualToString:@"user/login"]) {
        self.request=nil;
    }
    self.request.HTTPMethod = @"POST";
    self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTNAME,url]];
    [self addHttpHeader];

    if(params) {
        NSString *stringJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSData *data = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
        [self.request setHTTPBody:data];
    }
    [[self.manager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"一次请求接口 %@",self.request.URL);
        if(!error) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            // 定制
            if([[responseDictionary allKeys] containsObject:@"code"]) {
                NSInteger code = [responseObject[@"code"] integerValue];
                NSString *message = responseObject[@"message"];
                NSLog(@"----------- code  - %ld message-%@",(long)code,message);
                if(code == NetworkCodeSuccess) {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                    });
                    success([responseObject objectForKey:@"data"]);

                }else if (code == NetworkCodeOtherLoginError) {
                    NSLog(@"%@",url);
                    [self alert];
                    failure(error.description);
                }else{
                    failure(message);

                }
            }
            else {

                failure(error.description);
                
                NSLog(@"srror - > %@",error.description);
            }
        }
        else {
            failure(error.description);
            NSLog(@"srror - > %@",error.description);
        }
    }] resume];
}

- (void)GET:(NSString *)url params:(NSDictionary *)params cache:(BOOL )cache success:(void(^)(id result))success failure:(void(^)(NSString *description))failure {
    
    [self.manager.requestSerializer  setValue:@"application/json"  forHTTPHeaderField:@"Content－Type"];

    self.request.HTTPMethod = @"GET";
    self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTNAME,url]];
    [self addHttpHeader];
    if(params) {
        NSString *stringJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSData *data = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
        [self.request setHTTPBody:data];
    }
    [[self.manager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if(!error) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            // 定制
            if([[responseDictionary allKeys] containsObject:@"code"]) {
                NSInteger code = [responseObject[@"code"] integerValue];
                if(code == NetworkCodeSuccess) {
                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                    });
                    success(responseDictionary);
                }
                else {

                        failure(descByErrorCode(code));
                }
            }
            else {
                failure(error.description);
                NSLog(@"cuowu == %@",error.description);

            }
        }
        else {
            failure(error.description);            
            NSLog(@"cuowu == %@",error.description);
        }
    }] resume];
}


- (void)GET2:(NSString *)url params:(NSDictionary *)params cache:(BOOL )cache success:(void(^)(id result))success failure:(void(^)(NSString *description))failure {
    NSString *httpStr = [NSString stringWithFormat:@"%@%@/%@?native=",HOSTNAME,url,[params objectForKey:@"key"]];
    NSLog(@"httpStr==%@",httpStr);
    [self.manager GET:httpStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject====%@",responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == NetworkCodeSuccess) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            success(dic);
        }else{
            failure(descByErrorCode(code));
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        failure(error.description);
    }];
}

- (void)asyncUploadImage:(UIImage *)image avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names, UploadStatus state))complete {
    
    [self uploadImages:@[image] avatar:avatar isAsync:YES complete:complete];
}

- (void)syncUploadImage:(UIImage *)image avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names, UploadStatus state))complete {
    
    [self uploadImages:@[image] avatar:avatar isAsync:NO complete:complete];
}

- (void)asyncUploadImages:(NSArray<UIImage *> *)images avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names,  UploadStatus state))complete {
    
    [self uploadImages:images avatar:avatar isAsync:YES complete:complete];
}

- (void)syncUploadImages:(NSArray<UIImage *> *)images avatar:(BOOL )avatar complete:(void(^)(NSArray<NSString *> *names,  UploadStatus state))complete {
    
    [self uploadImages:images avatar:avatar isAsync:NO complete:complete];
}

-(void)addHttpHeader {
    //网络超时
    if(kNotNil([XLBUser user].token)) {
        [self.request setValue:[XLBUser user].token forHTTPHeaderField:@"token"];
        
    }
    [self.request setValue:@"t" forHTTPHeaderField:@"mobile"];
    
}
- (OSSClient *)client {
    
    if(!_client) {
        id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
            // 实现一个函数，同步返回从server获取到的STSToken
            return [self getFederationToken];
        }];
        
        // 用endpoint、凭证提供器初始化一个OSSClient
        _client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
    }
    return _client;
}

-(UIAlertView*)alert {
    if (!_alert) {
        _result = [self topViewController];
        _alert=[[UIAlertView alloc]initWithTitle:@"您的账号已在其他设备登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [_alert show];
    }
    return _alert;
}
-(void) alertRemove {
    _alert = nil;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[XLBUser user] logout];
    [[EMClient sharedClient] logout:YES completion:nil];
    
    [[[XLBLoginViewController alloc]init] openWithController:_result returnBlock:nil];
    [_result.navigationController popToRootViewControllerAnimated:NO];
    [RootTabbarController sharedRootBar].selectedIndex = 0;

}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
//异步上传数据文件
- (void)asyncUploadTheRecording:(NSString*)fullpath complete:(void(^)(NSString *name,  UploadStatus state))complete {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.bucketName = BucketName;
                NSString *imageName = [kPick stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".mp3"]];
                put.objectKey = imageName;
                put.uploadingFileURL = [NSURL fileURLWithPath:fullpath];
//                put.uploadingData = data;
                
                OSSTask *putTask = [self.client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                
                if (complete) {
                    complete(imageName ,UploadStatusSuccess);
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
}
#pragma  mark - 中途增加的图片存储，不方便在原来的方法上修改了，另辟一个方法，重复代码
- (void)asyncUploadPicks:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names,  UploadStatus state))complete {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.bucketName = BucketName;
                NSString *imageName = [kPick stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                put.objectKey = imageName;
                [callBackNames addObject:imageName];
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                
                OSSTask *putTask = [self.client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                if (image == images.lastObject) {
                    NSLog(@"upload object finished!");
                    if (complete) {
                        complete([NSArray arrayWithArray:callBackNames] ,UploadStatusSuccess);
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
}

- (void)uploadImages:(NSArray<UIImage *> *)images avatar:(BOOL )avatar isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names, UploadStatus state))complete {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.bucketName = BucketName;
//                NSString *uuid = [NSString stringWithFormat:@"2017/11/01/%@",[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                NSString *imageName = [avatar ? kAvatarFolder:kMomentFolder stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                put.objectKey = imageName;
                [callBackNames addObject:imageName];
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                put.uploadingData = data;
                
                OSSTask *putTask = [self.client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                if (isAsync) {
                    if (image == images.lastObject) {
                        NSLog(@"upload object finished!");
                        if (complete) {
                            complete([NSArray arrayWithArray:callBackNames] ,UploadStatusSuccess);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        if (complete) {
            if (complete) {
                complete([NSArray arrayWithArray:callBackNames], UploadStatusSuccess);
            }
        }
    }
}

- (OSSFederationToken *)getFederationToken {
    
    // http://192.168.1.103:9993/sts/credential
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@img/sts/credential",HOSTNAME]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    if(kNotNil([XLBUser user].token)) {
        [request setValue:[XLBUser user].token forHTTPHeaderField:@"token"];
    }
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [tcs setError:error];
                                                        return;
                                                    }
                                                    [tcs setResult:data];
                                                }];
    [sessionTask resume];
    
    // 实现这个回调需要同步返回Token，所以要waitUntilFinished
    [tcs.task waitUntilFinished];
    
    if (tcs.task.error) {
        // 如果网络请求出错，返回nil表示无法获取到Token。该次请求OSS会失败。
        return nil;
    } else {
        // 从网络请求返回的内容中解析JSON串拿到Token的各个字段，组成STSToken返回
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                               options:kNilOptions
                                                                 error:nil];
        NSDictionary *data = [object objectForKey:@"data"];
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = [data objectForKey:@"accessKeyId"];
        token.tSecretKey = [data objectForKey:@"accessKeySecret"];
        token.tToken = [data objectForKey:@"securityToken"];
        token.expirationTimeInGMTFormat = [data objectForKey:@"expiration"];
        
        return token;
    }
}


NSString *stringFromDictionary(NSDictionary *params) {
    
    if(params == nil || [params isKindOfClass:[NSNull class]]) return @"";
    NSArray *keys = [params allKeys];
    NSMutableString *string = [NSMutableString string];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *value = [NSString stringWithFormat:@"%@",params[obj]];
        if(idx == keys.count - 1) {
            [string appendFormat:@"%@=%@",obj,value];
        }
        else {
            [string appendFormat:@"%@=%@&",obj,value];
        }
    }];
    return string;
}

NSString *descByErrorCode(NSInteger code) {
    
    NSString *error = @"未知错误";
    switch (code) {
        case 000000:
            error = @"成功";
            break;
        case 100000:
            error = @"错误";
            break;
        case 100001:
            error = @"非法参数";
            break;
        case 200000:
            error = @"没有权限";
            break;
            
        default:
            break;
    }
    
    return error;
}

/*!
 * @brief 把字典转换成格式化的JSON格式的字符串
 * @param dic 字典
 * @param insert 是否插入"\"
 * @return 返回JSON格式的字符串
 */
- (NSString *)jsonStringWithDictionary:(NSDictionary *)dic insert:(BOOL)insert{
    
    if (dic == nil) {
        return @"";
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error) {
        NSLog(@"dictionary解析失败：%@",error);
        return @"";
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (!insert) return jsonString;
    
    NSString *json = [jsonString copy];
    
    for (NSInteger i = 0, j = 0; i < [jsonString length]; i++) {
        
        NSString *s = [jsonString substringWithRange:NSMakeRange(i, 1)];
        
        if ([s isEqualToString:@"\""]) {
            
            NSRange range = NSMakeRange(i + j, 1);
            
            json = [json stringByReplacingCharactersInRange:range withString:@"\\\""];
            
            j++;
        }
    }
    return json;
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if ([NSString isBlankString:jsonString]) {
        return nil;
    }
    
//    NSString *json = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

NSString *networkCacheKey(NSString *url, NSDictionary *params) {
    
    return [NSString stringWithFormat:@"%@?%@",url,stringFromDictionary(params)];
}

@end






















