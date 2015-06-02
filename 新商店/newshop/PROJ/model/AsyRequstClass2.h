//
//  AsyRequstClass2.h
//  TestAsyRequest___Block
//
//  Created by 刘璇 on 13-4-8.
//  Copyright (c) 2013年 刘璇. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^CompleteWithBlock)(id  obj);//定义一个block新类型

@interface AsyRequstClass2 : NSObject

//@property(assign)CompleteWithBlock block;
-(id)initWithUrlStr:(NSString*)urlStr  requestFinishedWith:(CompleteWithBlock)result;
@end
