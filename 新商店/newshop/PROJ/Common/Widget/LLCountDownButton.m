//
//  LLCountDownButton.m
//  walletSDK12580
//
//  Created by Xu Yefeng on 13-6-20.
//  Copyright (c) 2013年 LianLian. All rights reserved.
//

#import "LLCountDownButton.h"

@implementation LLCountDownButton

static LLCountDownButton *share = nil;

+ (LLCountDownButton*)shareManager
{
    @synchronized(self){
        if (share == nil) {
            share = [[LLCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 265, 42)];
            [share Myinit];
//            share = [LLCountDownButton button];
        }
    }
    return share;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self Myinit];
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)start
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
        [startTime release];
        startTime = nil;
        bManualStop = NO;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateButton:) userInfo:nil repeats:YES];
    self.enabled = NO;
    
    
    startTime = [[NSDate date] retain];
}

- (void)stop
{
    bManualStop = YES;
    timer = nil;
    startTime = nil;
}

- (void)updateButton:(NSTimer*)selfTimer
{
    timeInterval = [[NSDate date] timeIntervalSinceDate:startTime];
    
    if (timeInterval < self.countdownInterval && !bManualStop)
    {
//        [self setTitle:[NSString stringWithFormat:self.countdownFormatString, (int)(self.countdownInterval-timeInterval)]
//              forState:UIControlStateNormal];
        [self setTitle:[NSString stringWithFormat:self.countdownFormatString, (int)(self.countdownInterval-timeInterval)]
              forState:UIControlStateDisabled];
    }
    else
    {
        [self setTitle:self.stoppedString forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        self.enabled = YES;
        [startTime release];
        startTime = nil;
        bManualStop = NO;
    }
}

- (BOOL)isTimerOver
{
    if (timer == nil) {
        return YES;
    }
    return NO;
}

- (void)Myinit
{
    self.countdownInterval = 60;
    self.countdownFormatString = @"%d秒后重新获取";
    self.stoppedString = @"获取验证码";
    [self setTitle:self.stoppedString forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"reg_verify.png"] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:@"reg_sendcode.png"] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageNamed:@"reg_verify_dis.png"] forState:UIControlStateDisabled];
    
    [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClicked
{
    if ([self.delegate respondsToSelector:@selector(countdownBtnClicked)]) {
         [self.delegate performSelector:@selector(countdownBtnClicked) withObject:nil];
    }
}

+ (LLCountDownButton*)button
{
    LLCountDownButton *button = [[LLCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 265, 42)];
    
    //button.titleLabel.shadowOffset = CGSizeMake(1, 1);
    //button.titleLabel.shadowColor = [LLStyle shadowColor];
    
    button.countdownInterval = 60;
    button.countdownFormatString = @"%d秒后重新获取";
    button.stoppedString = @"获取验证码";
    [button setTitle:button.stoppedString forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"reg_verify.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"reg_verify_dis.png"] forState:UIControlStateDisabled];
    
    return button;
}

@end
