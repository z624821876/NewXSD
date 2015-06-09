//
//  NearbyVC.m
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "NearbyVC.h"
#import "ShopVC.h"
#import "PayVC.h"
#import "FoodShopVC.h"
#import "ShopVC.h"
#import "FruitVC.h"
@interface NearbyVC ()
{
    UIView              *_headView;
    CLLocationManager   *_locManager;

    NSMutableArray      *_dataArray;
    CLLocation          *_currentLoction;
    BOOL                isRefrens;
//    UITableView *_tableView;
}

@end

#define SHOP_CELL_HEIGHT 75.0

@implementation NearbyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    
    [self buildHeadView];

    self.tableView.frame = CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT-_headView.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *view = [UIView new];
    self.tableView.tableFooterView = view;
    
    //开始跟踪定位
    _locManager = [[CLLocationManager alloc] init];
    _locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locManager.delegate = self;
    if (iOS8)
    {
        [_locManager requestWhenInUseAuthorization];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [self refrensh];
}

- (void)refrensh
{
    isRefrens = YES;
    [super viewDidAppear:YES];
    [[tools shared] HUDShowText:@"正在加载"];
    [_locManager startUpdatingLocation];
}

#pragma mark -location Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [_locManager stopUpdatingLocation];
    if (isRefrens) {
        _currentLoction = [locations firstObject];
        isRefrens = NO;
        [self loadData];
    }

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [[tools shared] HUDHide];
    
    if ([error code] == kCLErrorDenied)
    {
        [[tools shared] HUDShowHideText:@"定位失败" delay:1.5];
    }
}


-(void)buildHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
    [self.view addSubview:_headView];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
    [imgView setImage:[UIImage imageNamed:@"ad_in.png"]];
    [_headView addSubview:imgView];
}

-(void)loadData
{

    NSString *lat = [NSString stringWithFormat:@"%f",_currentLoction.coordinate.latitude];
    NSString *longit = [NSString stringWithFormat:@"%f",_currentLoction.coordinate.longitude];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   lat,@"latitude",
                                   longit,@"longitude",
                                   @"0",@"categoryId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonNearby] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[tools shared] HUDHide];
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            //得到数据
            [_dataArray removeAllObjects];
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *shop = [[Info alloc] init];
                shop.id = nilOrJSONObjectForKey(dict, @"id");
                shop.name = nilOrJSONObjectForKey(dict, @"name");
                shop.image = nilOrJSONObjectForKey(dict, @"image");
                shop.catId = nilOrJSONObjectForKey(dict, @"catId");
                shop.logo = nilOrJSONObjectForKey(dict, @"logo");
                shop.address = nilOrJSONObjectForKey(dict, @"address");
                shop.mobile = nilOrJSONObjectForKey(dict, @"mobile");
                shop.latitude = nilOrJSONObjectForKey(dict, @"latitude");
                shop.longitude = nilOrJSONObjectForKey(dict, @"longitude");
                shop.distance = [[dict valueForKey:@"distance"] stringValue];
                [_dataArray addObject:shop];
            }
            //特殊
            [self.tableView reloadData];
        }else{
            [[tools shared] HUDShowHideText:@"读取店铺失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [self.tableView tableViewDidFinishedLoading];
    [self refrensh];
}

//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:0]; 不下拉
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *shopIdentifier = @"shopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    Info *shop = [_dataArray objectAtIndex:indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 5, 65, 65)];
    [cell.contentView addSubview:imgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+12, imgView.top, self.view.width - 12 - imgView.right - 74, 20)];
    [label1 setFont:[UIFont systemFontOfSize:12]];
    [label1 setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [cell.contentView addSubview:label1];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(label1.right, label1.top, 60, 20)];
    [payBtn setTitle:@"线下付款" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    payBtn.layer.borderColor = [UIColor redColor].CGColor;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    payBtn.layer.borderWidth = 0.5;
    payBtn.tag = indexPath.row;
    payBtn.layer.cornerRadius = 5;
    payBtn.layer.masksToBounds = YES;
    [payBtn addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:payBtn];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom, 150, 40)];
    [label2 setFont:[UIFont systemFontOfSize:12]];
    [label2 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    label2.numberOfLines = 2;
    [cell.contentView addSubview:label2];
    
    UIImageView *distanceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 40, 13, 13)];
    [distanceImgView setImage:[UIImage imageNamed:@"distance.png"]];
    [cell.contentView addSubview:distanceImgView];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(distanceImgView.right+5, distanceImgView.top-3, 150, 20)];
    [lable3 setFont:[UIFont systemFontOfSize:11]];
    [lable3 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [cell.contentView addSubview:lable3];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [imgView setImageWithURL: [NSURL URLWithString:shop.logo] placeholderImage:nil];
    [label1 setText:shop.name];
    [label2 setText:shop.address];
    [lable3 setText:[NSString stringWithFormat:@"%.2fkm",[shop.distance doubleValue]] ];
    
    return cell;
}

#pragma mark - 直接购买
- (void)doPay:(UIButton *)btn
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }else{
        Info *shop = [_dataArray objectAtIndex:btn.tag];
        PayVC *vc = [[PayVC alloc] init];
        vc.shopId = shop.id;
        vc.shopName = shop.name;
        vc.navTitle = @"我要付款";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHOP_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Info *shop = [_dataArray objectAtIndex:indexPath.row];
    switch ([shop.catId integerValue]) {
        case 5:
        {
            FoodShopVC *vc = [[FoodShopVC alloc] init];
            vc.shopId = shop.id;
            //                vc.name = info;
            vc.image = shop.image;
            vc.hidesBottomBarWhenPushed = YES;
            //                vc.navTitle = user.shopName;
            vc.cateId = shop.catId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 11:
        case 12:
        {
            FruitVC *vc = [[FruitVC alloc] init];
            vc.shopId = shop.id;
            //                vc.name = info;
            vc.hidesBottomBarWhenPushed = YES;
            //                vc.navTitle = user.shopName;
            vc.cateId = shop.catId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            ShopVC *vc = [[ShopVC alloc] init];
            vc.shopId = shop.id;
            //                vc.name = info;
            vc.image = shop.image;
            vc.hidesBottomBarWhenPushed = YES;
            //                vc.navTitle = user.shopName;
            vc.cateId = shop.catId;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
