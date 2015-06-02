//
//  AsyRequstClass2.m
//  TestAsyRequest___Block
//
//  Created by 刘璇 on 13-4-8.
//  Copyright (c) 2013年 刘璇. All rights reserved.
//

#import "AsyRequstClass2.h"

@implementation AsyRequstClass2
{
    NSMutableData * _recieveData;
    CompleteWithBlock _block;
}
//@synthesize block=_block;
-(void)dealloc
{
    Block_release(_block);
    [super dealloc];
}
-(id)initWithUrlStr:(NSString *)urlStr requestFinishedWith:(CompleteWithBlock)result
{
    if (self=[super init]) {
        NSURL * url=[NSURL URLWithString:urlStr];
        NSURLRequest * r=[[NSURLRequest alloc]initWithURL:url];
        [NSURLConnection connectionWithRequest:r  delegate:self];
//        self.block=result;
        _block= Block_copy(result);
//        _block=result;
        
    }
    DLog(@"()()())()()(");
    return self;
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recieveData=[[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recieveData appendData:data];
    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:_recieveData options:0 error:nil];
    if (_block) {//判断
        _block(dict);//block的调用
    }
}



@end
