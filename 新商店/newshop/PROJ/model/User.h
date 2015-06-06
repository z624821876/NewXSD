//
//  User.h
//  cheshi
//
//  Created by qiandong on 14-11-20.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel<NSCoding>
@property (nonatomic, strong) NSString *userName; //账号
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *headUrl;

@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopURL;
@property (nonatomic, strong) NSString *shopCat;

@property (nonatomic, strong) NSString *openId;

@property (nonatomic, strong)NSString *referrer;

@end
