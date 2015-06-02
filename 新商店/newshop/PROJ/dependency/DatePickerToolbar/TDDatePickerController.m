//
//  TDDatePickerController.m
//
//  Created by Nathan  Reed on 30/09/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import "TDDatePickerController.h"

@implementation TDDatePickerController

-(void)viewDidLoad
{
    [super viewDidLoad];
    

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
     self.datePicker.locale = locale;


    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	self.datePicker.date = [NSDate date];
    
    
    //加个不透明的背景
    _pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbar.top, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.toolbar.top)];
    [_pickBgView setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:_pickBgView atIndex:0];

	// we need to set the subview dimensions or it will not always render correctly
	// http://stackoverflow.com/questions/1088163
	for (UIView* subview in self.datePicker.subviews) {
		subview.frame = self.datePicker.bounds;
	}
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark -
#pragma mark Actions

-(IBAction)saveDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerSetDate:)]) {
		[self.delegate datePickerSetDate:self];
	}
}

-(IBAction)clearDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerClearDate:)]) {
		[self.delegate datePickerClearDate:self];
	}
}

-(IBAction)cancelDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerCancel:)]) {
		[self.delegate datePickerCancel:self];
	} else {
		// just dismiss the view automatically?
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [super viewDidUnload];

	self.datePicker = nil;
	self.delegate = nil;

}

@end


