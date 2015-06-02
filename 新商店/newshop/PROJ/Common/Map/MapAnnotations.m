//
//  MapAnnotations.m
//  mlh
//
//  Created by qd on 13-5-23.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "MapAnnotations.h"

@implementation MapAnnotations

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate
{
	_coordinate = coordinate;
	return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString *)Title subtitle:(NSString *)Subtitle
{
	_coordinate = coordinate;
    _title = Title;
    _subtitle = Subtitle;
	return self;
}

@end