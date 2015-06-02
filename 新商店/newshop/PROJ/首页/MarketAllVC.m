//
//  MarketAllVC.m
//  newshop
//
//  Created by qiandong on 15-1-8.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MarketAllVC.h"
#import "MarketVC.h"

@interface MarketAllVC ()
{
    UIView  *_headView;
    EScrollerView  *_eScrollerView;
    NSMutableArray *_adArray;
    
    NSMutableArray *_dataArray;
    
    NSString *_pageSize;
}

@end

#define LEFT_BG_COLOR [UIColor colorWithWhite:0.961 alpha:1.000]
#define MARKET_WIDTH 106.5
#define CELL_HEIGHT MARKET_WIDTH+25
#define TABLE_HEIGHT UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-_headView.height

@implementation MarketAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _adArray = [NSMutableArray arrayWithCapacity:3];
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    _pageSize = @"30";


    [self buildHeadView];
    [self buildMarketTable];
    
    [self loadAd];
    
    [self.tableView launchRefreshing]; 

}

-(void)buildHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*230/640+30)];
    [self.view addSubview:_headView];
    
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH*230/640, UI_SCREEN_WIDTH, 30)];
    [titleBgView setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [_headView addSubview:titleBgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [titleBgView addSubview:titleLabel];
    
    if ([self.type isEqualToString:@"0"]) {
        [titleLabel setText:@"所有市场"];
    }else{
        [titleLabel setText:@"所有商场"];
    }
}

-(void)buildMarketTable
{
    self.tableView.frame = CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-_headView.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.height = TABLE_HEIGHT;
}

- (void)loadAd
{
    NSString *adType;
    if ([self.type isEqualToString:@"0"]) {
        adType = @"4"; //市场广告
    }else{
        adType = @"5"; //商场广告
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   adType,@"typeId",
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
}


-(void)loadData
{
    self.refreshing ? self.page=1 : self.page++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].area.id,@"cityId",
                                   _pageSize,@"row",
                                   self.type,@"type",
                                   [NSString stringWithFormat:@"%d", self.page],@"page",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonMarket] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            //得到数据
            if (self.refreshing)
            {
                self.refreshing = NO;
               [_dataArray removeAllObjects];
            }

            NSArray *tmpResultArray = [[JSON valueForKey:@"result"] valueForKey:@"data"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *market = [[Info alloc] init];
                market.id = nilOrJSONObjectForKey(dict, @"id");
                market.name = nilOrJSONObjectForKey(dict, @"name");
                market.logo = nilOrJSONObjectForKey(dict, @"logo");
                [_dataArray addObject:market];
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
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_dataArray.count+1)/3;
    if (_dataArray.count == 0) {
        return 0;
    }else{
        return (_dataArray.count-1)/3+1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *marketIdentifier = @"marketCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:marketIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:marketIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row*3 < _dataArray.count) {
        Info *entity = [_dataArray objectAtIndex:indexPath.row*3];
        MarketView *marketView1 = [[MarketView alloc] initWithEntity:entity Frame:CGRectMake(0, 0, MARKET_WIDTH, CELL_HEIGHT)];
        marketView1.delegate = self;
        [cell.contentView addSubview:marketView1];
    }
    if (indexPath.row*3+1 < _dataArray.count) {
        Info *entity = [_dataArray objectAtIndex:indexPath.row*3+1];
        MarketView *marketView2 = [[MarketView alloc] initWithEntity:entity Frame:CGRectMake(MARKET_WIDTH, 0, MARKET_WIDTH, CELL_HEIGHT)];
        marketView2.delegate = self;
        [cell.contentView addSubview:marketView2];
    }
    if (indexPath.row*3+2 < _dataArray.count) {
        Info *entity = [_dataArray objectAtIndex:indexPath.row*3+2];
        MarketView *marketView3 = [[MarketView alloc] initWithEntity:entity Frame:CGRectMake(MARKET_WIDTH*2, 0, MARKET_WIDTH, CELL_HEIGHT)];
        marketView3.delegate = self;
        [cell.contentView addSubview:marketView3];
    }

    [self drawLine:CGRectMake(0, CELL_HEIGHT-0.5, UI_SCREEN_WIDTH, 0.5) inView:cell.contentView];
    [self drawLine:CGRectMake(MARKET_WIDTH-0.5, 0, 0.5, CELL_HEIGHT) inView:cell.contentView];
    [self drawLine:CGRectMake(MARKET_WIDTH*2-0.5, 0, 0.5, CELL_HEIGHT) inView:cell.contentView];
    
    return cell;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


-(void)marketClicked:(Info *)entity
{
    MarketVC *vc = [[MarketVC alloc] init];
    vc.navTitle = entity.name;
    vc.marketId = entity.id;
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)drawLine:(CGRect)rect inView:(UIView *)view
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [view addSubview:line];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
