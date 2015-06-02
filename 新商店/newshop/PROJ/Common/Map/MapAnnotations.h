//
//  MapAnnotations.h
//  mlh
//
//  Created by qd on 13-5-23.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotations : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end
