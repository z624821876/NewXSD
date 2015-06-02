//
//  MarketVC.m
//  newshop
//
//  Created by qiandong on 15/1/3.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MarketVC.h"
#import "UIButton+WebCache.h"
#import "ShopVC.h"

@interface MarketVC ()
{
    UIScrollView *_scrollView;
    
    UIView *_headView;
    EScrollerView  *_eScrollerView;
    NSMutableArray *_adArray;
    
    UILabel *_addressLabel;
    
    UIView *_catebgView;
    UIButton *_promotionBtn1;
    UILabel *_marketLabel;
    
    Info *_market;
    NSMutableArray *_cateArray;
    NSMutableArray *_shopArray;
    
    NSString *_cateId;
    
}

//先刷分类，再刷店铺，有顺序的

#define TABLE_CELL_HEIGHT 76

@end

@implementation MarketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cateArray = [NSMutableArray arrayWithCapacity:8];
    _shopArray = [NSMutableArray arrayWithCapacity:10];
    _adArray = [NSMutableArray arrayWithCapacity:10];
    _cateId = @"0";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*2)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [self buildHeadView];
    [self buildCateViewSolid];
    [self buildShopTable];
    
    [self loadMarketDetailAndCateAndAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
    [_scrollView addSubview:_headView];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640)];
//    [imgView setImage:[UIImage imageNamed:@"ad_in.png"]];
//    [_headView addSubview:imgView];
}

-(void)buildCateViewSolid
{
    _catebgView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, 250)];
    [_catebgView setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [_scrollView addSubview:_catebgView];
    
    UIView *addressBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32)];
    [addressBgView setBackgroundColor:[UIColor whiteColor]];
    [_catebgView addSubview:addressBgView];
    
    UIImageView *addressImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 13, 15)];
    [addressImgView setImage:[UIImage imageNamed:@"location.png"]];
    [addressBgView addSubview:addressImgView];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressImgView.right+10, addressImgView.top-2, 260, 20)];
    [_addressLabel setFont:[UIFont systemFontOfSize:14]];
    [_addressLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [addressBgView addSubview:_addressLabel];
    
    _promotionBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _promotionBtn1.frame = CGRectMake(13, addressBgView.bottom+8, 144, 31);
    [_promotionBtn1 setBackgroundImage:[UIImage imageNamed:@"promotion_1.png"] forState:UIControlStateNormal];
    [_catebgView addSubview:_promotionBtn1];
    
    UIButton *promotionBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    promotionBtn2.frame = CGRectMake(166, _promotionBtn1.top, 144, 31);
    [promotionBtn2 setBackgroundImage:[UIImage imageNamed:@"promotion_2.png"] forState:UIControlStateNormal];
    [_catebgView addSubview:promotionBtn2];
}

-(void)buildCateViewDynamic
{
    float top = _promotionBtn1.bottom;
    
    if (_cateArray.count > 0) {
        Info *cateAll = [[Info alloc] init];
        cateAll.id = @"0";
        [_cateArray insertObject:cateAll atIndex:0];
        
        int row = 0; int col = 0;
        for (int i = 0; i< _cateArray.count; i++) {
            Info *cate = [_cateArray objectAtIndex:i];
            UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cateBtn.frame = CGRectMake(12+75*col, _promotionBtn1.bottom+7+75*row, 72, 72);
            if (i == 0) {
                [cateBtn setBackgroundImage:[UIImage imageNamed:@"market_cate_all.png"] forState:UIControlStateNormal];
            }else{
                [cateBtn setImageWithURL:[NSURL URLWithString:cate.logo] forState:UIControlStateNormal placeholderImage:nil];
            }
            [cateBtn addTarget:self action:@selector(cateClick:) forControlEvents:UIControlEventTouchUpInside];
            cateBtn.tag = [cate.id integerValue];
            [_catebgView addSubview:cateBtn];
            
            top = cateBtn.bottom;
            col++;
            if(col%4==0)
            {
                col = 0;
                row++;
            }
        }
    }
    _marketLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top+5, 200, 20)];
    [_marketLabel setFont:[UIFont systemFontOfSize:15]];
    [_marketLabel setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    if([self.type isEqual:@"0"]){
        [_marketLabel setText:@"市场店铺"];
    }else{
        [_marketLabel setText:@"商场店铺"];
    }
    [_catebgView addSubview:_marketLabel];
    
    _catebgView.height = _marketLabel.bottom+8;
}

-(void)buildShopTable
{
    self.tableView.frame = CGRectMake(0, _catebgView.bottom, UI_SCREEN_WIDTH, TABLE_CELL_HEIGHT*2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView removeFromSuperview];
    [_scrollView addSubview:self.tableView];
    [self.tableView launchRefreshing];
}

-(void)loadMarketDetailAndCateAndAd;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                        self.marketId,@"id",
                                                        nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonMarketDetail] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            NSDictionary *marketDict = [[JSON valueForKey:@"result"] valueForKey:@"shopMarket"];
            _market = [[Info alloc] init];
            _market.id = nilOrJSONObjectForKey(marketDict, @"id");
            _market.name = nilOrJSONObjectForKey(marketDict, @"name");
            _market.address = nilOrJSONObjectForKey(marketDict, @"address");
            _market.mobile = nilOrJSONObjectForKey(marketDict, @"mobile");
            _market.logo = nilOrJSONObjectForKey(marketDict, @"logo");
            
            [_addressLabel setText:_market.address];
            self.navTitleLabel.text = _market.name;
            
            [_cateArray removeAllObjects];
            NSArray *tmpArray1 = [[JSON valueForKey:@"result"] valueForKey:@"children"];
            for(NSDictionary *dict in tmpArray1)
            {
                Info *cate = [[Info alloc] init];
                cate.id = nilOrJSONObjectForKey(dict, @"id");
                cate.name = nilOrJSONObjectForKey(dict, @"name");
                cate.logo = nilOrJSONObjectForKey(dict, @"logo");
                [_cateArray addObject:cate];
            }
            
            [_adArray removeAllObjects];
            NSArray *tmpArray2 = [[JSON valueForKey:@"result"] valueForKey:@"images"];
            for(NSDictionary *dict in tmpArray2)
            {
                Info *ad = [[Info alloc] init];
                ad.id = nilOrJSONObjectForKey(dict, @"id");
                ad.imgPath = nilOrJSONObjectForKey(dict, @"imgPath");
                ad.title = @"";
                [_adArray addObject:ad];
            }
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:[_adArray count]];
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:[_adArray count]];
            if(_adArray.count > 0){
                for (Info *ad in _adArray) {
                    [imageArray addObject:ad.imgPath];
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
            
            [self buildCateViewDynamic];
            
            [self buildShopTable];
            
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

-(void)loadShop
{
    self.refreshing ? self.page=1 : self.page++;
    
    NSMutableDictionary *params;
    NSString *path;
    if([_cateId isEqual:@"0"]){ //全部店
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  self.marketId,@"id",
                  [NSString stringWithFormat:@"%i",self.page],@"page",
                  nil];
        path = [tools getServiceUrl:jsonMarketShop];
    }else{ //分类下的店
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  _cateId,@"id",
                  [NSString stringWithFormat:@"%i",self.page],@"page",
                  nil];
        path = [tools getServiceUrl:jsonMarketCateShop];
    }
    [[RestClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            //得到数据
            if (self.refreshing)
            {
                self.refreshing = NO;
                [_shopArray removeAllObjects];
            }
            
            NSArray *tmpResultArray = [[JSON valueForKey:@"result"] valueForKey:@"data"];
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
                [_shopArray addObject:shop];
            }

            if ([tmpResultArray count] == 0 && self.page > 1 )
            {
                [self.tableView tableViewDidFinishedLoadingWithMessage:nil];
                self.tableView.reachedTheEnd  = YES;
            }
            else
            {
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd  = NO;
                [self.tableView reloadData];
            }
            self.tableView.height = _shopArray.count > 3 ? TABLE_CELL_HEIGHT * _shopArray.count : TABLE_CELL_HEIGHT*3;
            [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH,  _catebgView.bottom+self.tableView.height+UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT+5)];
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
//PullingRefreshTableView delegate方法（重写，覆盖load方法 ）
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadShop) withObject:nil afterDelay:0];
}

//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadShop) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shopArray.count;
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
    Info *shop = [_shopArray objectAtIndex:indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 5, 65, 65)];
    [cell.contentView addSubview:imgView];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+12, imgView.top, 150, 20)];
    [label1 setFont:[UIFont systemFontOfSize:12]];
    [label1 setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [cell.contentView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, imgView.bottom-20, 150, 20)];
    [label2 setFont:[UIFont systemFontOfSize:12]];
    [label2 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [cell.contentView addSubview:label2];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [imgView setImageWithURL: [NSURL URLWithString:shop.logo] placeholderImage:nil];
    [label1 setText:shop.name];
    [label2 setText:shop.address];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Info *shop = [_shopArray objectAtIndex:indexPath.row];
    ShopVC *vc = [[ShopVC alloc] init];
    vc.shopId = shop.id;
    vc.name = shop.name;
    vc.image = shop.image;
    vc.logo = shop.logo;
    vc.address = shop.address;
    vc.mobile = shop.mobile;
    vc.latitude = shop.latitude;
    vc.longitude = shop.longitude;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navTitle = shop.name;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cateClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%i",btn.tag);
    _cateId = [NSString stringWithFormat:@"%i",btn.tag];
    
    [_shopArray removeAllObjects];
    self.refreshing = YES;
    [self.tableView reloadData];
    self.tableView.reachedTheEnd  = NO;
    [self.tableView launchRefreshing];
}



@end
