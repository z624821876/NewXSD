//
//  BasicAlertView.m
//  PickerAlertView
//
//  Created by manuel garcia lopez on 26/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicActionSheet.h"

#define Margin_Y 5.0
#define ALERT_BUTTON_MARING_BOTTOM 15.0
#define UI_VIEW_HEIGHT 460.0
#define DatePicker_WIDTH 300.0
#define DatePicker_HEIGHT 216.0
#define PICKER_MARGIN_X 10.0

@implementation BasicActionSheet

- (id)initWithFrame:(CGRect)frame 
{
	if (self = [super initWithFrame:frame])
    {
	  basicView= [self createContentView];
	}
	return self;
}


#pragma mark - BasicView

- (id)createContentView
{
    basicView = [[UIView alloc] initWithFrame:CGRectZero];
    
	[self addSubview:basicView];
    
    return basicView;
}

//UIActionSheet和UIAlertView的subviews都是label+button。
//加入UIDatePicker或UIPicker后，用layoutSubviews重新布局即可
//同理可加进其他UI控件
-(void)layoutSubviews{
    float offsetY =0;
    
    if ([self.subviews count]>0)
    {
        offsetY+= Margin_Y;
        
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UILabel class]] && view.hidden ==FALSE )
            {   
                UILabel *label = (UILabel*) view;
                if ([label.text isEqualToString:@""]==FALSE)
                {
                    view.frame = CGRectMake(view.frame.origin.x, offsetY, view.frame.size.width, view.frame.size.height);
                    offsetY = view.frame.origin.y + view.frame.size.height;
                }
            }
        }
        
        offsetY+= Margin_Y;
        
        basicView.frame = CGRectMake(PICKER_MARGIN_X, offsetY, DatePicker_WIDTH, DatePicker_HEIGHT);
        offsetY = offsetY + DatePicker_HEIGHT;
        

        
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UIButton class]] && view.hidden ==FALSE)
            {
                view.frame = CGRectMake(view.frame.origin.x,offsetY+Margin_Y, view.frame.size.width, view.frame.size.height);
                offsetY = offsetY + Margin_Y + view.frame.size.height + Margin_Y;

            }
        }

        float hhh = offsetY + ALERT_BUTTON_MARING_BOTTOM;
        self.frame = CGRectMake(0, UI_VIEW_HEIGHT-hhh, UI_SCREEN_WIDTH, hhh);
    }
}

@end
