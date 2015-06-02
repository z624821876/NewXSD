//
//  PickerAlertView.h
//  YunPlus
//
//  Created by juxue.chen on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasicActionSheet.h"

@interface DatePickerActionSheet : BasicActionSheet

@property (nonatomic,strong) UIDatePicker *DatePicker;

@property (nonatomic,readonly) NSString *dateStr;

@end
