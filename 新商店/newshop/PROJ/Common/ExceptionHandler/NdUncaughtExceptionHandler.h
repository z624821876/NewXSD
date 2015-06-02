//
//  NdUncaughtExceptionHandler.h
//  mlh
//
//  Created by qd on 13-5-24.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NdUncaughtExceptionHandler : NSObject {
    
}

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;

@end