//
//  LocationVC.h
//  newshop
//
//  Created by qiandong on 15/1/3.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import <CoreLocation/CoreLocation.h>

//@protocol LocationDelegate <NSObject>
//
//-(void)selectedProvince:(Info *)province City:(Info *)city Area:(Info *)area;
//
//@end

@interface LocationVC : BaseVC <UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

//@property(nonatomic,strong) NSString *province;
//@property(nonatomic,strong) NSString *city;
//@property(nonatomic,strong) NSString *area;
//@property(nonatomic,strong) NSString *provinceId;
//@property(nonatomic,strong) NSString *cityId;
//@property(nonatomic,strong) NSString *areaId;

//@property(nonatomic,strong) Info *province;
//@property(nonatomic,strong) Info *city;
//@property(nonatomic,strong) Info *area; //只有area.id为真实，才有其他5个

//@property(nonatomic,assign) id<LocationDelegate> delegate;

@end
