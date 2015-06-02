//
//  HomeVC.h
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "EScrollerView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>


@interface HomeVC : BaseVC <EScrollerViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>
- (void)changeImg;
- (void)loction;


@end
