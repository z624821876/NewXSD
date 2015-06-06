//
//  ConnectionViewController.m
//  newshop
//
//  Created by 于洲 on 15/3/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ConnectionViewController.h"
#import "UIButton+Additions.h"
#import "PhoneSheet.h"
#import "MyAnnotation.h"

@interface ConnectionViewController ()

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) MKMapView *mapView;

@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectZero;
    [self buildShopInfoView];
    [self initMapView];
}

- (void)initMapView
{
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(5, 120, 310, 250)];
    [self.view addSubview:_mapView];
    
    //添加大头针
    [self addAnnotation];
}

- (void)addAnnotation
{
//    CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    MyAnnotation *annotation1=[[MyAnnotation alloc]init];
    annotation1.title = self.name;
    annotation1.subtitle = self.address;
        //百度坐标  转  高德坐标
    CGFloat x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CGFloat x = [self.longitude doubleValue] - 0.0065, y = [self.latitude doubleValue] - 0.006;
    CGFloat z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CGFloat theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CGFloat gg_lon = z * cos(theta);
    CGFloat gg_lat = z * sin(theta);
    CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake(gg_lat, gg_lon);
    
    annotation1.coordinate = location1;
    [_mapView addAnnotation:annotation1];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(location1, span);
    [_mapView setRegion:region animated:true];

    
}

-(void)buildShopInfoView
{
    float CELL_HEIGHT = 40;
    UIView *shopInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, CELL_HEIGHT*3)];
    [self.view addSubview:shopInfoView];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 18, 20)];
    [imgView1 setImage:[UIImage imageNamed:@"02.2_03.png"]];
    [shopInfoView addSubview:imgView1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView1.right+15, imgView1.top, 250, 20)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setText:self.name];
    [shopInfoView addSubview:label1];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(35, CELL_HEIGHT-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [shopInfoView addSubview:line1];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(imgView1.left, imgView1.top+CELL_HEIGHT, 18, 20)];
    [imgView2 setImage:[UIImage imageNamed:@"mobile.png"]];
    [shopInfoView addSubview:imgView2];
    
    UIImageView *imgVi = [[UIImageView alloc] initWithFrame:CGRectMake(280, imgView1.top+CELL_HEIGHT, 9, 20)];
    [imgVi setImage:[UIImage imageNamed:@"02.2_10.png"]];
    [shopInfoView addSubview:imgVi];
    
    UIButton *mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mobileBtn setFrame:CGRectMake(imgView2.right+15, imgView2.top, 272, 20)];
    [mobileBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [mobileBtn setTitle:self.mobile forState:UIControlStateNormal];
    [mobileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mobileBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:48];
    [mobileBtn addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
    //BTN文字居左
    
    mobileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    mobileBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [shopInfoView addSubview:mobileBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(35, CELL_HEIGHT*2-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [shopInfoView addSubview:line2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(imgView1.left, imgView2.top+CELL_HEIGHT, 18, 20)];
    [imgView3 setImage:[UIImage imageNamed:@"address.png"]];
    [shopInfoView addSubview:imgView3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(imgView3.right+15, imgView3.top, 250, 20)];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [label3 setText:self.address];
    [shopInfoView addSubview:label3];
    
}

    //点击打电话
- (void)phoneClick:(UIButton *)btn
{
    PhoneSheet *vc = [[PhoneSheet alloc] initWithPhoneNumber:self.mobile];
    [vc showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
