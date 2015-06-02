//
//  NetService.h
//  mlh
//
//  Created by qd on 13-5-9.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "RestClient.h"

@interface NetService : NSObject

+ (void)getMixObjectDictWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSDictionary *resultDict, NSString *code, NSString *msg,  NSError *error))block;
 
/**
 * 只获取code和msg,用get方法（效率高）,一般用于向服务器端SAVE数据的接口，适合数据量较小的，如收藏、登陆，等等。
 */
+ (void)getResultWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSString *code, NSString *msg, NSError *error))block;

/**
 * 只获取code和msg,用post方法, 一般用于向服务器端SAVE数据的接口，适合数据量较大的，如发帖、评论、日志保存，等等。
 */
+ (void)postResultWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSString *code, NSString *msg, NSError *error))block;

/**
 * 用post方法，发送form数据，特别用于图片文件等上传,返回errCode,fileUrl,error（http返回code,msg）
 */
+ (void)postFormWithPath:(NSString *)path
                  params:(NSDictionary *)params
                formdata:(void (^)(id<AFMultipartFormData> formdata)) formdata
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
               WithBlock:(void (^)(NSString *errCode, NSString *fileUrl, NSError *error))block;



@end
