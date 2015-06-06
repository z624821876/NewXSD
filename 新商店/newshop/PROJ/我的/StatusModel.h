//
//  StatusModel.h
//  newshop
//
//  Created by 于洲 on 15/5/13.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusModel : NSObject

@property (nonatomic, strong) NSString          *time;
@property (nonatomic, strong) NSString          *statusId;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSString          *status;
@property (nonatomic, strong) NSString          *orderId;

@end
