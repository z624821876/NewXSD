//
//  GroupDescVC.m
//  newshop
//
//  Created by 于洲 on 15/3/10.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "GroupDescVC.h"
#import "AppDelegate.h"
#import "MyTableViewCell.h"
#import "SVPullToRefresh.h"
#import "ProductVC.h"

#import "AFNetworking.h"
@interface GroupDescVC ()
{
    NSInteger index;
//    UITableView *_tableView;
    NSMutableArray *_shopArray;
}

@end

@implementation GroupDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    topView.backgroundColor = [UIColor colorWithRed:204.0 / 255.0 green:67 / 255.0 blue:60 / 255.0 alpha:1];
    [self.view addSubview:topView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 27.5, 25, 25);
    [backBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.showsTouchWhenHighlighted = YES;
    [topView addSubview:backBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(320 - 35, 27.5, 25, 25);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"ico_classify.png"] forState:UIControlStateNormal];
    rightBtn.showsTouchWhenHighlighted = YES;
    [topView addSubview:rightBtn];
    
    index = 10;
    _currentPage = 1;
    self.tableView = [[PullingRefreshTableView alloc]initWithCustomFrame:CGRectMake(0, 64, 320, self.view.height - 64) pullingDelegate:self];

//    self.tableView.frame = CGRectMake(0, 64, 320, self.view.height - 64);
//    self.tableView. = UITableViewStyleGrouped;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    
//    __weak GroupDescVC *vc = self;
//    //下拉刷新
//    [_tableView addPullToRefreshWithActionHandler:^{
//        vc.currentPage = 1;
//        [vc loadData];
//    }];
//    
//    //上拉加载更多
//    [_tableView addInfiniteScrollingWithActionHandler:^{
//        vc.currentPage += 1;
//        [vc loadData];
//    }];
    
//    _shopCateId = @"0";
    
    [self loadData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - PullingRefreshTableViewDelegate
//PullingRefreshTableView delegate方法（重写，覆盖load方法 ）
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.currentPage = 1;

    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];

}
//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
        self.currentPage += 1;
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

- (void)loadData
{
    NSString *latitude = [LLSession sharedSession].latitude;
    NSString *longitude = [LLSession sharedSession].longitude;

    NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/group/list?catId=%@&latitude=%@&longitude=%@&pageNo=%@&pageSize=10&cityId=%@",_shopCateId,latitude,longitude,[NSNumber numberWithInteger:self.currentPage],[LLSession sharedSession].area.id];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (_currentPage == 1) {
            [_shopArray removeAllObjects];
        }
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            
            NSArray *array = [[JSON objectForKey:@"result"] objectForKey:@"data"];
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
                    [_shopArray addObject:shop];
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

        _currentPage -= 1;
        [self.tableView tableViewDidFinishedLoading];


    }];
    [operation1 start];
}

#pragma mark - tableView 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Info *shop = [_shopArray objectAtIndex:indexPath.row];

    cell.titleLab.text = shop.name;
    cell.subtitleLab.text = shop.groupName;
    cell.discountLab.text = [NSString stringWithFormat:@"%@.0元",shop.discountPrice];
    cell.priceLab.text = [NSString stringWithFormat:@"%@元",shop.price];
    cell.distanceLab.text = [NSString stringWithFormat:@"%.1fkm",[shop.groupDistance doubleValue]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Info *shop = [_shopArray objectAtIndex:indexPath.row];
    ProductVC *vc = [[ProductVC alloc] init];
    vc.shopId = shop.shopId;
    vc.shopName = shop.name;
    vc.productId = shop.id;
    vc.detailImage = shop.image;
    vc.discountPrice = shop.discountPrice;
    vc.price = shop.price;
    vc.typeIn = 10;
    vc.name = shop.productName;
    vc.typeIndex = self.cateId;
    vc.navTitle = @"商品详情";
    [self.navigationController pushViewController:vc animated:YES];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView headerViewForSection:section];
    if (view) {
        return view;
    }
     UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
    [self.view addSubview:headView];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
    [imgView setImage:[UIImage imageNamed:@"ad_in.png"]];
    [headView addSubview:imgView];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UI_SCREEN_WIDTH*230/640;
}

- (void)rightBtnClick
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.view.frame.origin.x >= 0) {
        [app.menu showRightViewController:YES];

    }else {
        [app.menu showRootViewController:YES];
    }
}

- (void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
