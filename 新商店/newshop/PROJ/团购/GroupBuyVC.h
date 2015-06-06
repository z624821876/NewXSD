//
//  GroupBuyVC.h
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "BaseTableVC.h"
#import "EScrollerView.h"
#import <CoreLocation/CoreLocation.h>

@interface GroupBuyVC : BaseTableVC<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,EScrollerViewDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
//@property (nonatomic, strong) UITableView       *tableView;

@end
