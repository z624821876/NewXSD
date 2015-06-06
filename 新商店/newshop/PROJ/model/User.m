//
//  User.m
//  cheshi
//
//  Created by qiandong on 14-11-20.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#define knameKey @"userName"
#define kIdKey   @"userId"
#define kHeadKey    @"headUrl"

#define kshopID     @"shopID"
#define kshopName   @"shopName"
#define kshopImg    @"shopImg"
#define kshopCat    @"shopCat"
#define kopenId     @"openId"

#define kreferrer   @"referrer"

#import "User.h"

@implementation User

//- (id)initWithAttributes:(NSDictionary *)attributes {
//    self = [super initWithAttributes:attributes];
//    if (!self) {
//        return nil;
//    }
//    
//    self.name = nilOrJSONObjectForKey(attributes, @"name");
//    self.userName = nilOrJSONObjectForKey(attributes, @"userName");
//    self.password = nilOrJSONObjectForKey(attributes, @"password");
//    return self;
//}

#pragma mark-NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.userName forKey:knameKey];
    [aCoder encodeObject:self.userId forKey:kIdKey];
    [aCoder encodeObject:self.headUrl forKey:kHeadKey];
    [aCoder encodeObject:self.openId forKey:kopenId];
    [aCoder encodeObject:self.shopID forKey:kshopID];
    [aCoder encodeObject:self.shopName forKey:kshopName];
    [aCoder encodeObject:self.shopURL forKey:kshopImg];
    [aCoder encodeObject:self.shopCat forKey:kshopCat];
    [aCoder encodeObject:self.referrer forKey:kreferrer];
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        self.userId = [aDecoder decodeObjectForKey:kIdKey];
        self.headUrl = [aDecoder decodeObjectForKey:kHeadKey];
        self.userName = [aDecoder decodeObjectForKey:knameKey];
        self.openId = [aDecoder decodeObjectForKey:kopenId];
        self.shopID = [aDecoder decodeObjectForKey:kshopID];
        self.shopName = [aDecoder decodeObjectForKey:kshopName];
        self.shopURL = [aDecoder decodeObjectForKey:kshopImg];
        self.shopCat = [aDecoder decodeObjectForKey:kshopCat];
        self.referrer = [aDecoder decodeObjectForKey:kreferrer];
    }
    
    return self;
}


@end
