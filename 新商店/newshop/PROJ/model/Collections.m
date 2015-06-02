//
//  Collections.m
//  sdtea
//
//  Created by lange on 13-9-23.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "Collections.h"

#import "RestClient.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"

#define createSQL @"CREATE TABLE Collections ('pid' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'url' TEXT,'title',TEXT)"
#define insertSQL @"INSERT INTO Collections (url,title) VALUES(?,?)"
#define deleteAllSQL @"DELETE FROM Collections"
#define getAllSQL @"SELECT * FROM Collections"
#define searchByTitleSQL @"SELECT * FROM Collections WHERE title = ?"
#define deleteByTitleSQL @"DELETE FROM Collections WHERE title = ?"

@implementation Collections

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self)
    {
        return nil;
    }
    self.url = nilOrJSONObjectForKey(attributes, @"url");
    self.title = nilOrJSONObjectForKey(attributes, @"title");
    return self;
}


+ (BOOL)testDB
{
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        if(![db tableExists:@"Collections"])
        {
            BOOL res = [db executeUpdate:createSQL];
            [db close];
            return res;
        }
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) insert:(Collections *)entity
{
    if(![self testDB])
    {
        return NO;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        if([db tableExists:@"Collections"])
        {
            BOOL res = [db executeUpdate:insertSQL, entity.url,entity.title];
            [db close];
            return res;
        }
        return YES;
    }
    return NO;
}

+ (BOOL) deleteAll
{
    if(![self testDB])
    {
        return NO;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        BOOL res = [db executeUpdate:deleteAllSQL];
        [db close];
        return res;
    }
    return NO;
}


+ (BOOL) deleteItemByTitle:(Collections *)entity
{
    if(![self testDB])
    {
        return NO;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        BOOL res = [db executeUpdate:deleteByTitleSQL,entity.title];
        [db close];
        return res;
    }
    return NO;
}


+ (NSMutableArray *)getAll
{
    if(![self testDB]){
        return NO;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:20];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:getAllSQL];
        while ([rs next])
        {
            Collections *entity = [[Collections alloc] initWithAttributes:[rs resultDictionary]];
            [resultArray addObject:entity];
        }
        [db close];
    }
    return resultArray;
}


+ (Collections *)searchUniqueByTitle:(NSString *)searchTitle {
    if(![self testDB])
    {
        return NO;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    Collections *entity = nil;
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:searchByTitleSQL,searchTitle];
        while ([rs next]) {
            entity = [[Collections alloc] initWithAttributes:[rs resultDictionary]];
            break;
        }
        [db close];
    }
    return entity;
}


@end
