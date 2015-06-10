//
//  GroupVC.m
//  Distribution
//
//  Created by 于洲 on 15/3/13.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "GroupVC.h"
#import "Info.h"
#import "OrderCell.h"
#import "UIImageView+AFNetworking.h"
#import "OrderDetailVC.h"
#import "PayTypeNew.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "AFJSONRequestOperation.h"

@interface GroupVC ()

@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, assign) NSInteger             currentBtnTag;
@property (nonatomic, strong) NSMutableArray        *dataArr;
@property (nonatomic, strong) NSMutableDictionary   *dataDic;
@property (nonatomic, strong) NSMutableArray        *orderArray;
@property (nonatomic, assign) NSInteger             currentPage;

@end

@implementation GroupVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"订单";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = item;

}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isPush = YES;
    _currentPage = 1;
    _dataArr = [[NSMutableArray alloc] init];
    _dataDic = [[NSMutableDictionary alloc] init];
    _orderArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    
    [self initTopView];
    _currentBtnTag = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, UI_SCREEN_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    __weak GroupVC *vc = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        vc.currentPage = 1;
        [vc loadData];
    }];

    [_tableView addLegendFooterWithRefreshingBlock:^{
        if ([vc.orderArray count] < 10) {
            vc.currentPage = 1;
        }
        vc.currentPage += 1;
        [vc loadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_tableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _isPush = YES;
}

- (void)loadData
{
    NSInteger index = _currentBtnTag;
    if (_currentBtnTag == 0) {
        index = 4;
    }
    
    if (_currentBtnTag == 4) {
        index = 5;
    }
    
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/list?memberId=%@&pageNo=%d&pageSize=10&type=%d",[LLSession sharedSession].user.userId,_currentPage,index];
    
//    NSString *str = @"http://3fxadmin.53xsd.com/mobi/order/list?shopId=29&memberId=1&pageNo=1&pageSize=5&type=4";
    [[tools shared] HUDShowText:@"正在刷新..."];
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        if (_currentPage == 1) {
            [_dataArr removeAllObjects];
            [_dataDic removeAllObjects];
            [_orderArray removeAllObjects];
        }
        
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            id data = [[JSON objectForKey:@"result"] objectForKey:@"result"];
            if ([data isKindOfClass:[NSArray class]]) {
                
                NSArray *orderArray = [[JSON objectForKey:@"result"] objectForKey:@"result"];
                
                for (NSDictionary *dic in orderArray) {
                    Info *order = [[Info alloc] init];
                    order.createTime = [dic objectForKey:@"updateTime"];
                    order.shopId = [dic objectForKey:@"id"];
                    order.type = [dic objectForKey:@"status"];
                    order.name = [dic objectForKey:@"name"];
                    order.totalPrice = [Util getValuesFor:dic key:@"totalFee"];
                    [_orderArray addObject:order];
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    id arr = [dic objectForKey:@"items"];
                   if ([arr isKindOfClass:[NSArray class]]) {
                        if ([arr count] != 0) {
                            for (NSDictionary *shopDic in arr) {
                                Info *shop = [[Info alloc] init];
                                shop.name = [shopDic objectForKey:@"productName"];
                                shop.logo = [shopDic objectForKey:@"productImg"];
                                shop.num = [Util getValuesFor:shopDic key:@"num"];
                                shop.totalPrice = [Util getValuesFor:shopDic key:@"fee"];
                                [array addObject:shop];
                            }
                        }
                    }
                    [_dataDic setObject:array forKey:order.shopId];
                }
            }
        }else {
            _currentPage -= 1;
            [[tools shared] HUDShowHideText:@"暂无数据" delay:1.5];
        }
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        [_tableView reloadData];
        
        if (_currentBtnTag == 0) {
            
            if ([_orderArray count] > 0) {
                Info *info = [_orderArray firstObject];
                
                if ([info.type integerValue] != 3) {
                    if (_isPush) {
                        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self tableView:_tableView didSelectRowAtIndexPath:index];
                    }
                }
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _currentPage -= 1;
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
}

- (void)initTopView
{
    NSArray *array = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor whiteColor];

    CGFloat width = (self.view.frame.size.width - 30) / 5.0;
    for (NSInteger i = 0; i < 5; i ++) {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.frame = CGRectMake(5 + (width + 5) * i, 0, width, 40);
        topBtn.tag = i;
        [topBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBtn setTitle:array[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topView addSubview:topBtn];
    }
    [self.view addSubview:topView];
    
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 37, width, 3)];
    _lineView.backgroundColor = [UIColor redColor];
    [topView addSubview:_lineView];
    
    _currentBtnTag = 0;
//    [self changeLineView];
}

- (void)btnClick:(UIButton *)btn
{
    _currentBtnTag = btn.tag;
    [self changeLineView];
    [self.tableView.header beginRefreshing];
}

- (void)changeLineView
{
//    CGRect rect = _lineView.frame;
    CGFloat width = (self.view.frame.size.width - 30) / 5.0;
    _lineView.frame = CGRectMake(5 + (width + 5) * _currentBtnTag, 37, width, 3);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate login];
}

#pragma mark - tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    [bgView addSubview:view];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 12)];
    [imgView setImage:[UIImage imageNamed:@"enter_shop.png"]];
    [bgView addSubview:imgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 53, 320 -  30, 0.3)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    [bgView addSubview:lineView];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 20 - 10, 22, 10, 20)];
    nextImg.image = [UIImage imageNamed:@"arrow.png"];
    [bgView addSubview:nextImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 44)];
    Info *shop = [_orderArray objectAtIndex:section];
    label.text = shop.name;
    [bgView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 320, 44);
    btn.tag = section;
    [btn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 40)];
    label.font = [UIFont systemFontOfSize:14];
    Info *info = [_orderArray objectAtIndex:section];
    label.text = info.createTime;
    [bgView addSubview:label];

    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = section;
    deleteBtn.frame = CGRectMake(320 - 160, 15, 50, 30);
    deleteBtn.backgroundColor = [UIColor redColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = YES;
    [bgView addSubview:deleteBtn];

    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 100, 10, 80, 40)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:statusLabel];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(320 - 100, 15, 80, 30);
    btn.tag = section;
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 0.3;
    [bgView addSubview:btn];
    switch ([info.type integerValue]) {
        case 0:
        {
            //等待付款
            btn.hidden = NO;
            deleteBtn.hidden = NO;
            [btn setTitle:@"付款" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            //已付款  待发货
            statusLabel.text = @"等待发货";
        }
            break;
        case 2:
        {
            //待收货
            btn.hidden = NO;
            [btn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            //交易成功
            statusLabel.text = @"已完成";
            deleteBtn.hidden = NO;
        }
            break;
        case 4:
        {
            //交易关闭
            statusLabel.text = @"线下付款订单";
            statusLabel.backgroundColor = [UIColor grayColor];
        }
            break;
        case 5:
        {
            //退款中
            statusLabel.text = @"退款中";
        }
            break;
        case 6:
        {
            //交易取消
            statusLabel.text = @"交易取消";

        }
            break;
        case 7:
        {
            //会员删除
            statusLabel.text = @"会员删除";

        }
            break;
        case 8:
        {
            //失效的
            statusLabel.text = @"失效的";

        }
            break;
            
            
            
        default:
            break;
    }
    
    return bgView;
}

#pragma mark - push
- (void)deleteOrder:(UIButton *)btn
{
    Info *info = [_orderArray objectAtIndex:btn.tag];

    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/deleteOrder?orderId=%@&memberId=%@",info.shopId,[LLSession sharedSession].user.userId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[tools shared] HUDShowText:@"请稍候"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"操作成功" delay:1.0];
            _currentPage = 1;
            [self loadData];
        }else {
            [[tools shared] HUDShowHideText:[JSON objectForKey:@"message"] delay:1.0];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
}

- (void)doPay:(UIButton *)btn
{
    if (![btn.currentTitle isEqualToString:@"确认收货"]) {
        
        PayTypeNew *typeVC = [[PayTypeNew alloc]init];
        typeVC.navTitle = @"支付方式";
        typeVC.hidesBottomBarWhenPushed = YES;
        Info *order = [_orderArray objectAtIndex:btn.tag];
        typeVC.totalPrice = order.totalPrice;
        typeVC.orderId = order.shopId;
        typeVC.subject = @"需要接口确认商品标题";
        typeVC.body = @"需要接口确认商品描述";
        typeVC.type = @"订单直接支付";
        [self.navigationController pushViewController:typeVC animated:YES];
        
    }else {
        
        [[tools shared] HUDShowText:@"正在提交。。。"];
        //确认收货
        Info *order = [_orderArray objectAtIndex:btn.tag];
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/receiveConfirm?orderId=%@",order.shopId];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[tools shared] HUDHide];

            if ([[JSON objectForKey:@"code"] integerValue] == 0) {
                //提交成功
                [[tools shared] HUDShowHideText:@"提交成功" delay:1.5];
                [self loadData];
            }else {
                [[tools shared] HUDShowHideText:@"提交失败..." delay:1.5];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[tools shared] HUDHide];
            HUDShowErrorServerOrNetwork
        }];
        [operation start];
    }
}

- (void)nextClick:(UIButton *)btn
{
    Info *order = [_orderArray objectAtIndex:btn.tag];

    //进入订单详情页
    OrderDetailVC *detail = [[OrderDetailVC alloc] init];
    detail.totlalPrice = order.totalPrice;
    detail.orderID = order.shopId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Info *order = [_orderArray objectAtIndex:section];
    return [[_dataDic objectForKey:order.shopId] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Info *order = [_orderArray objectAtIndex:indexPath.section];
    Info *shop = [[_dataDic objectForKey:order.shopId] objectAtIndex:indexPath.row];
    NSLog(@"%@",shop.logo);
    [cell.logo setImageWithURL:[NSURL URLWithString:shop.logo]];
    cell.nameLabel.text = shop.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",shop.totalPrice];
    cell.numLabel.text = [NSString stringWithFormat:@"X%@",shop.num];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Info *order = [_orderArray objectAtIndex:indexPath.section];
    if ([order.type integerValue] == 4) {
        return;
    }
    //进入订单详情页
    OrderDetailVC *detail = [[OrderDetailVC alloc] init];
    detail.totlalPrice = order.totalPrice;
    detail.orderID = order.shopId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_orderArray count];
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
