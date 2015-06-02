//
//  PickerAlertView.m
//  YunPlus
//
//  Created by juxue.chen on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePickerActionSheet.h"

@implementation DatePickerActionSheet

#pragma mark - UIPickerView - Date/Time

- (id)createContentView
{
	self.DatePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	self.DatePicker.datePickerMode = UIDatePickerModeDate;
    
	[self addSubview:self.DatePicker];
    
    return self.DatePicker;
}

-(NSString *)dateStr{
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
    return [_dateFormatter stringFromDate:self.DatePicker.date];
}

@end
