//
//  NdUncaughtExceptionHandler.m
//  mlh
//
//  Created by qd on 13-5-24.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "NdUncaughtExceptionHandler.h"

#import "Util.h"
#import "AppDelegate.h"
#import "NetService.h"
@interface NdUncaughtExceptionHandler ()

@end

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *stackSymbolArray = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *content = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                         name,reason,[stackSymbolArray componentsJoinedByString:@"\n"]];
    
    content = [Util getUTF8Str:[Util stringByRemoveTrim:content]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content", nil];

    [NetService postResultWithPath:[tools getServiceUrl:jsonErrLogSave] WithParams:params WithBlock:^(NSString *code, NSString *msg, NSError *error) {
        debugLog(@"code:%@,msg:%@,error:%@",code,msg,error);
    }];

    //NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    //[url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
    
}

@implementation NdUncaughtExceptionHandler

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler); 
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

@end