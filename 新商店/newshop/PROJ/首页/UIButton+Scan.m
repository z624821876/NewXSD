//
//  UIButton+Location.m
//  newshop
//
//  Created by qiandong on 14/12/31.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "UIButton+Location.h"


@implementation UIButton(Scan)

- (void)setupButtonTitle:(NSString *)city image:(UIImage *)image{

    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 35, 20)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.text = city;
    [self addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(7.5, 0, 20,20)];
    [self addSubview:imageView];

}


@end
