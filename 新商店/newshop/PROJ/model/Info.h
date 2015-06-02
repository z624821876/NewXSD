//
//  Info.h
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "BaseModel.h"

//普通信息，对应json的infolist关键字

@interface Info : BaseModel
@property (nonatomic,strong) NSString *productName;


@property (nonatomic,strong) NSString *soldCount;
@property (nonatomic,strong) NSString *groupDistance;
@property (nonatomic,strong) NSString *groupName;

@property (nonatomic, assign) CGFloat shopDiscount;

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *filePath;
@property(nonatomic,strong) NSString *clickurl;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *contact;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *logo;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *provinceId;
@property(nonatomic,strong) NSString *districtId;
@property(nonatomic,strong) NSString *cityId;
@property(nonatomic,strong) NSString *detailImage;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *discountPrice;
@property(nonatomic,strong) NSString *catId;
@property(nonatomic,strong) NSString *catName;
@property(nonatomic,strong) NSString *productStore;
@property(nonatomic,strong) NSString *viewCount;
@property(nonatomic,strong) NSString *imgPath;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSString *shopName;
@property(nonatomic,strong) NSString *amount;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *balance;
@property(nonatomic,strong) NSString *userType;
@property(nonatomic,strong) NSString *objType;

@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *summary;
@property(nonatomic,strong) NSString *publicTime;
@property(nonatomic,strong) NSString *linker;
@property(nonatomic,strong) NSString *fatherId;
@property(nonatomic,strong) NSString *areaId;
@property(nonatomic,strong) NSString *position;
@property(nonatomic,strong) NSString *isDeleted;
@property(nonatomic,strong) NSString *distance;
@property(nonatomic,strong) NSString *objId;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *orderingTime;
@property(nonatomic,strong) NSString *orderTime;
@property(nonatomic,strong) NSString *completeTime;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *memberId;
@property(nonatomic,strong) NSString *teamId;
@property(nonatomic,strong) NSString *teamName;
@property(nonatomic,strong) NSString *linkman;
@property(nonatomic,strong) NSString *linkphine;
@property(nonatomic,strong) NSString *carNo;
@property(nonatomic,strong) NSString *remark;
@property(nonatomic,strong) NSString *commentDetail;
@property(nonatomic,strong) NSString *staffId;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,strong) NSString *isComplete;
@property(nonatomic,strong) NSString *orderNumber;
@property(nonatomic,strong) NSString *fullName;
@property(nonatomic,strong) NSString *level;
@property(nonatomic,strong) NSString *parentId;
@property(nonatomic,strong) NSString *simpleDesc;
//xiaofangzi
@property (nonatomic,strong) NSString *dingjin;
@property (nonatomic,strong) NSString *payType;

@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *colorName;
@property (nonatomic,strong) NSString *num;
//@property (nonatomic,strong) NSString *productId; == id
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *stockSize;
@property (nonatomic,strong) NSString *totalPrice;

//订单
@property (nonatomic,strong) NSString *memo;//备注
@property (nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) NSString *payMethod;

@property (nonatomic,assign) NSInteger foodNum;




- (id)initWithAttributes:(NSDictionary *)attributes;
+ (BOOL)testDB;
+ (BOOL)insert:(Info *)entity;
+ (BOOL)deleteAll;
+ (NSMutableArray *)getAllwithId:(NSString *)infoId;

//本地搜索国家标准
+ (NSMutableArray *)getByKeyword:(NSString *)keyword Type:(NSString *)type PageNo:(NSString *)pageNo pageSize:(NSString *)pageSize;


@end