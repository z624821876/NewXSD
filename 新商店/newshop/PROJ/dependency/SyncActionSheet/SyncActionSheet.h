//
//  SynchronizedUIActionSheet.h
//  SynchronizedUIActionSheetDemo
//
//  Created by Tang Qiao on 12-6-24.
//  Copyright (c) 2012年 blog.devtang.com . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncActionSheet : NSObject<UIActionSheetDelegate>

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * cancelButtonTitle;
@property (nonatomic, strong) NSString * destructiveButtonTitle;
@property (nonatomic, strong) NSMutableArray * buttonTitles;

@property (nonatomic, assign) NSInteger cancelButtonIndex;
@property (nonatomic, assign) NSInteger destructiveButtonIndex;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)showInView:(UIView *)view;

@end
