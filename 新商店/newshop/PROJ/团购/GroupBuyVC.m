//
//  GroupBuyVC.m
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "GroupBuyVC.h"
#import "UIButton+Location.h"
#import "UIButton+Additions.h"
#import "ShopInCateVC.h"
#import "MyTableViewCell.h"
#import "GroupDescVC.h"
#import "ZYMenuViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "LocationVC.h"
#import "AFNetworking.h"
#import "ProductVC.h"

@interface GroupBuyVC ()
{
    UISearchBar *_searchBar;
    UIButton *_rightNavBtn;
    UIButton *_leftNavBtn;
    
    UIScrollView *_scrollView;
    
    UIView *_banner1View;
    UIView *_banner2View;
    
    UIView  *_headView;
    EScrollerView  *_eScrollerView;
    NSMutableArray *_adArray;
    
    NSMutableArray *_cateArray;
    UIView  *_cateView;
    
    NSMutableArray *_marketArray;
    NSMutableArray *_arcadeArray;
    UIView *_marketView;
    UIView *_arcadeView;
    
    CLLocationManager *_locManager;
    
    UIAlertView *_locationAlert;
    
    BOOL _flag;
    NSMutableArray *_dataArr;
    
    UIScrollView *gScroll;
    
    UIView      *_myHeadView;
    
    
    NSInteger _currentPage;
}

@end

@implementation GroupBuyVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 1;

    _dataArr = [NSMutableArray array];
    _adArray = [NSMutableArray arrayWithCapacity:3];
    _cateArray = [NSMutableArray arrayWithCapacity:12];
    _marketArray = [NSMutableArray arrayWithCapacity:6];
    _arcadeArray = [NSMutableArray arrayWithCapacity:6];
    
    [self buildNavBar];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height - 64 - 49) style:UITableViewStyleGrouped];
    
    self.tableView = [[PullingRefreshTableView alloc]initWithCustomFrame:CGRectMake(0, 0, 320, self.view.height - 64 - 49) pullingDelegate:self];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    //KVO
    [[LLSession sharedSession] addObserver:self forKeyPath:@"area.id" options:NSKeyValueObservingOptionNew context:nil];
    
    
    if ([LLSession sharedSession].area.id != nil) {
        [self updateUIByArea];
    }
    
}
- (void)loadData
{
    NSString *latitude = [LLSession sharedSession].latitude;
    NSString *longitude = [LLSession sharedSession].longitude;
    
    if (latitude.length <= 0 || longitude <= 0) {
        latitude = 0;
        longitude = 0;
    }
    
//    http://admin.53xsd.com/mobi/getProductDetail&productId=9
    NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/group/list?catId=0&latitude=%@&longitude=%@&pageNo=%d&pageSize=10&cityId=%@&isRec=1",latitude,longitude,_currentPage,[LLSession sharedSession].area.id];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (_currentPage == 1) {
            [_dataArr removeAllObjects];
        }
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            
                NSDictionary *dic = nilOrJSONObjectForKey(JSON, @"result");
                
                NSArray *array = nilOrJSONObjectForKey(dic, @"data");
                
                if ([array count] != 0) {
                    
                    //有数据
                    for (NSDictionary *dict in array) {
                        Info *shop = [[Info alloc] init];
                        shop.id = nilOrJSONObjectForKey(dict, @"productId");
                        shop.shopId = nilOrJSONObjectForKey(dict, @"shopId");
                        shop.name = nilOrJSONObjectForKey(dict, @"shopName");
                        shop.groupName = nilOrJSONObjectForKey(dict, @"groupName");
                        shop.image = nilOrJSONObjectForKey(dict, @"img");
                        shop.discountPrice = nilOrJSONObjectForKey(dict, @"discountPrice");
                        shop.price = nilOrJSONObjectForKey(dict, @"price");
                        shop.groupDistance = nilOrJSONObjectForKey(dict, @"distance");
                        shop.soldCount = nilOrJSONObjectForKey(dict, @"soldCount");
                        shop.productName = nilOrJSONObjectForKey(dict, @"productName");
                        //店铺介绍
                        [_dataArr addObject:shop];
                    }
                
            }else {
                _currentPage -= 1;
            }

            
        }else {
            _currentPage -= 1;
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
        
        NSLog(@"发生错误！%@",error);
        _currentPage -= 1;

        [self.tableView tableViewDidFinishedLoading];
        

    }];
    [operation1 start];
}

#pragma mark - PullingRefreshTableViewDelegate
//PullingRefreshTableView delegate方法（重写，覆盖load方法 ）
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _currentPage = 1;
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
    
}
//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
        _currentPage += 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}


#pragma mark - tableView  代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    }
    
    Info *shop = [_dataArr objectAtIndex:indexPath.row];
    
    cell.titleLab.text = shop.name;
    cell.subtitleLab.text = shop.groupName;
    cell.discountLab.text = [NSString stringWithFormat:@"%@.0元",shop.discountPrice];
    cell.priceLab.text = [NSString stringWithFormat:@"%@元",shop.price];
    
    if ([[shop groupDistance] doubleValue] == -1) {
        
        cell.discountLab.text = @"未知";
    }else {
        cell.distanceLab.text = [NSString stringWithFormat:@"%.1fkm",[shop.groupDistance doubleValue]];
    }
    
    NSString *sold;
    if (!shop.soldCount) {
        sold = @"0";
    }else {
        sold = shop.soldCount;
    }
    
    cell.workoffLab.text = [NSString stringWithFormat:@"已售%@",sold];
    
    [cell.img setImageWithURL:[NSURL URLWithString:shop.image]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (!_myHeadView) {
            CGFloat height = UI_SCREEN_WIDTH*230/640;
            
            _myHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height + 250 + 55 + 10)];
            _myHeadView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
            
            _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
            _headView.backgroundColor = [UIColor whiteColor];
            [_myHeadView addSubview:_headView];
            [self loadAd];
            
            _cateView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, 250)];
            _cateView.backgroundColor = [UIColor whiteColor];
            [_myHeadView addSubview:_cateView];
            
            NSArray *cateNameArr = [NSArray arrayWithObjects:@"水果、蔬菜",@"餐饮美食",@"酒店宾馆",@"同城送",@"休闲娱乐",@"美容美发",@"家居装饰",@"甜点、超市",@"洗衣、洗车",@"服装鞋帽",@"日用百货",@"本地特色", nil];
            NSArray *cateIdArr = [NSArray arrayWithObjects:@11,@5,@6,@15,@8,@9,@10,@12,@14,@1,@13,@7,nil];
            int row = 0; int col = 0;
            for (int i=0; i<12; i++) {
                UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cateBtn setFrame: CGRectMake(28+75*col, 20+75*row, 40, 40)];
                [cateBtn addTarget:self action:@selector(CateClick:) forControlEvents:UIControlEventTouchUpInside];
                //[cateBtn addTarget:(id) action:(SEL) forControlEvents:<#(UIControlEvents)#>]
                [_cateView addSubview:cateBtn];
                UILabel *cateLabel = [[UILabel alloc] init];
                [cateLabel setFrame: CGRectMake(cateBtn.left - 9, cateBtn.bottom+2, 40 + 18, 20)];
                cateLabel.textAlignment = NSTextAlignmentCenter;
                [cateLabel setFont:[UIFont systemFontOfSize:11]];
                [_cateView addSubview:cateLabel];
                [cateBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"XSD首页_%i.png",i+1]] forState:UIControlStateNormal];
                
                [cateLabel setText:[cateNameArr objectAtIndex:i]];
                [cateBtn setEnlargeEdgeWithTop:5 right:10 bottom:15 left:10];
                cateBtn.tag = [[cateIdArr objectAtIndex:i] integerValue];
                col++;
                if(col%4==0)
                {
                    col = 0;
                    row++;
                }
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, _cateView.bottom + 15, 100, 40)];
            label.text = @"推荐团购";
            [_myHeadView addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom, 300, 0.3)];
            lineView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
            [_myHeadView addSubview:lineView];
            return _myHeadView;
        }
        return _myHeadView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = UI_SCREEN_WIDTH*230/640;
    
    return height + 250 + 55 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Info *shop = [_dataArr objectAtIndex:indexPath.row];
    ProductVC *vc = [[ProductVC alloc] init];
    vc.shopId = shop.shopId;
    vc.shopName = shop.name;
    NSLog(@"%@",shop.id);
    vc.productId = shop.id;
    vc.detailImage = shop.image;
    vc.discountPrice = shop.discountPrice;
    vc.price = shop.price;
    vc.typeIn = 10;
    vc.name = shop.productName;
    vc.navTitle = @"商品详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)CateClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Cate:%i",btn.tag);
    if ([LLSession sharedSession].area.id == nil) {
        [[tools shared] HUDShowHideText:@"尚未定位，请重新定位城市" delay:2];
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%i",btn.tag];
    if ([str isEqualToString:@"15"]) {
        return;
    }
    
    GroupDescVC *tuangou = [[GroupDescVC alloc] init];
    MenuViewController *mVC = [[MenuViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    tuangou.shopCateId = [NSString stringWithFormat:@"%i",btn.tag];
    mVC.shopCateId = [NSString stringWithFormat:@"%i",btn.tag];
    
    tuangou.cateName = btn.currentTitle;
    mVC.cateName = btn.currentTitle;
    
    app.menu = [[ZYMenuViewController alloc] initWithRootViewController:tuangou leftViewController:nil rightViewController:mVC];
    self.navigationController.navigationBarHidden = YES;
    tuangou.navigationController.navigationBarHidden = YES;
    app.menu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:app.menu animated:YES];
    
//    //跳转到
//    ShopInCateVC *vc = [[ShopInCateVC alloc] init];
//    vc.cateId = [NSString stringWithFormat:@"%i",btn.tag];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    if ([LLSession sharedSession].area.id == nil) {
        //没有位置信息
        //开始定位
        //开始跟踪定位
        _locManager = [[CLLocationManager alloc] init];
        _locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locManager.delegate = self;
        if (iOS8)
        {
            [_locManager requestWhenInUseAuthorization];
        }
        
        [[tools shared] HUDShowText:@"正在定位"];
        [_locManager startUpdatingLocation];
    }else {
    }
    
}

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
                     NSLog(@"location: longitude = %.8f\nlatitude = %.8f", currentLocation.coordinate.longitude,currentLocation.coordinate.latitude);
                     // stop updating location in order to save battery power
                     [manager stopUpdatingLocation];
                     
                     CLPlacemark *placemark=[placemarks objectAtIndex:0];
                     [LLSession sharedSession].province.name = placemark.administrativeArea;
                     [LLSession sharedSession].city.name = placemark.locality;
                     [LLSession sharedSession].area.name = placemark.subLocality;
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
        _locationAlert = [[UIAlertView alloc] initWithTitle:@"定位服务没打开，请您去设置->隐私中打开本应用的定位服务" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_locationAlert show];
        [[tools shared] HUDHide];
    }
    //    [[tools shared] HUDShowHideText:@"定位失败" delay:2];
    //    if ([error code] == kCLErrorLocationUnknown) {
    //        [[tools shared] HUDShowHideText:@"无法定位到你的位置" delay:2];
    //    }
}

-(void)updateUIByArea
{
    NSLog(@"updateUIByArea");
    //更新导航条按钮
    [_rightNavBtn setupButtonWithCity:[LLSession sharedSession].city.name area:[LLSession sharedSession].area.name image:[UIImage imageNamed:@"anchor.png"]];
    //load广告数据并重画UI
    [self loadAd];
    [self loadData];
    //按流程顺序load市场->商场数据，并重画市场->商场UI【先removeFromSuperview，再重画】
//    [self loadMarketWithType:@"0" Top:_banner1View.bottom];
}

#pragma mark-- KVO观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"area.id"])
    {
        [self updateUIByArea];
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)loadArea
{
    NSLog(@"loadArea");
    [[tools shared] HUDShowText:@"读取城市"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].city.name,@"cityName",
                                   [LLSession sharedSession].area.name,@"areaName",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonAreaIdByName] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            NSDictionary *dict = [JSON valueForKey:@"result"];
            //必须self.xx或者setXx才能KVO
            [LLSession sharedSession].area.id = [NSString stringWithFormat:@"%i",[[dict valueForKey:@"areaId"] integerValue]];
            [LLSession sharedSession].city.id = [NSString stringWithFormat:@"%i",[[dict valueForKey:@"cityId"] integerValue]];
            [LLSession sharedSession].province.id = [NSString stringWithFormat:@"%i",[[dict valueForKey:@"provinceId"] integerValue]];
            [[tools shared] HUDHide];
        }else{
            [[tools shared] HUDShowHideText:@"读取区县数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDShowHideText:@"加载定位数据时网络或服务器异常" delay:2];
    }];
}

- (void)loadAd
{
    
        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"1",@"typeId",
                                   [LLSession sharedSession].area.id,@"areaId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonAd] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            [_adArray removeAllObjects];
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                NSDictionary *adItemDict = [dict valueForKey:@"advertisementItem"];
                Info *ad = [[Info alloc] init];
                ad.filePath = nilOrJSONObjectForKey(adItemDict, @"filePath");
                ad.clickurl = nilOrJSONObjectForKey(adItemDict, @"clickurl");
                ad.title = @"";
                [_adArray addObject:ad];
            }
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:[_adArray count]];
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:[_adArray count]];
            if(_adArray.count > 0){
                for (Info *ad in _adArray) {
                    [imageArray addObject:ad.filePath];
                    [titleArray addObject:ad.title];
                }
            }else{ //否则加个固定的
                [imageArray addObject:@"http://image.53xsd.com/newshop/2014/12/c344c3d0-f67a-412a-b09d-40c9b01af3e8.png"];
                [titleArray addObject:@""];
            }
            
            if(nil != _eScrollerView)
            {
                [_eScrollerView removeFromSuperview];
            }

            // 设置滚动视图
            _eScrollerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)
                                                           ImageArray:imageArray
                                                           TitleArray:titleArray];
            _eScrollerView.tag = 10010;
            _eScrollerView.delegate = self;
            [_headView addSubview:_eScrollerView];
            //            }
        }else{
            [[tools shared] HUDShowHideText:@"读取广告失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDShowHideText:@"加载广告数据时网络或服务器异常" delay:2];
    }];
    

}

-(void)buildNavBar
{
    //    _leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _leftNavBtn.frame = CGRectMake(0, 0, 35, 40);
    //    [_leftNavBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    //    [_leftNavBtn setupButtonTitle:@"扫一扫" image:[UIImage imageNamed:@"scan.png"]];
    //    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:_leftNavBtn];
    
    //适配7.0的按钮间距
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (iOS7)
        leftSpaceItem.width = -10;
    else
        leftSpaceItem.width = -5;
    [self.navigationItem setLeftBarButtonItems:@[leftSpaceItem] animated:YES];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    _searchBar.placeholder = @"找团购";
    _searchBar.userInteractionEnabled = NO;
    [self.navigationItem setTitleView:_searchBar];
    
    _rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightNavBtn.frame = CGRectMake(0, 0, 50, 40);
    [_rightNavBtn addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_rightNavBtn setupButtonWithCity:@"" area:@"" image:[UIImage imageNamed:@"anchor.png"]];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}

-(void)changeLocation:(id)sender
{
    NSLog(@"location");
    LocationVC *vc = [[LocationVC alloc] init];
    vc.navTitle = @"选择城市";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
