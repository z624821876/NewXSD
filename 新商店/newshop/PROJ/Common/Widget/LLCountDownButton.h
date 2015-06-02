//
//  LLCountDownButton.h
//  walletSDK12580
//
//  Created by Xu Yefeng on 13-6-20.
//  Copyright (c) 2013年 LianLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LLCountDownButtonDelegate<NSObject>

- (void)countdownBtnClicked;

@end

@interface LLCountDownButton : UIButton
{
    NSDate *startTime;
    
    BOOL    bManualStop;
    NSTimeInterval timeInterval;
    NSTimer *timer;
}

@property (nonatomic, assign) int countdownInterval;
@property (nonatomic, retain) NSString *countdownFormatString; // @"%d秒后重新发送"
@property (nonatomic, retain) NSString *stoppedString;
@property (nonatomic, retain) NSObject<LLCountDownButtonDelegate> *delegate;

- (void)start;
- (void)stop;
- (BOOL)isTimerOver;

+ (LLCountDownButton*)button;
+ (LLCountDownButton*)shareManager;

@end
