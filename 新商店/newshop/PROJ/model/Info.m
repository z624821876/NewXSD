//
//  Info.m
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "Info.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

// 建表语句
#define createSQL @"CREATE TABLE Info ('pid' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'title' TEXT, 'url' TEXT,'fatherId' TEXT, 'image' TEXT,'summary' TEXT, 'publicTime' TEXT,'linker' TEXT)"
// 数据插入语句
#define insertSQL @"INSERT INTO Info (title,url,fatherId,image,summary,publicTime,linker) VALUES(?,?,?,?,?,?,?)"
// 删除全部信息
#define deleteAllSQL @"DELETE FROM Info"
// 获取全部
#define getASQL @"SELECT * FROM Info WHERE fatherId = ?"

#define getAllSQL @"SELECT * FROM Info"
//// 获取用户与某个好友之间的聊天记录
//#define getChats @"SELECT * FROM Message WHERE userid= ? AND friendid= ?"
//#define getChats1 @"SELECT * FROM ( SELECT * FROM Message WHERE userid= ? AND friendid= ? ORDER BY pid desc LIMIT 5) ORDER BY pid asc"





@implementation Info

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    

    
    self.title = nilOrJSONObjectForKey(attributes, @"title");
    self.title = nilOrJSONObjectForKey(attributes, @"content");
    self.title = nilOrJSONObjectForKey(attributes, @"filePath");
    self.title = nilOrJSONObjectForKey(attributes, @"clickurl");
    self.name = nilOrJSONObjectForKey(attributes, @"name");
    self.image = nilOrJSONObjectForKey(attributes, @"image");
    self.contact = nilOrJSONObjectForKey(attributes, @"contact");
    self.mobile = nilOrJSONObjectForKey(attributes, @"mobile");
    self.address = nilOrJSONObjectForKey(attributes, @"address");
    self.logo = nilOrJSONObjectForKey(attributes, @"logo");
    self.latitude = nilOrJSONObjectForKey(attributes, @"latitude");
    self.longitude = nilOrJSONObjectForKey(attributes, @"longitude");
    self.provinceId = nilOrJSONObjectForKey(attributes, @"provinceId");
    self.districtId = nilOrJSONObjectForKey(attributes, @"districtId");
    self.cityId = nilOrJSONObjectForKey(attributes, @"cityId");
    self.detailImage = nilOrJSONObjectForKey(attributes, @"detailImage");
    self.price = nilOrJSONObjectForKey(attributes, @"price");
    self.discountPrice = nilOrJSONObjectForKey(attributes, @"discountPrice");
    self.catId = nilOrJSONObjectForKey(attributes, @"catId");
    self.catName = nilOrJSONObjectForKey(attributes, @"catName");
    self.productStore = nilOrJSONObjectForKey(attributes, @"productStore");
    self.viewCount = nilOrJSONObjectForKey(attributes, @"viewCount");
    self.imgPath = nilOrJSONObjectForKey(attributes, @"imgPath");
    self.text = nilOrJSONObjectForKey(attributes, @"text");
    self.shopName = nilOrJSONObjectForKey(attributes, @"shopName");
    self.amount = nilOrJSONObjectForKey(attributes, @"amount");
    self.createTime = nilOrJSONObjectForKey(attributes, @"createTime");
    self.balance = nilOrJSONObjectForKey(attributes, @"balance");
    self.userType = nilOrJSONObjectForKey(attributes, @"userType");
    self.objType = nilOrJSONObjectForKey(attributes, @"objType");
    
    self.url = nilOrJSONObjectForKey(attributes, @"url");
    self.summary = nilOrJSONObjectForKey(attributes, @"summary");
    self.publicTime = nilOrJSONObjectForKey(attributes, @"publicTime");
    self.linker = nilOrJSONObjectForKey(attributes, @"linker");
    self.fatherId = nilOrJSONObjectForKey(attributes, @"fatherId");
    self.areaId = nilOrJSONObjectForKey(attributes, @"areaId");
    self.position = nilOrJSONObjectForKey(attributes, @"position");
    self.isDeleted = nilOrJSONObjectForKey(attributes, @"isDeleted");
    self.distance = nilOrJSONObjectForKey(attributes, @"distance");
    self.objId = nilOrJSONObjectForKey(attributes, @"objId");
    self.type = nilOrJSONObjectForKey(attributes, @"type");
    self.orderingTime = nilOrJSONObjectForKey(attributes, @"orderingTime");
    self.orderTime = nilOrJSONObjectForKey(attributes, @"orderTime");
    self.completeTime = nilOrJSONObjectForKey(attributes, @"completeTime");
    self.status = nilOrJSONObjectForKey(attributes, @"status");
    self.memberId = nilOrJSONObjectForKey(attributes, @"memberId");
    self.teamId = nilOrJSONObjectForKey(attributes, @"teamId");
    self.teamName = nilOrJSONObjectForKey(attributes, @"teamName");
    self.linkman = nilOrJSONObjectForKey(attributes, @"linkman");
    self.linkphine = nilOrJSONObjectForKey(attributes, @"linkphine");
    self.carNo = nilOrJSONObjectForKey(attributes, @"carNo");
    self.remark = nilOrJSONObjectForKey(attributes, @"remark");
    self.commentDetail = nilOrJSONObjectForKey(attributes, @"commentDetail");
    self.staffId = nilOrJSONObjectForKey(attributes, @"staffId");
    self.startTime = nilOrJSONObjectForKey(attributes, @"startTime");
    self.isComplete = nilOrJSONObjectForKey(attributes, @"isComplete");
    self.orderNumber = nilOrJSONObjectForKey(attributes, @"orderNumber");
    self.fullName = nilOrJSONObjectForKey(attributes, @"fullName");
    self.level = nilOrJSONObjectForKey(attributes, @"level");
    self.parentId = nilOrJSONObjectForKey(attributes, @"parentId");
    
    //xiaofangzi
    self.payType = nilOrJSONObjectForKey(attributes, @"payType");
    self.dingjin = nilOrJSONObjectForKey(attributes, @"dingjin");
    self.color = nilOrJSONObjectForKey(attributes, @"color");
    self.colorName = nilOrJSONObjectForKey(attributes, @"colorName");
    self.num = nilOrJSONObjectForKey(attributes, @"num");
    self.shopId = nilOrJSONObjectForKey(attributes, @"shopId");
    self.stockSize = nilOrJSONObjectForKey(attributes, @"stockSize");
    self.totalPrice = nilOrJSONObjectForKey(attributes, @"totalPrice");
  
    self.orderNo = nilOrJSONObjectForKey(attributes, @"orderNo");
    self.payMethod = nilOrJSONObjectForKey(attributes, @"payMethod");
    

    /*
     memo;//备注
     @property (nonatomic,strong) NSString *mobile;
     @property (nonatomic,strong) NSString *orderNo;
     @property (nonatomic,strong) NSString *payMethod
     
     
     */
    return self;
}
#pragma mark-- Database Access
+ (BOOL)testDB
{
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        if(![db tableExists:@"Info"])
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

+ (BOOL) insert:(Info *)entity
{
    if(![self testDB])
    {
        return NO;
    }
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    
    if ([db open])
    {
        if([db tableExists:@"Info"])
        {
            BOOL res = [db executeUpdate:insertSQL, entity.title,entity.url,entity.fatherId,entity.image,entity.summary,entity.publicTime,entity.linker];
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

+ (NSMutableArray *)getAllwithId:(NSString *)infoId
{
    if(![self testDB]){
        return NO;
    }
    FMDatabase *db=[[FMDatabase alloc] initWithPath:dbPath];
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    if ([db open]) {
        FMResultSet *res=[db executeQuery:getASQL,infoId];
        while ([res next]) {
            Info *entity=[[Info alloc] initWithAttributes:[res resultDictionary]];
            [resultArray addObject:entity];
        }
    }
    [db close];
    return resultArray;
}

//本地搜索国家标准

#define getAllByPageSQL @"SELECT * FROM ZSTANDARD WHERE ZCATEGORY = 1  LIMIT ?,?" //国标1，机械行标2
#define searchTitleByPageSQL @"SELECT * FROM ZSTANDARD WHERE ZCATEGORY = 1 AND ZTITLE LIKE ? LIMIT ?,?" //
#define searchNoByPageSQL @"SELECT * FROM ZSTANDARD WHERE ZCATEGORY = 1 AND ZNO LIKE ? LIMIT ?,?" //

+ (BOOL)testGBDB
{
    FMDatabase * db = [FMDatabase databaseWithPath:GBPath];
    if ([db open])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSMutableArray *)getByKeyword:(NSString *)keyword Type:(NSString *)type PageNo:(NSString *)pageNo pageSize:(NSString *)pageSize
{
    if(![self testGBDB]){
        return NO;
    }
    FMDatabase *db=[[FMDatabase alloc] initWithPath:GBPath];
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    if ([db open]) {
        FMResultSet *res = nil;
        if (type == nil) {
            res=[db executeQuery:getAllByPageSQL,pageNo,pageSize];
        }else if([type isEqualToString:@"bzdh"]){
            res=[db executeQuery:searchNoByPageSQL,[NSString stringWithFormat:@"%%%@%%", keyword],pageNo,pageSize];
        }else if([type isEqualToString:@"bzmc"]){
            res=[db executeQuery:searchTitleByPageSQL,[NSString stringWithFormat:@"%%%@%%", keyword],pageNo,pageSize];
        }
        while ([res next]) {
            Info *entity=[[Info alloc] initWithAttributes:[res resultDictionary]];
            [resultArray addObject:entity];
        }
    }
    [db close];
    return resultArray;
}





@end

