//
//  HttpClient.h
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface RestClient : AFHTTPClient

+ (RestClient*) sharedClient;

@end

