//
//  MyCustomScroll.m
//  newshop
//
//  Created by 于洲 on 15/4/11.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MyCustomScroll.h"

@implementation MyCustomScroll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [self setContentOffset:CGPointMake(0, 0) animated:YES];

}

@end
