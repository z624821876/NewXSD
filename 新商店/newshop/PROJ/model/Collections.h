//
//  Collections.h
//  sdtea
//
//  Created by lange on 13-9-23.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "BaseModel.h"

@interface Collections : BaseModel
@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSString *url;
+ (BOOL)testDB;
+ (BOOL) insert:(Collections *)entity;
+ (BOOL) deleteAll;
+ (NSMutableArray *)getAll;
+ (Collections *)searchUniqueByTitle:(NSString *)searchTitle;
+ (BOOL) deleteItemByTitle:(Collections *)entity;

@end
