//
//  TTVC.h
//  cheshi
//
//  Created by qiandong on 14/11/13.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "LLKeyboardAvoidingScrollView.h"

@interface LoginVC1 : BaseVC <UITabBarControllerDelegate,
                                    UITextFieldDelegate,
                                    UIScrollViewDelegate,
                                    LLKeyboardAvoidingScrollViewDelegate>

@end
