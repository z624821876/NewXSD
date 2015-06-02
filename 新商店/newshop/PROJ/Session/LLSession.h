//
//  NetSession.h
//  wallet2
//
//  Created by qiandong on 13-12-17.
//  Copyright (c) 2013年 LianLian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Info.h"

@interface LLSession : NSObject

+ (LLSession*)sharedSession;

@property (nonatomic,strong) User *user;


@property (nonatomic,strong) Info *province;
@property (nonatomic,strong) Info *city;
@property (nonatomic,strong) Info *area;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;
//订单



@end
