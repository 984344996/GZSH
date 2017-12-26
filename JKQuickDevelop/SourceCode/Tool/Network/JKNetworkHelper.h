//
//  JKNetworkHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/23.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include (<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#ifndef kIsNetwork
#define kIsNetwork [AFNetworkReachabilityManager sharedManager].reachable  // 一次性判断是否有网的宏
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [AFNetworkReachabilityManager sharedManager].reachableViaWWAN  // 一次性判断是否为手机网络的宏
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;  // 一次性判断是否为WiFi网络的宏
#endif

typedef NS_ENUM(NSUInteger,JKHttpRequestType) {
    JKHttpRequestTypeGET,
    JKHttpRequestTypePOST,
    JKHttpRequestTypePUT,
    JKHttpRequestTypeDELETE
};

/** 缓存返回 */
typedef void (^JKHttpRequestCacheResponse)(id _Nonnull cacheObject);

/** http请求成功返回 */
typedef void(^JKHttpRequestSuccess)(id _Nonnull responseObject);

/** http请求失败返回 */
typedef void(^JKHttpRequestFailed)(NSError* _Nonnull error);

/** http请求进度 */
typedef void (^JKHttpRequestProgress)(NSProgress* _Nonnull progress);


@interface JKNetworkHelper : NSObject


/**
 HTTP请求

 @param requestType 请求类型
 @param URL 请求地址
 @param parameters 请求参数
 @param cache 缓存
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回对象用于取消请求
 */
+ (__kindof NSURLSessionTask* _Nonnull)request:(JKHttpRequestType)requestType
                                           URL:(NSString * _Nonnull)URL
                                    parameters:(NSDictionary * _Nullable)parameters
                                         cache:(JKHttpRequestCacheResponse _Nullable)cache
                                       success:(JKHttpRequestSuccess _Nullable)success
                                       failure:(JKHttpRequestFailed _Nullable)failure;


/**
 GET请求
 
 @param URL 请求地址
 @param parameters 请求参数
 @param cache 缓存
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回对象用于取消请求
 */
+ (__kindof NSURLSessionTask* _Nonnull)GET:(NSString * _Nonnull)URL
                                parameters:(NSDictionary * _Nullable)parameters
                                     cache:(JKHttpRequestCacheResponse _Nullable)cache
                                   success:(JKHttpRequestSuccess _Nullable)success
                                   failure:(JKHttpRequestFailed _Nullable)failure;

/**
 POST请求
 
 @param URL 请求地址
 @param parameters 请求参数
 @param cache 缓存
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回对象用于取消请求
 */
+ (__kindof NSURLSessionTask* _Nonnull)POST:(NSString * _Nonnull)URL
                                 parameters:(NSDictionary * _Nullable)parameters
                                      cache:(JKHttpRequestCacheResponse _Nullable)cache
                                    success:(JKHttpRequestSuccess _Nullable)success
                                    failure:(JKHttpRequestFailed _Nullable)failure;


/**
 PUT请求
 
 @param URL 请求地址
 @param parameters 请求参数
 @param cache 缓存
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回对象用于取消请求
 */
+ (__kindof NSURLSessionTask* _Nonnull)PUT:(NSString * _Nonnull )URL
                                parameters:(NSDictionary * _Nullable)parameters
                                     cache:(JKHttpRequestCacheResponse _Nullable)cache
                                   success:(JKHttpRequestSuccess _Nullable)success
                                   failure:(JKHttpRequestFailed _Nullable)failure;

/**
 DELETE请求
 
 @param URL 请求地址
 @param parameters 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回对象用于取消请求
 */
+ (__kindof NSURLSessionTask* _Nonnull)DELETE:(NSString * _Nonnull)URL
                                   parameters:(NSDictionary * _Nullable)parameters
                                      success:(JKHttpRequestSuccess _Nullable)success
                                      failure:(JKHttpRequestFailed _Nullable)failure;


/**
 上传图片

 @param URL 上传地址
 @param parameters 上传参数
 @param images 图片数组
 @param name 文件对应服务器上的字段
 @param fileName 文件名
 @param mimeType 图片文件的类型,例:png、jpeg(默认类型)....
 @param progress 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 @return 返回对象用于取消上传
 */
+ (__kindof NSURLSessionTask * _Nonnull)uploadWithURL:(NSString *_Nonnull)URL
                                           parameters:(NSDictionary *_Nullable)parameters
                                               images:(NSArray<UIImage *> * _Nonnull)images
                                                 name:(NSString * _Nonnull)name
                                             fileName:(NSString * _Nonnull)fileName
                                             mimeType:(NSString * _Nullable)mimeType
                                             progress:(JKHttpRequestProgress _Nullable)progress
                                              success:(JKHttpRequestSuccess _Nullable)success
                                              failure:(JKHttpRequestFailed _Nullable)failure;

/**
 上传文件
 
 @param URL 上传地址
 @param parameters 上传参数
 @param filePath 文件路径
 @param name 文件对应服务器上的字段
 @param fileName 文件名
 @param mimeType 图片文件的类型,例:png、jpeg(默认类型)....
 @param progress 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 @return 返回对象用于取消上传
 */
+ (__kindof NSURLSessionTask * _Nonnull)uploadWithURL:(NSString *_Nonnull)URL
                                           parameters:(NSDictionary *_Nullable)parameters
                                             filePath:(NSString * _Nonnull)filePath
                                                 name:(NSString * _Nonnull)name
                                             fileName:(NSString * _Nonnull)fileName
                                             mimeType:(NSString * _Nullable)mimeType
                                             progress:(JKHttpRequestProgress _Nullable)progress
                                              success:(JKHttpRequestSuccess _Nullable)success
                                              failure:(JKHttpRequestFailed _Nullable)failure;




/**
 下载文件

 @param URL 下载地址
 @param parameters 下载参数
 @param fileDir 下载目录
 @param progress 下载进度
 @param success 下载成功回调
 @param failure 下载失败回调
 @return  返回对象用于取消下载
 */
+ (__kindof NSURLSessionTask * _Nonnull)downLoadWithURL:(NSString *_Nonnull)URL
                                             parameters:(NSDictionary *_Nullable)parameters
                                                fileDir:(NSString * _Nullable)fileDir
                                               progress:(JKHttpRequestProgress _Nullable)progress
                                                success:(JKHttpRequestSuccess _Nullable)success
                                                failure:(JKHttpRequestFailed _Nullable)failure;
@end
