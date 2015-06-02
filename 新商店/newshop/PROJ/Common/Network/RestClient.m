//
//  HttpClient.m
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "RestClient.h"
#import "AFJSONRequestOperation.h"




@implementation RestClient

+ (AFHTTPClient*) sharedClient
{
    static RestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        _sharedClient = [[RestClient alloc] initWithBaseURL:[NSURL URLWithString:sBaseJsonURLStr]];
        /*
        [_sharedClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         {
             
            if (status == AFNetworkReachabilityStatusReachableViaWiFi)
            {
                [[tools shared] HUDShowHideText:@"WIFI网络" delay:1];
            }
            else if (status == AFNetworkReachabilityStatusReachableViaWWAN)
            {
                [[tools shared] HUDShowHideText:@"运营商网络" delay:1];
            }
            else if (status == AFNetworkReachabilityStatusNotReachable)
            {
                [[tools shared] HUDShowHideText:@"没有网络" delay:1];
            }
            else
            {
                [[tools shared] HUDShowHideText:@"未知网络" delay:1];
            }
         
        }];
         */
        
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Accept" value:@"text/plain"];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/png"]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/jpg"]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/jpeg"]];
    
    return self;
}

@end

