//
//  JKNetworkHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/23.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "JKNetworkHelper.h"
#import <MJExtension.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "JKNetworkCache.h"
#import "UIImage+JKSuperCompress.h"

/** 选取适用的Manager */
#define kAFManager ([self needSSLValidateForDomain:URL] ? _securityPolicyManager : _commonManager)

@interface  JKNetworkHelper()

/** 是否需要进行自认证 */
+ (BOOL)needSSLValidateForDomain:(NSString *)URL;

/** 获取普通AFHTTPSessionManager对象 */
+ (AFHTTPSessionManager *)getCommonManger;

/** 获取带SSL证书AFHTTPSessionManager对象 */
+ (AFHTTPSessionManager *)getSecurityPolicyManger;

/** 获取Cache对象 */
+ (void)fetchCache:(NSString *)URL parameters:(NSDictionary *)parameters cache:(JKHttpRequestCacheResponse)cache;

@end
@implementation JKNetworkHelper
static NSMutableArray *_allSessionTask;
static NSString* _authorization;

/** 普通对象 */
static AFHTTPSessionManager* _commonManager;
/** 带SSL验证AFHTTPSessionManager */
static AFHTTPSessionManager* _securityPolicyManager;

#pragma mark - 初始化配置
+ (void)initialize{
    _commonManager = [self getCommonManger];
    _securityPolicyManager = [self getSecurityPolicyManger];
}

#pragma mark - Private methods
+ (BOOL)needSSLValidateForDomain:(NSString *)URL{
    return NO;
}

+ (void)setToken:(NSString *)newToken{
    if (newToken) {
        [_commonManager.requestSerializer setValue:newToken forHTTPHeaderField:@"Authorization"];
    }
}

+ (AFHTTPSessionManager *)getCommonManger{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer  = [AFJSONRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    if (_authorization != nil) {
        [manger.requestSerializer setValue:_authorization forHTTPHeaderField:@"Authorization"];
    }
    manger.requestSerializer.timeoutInterval = 30.f;
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    return manger;
}

+ (AFHTTPSessionManager *)getSecurityPolicyManger{
    AFHTTPSessionManager *manger = [self getCommonManger];
    [self setSecurityPolicyWithCerPath:manger cerPath:APIServerCerPath validatesDomainName:NO];
    return manger;
}


+(void)fetchCache:(NSString *)URL parameters:(NSDictionary *)parameters cache:(JKHttpRequestCacheResponse)cache{
    // 获取缓存
    cache ? [JKNetworkCache httpCacheForURL:URL parameters:parameters withBlock:^(id<NSCoding> object) {
        if (object){
            cache(object);
        }
    }] : nil;
}
#pragma mark - 请求方法封装
+ (NSURLSessionTask *)request:(JKHttpRequestType)requestType URL:(NSString *)URL parameters:(NSDictionary *)parameters cache:(JKHttpRequestCacheResponse)cache success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    switch (requestType) {
        case JKHttpRequestTypeGET:
            return [self GET:URL parameters:parameters cache:cache success:success failure:failure];
            break;
        case JKHttpRequestTypePOST:
            return [self POST:URL parameters:parameters cache:cache success:success failure:failure];
            break;
        case JKHttpRequestTypePUT:
            return [self PUT:URL parameters:parameters cache:cache success:success failure:failure];
            break;
        case JKHttpRequestTypeDELETE:
            return [self DELETE:URL parameters:parameters success:success failure:failure];
        default:
            return nil;
            break;
    }
}

+(NSURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters cache:(JKHttpRequestCacheResponse)cache success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{

    [self fetchCache:URL parameters:parameters cache:cache];
    NSURLSessionTask *sessionTask = [kAFManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        cache ? [JKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;//存入缓存
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

+ (NSURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters cache:(JKHttpRequestCacheResponse)cache success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    [self fetchCache:URL parameters:parameters cache:cache];
    NSURLSessionTask *sessionTask = [kAFManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        cache ? [JKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

+ (NSURLSessionTask *)PUT:(NSString *)URL parameters:(NSDictionary *)parameters cache:(JKHttpRequestCacheResponse)cache success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    [self fetchCache:URL parameters:parameters cache:cache];
    NSURLSessionTask *sessionTask =  [kAFManager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
        cache ? [JKNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

+ (NSURLSessionTask *)DELETE:(NSString *)URL parameters:(NSDictionary *)parameters success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    NSURLSessionTask *sessionTask = [kAFManager DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

+ (NSURLSessionTask *)uploadSingleImageWithURL:(NSString *)URL parameters:(NSDictionary *)parameters image:(UIImage *)image name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(JKHttpRequestProgress)progress success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    NSURLSessionTask *sessionTask = [kAFManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩-添加-上传
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:@"file"
                                    fileName:fileName
                                    mimeType:[NSString stringWithFormat:@"image/%@",mimeType ? mimeType : @"jpeg"]];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}


+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(JKHttpRequestProgress)progress success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    NSURLSessionTask *sessionTask = [kAFManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //压缩-添加-上传
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:name
                                    fileName:[NSString stringWithFormat:@"%@%lu.%@",fileName,(unsigned long)idx,mimeType ? mimeType : @"jpeg"]
                                    mimeType:[NSString stringWithFormat:@"image/%@",mimeType ? mimeType : @"jpeg"]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(JKHttpRequestProgress)progress success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data && failure) {
        NSError *error = [[NSError alloc] init];
        failure(error);
        return nil;
    }
    
    NSURLSessionTask *sessionTask = [kAFManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType ? mimeType : @"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

+(NSURLSessionTask *)downLoadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters fileDir:(NSString *)fileDir progress:(JKHttpRequestProgress)progress success:(JKHttpRequestSuccess)success failure:(JKHttpRequestFailed)failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [kAFManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (fileDir){
            [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
            return [NSURL fileURLWithPath:fileDir];
        }
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"Download"];
        //创建下载目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(failure && error) {
            failure(error) ;
            return ;
        };
        success ? success(filePath.absoluteString) : nil;
    }];
    
    //开始下载
    [downloadTask resume];
    return downloadTask;
}

+ (void)setSecurityPolicyWithCerPath:(AFHTTPSessionManager *)manager cerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName{
    
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    [manager setSecurityPolicy:securityPolicy];
}

@end

