//
//  HomeVC.m
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "HomeVC.h"
#import "UIButton+Scan.h"
#import "UIButton+Location.h"
#import "UIButton+WebCache.h"
#import "UIButton+Additions.h"
#import "ShopInCateVC.h"
#import "MarketVC.h"
#import "LocationVC.h"
#import "DateUtil.h"
#import "LLSystemConfig.h"
#import "MarketAllVC.h"
#import "DiscountVC.h"
#import "ShopVC.h"
#import "FoodShopVC.h"
#import "SearchResultVC.h"
@interface HomeVC ()
{
    UISearchBar *_searchBar;
    UIButton *_rightNavBtn;
    UIButton *_leftNavBtn;
    
    UIScrollView *_scrollView;
    
    UIView *_banner1View;
    UIView *_banner2View;
    
    UIButton *bannerBtn1;
    UIButton *bannerBtn2;
    UIButton *bannerBtn3;

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
    NSString        *shopImgUrl;
 
    NSString        *advertisementShopId;
    NSString        *advertisementCatId;

    
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _adArray = [NSMutableArray arrayWithCapacity:3];
    _cateArray = [NSMutableArray arrayWithCapacity:12];
    _marketArray = [NSMutableArray arrayWithCapacity:6];
    _arcadeArray = [NSMutableArray arrayWithCapacity:6];
    [self buildNavBar];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*2)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [self buildHeadView];
    [self buildCategoryView];
    [self buildBanner1View:_cateView.bottom];
    
    //KVO
    [[LLSession sharedSession] addObserver:self forKeyPath:@"area.id" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始跟踪定位
    _locManager = [[CLLocationManager alloc] init];
    _locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locManager.delegate = self;
}

- (void)loction
{
    
    if (!_flag) {
        NSString *str = [KNSUserDefaults objectForKey:@"provincename"];
        if ([str isKindOfClass:[NSNull class]] || nil == str) {
            if (iOS8)
            {
                [_locManager requestWhenInUseAuthorization];
            }
            [[tools shared] HUDShowText:@"正在定位"];
            [_locManager startUpdatingLocation];
        }else {
            [LLSession sharedSession].province.name = [KNSUserDefaults objectForKey:@"provincename"];
            [LLSession sharedSession].city.name = [KNSUserDefaults objectForKey:@"cityname"];
            [LLSession sharedSession].area.name = [KNSUserDefaults objectForKey:@"areaname"];
            [LLSession sharedSession].province.id = [KNSUserDefaults objectForKey:@"provinceid"];
            
            [LLSession sharedSession].city.id = [KNSUserDefaults objectForKey:@"cityid"];
            [LLSession sharedSession].area.id = [KNSUserDefaults objectForKey:@"areaid"];
            [LLSession sharedSession].latitude = [KNSUserDefaults objectForKey:@"latitude"];
            [LLSession sharedSession].longitude = [KNSUserDefaults objectForKey:@"longitude"];
            _flag = YES;
            [self loadArea];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self changeImg];
    
    [super viewWillAppear:animated];

    //异步检查更新版本
    NSString *dateFromData = [NSString stringWithFormat:@"%@", [DateUtil getLocaleDateStr:[NSDate date]]];
    NSString *date = [dateFromData substringWithRange:NSMakeRange(0, 10)];
    NSString *lastVersionCheckDate = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsLastVersionCheckDate];
    
    if (![lastVersionCheckDate isEqualToString:date])
    {
        NSString *URL = sVersionURL;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *resopnse, NSData *data, NSError *error) {
            if (data)
            {
                NSPropertyListFormat format;
                NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:&error];
                NSString* version;
                NSString* versionInfo;
                for(NSString*  key in dict){
                    version = [[NSString alloc] initWithFormat:@"%@",key];
                    NSMutableArray *templist=[dict objectForKey:key];
                    versionInfo=[templist objectAtIndex:0];
                    break;
                }
                [self performSelectorOnMainThread:@selector(VersionAlert:) withObject:[NSArray arrayWithObjects:version,versionInfo,nil]  waitUntilDone:NO];
                
            }
        }];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:kUserDefaultsLastVersionCheckDate];
    }
}

- (void)changeImg
{
    User *user = [LLSession sharedSession].user;
    if (user.shopID.length > 0) {
        [bannerBtn2 setImageWithURL:[NSURL URLWithString:user.shopURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"首页9.92.png"]];
    }else {
        [bannerBtn2 setImage:[UIImage imageNamed:@"首页9.92.png"] forState:UIControlStateNormal];
    }

}

-(void)VersionAlert:(NSArray *)array{
    NSString *version = [array objectAtIndex:0];
    NSString *versionInfo = [array objectAtIndex:1];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    if (version!=nil&&![version isEqualToString:@""]&&![version isEqualToString:currentVersion]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"版本%@更新",version] message:versionInfo delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"稍后提醒", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView != _locationAlert && buttonIndex==0)
    {
        NSURL *aURL = [NSURL URLWithString:sVersionDownloadURL];
        [[UIApplication sharedApplication] openURL:aURL];
    }
}

- (void)EScrollerViewDidClicked:(NSUInteger)index
{
    if ([_adArray count] <= 0) {
        return;
    }
    //进入绑定商家
    Info *info = [_adArray objectAtIndex:index];
    if (info.clickurl != nil && info.objId != nil) {
        if (![info.clickurl isEqualToString:@"#"]) {
            
            if (![info.objId isEqualToString:@"5"]) {
                ShopVC *vc = [[ShopVC alloc] init];
                vc.shopId = info.clickurl;
//                vc.name = info;
                vc.image = info.filePath;
                vc.hidesBottomBarWhenPushed = YES;
//                vc.navTitle = user.shopName;
                vc.cateId = info.objId;
                
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                FoodShopVC *vc = [[FoodShopVC alloc] init];
                vc.shopId = info.clickurl;
                //                vc.name = info;
                vc.image = info.filePath;
                vc.hidesBottomBarWhenPushed = YES;
                //                vc.navTitle = user.shopName;
                vc.cateId = info.objId;
                [self.navigationController pushViewController:vc animated:YES];
            }

            
        }
        
    }

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
    [[tools shared] HUDHide];

    if ([error code] == kCLErrorDenied)
    {
        _locationAlert = [[UIAlertView alloc] initWithTitle:@"定位服务没打开，请您去设置->隐私中打开本应用的定位服务" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_locationAlert show];
    }
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

#pragma mark-- Update UI by AreaId
-(void)updateUIByArea
{
    NSLog(@"updateUIByArea");
    //更新导航条按钮
    [_rightNavBtn setupButtonWithCity:[LLSession sharedSession].city.name area:[LLSession sharedSession].area.name image:[UIImage imageNamed:@"anchor.png"]];
    //load广告数据并重画UI
    [self loadAd];
    //按流程顺序load市场->商场数据，并重画市场->商场UI【先removeFromSuperview，再重画】
    [self loadMarketWithType:@"0" Top:_banner1View.bottom]; }

#pragma mark-- Build View
-(void)buildHeadView
{
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
    [_scrollView addSubview:_headView];
}

-(void)buildCategoryView
{
    _cateView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, 250)];
    [_scrollView addSubview:_cateView];
    
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
}

-(UIView *)getSepaView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 8)];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [bgView addSubview:line1];
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom, UI_SCREEN_WIDTH, 7)];
    [spaceView setBackgroundColor:[UIColor colorWithWhite:0.961 alpha:1]];
    [bgView addSubview:spaceView];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, spaceView.bottom, UI_SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [bgView addSubview:line2];
    return bgView;
}

-(void)buildBanner1View:(float)top
{
    if (_banner1View) {
        [_banner1View removeFromSuperview];
        _banner1View = nil;
    }
    _banner1View = [[UIView alloc] initWithFrame:CGRectMake(0, top, UI_SCREEN_WIDTH, 8 + 120)];
    [_scrollView addSubview:_banner1View];
    
    UIView *sepaView = [self getSepaView];
    [_banner1View addSubview:sepaView];
    bannerBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bannerBtn1 setBackgroundImage:[UIImage imageNamed:@"商家活动.png"] forState:UIControlStateNormal];
    bannerBtn1.backgroundColor = [UIColor redColor];
    bannerBtn1.tag = 99;
    [bannerBtn1 addTarget:self action:@selector(bannerClick:) forControlEvents:UIControlEventTouchUpInside];
    [bannerBtn1 setFrame:CGRectMake(10, sepaView.bottom, 100, 120)];
    [_banner1View addSubview:bannerBtn1];

    bannerBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bannerBtn2 setImage:[UIImage imageNamed:@"首页9.92.png"] forState:UIControlStateNormal];
    [bannerBtn2 setFrame:CGRectMake(115, sepaView.bottom, 195, 120)];
    bannerBtn2.tag = 100;
    //绑定商家点击
    [bannerBtn2 addTarget:self action:@selector(bannerClick:) forControlEvents:UIControlEventTouchUpInside];
    [_banner1View addSubview:bannerBtn2];
    
//        //9.9
//    bannerBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bannerBtn3 setBackgroundImage:[UIImage imageNamed:@"首页9.93.png"] forState:UIControlStateNormal];
//    [bannerBtn3 setFrame:CGRectMake(140 + 5, bannerBtn2.bottom + 5, UI_SCREEN_WIDTH - 150, (140 - 15) / 2.0)];
//    bannerBtn3.tag = 101;
//        //9.9点击
//    [bannerBtn3 addTarget:self action:@selector(bannerClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_banner1View addSubview:bannerBtn3];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(122.5, sepaView.bottom, 0.5, 120)];
//    [lineView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
//    [_banner1View addSubview:lineView];

}

#pragma mark - 9.9点击
- (void)bannerClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 99:
        {
            if (advertisementCatId != nil && advertisementShopId != nil) {
                if (![advertisementShopId isEqualToString:@"#"]) {
                    
                    if (![advertisementCatId isEqualToString:@"5"]) {
                        ShopVC *vc = [[ShopVC alloc] init];
                        vc.shopId = advertisementShopId;
//                        vc.image = info.filePath;
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.cateId = advertisementCatId;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        FoodShopVC *vc = [[FoodShopVC alloc] init];
                        vc.shopId = advertisementShopId;
//                        vc.image = info.filePath;
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.cateId = advertisementCatId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                    
                }
                
            }

        }
            break;
        case 100:
        {
            //进入绑定商家
            User *user = [LLSession sharedSession].user;
            if (user.shopID.length > 0) {
                if (![user.shopCat isEqualToString:@"5"]) {
                    ShopVC *vc = [[ShopVC alloc] init];
                    vc.shopId = user.shopID;
                    vc.name = user.shopName;
                    vc.image = user.shopURL;
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navTitle = user.shopName;
                    vc.cateId = user.shopCat;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    FoodShopVC *vc = [[FoodShopVC alloc] init];
                    vc.shopId = user.shopID;
                    vc.name = user.shopName;
                    vc.image = user.shopURL;
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.navTitle = user.shopName;
                    vc.cateId = user.shopCat;
                    vc.navTitle = user.shopName;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        case 101:
        {
                //9.9
            DiscountVC *dis = [[DiscountVC alloc] init];
            dis.navTitle = @"9.9专区";
            dis.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dis animated:YES];

        }
            break;
            
        default:
            break;
    }
    
}

-(void)buildMarketWithTop:(float)top
{
    
    
    if (nil != _marketView) {
        [_marketView removeFromSuperview];
    }
    _marketView = [[UIView alloc] initWithFrame:CGRectMake(0, top, UI_SCREEN_WIDTH, 150+8)];
    [_scrollView addSubview:_marketView];
    
    UIView *sepaView = [self getSepaView];
    [_marketView addSubview:sepaView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, sepaView.bottom+8, 80, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setText:@"本地市场"];
    [_marketView addSubview:label];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-60, label.top, 60, 20)];
    [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [moreBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreMarket:) forControlEvents:UIControlEventTouchUpInside];
    [_marketView addSubview:moreBtn];


    int row = 0; int col = 0;
    float BGVIEW_WIDTH = 95;
    float BGVIEW_HEIGHT = 125;

    for (Info *market in _marketArray) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(7.5+(BGVIEW_WIDTH+10)*col, 40+(BGVIEW_HEIGHT+10)*row, BGVIEW_WIDTH, BGVIEW_HEIGHT)];
        [_marketView addSubview:bgView];
        
        UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoButton setFrame: CGRectMake(0, 0, BGVIEW_WIDTH, BGVIEW_WIDTH)];
        [logoButton addTarget:self action:@selector(marketClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:logoButton];
        
        UILabel *nameLabel = [[UILabel alloc]  initWithFrame:CGRectMake(0, logoButton.bottom+5, bgView.width,20)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [bgView addSubview:nameLabel];
        
        [logoButton setImageWithURL:[NSURL URLWithString:market.logo] forState:UIControlStateNormal placeholderImage:nil];
        logoButton.tag = [market.id integerValue];
        [nameLabel setText:market.name];
        
        col++;
        if(col%3==0)
        {
            col = 0;
            row++;
        }
    }
    
    [self drawLine:CGRectMake(0, 40, UI_SCREEN_WIDTH, 0.5) inView:_marketView]; //本地市场下第一根横线
    if(row == 0 || (row == 1 && col ==0)){ //只有一行
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH+5, 40, 0.5, BGVIEW_HEIGHT+5) inView:_marketView]; //2根短的竖线
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH*2+10+5, 40, 0.5, BGVIEW_HEIGHT+5) inView:_marketView];
    }else { //有2行,则画中间的线
        [self drawLine:CGRectMake(0, 40+BGVIEW_HEIGHT+5, UI_SCREEN_WIDTH, 0.5) inView:_marketView]; //2行中间的横线
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH*1+5, 40, 0.5, BGVIEW_HEIGHT*2+10+5) inView:_marketView]; //2根长的竖线
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH*2+10+5, 40, 0.5, BGVIEW_HEIGHT*2+10+5) inView:_marketView];
    }
    
    
    if([_marketArray count] <= 3){
        _marketView.height = 40+BGVIEW_HEIGHT+5;
    }else{
        _marketView.height = 40+BGVIEW_HEIGHT*2+10+5;
    }
    [self buildBanner2View:_marketView.bottom];

//        [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _marketView.bottom+120)];
}

-(void)drawLine:(CGRect)rect inView:(UIView *)view
{
    
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [view addSubview:line];
}

-(void)buildArcadeWithTop:(float)top
{
    
    if (nil != _arcadeView) {
        [_arcadeView removeFromSuperview];
    }
    _arcadeView = [[UIView alloc] initWithFrame:CGRectMake(0, top, UI_SCREEN_WIDTH, 150+8)];
    [_scrollView addSubview:_arcadeView];
    
    UIView *sepaView = [self getSepaView];
    [_arcadeView addSubview:sepaView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, sepaView.bottom+8, 80, 20)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setText:@"本地商场"];
    [_arcadeView addSubview:label];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-60, label.top, 60, 20)];
    [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [moreBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreArcade:) forControlEvents:UIControlEventTouchUpInside];
    [_arcadeView addSubview:moreBtn];
    
    
    int row = 0; int col = 0;
    float BGVIEW_WIDTH = 95;
    float BGVIEW_HEIGHT = 125;
    
    for (Info *arcade in _arcadeArray) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(7.5+(BGVIEW_WIDTH+10)*col, 40+(BGVIEW_HEIGHT+10)*row, BGVIEW_WIDTH, BGVIEW_HEIGHT)];
        [_arcadeView addSubview:bgView];
        
        UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoButton setFrame: CGRectMake(0, 0, BGVIEW_WIDTH, BGVIEW_WIDTH)];
        [logoButton addTarget:self action:@selector(arcadeClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:logoButton];
        
        UILabel *nameLabel = [[UILabel alloc]  initWithFrame:CGRectMake(0, logoButton.bottom+5, bgView.width,20)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [bgView addSubview:nameLabel];
        
        [logoButton setImageWithURL:[NSURL URLWithString:arcade.logo] forState:UIControlStateNormal placeholderImage:nil];
        logoButton.tag = [arcade.id integerValue];
        [nameLabel setText:arcade.name];
        
        col++;
        if(col%3==0)
        {
            col = 0;
            row++;
        }
    }
    
    [self drawLine:CGRectMake(0, 40, UI_SCREEN_WIDTH, 0.5) inView:_arcadeView]; //本地市场下第一根横线
    if(row == 0 || (row == 1 && col ==0)){ //只有一行
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH+5, 40, 0.5, BGVIEW_HEIGHT+5) inView:_arcadeView]; //2根短的竖线
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH*2+10+5, 40, 0.5, BGVIEW_HEIGHT+5) inView:_arcadeView];
        [self drawLine:CGRectMake(0, 40+BGVIEW_HEIGHT+5, UI_SCREEN_WIDTH, 0.5) inView:_arcadeView]; //最下面的横线
    }else { //有2行,则画中间的线
        [self drawLine:CGRectMake(0, 40+BGVIEW_HEIGHT+5, UI_SCREEN_WIDTH, 0.5) inView:_arcadeView]; //2行中间的横线
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH*1+5, 40, 0.5, BGVIEW_HEIGHT*2+10+5) inView:_arcadeView]; //2根长的竖线
        [self drawLine:CGRectMake(7.5+BGVIEW_WIDTH*2+10+5, 40, 0.5, BGVIEW_HEIGHT*2+10+5) inView:_arcadeView];
        [self drawLine:CGRectMake(0, 40+BGVIEW_HEIGHT*2+10+5, UI_SCREEN_WIDTH, 0.5) inView:_arcadeView]; //最下面的横线
    }
    
    
    if([_arcadeArray count] <= 3){
        _arcadeView.height = 40+BGVIEW_HEIGHT+5;
    }else{
        _arcadeView.height = 40+BGVIEW_HEIGHT*2+10+5;
    }
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _arcadeView.bottom+UI_TAB_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT)];

}

-(void)buildBanner2View:(float) top
{
    if (nil != _banner2View) {
        [_banner2View removeFromSuperview];
    }
    _banner2View = [[UIView alloc] initWithFrame:CGRectMake(0, top, UI_SCREEN_WIDTH, 8+75)];
    [_scrollView addSubview:_banner2View];
    
    UIView *sepaView = [self getSepaView];
    [_banner2View addSubview:sepaView];
    
    UIButton *banner2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [banner2Btn setBackgroundImage:[UIImage imageNamed:@"banner2.png"] forState:UIControlStateNormal];
    [banner2Btn setFrame:CGRectMake(0, sepaView.bottom, UI_SCREEN_WIDTH, 75)];
    [_banner2View addSubview:banner2Btn];
    
    [self loadMarketWithType:@"1" Top:_banner2View.bottom];
}

////加载行业分类
//- (void)loadCategory
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"0",@"parentId",
//                                   nil];
//    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonCategory] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
//        if (code == 0){
//            //得到数据
//            [_cateArray removeAllObjects];
//            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
//            for (NSDictionary *dict in tmpResultArray) {
//                Info *cate = [[Info alloc] init];
//                cate.name = nilOrJSONObjectForKey(dict, @"name");
//                cate.image = nilOrJSONObjectForKey(dict, @"image");
//                [_cateArray addObject:cate];
//            }
//            //画UI
//            int row = 0; int col = 0;
//            for (Info *cate in _cateArray) {
//                UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [cateBtn setImageWithURL:[NSURL URLWithString:cate.image] forState:UIControlStateNormal];
//                [cateBtn setFrame: CGRectMake(30+75*col, _headView.bottom+22+75*row, 40, 40)];
//                cateBtn.tag = [cate.id integerValue];
//                [self.view addSubview:cateBtn];
//                UILabel *cateLabel = [[UILabel alloc] init];
//                [cateLabel setFrame: CGRectMake(cateBtn.left-3, cateBtn.bottom+2, 45, 20)];
//                [cateLabel setFont:[UIFont systemFontOfSize:11]];
//                [cateLabel setText:cate.name];
//                [self.view addSubview:cateLabel];
//                _bannerTop = cateBtn.bottom + 46;
//                col++;
//                if(col%4==0)
//                {
//                    col = 0;
//                    row++;
//                }
//            }
//        }else{
//            [[tools shared] HUDShowHideText:@"读取分类失败" delay:1];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        HUDShowErrorServerOrNetwork
//    }];
//}

#pragma mark-- load Data

-(void)loadArea
{
    NSLog(@"loadArea");
//   [[tools shared] HUDShowText:@"读取城市"];
    
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
            
            [KNSUserDefaults setObject:[LLSession sharedSession].province.name forKey:@"provincename"];
            [KNSUserDefaults setObject:[LLSession sharedSession].city.name forKey:@"cityname"];
            [KNSUserDefaults setObject:[LLSession sharedSession].area.name forKey:@"areaname"];
            [KNSUserDefaults setObject:[LLSession sharedSession].province.id forKey:@"provinceid"];
            [KNSUserDefaults setObject:[LLSession sharedSession].city.id forKey:@"cityid"];
            [KNSUserDefaults setObject:[LLSession sharedSession].area.id forKey:@"areaid"];
            [KNSUserDefaults setObject:[LLSession sharedSession].latitude forKey:@"latitude"];
            [KNSUserDefaults setObject:[LLSession sharedSession].longitude forKey:@"longitude"];
            [KNSUserDefaults synchronize];
            
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
                NSNumber *objNumber = nilOrJSONObjectForKey(adItemDict, @"catId");
                ad.objId = [objNumber stringValue];
                
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
//            if ([_adArray count]>0) {
                // 设置滚动视图
                _eScrollerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)
                                                              ImageArray:imageArray
                                                              TitleArray:titleArray];
                _eScrollerView.delegate = self;
                [_headView addSubview:_eScrollerView];
//            }
        }else{
            [[tools shared] HUDShowHideText:@"读取广告失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDShowHideText:@"加载广告数据时网络或服务器异常" delay:2];
    }];
    
    
    
    NSMutableDictionary *params2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"22",@"typeId",
                                   [LLSession sharedSession].area.id,@"areaId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonAd] parameters:params2 success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"--------%@",JSON);
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
        
            NSArray *array = [JSON objectForKey:@"result"];
            if ([array count] != 0) {
                NSDictionary *dic = [array firstObject];
                NSDictionary *advDic = [dic objectForKey:@"advertisementItem"];
                shopImgUrl = nilOrJSONObjectForKey(advDic, @"filePath");
                [bannerBtn1 setImageWithURL:[NSURL URLWithString:shopImgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"商家活动.png"]];
                
                advertisementShopId = nilOrJSONObjectForKey(advDic, @"clickurl");
                NSNumber *catId = nilOrJSONObjectForKey(advDic, @"catId");
                advertisementCatId = [catId stringValue];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDShowHideText:@"加载广告数据时网络或服务器异常" delay:2];
    }];

}

- (void)loadMarketWithType:(NSString *)type Top:(float)top
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   type,@"type",
                                   [LLSession sharedSession].area.id,@"cityId",
                                   @"0",@"page",
                                   @"6",@"rows",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonMarket] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            //得到数据
            if ([type isEqualToString:@"0"]) {
                [_marketArray removeAllObjects];
            }else{
                [_arcadeArray removeAllObjects];
            }
            NSArray *tmpResultArray = [[JSON valueForKey:@"result"] valueForKey:@"data"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *market = [[Info alloc] init];
                market.id = nilOrJSONObjectForKey(dict, @"id");
                market.name = nilOrJSONObjectForKey(dict, @"name");
                market.logo = nilOrJSONObjectForKey(dict, @"logo");
                
                if ([type isEqualToString:@"0"]) {
                    [_marketArray addObject:market];
                }else{
                    [_arcadeArray addObject:market];
                }
            }
            //画UI
            if ([type isEqualToString:@"0"]) {
                [self buildMarketWithTop:top];
            }else{
                [self buildArcadeWithTop:top];
            }
        }else{
            [[tools shared] HUDShowHideText:@"读取本地市场列表失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDShowHideText:@"加载市场数据时网络或服务器异常" delay:2];
    }];
}

#pragma mark-- Category Click
-(void)CateClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([LLSession sharedSession].area.id == nil) {
        [[tools shared] HUDShowHideText:@"尚未定位，请重新定位城市" delay:2];
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%i",btn.tag];
    if ([str isEqualToString:@"15"]) {
        return;
    }
    
    //跳转到
    ShopInCateVC *vc = [[ShopInCateVC alloc] init];
    vc.cateId = [NSString stringWithFormat:@"%i",btn.tag];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)marketClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Market:%i",btn.tag);
    MarketVC *vc = [[MarketVC alloc] init];
    vc.marketId = [NSString stringWithFormat:@"%i",btn.tag];
    vc.type = @"0";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)arcadeClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Arcade:%i",btn.tag);
    MarketVC *vc = [[MarketVC alloc] init];
    vc.marketId = [NSString stringWithFormat:@"%i",btn.tag];
    vc.type = @"1";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)moreMarket:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"More market:%i",btn.tag);
    MarketAllVC *vc = [[MarketAllVC alloc] init];
    vc.navTitle = @"本地市场";
    vc.type = @"0";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)moreArcade:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"More arcade:%i",btn.tag);
    MarketAllVC *vc = [[MarketAllVC alloc] init];
    vc.navTitle = @"本地商场";
    vc.type = @"1";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    _searchBar.placeholder = @"找店铺";
    _searchBar.delegate = self;
    _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 0);
    [self.navigationItem setTitleView:_searchBar];
    
    _rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightNavBtn.frame = CGRectMake(0, 0, 50, 40);
    [_rightNavBtn addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_rightNavBtn setupButtonWithCity:@"" area:@"" image:[UIImage imageNamed:@"anchor.png"]];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    [self setNavRightBtn];
}

- (void)cancelSearch
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    [self setNavRightBtn];
}

- (void)setNavRightBtn
{
    _rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightNavBtn.frame = CGRectMake(0, 0, 50, 40);
    [_rightNavBtn addTarget:self action:@selector(changeLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_rightNavBtn setupButtonWithCity:[LLSession sharedSession].city.name area:[LLSession sharedSession].area.name image:[UIImage imageNamed:@"anchor.png"]];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = nil;
    [self setNavRightBtn];

    [searchBar resignFirstResponder];
    
    if (searchBar.text.length > 0) {
        SearchResultVC *vc = [[SearchResultVC alloc] init];
        vc.keyWord = searchBar.text;
        vc.hidesBottomBarWhenPushed = YES;
        vc.navTitle = @"搜索结果";
        searchBar.text = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scan:(id)sender
{
    NSLog(@"scan");
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

-(void)dealloc
{
    [[LLSession sharedSession] removeObserver:self forKeyPath:@"area.id"];
}

@end
