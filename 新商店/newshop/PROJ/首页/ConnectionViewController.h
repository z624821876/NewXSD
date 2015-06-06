//
//  ConnectionViewController.h
//  newshop
//
//  Created by 于洲 on 15/3/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ConnectionViewController : BaseTableVC

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;

@end
