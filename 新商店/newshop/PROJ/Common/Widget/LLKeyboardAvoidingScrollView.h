//
//  LLKeyboardAvoidingScrollView.h
//  wallet2
//
//  Created by qiandong on 14-1-11.
//  Copyright (c) 2014年 LianLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLKeyboardAvoidingScrollViewDelegate <NSObject>

@optional

-(void)touchBG:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface LLKeyboardAvoidingScrollView : UIScrollView

@property (nonatomic,assign) id<LLKeyboardAvoidingScrollViewDelegate> llDelegate;

-(void)resignALlResponse;

@end
