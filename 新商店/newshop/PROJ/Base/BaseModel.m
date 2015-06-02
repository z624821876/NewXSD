//
//  BaseModel.m
//  mlh
//
//Users/niujh/Desktop/xiaofangzi/Sunday/newshop/PROJ/global.h/  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "BaseModel.h"
#import "RestClient.h"


@implementation BaseModel

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.id = [attributes valueForKeyPath:@"id"];
    return self;
}

/**
 网络读取BaseModel的子类所组成的array
 
 @param     path    http地址url
 @param     params  参数
 @param     void (^)(NSDictionary *resultArray, NSString *code, NSString *msg, NSError *error)block 回调方法，resultArray是返回的array，包含的是BaseModel的子类
*/
+ (void)getModelArrayWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSArray *resultArray, NSString *code, NSString *msg, NSError *error))block{
    
    [[RestClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON)
     {
        //NSDictionary *dict =  [[operation response] allHeaderFields];
        // 只取出当前model子类
        NSArray *jsonArray = [JSON valueForKeyPath:[self jsonkeyForModel]];
         
//        NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:[jsonArray count]];
        NSMutableArray *objectArray = [NSMutableArray array];
        if(![jsonArray isKindOfClass:[NSNull class]])
        {
            for (NSDictionary *attributes in jsonArray)
            {
                BaseModel *data = [[[self class] alloc] initWithAttributes:attributes];
                [objectArray addObject:data];
            }
        }
                
        NSString *code = [JSON valueForKeyPath:@"date"];
        NSString *msg = [JSON valueForKeyPath:@"msg"];
        
        if (block)
        {
            block([NSArray arrayWithArray:objectArray], code, msg, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block)
        {
            block([NSArray array],nil,nil, error);
        }
    }];
}

/**
 网络读取BaseModel的子类
 
 @param     path    http地址url
 @param     params  参数
 @param     void (^)(BaseModel *model, NSString *code, NSString *msg, NSError *error)block 回调方法，model是返回的BaseModel子类
 */
+ (void)getModelWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(BaseModel *model, NSString *code, NSString *msg, NSError *error))block{
    
    [[RestClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {

        BaseModel *model = [[self alloc] initWithAttributes:JSON];
        NSString *code = [JSON valueForKeyPath:@"code"];
        NSString *msg = [JSON valueForKeyPath:@"msg"];
        
        if (block) {
            block(model, code, msg, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, nil, nil, error);
        }
    }];
}


//配置model和jsonkey之间的关联
+(NSString *)jsonkeyForModel 
{
    NSString *jsonkeyForModel;
    if ([@"Company" compare:NSStringFromClass([self class])] == NSOrderedSame)
    {
        jsonkeyForModel = @"result";
    }
    if ([@"Product" compare:NSStringFromClass([self class])] == NSOrderedSame)
    {
        jsonkeyForModel = @"result";
    }
    return jsonkeyForModel;
}

@end
