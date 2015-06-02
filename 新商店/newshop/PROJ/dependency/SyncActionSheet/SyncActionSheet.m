//
//  SynchronizedUIActionSheet.m
//  SynchronizedUIActionSheetDemo
//
//  Created by Tang Qiao on 12-6-24.
//  Copyright (c) 2012年 blog.devtang.com . All rights reserved.
//

#import "SyncActionSheet.h"

@implementation SyncActionSheet {
    UIActionSheet * _actionSheet;
    NSInteger _selectedIndex;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super init];
    if (self) {
        
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        _buttonTitles = [[NSMutableArray alloc] initWithCapacity:2];
        
        NSMutableArray *argsArray = [[NSMutableArray alloc] init];
        id arg;
        va_list argList;
        if(otherButtonTitles)
        {
            [argsArray addObject:otherButtonTitles];
            va_start(argList,otherButtonTitles);
            while ((arg = va_arg(argList,id)))
            {
                [argsArray addObject:arg];
            }
            va_end(argList);
        }
        //destructiveButton缺省为第一个
        if (_destructiveButtonTitle != nil) {
            [_buttonTitles addObject:_destructiveButtonTitle];
            _destructiveButtonIndex = 0;
        }else{
            _destructiveButtonIndex = -1;
        }
        
        if ([argsArray count]>0) {
            [_buttonTitles addObjectsFromArray:argsArray];
        }
        
        //destructiveButton缺省为最后一个
        if (_cancelButtonTitle != nil) {
            [_buttonTitles addObject:_cancelButtonTitle];
            _cancelButtonIndex = [_buttonTitles count] - 1;
        }else{
            _cancelButtonIndex = -1;
        }
    }
    
    return self;
}


- (NSInteger)showInView:(UIView *)view {
    
    _actionSheet = [[UIActionSheet alloc] init];
    
    _actionSheet.delegate = self;
    
    for (NSString * title in _buttonTitles) {
        [_actionSheet addButtonWithTitle:title];
    }
    if (_destructiveButtonIndex != -1) {
        _actionSheet.destructiveButtonIndex = _destructiveButtonIndex;
    }
    if (_cancelButtonIndex != -1) {
        _actionSheet.cancelButtonIndex = _cancelButtonIndex;
    }
    [_actionSheet showInView:view];
    CFRunLoopRun();
    return _selectedIndex;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    _selectedIndex = buttonIndex;
    _actionSheet = nil;
    CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
