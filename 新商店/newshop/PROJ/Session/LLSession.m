//
//  NetSession.m
//  wallet2
//
//  Created by qiandong on 13-12-17.
//  Copyright (c) 2013年 LianLian. All rights reserved.
//

#import "LLSession.h"

LLSession *sharedNetSession;

@implementation LLSession

+ (LLSession*)sharedSession
{
    if (sharedNetSession == nil)
    {
        @synchronized(self)
        {
            if (sharedNetSession == nil)
            {
                sharedNetSession = [[LLSession alloc] init];
                sharedNetSession.user = [[User alloc] init];
                sharedNetSession.province = [[Info alloc] init];
                sharedNetSession.city = [[Info alloc] init];
                sharedNetSession.area = [[Info alloc] init];
               
                
            }
        }
    }
    return sharedNetSession;
}
@end
