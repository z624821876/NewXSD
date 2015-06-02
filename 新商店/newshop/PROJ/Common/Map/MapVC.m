//
//  MapViewController.m
//  sunday
//
//  Created by qd on 13-3-4.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "MapVC.h"
#import "AppDelegate.h"


@interface MapVC ()


@end

@implementation MapVC


#pragma mark - lifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        // 设置导航栏坐标按钮
        UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 44)];
        [Btn setBackgroundImage:[UIImage imageNamed:@"index_02_7.png"] forState:UIControlStateNormal];
        [Btn setBackgroundImage:[UIImage imageNamed:@"index_02_7.png"] forState:UIControlStateHighlighted];
        Btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [Btn setTitle:@"列表模式" forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *BarBtn = [[UIBarButtonItem alloc] initWithCustomView:Btn];
        self.navigationItem.rightBarButtonItem = BarBtn;    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 是否显示导航栏后退按钮
    if(_ifHideLeftNavItem)
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    }
    
    //显示地图
    _map = [[MKMapView alloc]initWithFrame:CGRectMake(0,0,UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)];
	_map.showsUserLocation = YES;
    _map.mapType =MKMapTypeStandard;
	[self.view addSubview:_map];
    
    [self.map setZoomEnabled:YES];
    [self.map setScrollEnabled:YES];
    
    //定位监控
    if(_locManager)
    {
        _locManager.delegate=nil;
        _locManager=nil;
    }
    _locManager = [[CLLocationManager alloc] init];
	_locManager.delegate = self;
	_locManager.desiredAccuracy = kCLLocationAccuracyBest;
	_locManager.distanceFilter = 100;
    if (iOS8) {
        [_locManager requestWhenInUseAuthorization];
    }
    
	[_locManager startUpdatingLocation];

    
    [self daohangto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)rightAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    //当前位置
    CLLocationCoordinate2D currentLocation = [newLocation coordinate];
    self.currentLat=[NSString  stringWithFormat:@"%f",currentLocation.latitude];
    self.currentLng=[NSString  stringWithFormat:@"%f",currentLocation.longitude];
    
    CLLocationCoordinate2D targetLocation;
    
    NSUInteger count = [self.targetLatArray count];
    for (int i=0; i<count; i++)
    {
        targetLocation.latitude = [[self.targetLatArray objectAtIndex:i] doubleValue];
        targetLocation.longitude = [[self.targetLngArray objectAtIndex:i] doubleValue];
        _mapAnnotations=[[MapAnnotations alloc] initWithCoordinate:targetLocation];
        _mapAnnotations.title = [self.annotationTitleArray objectAtIndex:i];
        _mapAnnotations.subtitle = [self.annotationSubtitleArray objectAtIndex:i];
        [_map addAnnotation:_mapAnnotations];
    }
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    float zoomLevel = 0.04;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
//    region.center=targetLocation;
    [_map setRegion:[_map regionThatFits:region] animated:YES];
//    [_map regionThatFits:region];
    
//    MKCoordinateRegion region;
//	MKCoordinateSpan span;
//	span.latitudeDelta=0.1; //zoom level
//	span.longitudeDelta=0.1; //zoom level
//    region.span=span;
//    targetLocation.latitude = [[self.targetLatArray objectAtIndex:0] doubleValue];
//    targetLocation.longitude = [[self.targetLngArray objectAtIndex:0] doubleValue];
//	region.center=targetLocation;
//	
//	[_map setRegion:region animated:YES];
//	[_map regionThatFits:region];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	if ([error code] == kCLErrorDenied)
    {
        [[tools shared] HUDShowHideText:@"访问被拒绝" delay:2];
	}
	if ([error code] == kCLErrorLocationUnknown) {
        [[tools shared] HUDShowHideText:@"无法定位到你的位置" delay:2];
 	}
}

-(void)RightAction:(id)sender
{
    /*
    NSString *urlString = [[NSString alloc]
                           initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d",
                           [self.currentLat doubleValue],
                           [self.currentLng doubleValue],
                           [self.targetLat doubleValue],
                           [self.targetLng doubleValue]];
    NSURL *aURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:aURL];
     */
}

-(void)daohangto
{
    CLLocationCoordinate2D current;
    current.latitude = self.currentLat.doubleValue;
    current.longitude = self.currentLng.doubleValue;
    
    CLLocationCoordinate2D to;
    to.latitude = 30.6055821676;
    to.longitude = 119.9076347501;
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
    toLocation.name = @"西坡酒店";
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    
}

@end
