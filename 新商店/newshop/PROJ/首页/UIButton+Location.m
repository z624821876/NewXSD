//
//  UIButton+Location.m
//  newshop
//
//  Created by qiandong on 14/12/31.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "UIButton+Location.h"


@implementation UIButton(Location)

- (void)setupButtonWithCity:(NSString *)city area:(NSString *) area image:(UIImage *)image {
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 20)];
    [cityLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [cityLabel setTextColor:[UIColor whiteColor]];
    cityLabel.text = city;
    [self addSubview:cityLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 10, 20,20)];
    [self addSubview:imageView];
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 20)];
    [areaLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [areaLabel setTextColor:[UIColor whiteColor]];
    areaLabel.text = area;
    [self addSubview:areaLabel];
}


@end
