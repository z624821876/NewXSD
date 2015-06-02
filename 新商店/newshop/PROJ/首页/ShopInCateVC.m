//
//  ShopInCate.m
//  newshop
//
//  Created by qiandong on 15/1/1.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ShopInCateVC.h"
#import "ShopVC.h"
#import "AFNetworking.h"
#import "FoodShopVC.h"
#import "PayVC.h"
#import "SearchResultVC.h"
#import "FruitVC.h"


@interface ShopInCateVC ()
{
    UISearchBar *_searchBar;
    
    UIView  *_headView;
    
    UITableView *_cateTableView;
    
    NSMutableArray *_cateArray;
    NSMutableArray *_shopArray;
    
    NSString *_curCateId;
    NSMutableArray *_adArray;
}
@end

#define LEFT_BG_COLOR [UIColor colorWithWhite:0.961 alpha:1.000]
#define CATE_CELL_HEIGHT 42.0
#define SHOP_CELL_HEIGHT 75.0
#define TABLE_HEIGHT UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-_headView.height
static NSInteger __currentPage;

@implementation ShopInCateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _adArray = [[NSMutableArray alloc] init];
    _cateArray = [NSMutableArray arrayWithCapacity:10];
    _shopArray = [NSMutableArray arrayWithCapacity:10];
    
    _curCateId = self.cateId;
    __currentPage = 0;
    [self buildNavBar];
    [self buildHeadView];
    [self buildCateTable];
    [self buildShopTable];
    [self loadCate];
    [self loadAd];

}

- (void)loadAd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.cateId,@"catId",
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
                NSNumber *objId = nilOrJSONObjectForKey(adItemDict, @"catId");
                ad.objId = [objId stringValue];
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
            } else{ //否则加个固定的
//                [imageArray addObject:@"http://image.53xsd.com/newshop/2014/12/c344c3d0-f67a-412a-b09d-40c9b01af3e8.png"];
//                [titleArray addObject:@""];
            }
            
            if(nil != _escrollView)
            {
                [_escrollView removeFromSuperview];
            }
                        if ([_adArray count]>0) {
            // 设置滚动视图
            _escrollView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)
                                                           ImageArray:imageArray
                                                           TitleArray:titleArray];
            _escrollView.delegate = self;
            [_headView addSubview:_escrollView];
                        }
        }else{
//            [[tools shared] HUDShowHideText:@"读取广告失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[tools shared] HUDShowHideText:@"加载广告数据时网络或服务器异常" delay:2];
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [RestClient cancelPreviousPerformRequestsWithTarget:self];
    [self.tableView tableViewDidFinishedLoading];
}

-(void)buildNavBar
{
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    _searchBar = [[UISearchBar alloc] init];
    ;
    _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 0);
    _searchBar.placeholder = @"找店铺";
    _searchBar.delegate = self;
//    _searchBar.showsSearchResultsButton = YES;
    [self.navigationItem setTitleView:_searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    return YES;
}

- (void)cancelSearch
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = nil;
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length > 0) {
        SearchResultVC *vc = [[SearchResultVC alloc] init];
        vc.keyWord = searchBar.text;
        vc.navTitle = @"搜索结果";
        vc.catId = self.cateId;
        searchBar.text = @"";
        [self.navigationController pushViewController:vc animated:YES];
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

- (void)EScrollerViewDidClicked:(NSUInteger)index
{
    if ([_adArray count] <= 0) {
        return;
    }
    //进入绑定商家
    Info *info = [_adArray objectAtIndex:index];
    if (info.clickurl != nil && info.objId != nil) {
        if (![info.clickurl isEqualToString:@"#"]) {
            
            switch ([info.objId integerValue]) {
                case 5:
                {
                    FoodShopVC *vc = [[FoodShopVC alloc] init];
                    vc.shopId = info.clickurl;
                    //                vc.name = info;
                    vc.image = info.filePath;
                    vc.hidesBottomBarWhenPushed = YES;
                    //                vc.navTitle = user.shopName;
                    vc.cateId = info.objId;
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
                case 11:
                case 12:
                {
                    FruitVC *vc = [[FruitVC alloc] init];
                    vc.shopId = info.clickurl;
//                    vc.name = info.name;
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.cateId = info.objId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                {
                    ShopVC *vc = [[ShopVC alloc] init];
                    vc.shopId = info.clickurl;
                    //                vc.name = info;
                    vc.image = info.filePath;
                    vc.hidesBottomBarWhenPushed = YES;
                    //                vc.navTitle = user.shopName;
                    vc.cateId = info.objId;
                    
                    [self.navigationController pushViewController:vc animated:YES];

                }
                    break;
            }
            
//            if (![info.objId isEqualToString:@"5"]) {
//            }else{
//            }
            
            
        }
        
    }
    
}


-(void)buildCateTable
{
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, 80, UI_SCREEN_HEIGHT)];
//    [leftView setBackgroundColor:LEFT_BG_COLOR];
//    [self.view addSubview:leftView];
    
    _cateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.bottom, 80, UI_SCREEN_HEIGHT - _headView.bottom - 64) style:UITableViewStylePlain];
    [_cateTableView setBackgroundColor:LEFT_BG_COLOR];
    _cateTableView.delegate = self;
    _cateTableView.dataSource = self;
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cateTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_cateTableView];
}

-(void)buildShopTable
{
    self.tableView.frame = CGRectMake(_cateTableView.right, _headView.bottom, 240, SHOP_CELL_HEIGHT*5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.height = TABLE_HEIGHT;
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
//PullingRefreshTableView delegate方法（重写，覆盖load方法 ）
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    __currentPage = 0;
    self.refreshing = YES;
    [self performSelector:@selector(loadShop) withObject:nil afterDelay:0];
}
//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    __currentPage += 1;
    [self performSelector:@selector(loadShop) withObject:nil afterDelay:0];

}

#pragma mark -
#pragma mark - load数据
-(void)loadCate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.cateId,@"parentId",
                                   nil];
    
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonCate] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
        if (code == 0){
            //得到数据
            [_cateArray removeAllObjects];
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *cate = [[Info alloc] init];
                cate.id = nilOrJSONObjectForKey(dict, @"id");
                cate.name = nilOrJSONObjectForKey(dict, @"name");
                cate.image = nilOrJSONObjectForKey(dict, @"image");
                [_cateArray addObject:cate];
            }
//            _cateTableView.height = (_cateArray.count+1) * CATE_CELL_HEIGHT > TABLE_HEIGHT ? (_cateArray.count+1) * CATE_CELL_HEIGHT : TABLE_HEIGHT;
            [_cateTableView reloadData];
            [self.tableView launchRefreshing]; //店铺
        }else{
            [[tools shared] HUDShowHideText:@"读取分类失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

#pragma mark - 请求商品列表
-(void)loadShop
{
//    self.refreshing ? self.page=0 : self.page++;
    
    
    NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getShops?categoryId=%@&cityId=%@&cityName=%@&pageIndex=%d",_curCateId,[LLSession sharedSession].area.id,[LLSession sharedSession].city.name,__currentPage];
    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSInteger code = [[JSON objectForKey:@"code"] integerValue];

                if (code == 0){

                    if (__currentPage == 0) {
        
                        [_shopArray removeAllObjects];
                    }
        
                    NSArray *tmpResultArray = [[JSON objectForKey:@"result"] objectForKey:@"result"];
                    for (NSDictionary *dict in tmpResultArray) {
        
                        Info *shop = [[Info alloc] init];
                        shop.id = nilOrJSONObjectForKey(dict, @"id");
                        shop.name = nilOrJSONObjectForKey(dict, @"name");
                        shop.image = nilOrJSONObjectForKey(dict, @"image");
                        shop.logo = nilOrJSONObjectForKey(dict, @"logo");
                        shop.address = nilOrJSONObjectForKey(dict, @"address");
                        shop.mobile = nilOrJSONObjectForKey(dict, @"mobile");
                        shop.latitude = nilOrJSONObjectForKey(dict, @"latitude");
                        shop.longitude = nilOrJSONObjectForKey(dict, @"longitude");
                        NSNumber *number = nilOrJSONObjectForKey(dict, @"discount");
                        shop.shopDiscount = [number floatValue];
                        [_shopArray addObject:shop];
                        
                    }
//                    if ([tmpResultArray count] == 0 && self.page > 0 )
//                    {
//                        [self.tableView tableViewDidFinishedLoadingWithMessage:nil];
//                        self.tableView.reachedTheEnd  = YES;
//                    }
//                    else
//                    {
//                        [self.tableView tableViewDidFinishedLoading];
//                        self.tableView.reachedTheEnd  = NO;
//                        [self.tableView reloadData];
//                    }
                    [self.tableView tableViewDidFinishedLoading];
                    [self.tableView reloadData];
                }else{
                    
                    __currentPage -= 1;
                    //没有数据
                    [self.tableView tableViewDidFinishedLoading];
        
                    [[tools shared] HUDShowHideText:@"读取店铺失败" delay:1];
                }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
                __currentPage -= 1;
                HUDShowErrorServerOrNetwork

    }];
    [operation1 start];
}
    
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   _curCateId,@"categoryId",
//                                   ,@"cityId",
//
//                                   ,@"cityName",
//                                   __currentPage,@"pageIndex",
//                                   nil];
//  
//    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonCateShop] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
//}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _cateTableView) {
        return _cateArray.count+1;
    }else{
        return _shopArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTableView) {
        static NSString *cateCellIdentifier = @"cateCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cateCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cateCellIdentifier];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 18, 18)];
        [cell.contentView addSubview:imgView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 5, 12, 50, 20)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
        [cell.contentView addSubview:label];
        [cell setBackgroundColor:LEFT_BG_COLOR];
        
        //选中时的背景色
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [selectBgView setBackgroundColor:[UIColor whiteColor]];
        cell.selectedBackgroundView = selectBgView;
        
        if (indexPath.row == 0) {
            [imgView setImage:[UIImage imageNamed:@"cate_all.png"]];
            [label setText:@"  全  部"];
        }else{
            Info *cate = [_cateArray objectAtIndex:indexPath.row-1];
            [imgView setImageWithURL: [NSURL URLWithString:cate.image] placeholderImage:nil];
            [label setText:cate.name];
        }
        return cell;
        
    }else{
        static NSString *shopIdentifier = @"shopCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopIdentifier];
        }else{
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        Info *shop = [_shopArray objectAtIndex:indexPath.row];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 5, 65, 65)];
        [cell.contentView addSubview:imgView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+12, imgView.top, tableView.width - 12 - imgView.right - 74, 20)];
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

        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, imgView.bottom-40, 150, 40)];
        [label2 setFont:[UIFont systemFontOfSize:12]];
        [label2 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
        label2.numberOfLines = 2;
        [cell.contentView addSubview:label2];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [imgView setImageWithURL: [NSURL URLWithString:shop.logo] placeholderImage:nil];
        [label1 setText:shop.name];
        [label2 setText:shop.address];
        
        return cell;
    }
}

- (void)doPay:(UIButton *)btn
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }else{
        Info *shop = [_shopArray objectAtIndex:btn.tag];
        PayVC *vc = [[PayVC alloc] init];
        vc.shopId = shop.id;
        vc.shopDiscount = shop.shopDiscount;
        vc.shopName = shop.name;
        vc.navTitle = @"我要付款";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTableView) {
        return CATE_CELL_HEIGHT;
    }else{
        return SHOP_CELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTableView) {
        if(indexPath.row == 0){
            _curCateId = self.cateId;
        }else{
            Info *cate = [_cateArray objectAtIndex:indexPath.row-1];
            _curCateId = cate.id;
        }
        [_shopArray removeAllObjects];
        self.refreshing = YES;
        [self.tableView reloadData];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView launchRefreshing];
    }else{
          Info *shop = [_shopArray objectAtIndex:indexPath.row];
        
        switch ([_cateId integerValue]) {
            case 5:
            {
                FoodShopVC *vc = [[FoodShopVC alloc] init];
                vc.shopId = shop.id;
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
                vc.cateId = _curCateId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 11:
            case 12:
            {
                FruitVC *vc = [[FruitVC alloc] init];
                vc.shopId = shop.id;
//                vc.name = shop.name;
                vc.hidesBottomBarWhenPushed = YES;
                vc.cateId = _curCateId;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
            {
                ShopVC *vc = [[ShopVC alloc] init];
                vc.shopId = shop.id;
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
                vc.cateId = _curCateId;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
        }

        
//        if (![_cateId isEqualToString:@"5"]) {
//            ShopVC *vc = [[ShopVC alloc] init];
//            vc.shopId = shop.id;
//            vc.name = shop.name;
//            vc.image = shop.image;
//            vc.logo = shop.logo;
//            vc.address = shop.address;
//            vc.mobile = shop.mobile;
//            vc.latitude = shop.latitude;
//            vc.longitude = shop.longitude;
//            vc.simpleDesc = shop.simpleDesc;
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.navTitle = shop.name;
//            vc.cateId = _curCateId;
//        NSLog(@"_curCateId == %@",_curCateId);
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            FoodShopVC *vc = [[FoodShopVC alloc] init];
//            vc.shopId = shop.id;
//            vc.name = shop.name;
//            vc.image = shop.image;
//            vc.logo = shop.logo;
//            vc.address = shop.address;
//            vc.mobile = shop.mobile;
//            vc.latitude = shop.latitude;
//            vc.longitude = shop.longitude;
//            vc.simpleDesc = shop.simpleDesc;
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.navTitle = shop.name;
//            vc.cateId = _curCateId;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
    }
    
}

//设置按下时的颜色
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Add your Colour.
    if(_cateTableView == tableView){
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor:[UIColor whiteColor] ForCell:cell];  //highlight colour
    }
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reset Colour.
    if(_cateTableView == tableView){
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor:LEFT_BG_COLOR ForCell:cell]; //normal color
    }
}
- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
