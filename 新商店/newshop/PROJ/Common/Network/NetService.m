//
//  NetService.m
//  mlh
//
//  Created by qd on 13-5-9.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "NetService.h"

#import "UploadClient.h"
#import "Info.h"

@implementation NetService

#pragma mark -
#pragma mark - RestClient
/**
 复杂的json读取方法
 所有的get方法都可从这里过，也可按业务分割成几个方法。毕竟把所有的字段都放这里，太拥挤了。
 比如只读取信息列表、栏目列表、是否成功，返回字符串的，可以只读取info,item,code,msg这几个字段。
 
 @param     path    http地址url
 @param     params  参数
 @param     void (^)(NSDictionary *resultDict, NSString *code, NSString *msg, NSError *error)block 回调方法，resultDict是返回json的装配对象。可以把所有可能返回的json字段都装配在这里，比如：info,item,msg等等。 调用时只需要读取[dict valueForKey:@""]即可。 返回的resultDict用中文做关键字，是因为宜理解记忆，并且这个关键字不用改（即使json中的关键字段名改掉了，也不用到各个业务视图里去改这个关键字）
 */
+ (void)getMixObjectDictWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSDictionary *resultDict, NSString *code, NSString *msg,  NSError *error))block{
    
    [[RestClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSString *code = [JSON valueForKeyPath:@"code"];
        NSString *msg = [JSON valueForKeyPath:@"msg"];
        //resultDict,返回结果集，是由model object array所组成的dictionary
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        //jsonArray ，json返回的字符串array
        NSArray *jsonArray = [NSArray array];
        //objectArray，装配过的model object array
        NSMutableArray *objectArray = [NSMutableArray array];
        jsonArray =[JSON valueForKeyPath:@"itemlist"];
       if(![jsonArray isKindOfClass:[NSNull class]])
       {
           objectArray = [NSMutableArray arrayWithCapacity:[jsonArray count]];
           for (NSDictionary *attributes in jsonArray)
           {
               Info *data = [[Info alloc] initWithAttributes:attributes];
               [objectArray addObject:data];
             
           }
           [resultDict setValue:objectArray forKey:@"infolist"];
       }
        
        jsonArray = [JSON valueForKeyPath:@"infolist"];
        
        if(![jsonArray isKindOfClass:[NSNull class]])
        {
            objectArray = [NSMutableArray arrayWithCapacity:[jsonArray count]];
            for (NSDictionary *attributes in jsonArray)
            {
                Info *data = [[Info alloc] initWithAttributes:attributes];
                [objectArray addObject:data];
            }
            [resultDict setValue:objectArray forKey:@"infolist"];
        }
        jsonArray = [JSON valueForKeyPath:@"date"];
        
        if(![jsonArray isKindOfClass:[NSNull class]])
        {
            objectArray = [NSMutableArray arrayWithCapacity:[jsonArray count]];
            for (NSDictionary *attributes in jsonArray)
            {
                Info *data = [[Info alloc] initWithAttributes:attributes];
                [objectArray addObject:data];
            }
            [resultDict setValue:objectArray forKey:@"date"];
        }

        jsonArray = [JSON valueForKeyPath:@"imagelist"];
        
        if(![jsonArray isKindOfClass:[NSNull class]])
        {
            objectArray = [NSMutableArray arrayWithCapacity:[jsonArray count]];
            for (NSDictionary *attributes in jsonArray)
            {
                Info *data = [[Info alloc] initWithAttributes:attributes];
                [objectArray addObject:data];
            }
            [resultDict setValue:objectArray forKey:@"imagelist"];
        }
        DLog(@"jsonArray=%@",jsonArray);
    
//        jsonArray = [JSON valueForKeyPath:@"imagelist"];
//        if(![jsonArray isKindOfClass:[NSNull class]])
//        {
//            
//        }
        
        //这里这样处理是因为服务器端的json接口写的很不一致。itemlist里的链接一会有itemlist,一会又没有。
        //本来应该有
         
        if (block) {
            block([NSDictionary dictionaryWithDictionary:resultDict], code, msg, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSDictionary dictionary], nil, nil, error);
        }
    }];
}

/**
 * 只获取code和msg,一般用于向服务器端SAVE数据的接口，适合数据量较小的，用get方法（效率高），如收藏、登陆，等等。
 */
+ (void)getResultWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSString *code, NSString *msg, NSError *error))block{
    [[RestClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {

        NSString *code = [JSON valueForKeyPath:@"code"];
        NSString *msg = [JSON valueForKeyPath:@"msg"];
        
        if (block) {
            block(code, msg, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
}

/**
 * 只获取code和msg,一般用于向服务器端SAVE数据的接口，适合数据量较大的，用post方法，如发帖、评论、日志保存，等等。
 */
+ (void)postResultWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSString *code, NSString *msg, NSError *error))block{
    [[RestClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSString *code = [JSON valueForKeyPath:@"code"];
        NSString *msg = [JSON valueForKeyPath:@"message"];
        
        if (block) {
            block(code, msg, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            [operation waitUntilFinished];
            block(nil, nil, error);
        }
    }];
}

#pragma mark -
#pragma mark - UploadClient

/**
 * 用post方法，发送form数据，特别用于图片文件等上传,返回errCode,fileUrl,error（http返回code,msg）
 *
 */
+ (void)postFormWithPath:(NSString *)path
                  params:(NSDictionary *)params
                formdata:(void (^)(id<AFMultipartFormData> formdata)) formdata
                progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                WithBlock:(void (^)(NSString *errCode, NSString *fileUrl, NSError *error))block{
    
    NSURLRequest *request = [[UploadClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:params constructingBodyWithBlock:formdata];

    
    AFHTTPRequestOperation *operation =  [[UploadClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *errCode = [[responseObject valueForKeyPath:@"error"] stringValue];    //因为返回的是error=1而不是error="1"格式
        NSString *fileUrl = [responseObject valueForKeyPath:@"url"];
        
        if (block) {
            block(errCode, fileUrl, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, nil, error);
        }
    }];
    
    [operation setUploadProgressBlock:progress];
    //[operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:nil]; //后台运行
    [[UploadClient sharedClient] enqueueHTTPRequestOperation:operation];
}




@end
