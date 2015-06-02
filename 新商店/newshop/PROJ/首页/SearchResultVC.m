//
//  SearchResultVC.m
//  newshop
//
//  Created by 于洲 on 15/5/8.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "SearchResultVC.h"
#import "MJRefresh.h"
#import "AFJSONRequestOperation.h"
#import "MyButton.h"
#import "ShopVC.h"
#import "FoodShopVC.h"
#import "PayVC.h"
@interface SearchResultVC ()
@property (nonatomic, assign) NSInteger             currentPage;
@property (nonatomic, strong) NSMutableArray        *shopArray;
@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _currentPage = 1;
    _shopArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf loadData];
    }];
    [_tableView.header beginRefreshing];
}

- (void)loadData
{
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/searchShops?keyword=%@&areaId=%@&pageNo=%d&pageSize=10&catId=%@",_keyWord,[LLSession sharedSession].area.id,_currentPage,_catId];
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[tools shared] HUDShowText:@"正在加载..."];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            
            if (_currentPage == 1) {
                [_shopArray removeAllObjects];
            }
            
            NSArray *array = nilOrJSONObjectForKey(JSON, @"result");
            for (NSDictionary *dict in array) {
                Info *shop = [[Info alloc] init];
                shop.shopId = nilOrJSONObjectForKey(dict, @"id");
                shop.name = nilOrJSONObjectForKey(dict, @"name");
                shop.image = nilOrJSONObjectForKey(dict, @"image");
                shop.logo = nilOrJSONObjectForKey(dict, @"logo");
                shop.address = nilOrJSONObjectForKey(dict, @"address");
                shop.mobile = nilOrJSONObjectForKey(dict, @"mobile");
                shop.latitude = nilOrJSONObjectForKey(dict, @"latitude");
                shop.longitude = nilOrJSONObjectForKey(dict, @"longitude");
                NSNumber *number = nilOrJSONObjectForKey(dict, @"discount");
                shop.shopDiscount = [number integerValue];
                
                NSNumber *cat = nilOrJSONObjectForKey(dict, @"catId");
                shop.catId = [cat stringValue];
                [_shopArray addObject:shop];
            }
            if ([array count] <= 0) {
                _currentPage -= 1;
            }
            [_tableView reloadData];
            
        }else {
            _currentPage -= 1;
        }
        
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }

        HUDShowErrorServerOrNetwork
    }];
    [operation start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 65, 65)];
        logo.tag = 10;
        [cell.contentView addSubview:logo];
        
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(UI_SCREEN_WIDTH - 75, 15, 60, 30);
        [btn setTitle:@"线下付款" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = 11;
        [btn addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(logo.right + 5, 10, btn.left - 10 - logo.right, 40)];
        label.numberOfLines = 2;
        label.tag = 12;
        [cell.contentView addSubview:label];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(logo.right + 5, label.bottom, UI_SCREEN_WIDTH - logo.right - 20, 20)];
        lable2.tag = 13;
        lable2.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:lable2];
    }
    
    UIImageView *logo = (UIImageView *)[cell.contentView viewWithTag:10];
    MyButton *btn = (MyButton *)[cell.contentView viewWithTag:11];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:12];
    UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:13];
    btn.indexPath = indexPath;
    Info *shop = _shopArray[indexPath.row];
    [logo setImageWithURL:[NSURL URLWithString:shop.logo]];
    nameLabel.text = shop.name;
    addressLabel.text = shop.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Info *shop = [_shopArray objectAtIndex:indexPath.row];
    if (![shop.catId isEqualToString:@"5"]) {
        ShopVC *vc = [[ShopVC alloc] init];
        vc.shopId = shop.shopId;
        vc.name = shop.name;
        vc.image = shop.image;
        vc.logo = shop.logo;
        vc.address = shop.address;
        vc.mobile = shop.mobile;
        vc.latitude = shop.latitude;
        vc.longitude = shop.longitude;
        vc.simpleDesc = shop.simpleDesc;
        vc.hidesBottomBarWhenPushed = YES;
        vc.navTitle = shop.name;
        vc.cateId = shop.catId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FoodShopVC *vc = [[FoodShopVC alloc] init];
        vc.shopId = shop.shopId;
        vc.name = shop.name;
        vc.image = shop.image;
        vc.logo = shop.logo;
        vc.address = shop.address;
        vc.mobile = shop.mobile;
        vc.latitude = shop.latitude;
        vc.longitude = shop.longitude;
        vc.simpleDesc = shop.simpleDesc;
        vc.hidesBottomBarWhenPushed = YES;
        vc.navTitle = shop.name;
        vc.cateId = shop.catId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    
}

- (void)doPay:(MyButton *)btn
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }else{
        Info *shop = [_shopArray objectAtIndex:btn.indexPath.row];
        PayVC *vc = [[PayVC alloc] init];
        vc.shopId = shop.shopId;
        vc.shopDiscount = shop.shopDiscount;
        vc.shopName = shop.name;
        vc.navTitle = @"我要付款";
        [self.navigationController pushViewController:vc animated:YES];
    }
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
