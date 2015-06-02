//
//  MapVC.h
//  mlh
//
//  Created by qd on 13-5-23.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "MapAnnotations.h"
#import "BaseVC.h"

@interface MapVC : BaseVC <CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) CLLocationManager *locManager;

//@property (nonatomic, retain) NSArray *mapAnnotationsArray;
@property (nonatomic, retain) NSArray *targetLatArray;          //经度
@property (nonatomic, retain) NSArray *targetLngArray;          //纬度
@property (nonatomic, retain) NSArray *annotationTitleArray;    
@property (nonatomic, retain) NSArray *annotationSubtitleArray;

@property (nonatomic, retain) MapAnnotations *mapAnnotations;
//@property (nonatomic, strong) NSString  *targetLat;     //目标位置
//@property (nonatomic, strong) NSString  *targetLng;@
//@property (nonatomic, strong) NSString  *annotationTitle;
//@property (nonatomic, strong) NSString  *annotationSubtitle;


@property (nonatomic, strong) NSString  *currentLat;    //当前位置
@property (nonatomic, strong) NSString  *currentLng;


@property(nonatomic,assign) BOOL ifHideLeftNavItem;


@end
