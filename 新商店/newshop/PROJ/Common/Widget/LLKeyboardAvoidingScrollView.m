//
//  LLKeyboardAvoidingScrollView.m
//  wallet2
//
//  Created by qiandong on 14-1-11.
//  Copyright (c) 2014年 LianLian. All rights reserved.
//

#import "LLKeyboardAvoidingScrollView.h"

@implementation LLKeyboardAvoidingScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setShowsVerticalScrollIndicator:YES];
        [self setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Responders, events
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self resignALlResponse];
    
    [super touchesEnded:touches withEvent:event];
    
    if (self.llDelegate != nil) {
        [self.llDelegate touchBG:touches withEvent:event];
    }
}

-(void)resignALlResponse
{
    [[self findFirstResponderBeneathView:self] resignFirstResponder];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

@end
