//
//  LocationVC.m
//  newshop
//
//  Created by qiandong on 15/1/3.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "LocationVC.h"

@interface LocationVC ()
{
    UIView *_topBgView;
    UIView *_grayBgView;
    
    UITableView *_provinceTable;
    UITableView *_cityTable;
    UITableView *_areaTable;
    
    NSMutableArray *_provinceArray;
    NSMutableArray *_cityArray;
    NSMutableArray *_areaArray;
    
    Info *_curProvince;
    Info *_curCity;
    Info *_curArea;
    
    CLLocationManager *_locManager;
    BOOL _flag;
}

@end

#define TABLE_CELL_HEIGHT 30
#define PROVINCE @"1"
#define CITY @"2"
#define AREA @"3"

#define TOPVIEW_HEIGHT 106
#define TABLE_HEIGHT UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-TOPVIEW_HEIGHT
#define CELL_FONT [UIFont systemFontOfSize:13]
#define CELL_COLOR [UIColor colorWithWhite:0.3 alpha:1]

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _provinceArray = [NSMutableArray arrayWithCapacity:10];
    _cityArray = [NSMutableArray arrayWithCapacity:10];
    _areaArray = [NSMutableArray arrayWithCapacity:10];
    
    _curProvince = [[Info alloc] init];
    _curCity = [[Info alloc] init];
    _curArea = [[Info alloc] init];
    
    [self buildTopView];
    [self updateCurrentCity];
    [self buildTableView];
    
    //开始跟踪定位
    _locManager = [[CLLocationManager alloc] init];
    _locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locManager.delegate = self;
    if (iOS8)
    {
        [_locManager requestWhenInUseAuthorization];
    }
    
    [self load:PROVINCE];
}

-(void)buildTopView
{
    _topBgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, TOPVIEW_HEIGHT)];
    [_topBgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topBgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 150, 20)];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    [label1 setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [label1 setText:@"你当前所在城市"];
    [_topBgView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, 82, 150, 20)];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [label2 setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [label2 setText:@"全部"];
    [_topBgView addSubview:label2];

    
    _grayBgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 48)];
    [_grayBgView setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [_topBgView addSubview:_grayBgView];
    
    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, _grayBgView.top, UI_SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [_topBgView addSubview:line1];
    
    UIView *line2  = [[UIView alloc] initWithFrame:CGRectMake(0, _grayBgView.bottom-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [_topBgView addSubview:line2];
    
    UIView *line3  = [[UIView alloc] initWithFrame:CGRectMake(0, _topBgView.bottom-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line3 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [_topBgView addSubview:line3];
    
}

-(void)updateCurrentCity
{
    for(UIView *view in [_grayBgView subviews])
    {
        [view removeFromSuperview];
    }
    if ([LLSession sharedSession].area.id != nil) {
        UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cityBtn setFrame:CGRectMake(15, 10, 84, 29)];
        [cityBtn setBackgroundImage:[UIImage imageNamed:@"auto_location.png"] forState:UIControlStateNormal];
        cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cityBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
        [cityBtn setUserInteractionEnabled:NO];
        [_grayBgView addSubview:cityBtn];
        [cityBtn setTitle:[LLSession sharedSession].city.name forState:UIControlStateNormal];
        
        UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [areaBtn setFrame:CGRectMake(cityBtn.right+10, cityBtn.top, 84, 29)];
        [areaBtn setBackgroundImage:[UIImage imageNamed:@"auto_location.png"] forState:UIControlStateNormal];
        areaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [areaBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
        [areaBtn setUserInteractionEnabled:NO];
        [_grayBgView addSubview:areaBtn];
        [areaBtn setTitle:[LLSession sharedSession].area.name forState:UIControlStateNormal];
        
        UIButton *autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [autoBtn setFrame:CGRectMake(areaBtn.right+30, cityBtn.top, 84, 29)];
        [autoBtn setBackgroundImage:[UIImage imageNamed:@"city_btn.png"] forState:UIControlStateNormal];
        autoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [autoBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
        [autoBtn addTarget:self action:@selector(autoLocation:) forControlEvents:UIControlEventTouchUpInside];
        [_grayBgView addSubview:autoBtn];
        [autoBtn setTitle:@"自动定位" forState:UIControlStateNormal];
    }else{
        UIButton *autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [autoBtn setFrame:CGRectMake(15, 10, 84, 29)];
        [autoBtn setBackgroundImage:[UIImage imageNamed:@"city_btn.png"] forState:UIControlStateNormal];
        autoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [autoBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
        [autoBtn addTarget:self action:@selector(autoLocation:) forControlEvents:UIControlEventTouchUpInside];
        [_grayBgView addSubview:autoBtn];
        [autoBtn setTitle:@"自动定位" forState:UIControlStateNormal];
    }
}

-(void)buildTableView
{
    
    _provinceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _topBgView.bottom, UI_SCREEN_WIDTH/3, TABLE_HEIGHT)];
    _cityTable = [[UITableView alloc] initWithFrame:CGRectMake(_provinceTable.right, _topBgView.bottom, UI_SCREEN_WIDTH/3, TABLE_HEIGHT)];
    _areaTable = [[UITableView alloc] initWithFrame:CGRectMake(_cityTable.right, _topBgView.bottom, UI_SCREEN_WIDTH/3, TABLE_HEIGHT)];
    _provinceTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _cityTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _areaTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _provinceTable.delegate = self;
    _provinceTable.dataSource = self;
    _cityTable.delegate = self;
    _cityTable.dataSource = self;
    _areaTable.delegate = self;
    _areaTable.dataSource = self;
    [self.view addSubview:_provinceTable];
    [self.view addSubview:_cityTable];
    [self.view addSubview:_areaTable];
}

-(void)load:(NSString *)type
{
    [[tools shared] HUDShowText:@"正在读取"];
    
    NSString *areaId;
    if([type isEqualToString:PROVINCE]){
        areaId = @"1"; //缺省
    }else if([type isEqualToString:CITY]){
        areaId = _curProvince.id;
    }else{
        areaId = _curCity.id;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   areaId,@"areaId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonAreaList] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            //得到数据
            if([type isEqualToString:PROVINCE]){
                [_provinceArray removeAllObjects];
            }else if([type isEqualToString:CITY]){
                [_cityArray removeAllObjects];
            }else{
                [_areaArray removeAllObjects];
            }
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *entity = [[Info alloc] init];
                entity.id = [[dict valueForKey:@"id"] stringValue];
                entity.name = [dict valueForKey:@"name"];
                
                if([type isEqualToString:PROVINCE]){
                    [_provinceArray addObject:entity];
                }else if([type isEqualToString:CITY]){
                    [_cityArray addObject:entity];
                }else{
                    [_areaArray addObject:entity];
                }
            }
            if([type isEqualToString:PROVINCE]){
                [_provinceTable reloadData];
                NSInteger row = [self getRowByDistId:[LLSession sharedSession].province.id inArray:_provinceArray];
                [self selectRow:row OnTable:_provinceTable Act:YES]; //自动选中第一个并ACT
            }else if([type isEqualToString:CITY]){
                [_cityTable reloadData];
                NSInteger row = [self getRowByDistId:[LLSession sharedSession].city.id inArray:_cityArray];
                [self selectRow:row OnTable:_cityTable Act:YES]; //自动选中第一个并ACT
            }else{
                [_areaTable reloadData];
                NSInteger row = [self getRowByDistId:[LLSession sharedSession].area.id inArray:_areaArray];
                [self selectRow:row OnTable:_areaTable Act:NO]; //自动选中第一个,  但是不ACT
            }
            [[tools shared] HUDHide];
            
            
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}
-(NSInteger)getRowByDistId:(NSString *)distId inArray:(NSArray *)array;
{
    NSInteger row = 0;
    if (distId != nil) { //如果定位到了结果，并且provinceId不为空，则找到那个row
        for (int i = 0; i<array.count; i++) {
            Info *entity = [array objectAtIndex:i];
            if ([entity.id isEqualToString:distId]) {
                row = i;
                break;
            }
        }
    }
    return row;
}
-(void)selectRow:(NSInteger)row OnTable:(UITableView *)tableView Act:(BOOL) needAct
{
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    if (needAct) {
        if ([tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _provinceTable) {
        return _provinceArray.count;
    }else if(tableView == _cityTable) {
        return _cityArray.count;
    }else{
        return _areaArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView == _provinceTable) {
        static NSString *provinceCellIdentifier = @"provinceCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:provinceCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:provinceCellIdentifier];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        Info *province = [_provinceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = province.name;
        cell.textLabel.font = CELL_FONT;
        cell.textLabel.textColor = CELL_COLOR;
        //选中时的背景色
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [selectBgView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
        cell.selectedBackgroundView = selectBgView;
        return cell;
    }else if(tableView == _cityTable) {
        static NSString *cityCellIdentifier = @"cityCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCellIdentifier];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        Info *city = [_cityArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.textLabel.font = CELL_FONT;
        cell.textLabel.textColor = CELL_COLOR;
        //选中时的背景色
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [selectBgView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
        cell.selectedBackgroundView = selectBgView;
        return cell;
    }else {
        static NSString *areaCellIdentifier = @"areaCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:areaCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:areaCellIdentifier];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        Info *area = [_areaArray objectAtIndex:indexPath.row];
        cell.textLabel.text = area.name;
        cell.textLabel.font = CELL_FONT;
        cell.textLabel.textColor = CELL_COLOR;
        //选中时的背景色
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [selectBgView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
        cell.selectedBackgroundView = selectBgView;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _provinceTable) {
        _curProvince = [_provinceArray objectAtIndex:indexPath.row];
        [self load:CITY];
    }else if(tableView == _cityTable) {
        _curCity = [_cityArray objectAtIndex:indexPath.row];
        [self load:AREA];
    }else{
        _curArea = [_areaArray objectAtIndex:indexPath.row];
        [LLSession sharedSession].province = _curProvince;
        [LLSession sharedSession].city = _curCity;
        [LLSession sharedSession].area = _curArea;
        [KNSUserDefaults setObject:[LLSession sharedSession].province.name forKey:@"provincename"];
        [KNSUserDefaults setObject:[LLSession sharedSession].city.name forKey:@"cityname"];
        [KNSUserDefaults setObject:[LLSession sharedSession].area.name forKey:@"areaname"];
        [KNSUserDefaults setObject:[LLSession sharedSession].province.id forKey:@"provinceid"];
        [KNSUserDefaults setObject:[LLSession sharedSession].city.id forKey:@"cityid"];
        [KNSUserDefaults setObject:[LLSession sharedSession].area.id forKey:@"areaid"];
        [KNSUserDefaults setObject:[LLSession sharedSession].latitude forKey:@"latitude"];
        [KNSUserDefaults setObject:[LLSession sharedSession].longitude forKey:@"longitude"];
        [KNSUserDefaults synchronize];
        [self LeftAction:nil];
    }
}


-(void)autoLocation:(id)sender
{
    NSLog(@"autoLocation");
    [[tools shared] HUDShowText:@"正在定位"];
    [_locManager startUpdatingLocation];
}

#pragma mark -
#pragma mark -location Delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        CLGeocoder *geocoder=[[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks,
                                           NSError *error)
         {
             if (error == nil && [placemarks count] > 0)
             {
                 if (!_flag) {
                     NSLog(@"longitude = %.8f\nlatitude = %.8f", currentLocation.coordinate.longitude,currentLocation.coordinate.latitude);
                     // stop updating location in order to save battery power
                     [manager stopUpdatingLocation];
                     CLPlacemark *placemark=[placemarks objectAtIndex:0];
                     _curProvince.name = placemark.administrativeArea;
                     _curCity.name = placemark.locality;
                     _curArea.name = placemark.subLocality;
                     [LLSession sharedSession].latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                     [LLSession sharedSession].longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                     
                     [[tools shared] HUDHide];
                     [self loadArea];
                     
                     _flag = YES;
                 }
             }
         }];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务没打开，请您去设置->隐私中打开本应用的定位服务" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [[tools shared] HUDHide];
    }
//    [[tools shared] HUDShowHideText:@"定位失败" delay:2];
    //    if ([error code] == kCLErrorLocationUnknown) {
    //        [[tools shared] HUDShowHideText:@"无法定位到你的位置" delay:2];
    //    }
}

-(void)loadArea
{
    [[tools shared] HUDShowText:@"读取城市"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _curCity.name,@"cityName",
                                   _curArea.name,@"areaName",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonAreaIdByName] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            NSDictionary *dict = [JSON valueForKey:@"result"];
            //必须self.xx或者setXx才能KVO
            _curArea.id = [NSString stringWithFormat:@"%i",[[dict valueForKey:@"areaId"] integerValue]];
            _curCity.id = [NSString stringWithFormat:@"%i",[[dict valueForKey:@"cityId"] integerValue]];
            _curProvince.id = [NSString stringWithFormat:@"%i",[[dict valueForKey:@"provinceId"] integerValue]];
            [LLSession sharedSession].province = _curProvince;
            [LLSession sharedSession].city = _curCity;
            [LLSession sharedSession].area = _curArea;
            
            [KNSUserDefaults setObject:[LLSession sharedSession].province.name forKey:@"provincename"];
            [KNSUserDefaults setObject:[LLSession sharedSession].city.name forKey:@"cityname"];
            [KNSUserDefaults setObject:[LLSession sharedSession].area.name forKey:@"areaname"];
            [KNSUserDefaults setObject:[LLSession sharedSession].province.id forKey:@"provinceid"];
            [KNSUserDefaults setObject:[LLSession sharedSession].city.id forKey:@"cityid"];
            [KNSUserDefaults setObject:[LLSession sharedSession].area.id forKey:@"areaid"];
            [KNSUserDefaults setObject:[LLSession sharedSession].latitude forKey:@"latitude"];
            [KNSUserDefaults setObject:[LLSession sharedSession].longitude forKey:@"longitude"];
            [KNSUserDefaults synchronize];

            [self LeftAction:nil];

            [[tools shared] HUDHide];
        }else{
            [[tools shared] HUDShowHideText:@"读取区县数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDShowHideText:@"加载定位数据时网络或服务器异常" delay:2];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
