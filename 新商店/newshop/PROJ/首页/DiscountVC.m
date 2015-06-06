//
//  DiscountVC.m
//  newshop
//
//  Created by 于洲 on 15/3/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "DiscountVC.h"
#import "SVPullToRefresh.h"
#import "AFNetworking.h"
#import "MyCell.h"
#import "UIImageView+WebCache.h"
#import "ProductVC.h"

@interface DiscountVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *areaId;

@end

@implementation DiscountVC
static NSInteger __currentPage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc] init];
    _cityName = [LLSession sharedSession].city.name;
    _areaId = [LLSession sharedSession].area.id;
    __currentPage = 1;
    [self initGUI];
    [self loadDataWithPage:1];
}

- (void)initGUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((320 - 45) / 2.0, 210);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    CGFloat height = self.view.frame.size.height;
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, height - 64) collectionViewLayout:flowLayout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    [_collection registerClass:[MyCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collection];
    
    __weak DiscountVC *vc = self;
    //下拉刷新
    [_collection addPullToRefreshWithActionHandler:^{
        __currentPage = 1;
        //        NSLog(@"%d",__currentPage);
        [vc loadDataWithPage:__currentPage];
    }];
    
    //上拉加载更多
    [_collection addInfiniteScrollingWithActionHandler:^{
        __currentPage += 1;
                NSLog(@"%d",__currentPage);
        [vc loadDataWithPage:__currentPage];
    }];
}

- (void)loadDataWithPage:(NSInteger )page
{
    NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getCheapSell?cityName=%@&pageNo=%d&pageSize=10&areaId=%@",_cityName,page,_areaId];
    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
        
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            NSLog(@"%@",JSON);
        NSArray *array = [[JSON objectForKey:@"result"] objectForKey:@"result"];
        if ([array count] != 0) {
            //有数据
            if (page == 1) {
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dict in array) {
                Info *shop = [[Info alloc] init];
                shop.id = nilOrJSONObjectForKey(dict, @"id");
                shop.shopId = nilOrJSONObjectForKey(dict, @"shopId");
                shop.shopName = nilOrJSONObjectForKey(dict, @"shopName");
                shop.name = nilOrJSONObjectForKey(dict, @"name");
                shop.image = nilOrJSONObjectForKey(dict, @"detailImage");
                shop.logo = nilOrJSONObjectForKey(dict, @"logo");
                shop.address = nilOrJSONObjectForKey(dict, @"address");
                shop.mobile = nilOrJSONObjectForKey(dict, @"mobile");
                shop.latitude = nilOrJSONObjectForKey(dict, @"latitude");
                shop.longitude = nilOrJSONObjectForKey(dict, @"longitude");
                shop.discountPrice = nilOrJSONObjectForKey(dict, @"discountPrice");
//                shop.viewCount = nilOrJSONObjectForKey(dict, @"viewCount");
                shop.viewCount = [[dict objectForKey:@"viewCount"] stringValue];
                shop.price = nilOrJSONObjectForKey(dict, @"price");
                //店铺介绍
                shop.simpleDesc = nilOrJSONObjectForKey(dict, @"simpleDesc");
                [_dataArr addObject:shop];
            }
            [_collection reloadData];
            if (page == 1) {
                //下拉刷新
                [_collection.pullToRefreshView stopAnimating];
                
            }else {
                [_collection.infiniteScrollingView stopAnimating];
                
            }
            
        }else {
            __currentPage -= 1;
            //没有数据
            if (page == 1) {
                //下拉刷新
                [_collection.pullToRefreshView stopAnimating];
                
            }else {
                [_collection.infiniteScrollingView stopAnimating];
                
            }
        }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
        NSLog(@"发生错误！%@",error);
        __currentPage -= 1;
        if (page == 1) {
            //下拉刷新
            [_collection.pullToRefreshView stopAnimating];
        }else {
            [_collection.infiniteScrollingView stopAnimating];
            
        }
    }];
    [operation1 start];
    
    
}

#pragma mark - collectionView   dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Info *shop = [_dataArr objectAtIndex:indexPath.item];
    [cell.img setImageWithURL:[NSURL URLWithString:shop.image]];
//    NSString *str = @"http://fbbimage.53xsd.com/2015/2/e7ed186d-cb7e-467f-9350-f851c7404990.jpg";
//    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    [cell.img setImageWithURL:url];
    
    cell.img.frame = CGRectMake(0, 0, cell.bgView.width, cell.bgView.width + 10);
    
    cell.nameLabel.frame = CGRectMake(5, cell.img.bottom, cell.bgView.width - 10, 40);
    cell.nameLabel.text = shop.name;
    cell.nameLabel.font = [UIFont systemFontOfSize:10];
    cell.nameLabel.numberOfLines = 2;
    
    cell.lineView.frame = CGRectMake(5, cell.nameLabel.bottom - 0.5, cell.width - 10, 0.5);
    cell.lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    
    cell.priceLabel.frame = CGRectMake(5, cell.lineView.bottom, 100, 20);
    cell.priceLabel.textColor = [UIColor redColor];
    cell.priceLabel.font = [UIFont systemFontOfSize:12];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@.00",shop.discountPrice];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Info *shop = [_dataArr objectAtIndex:indexPath.item];
    ProductVC *vc = [[ProductVC alloc] init];
    vc.shopId =  shop.shopId;
    vc.shopName = shop.shopName;
    vc.productId = shop.id;
    vc.name = shop.name;
    vc.detailImage = shop.image;
    vc.discountPrice = shop.discountPrice;
    vc.price = shop.price;
    vc.viewCount = shop.viewCount;
    vc.navTitle = @"商品详情";
    [self.navigationController pushViewController:vc animated:YES];
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
