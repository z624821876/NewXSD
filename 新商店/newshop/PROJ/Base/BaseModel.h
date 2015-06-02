//
//  BaseModel.h
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

/** Model的子类统一用id字段(NSString)，来作为实体类的id,比如userId，infoId（json返回id)。
 *  存入sqlite表时，用的是pid字段做主键，id字段依旧代表userId,infoId(json返回id）
 *  user的返回json因为用了userid作关键字，所以init方法重写了self.id = [[attributes valueForKeyPath:@"userid"] integerValue];
 */

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic,strong) NSString *id;

- (id)initWithAttributes:(NSDictionary *)attributes;

/**
 网络读取列表（BaseModel的子类所组成的array）
 
 @param     path    http地址url
 @param     params  参数
 @param     void (^)(NSDictionary *dict, NSString *code, NSString *msg, NSError *error)block 回调方法，resultArray是返回的array，包含的是BaseModel的子类
 */
+ (void)getModelArrayWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(NSArray *resultArray, NSString *code, NSString *msg, NSError *error))block;

/**
 网络读取BaseModel的子类
 
 @param     path    http地址url
 @param     params  参数
 @param     void (^)(BaseModel *model, NSString *code, NSString *msg, NSError *error)block 回调方法，model是返回的BaseModel子类
 */
+ (void)getModelWithPath:(NSString *)path WithParams:(NSDictionary *)params WithBlock:(void (^)(BaseModel *model, NSString *code, NSString *msg, NSError *error))block;




@end

