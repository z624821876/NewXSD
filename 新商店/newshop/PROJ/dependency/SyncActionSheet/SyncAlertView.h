//
//  SyncAlertView.h
//  mlh
//
//  Created by qd on 13-5-30.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncAlertView : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray * buttonTitles;

@property (nonatomic, assign) NSInteger cancelButtonIndex;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)show;

@end
