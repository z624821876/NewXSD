//
//  LLGlobalDefine.h
//
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//



#ifdef DEBUG
#define DDLog(...) NSLog(__VA_ARGS__)
#define DDMethod() NSLog(@"%s", __func__)
//#define DLog(fmt, ...) (NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__));
#define DLog(fmt, ...) (NSLog((@"%@" fmt), @"", ##__VA_ARGS__));

#else
#define DDLog(...)
#define DMethod()
#define DLog(...)
#endif


#ifndef LLGlobalDefine_h
#define LLGlobalDefine_h

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#define FLOAT_EQUAL 0.000001

#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
//#define UI_SCREEN_WIDTH                 [[UIScreen mainScreen] bounds].size.width
//#define UI_SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height

#define is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define is_Ios7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBAlpha(rgbValue,aValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]



#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#endif
