//
//  SyncAlertView.m
//  mlh
//
//  Created by qd on 13-5-30.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "SyncAlertView.h"

@interface SyncAlertView()
{
    UIAlertView * _alertView;
    NSInteger _selectedIndex;
}

@end

@implementation SyncAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        _cancelButtonTitle = cancelButtonTitle;
        
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
        
        [_buttonTitles addObjectsFromArray:argsArray];
        
        //destructiveButton缺省为最后一个
        if (cancelButtonTitle != nil) {
            [_buttonTitles addObject:_cancelButtonTitle];
            _cancelButtonIndex = [_buttonTitles count]-1;
        }else{
            _cancelButtonIndex = -1;
        }    
    }
    return self;
}

- (NSInteger)show {
    
    _alertView = [[UIAlertView alloc] init];
    _alertView.title = _title;
    _alertView.message = _message;
    
    for (NSString * title in _buttonTitles) {
        [_alertView addButtonWithTitle:title];
    }
    
    if (_cancelButtonIndex != -1) {
        _alertView.cancelButtonIndex = _cancelButtonIndex;
    }
    _alertView.delegate = self;

    [_alertView show];
    CFRunLoopRun();
    return _selectedIndex;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _selectedIndex = buttonIndex;
    _alertView = nil;
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
