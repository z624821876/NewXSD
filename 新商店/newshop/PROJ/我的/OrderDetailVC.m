//
//  OrderDetailVC.m
//  Distribution
//
//  Created by 于洲 on 15/3/24.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderCell.h"
#import "UIImageView+AFNetworking.h"
#import "PayTypeNew.h"
#import "AFJSONRequestOperation.h"
#import "OrderStatusView.h"
#import "StatusModel.h"
#import "GroupVC.h"
@interface OrderDetailVC ()
@property (nonatomic, strong) UIButton              *bottomBtn;
@property (nonatomic, strong) UILabel               *bottomLabel;
@property (nonatomic, strong) OrderStatusView       *orderStatusView;

@property (nonatomic, strong) UIButton              *leftBtn;
@property (nonatomic, strong) UIButton              *rightBtn;
@property (nonatomic, strong) UIView                *markView;
@property (nonatomic, strong) NSMutableArray        *statusArray;

@end

@implementation OrderDetailVC


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
    GroupVC *vc = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
    vc.isPush = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _statusArray = [[NSMutableArray alloc] init];
    [self buildOptionView];
    self.view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];

    _shopArr = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160 + 10, 320, self.view.height - 64 - 160 - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _orderStatusView = [[OrderStatusView alloc] initWithFrame:CGRectMake(0, 50, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 50)];
    [_orderStatusView.statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderStatusView];
    
}

- (void)statusBtnClick:(UIButton *)btn
{
    if (btn.tag == 2 || btn.tag == 10086) {
        
        if ([LLSession sharedSession].user.userId == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 624821;
            [alert show];
            return;
        }

    }
    
    if (btn.tag == 2) {
        //付款
        PayTypeNew *typeVC = [[PayTypeNew alloc] init];
        typeVC.navTitle = @"支付方式";
        typeVC.totalPrice = self.totlalPrice;
        typeVC.orderId = self.orderID;
        typeVC.subject = @"需要接口确认商品标题";
        typeVC.body = @"需要接口确认商品描述";
        typeVC.type = @"订单直接支付";
        [self.navigationController pushViewController:typeVC animated:YES];
    }
    
    if (btn.tag == 10086) {
        [[tools shared] HUDShowText:@"正在提交。。。"];
        //确认收货
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/receiveConfirm?orderId=%@",self.orderID];
        
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

- (void)buildOptionView
{
    UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    optionView.backgroundColor = [UIColor whiteColor];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH / 2.0, 50);
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftBtn setTitle:@"订单状态" forState:UIControlStateNormal];
    _leftBtn.selected = YES;
    _leftBtn.tag = 10;
    [_leftBtn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
    [optionView addSubview:_leftBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(_leftBtn.right, 0, _leftBtn.width, 50);
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"订单详情" forState:UIControlStateNormal];
    _rightBtn.tag = 11;
    [_rightBtn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
    [optionView addSubview:_rightBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, optionView.bottom - 0.5, optionView.width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [optionView addSubview:line];
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, optionView.bottom - 3, _leftBtn.width, 3)];
    _markView.backgroundColor = [UIColor redColor];
    [optionView addSubview:_markView];

    [self.view addSubview:optionView];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, UI_SCREEN_WIDTH, 120)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.backgroundColor = [UIColor redColor];
    _bottomBtn.frame = CGRectMake(self.view.width - 110, self.view.height - 100, 80, 30);

    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 90, self.view.height - 100, 80, 30)];
    [self.view addSubview:_bottomBtn];
    [self.view addSubview:_bottomLabel];

    _bottomBtn.hidden = YES;
    _bottomLabel.hidden = YES;
    
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    if (btn.tag == 10) {
        _rightBtn.selected = NO;
        _orderStatusView.hidden = NO;
    }else {
        _leftBtn.selected = NO;
        _orderStatusView.hidden = YES;
    }
    CGRect rect = _markView.frame;
    rect.origin.x = (btn.tag - 10) * UI_SCREEN_WIDTH / 2.0;
    _markView.frame = rect;
    
    
}

- (void)loadData
{
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/getDetail?orderId=%@",self.orderID];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [_shopArr removeAllObjects];
        if ([[JSON  objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *resultDic = [JSON objectForKey:@"result"];
            self.orderNo = [resultDic objectForKey:@"orderNo"];
            self.paymentTime = [resultDic objectForKey:@"payTime"];
            self.completeTime = [resultDic objectForKey:@"completeTime"];
            self.orderStatus = [[resultDic objectForKey:@"orderStatus"] stringValue];
            self.shopName = [resultDic objectForKey:@"shopName"];
            self.postFee = [[resultDic objectForKey:@"postFee"] stringValue];;
            self.itemNum = [[resultDic objectForKey:@"itemNum"] stringValue];
            
            self.postName = [resultDic objectForKey:@"express"];
            self.postNo = [resultDic objectForKey:@"expressNo"];
            
            NSDictionary *receiveAddress = nilOrJSONObjectForKey(resultDic, @"receiveAddress");
            //收货信息
            self.name = nilOrJSONObjectForKey(receiveAddress, @"name");
            self.phone = nilOrJSONObjectForKey(receiveAddress, @"mobile");
            self.address = nilOrJSONObjectForKey(receiveAddress, @"address");
            
            NSArray *itemArr = nilOrJSONObjectForKey(resultDic, @"items");
            for (NSDictionary *dic in itemArr) {
                Info *info = [[Info alloc] init];
                info.logo = [dic objectForKey:@"productImg"];
                info.name = [dic objectForKey:@"productName"];
                info.totalPrice = [[dic objectForKey:@"fee"] stringValue];
                info.num = [[dic objectForKey:@"num"] stringValue];
                [_shopArr addObject:info];
            }
            
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"orderDetailStatus");
            
            [_statusArray removeAllObjects];
            for (NSDictionary *dict in array) {
                StatusModel *model = [[StatusModel alloc] init];
                model.time = nilOrJSONObjectForKey(dict, @"time");
                model.content = nilOrJSONObjectForKey(dict, @"content");
                NSNumber *status = nilOrJSONObjectForKey(dict, @"status");
                model.status = [status stringValue];
                NSNumber *idNum = nilOrJSONObjectForKey(dict, @"id");
                model.statusId = [idNum stringValue];
                model.orderId = nilOrJSONObjectForKey(dict, @"orderId");
                [_statusArray addObject:model];
            }
            
            [_orderStatusView setDataArray:_statusArray];
            [self buildTopView];
            [_tableView reloadData];
            [self buildFootView];
            
        }
        [[tools shared] HUDHide];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [operation start];

}

- (void)buildTopView
{
        UIImageView *bookImage = [[UIImageView alloc]initWithFrame:CGRectMake(_headView.left + 5, 5, 20,30)];
        // bookImage.backgroundColor = [UIColor yellowColor];
        [_headView addSubview:bookImage];
        
        UILabel *bookNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, bookImage.top, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
        bookNumLabel.textColor = [UIColor blackColor];
        [_headView addSubview:bookNumLabel];
        [bookNumLabel setText:[NSString stringWithFormat:@"订单编号：%@",self.orderNo]];

        UILabel *payDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, bookNumLabel.bottom + 5, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
        payDateLabel.textColor = [UIColor blackColor];
        [_headView addSubview:payDateLabel];
        [payDateLabel setText:[NSString stringWithFormat:@"付款时间：%@",self.paymentTime]];
        
        UILabel *makedateLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, payDateLabel.bottom + 5, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
        makedateLabel.textColor = [UIColor blackColor];
        [_headView addSubview:makedateLabel];
        [makedateLabel setText:[NSString stringWithFormat:@"成交时间：%@",self.completeTime]];
}

- (void)doPay:(UIButton *)btn
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
        return;
    }
    if (btn.tag == 0) {
        //付款
        PayTypeNew *typeVC = [[PayTypeNew alloc] init];
        typeVC.navTitle = @"支付方式";
        typeVC.totalPrice = self.totlalPrice;
        typeVC.orderId = self.orderID;
        typeVC.subject = @"需要接口确认商品标题";
        typeVC.body = @"需要接口确认商品描述";
        typeVC.type = @"订单直接支付";
        [self.navigationController pushViewController:typeVC animated:YES];
        
    }else {
        [[tools shared] HUDShowText:@"正在提交。。。"];
        //确认收货
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/receiveConfirm?orderId=%@",self.orderID];
        
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

- (void)buildFootView
{
    _bottomLabel.hidden = YES;
    _bottomLabel.hidden = YES;

//    _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.layer.cornerRadius = 10;
    _bottomBtn.layer.masksToBounds = YES;
    _bottomBtn.backgroundColor = [UIColor redColor];
//    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 90, self.view.height - 35, 80, 30)];
    _bottomLabel.textAlignment = NSTextAlignmentCenter;
    
    switch ([self.orderStatus integerValue]) {
        case 0:
        {
            //等待付款   去付款
            [_bottomBtn setTitle:@"去付款" forState:UIControlStateNormal];
            _bottomBtn.tag = [self.orderStatus integerValue];
            [_bottomBtn addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventTouchUpInside];
            _bottomBtn.hidden = NO;
//            [self.view addSubview:_bottomBtn];
            
        }
            break;
        case 1:
        {
            _bottomLabel.hidden = NO;

            //已付款  待发货
            _bottomLabel.text = @"等待发货";
//            [self.view addSubview:_bottomLabel];
        }
            break;
        case 2:
        {
            //待收货
            [_bottomBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            _bottomBtn.tag = [self.orderStatus integerValue];
            [_bottomBtn addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventTouchUpInside];
            _bottomBtn.hidden = NO;
//            [self.view addSubview:_bottomBtn];
            
            
        }
            break;
        case 3:
        {
            //交易成功
            _bottomLabel.text = @"交易成功";
            _bottomLabel.hidden = NO;
//            [self.view addSubview:_bottomLabel];
            
        }
            break;
        case 4:
        {
            //交易关闭
            _bottomLabel.text = @"交易关闭";
            _bottomLabel.hidden = NO;
//            [self.view addSubview:_bottomLabel];
            
            
        }
            break;
        case 5:
        {
            //退款中
            _bottomLabel.text = @"退款中";
            _bottomLabel.hidden = NO;
//            [self.view addSubview:_bottomLabel];
            
        }
            break;
        case 6:
        {
            //交易取消
            _bottomLabel.text = @"交易取消";
            _bottomLabel.hidden = NO;
//            [self.view addSubview:_bottomLabel];
            
            
        }
            break;
        case 7:
        {
            //会员删除
            
            _bottomLabel.text = @"会员已删除";
            _bottomLabel.hidden = NO;
//            [self.view addSubview:_bottomLabel];
            
        }
            break;
        case 8:
        {
            //失效的
            _bottomLabel.text = @"失效的订单";
            _bottomLabel.hidden = NO;
//            [self.view addSubview:_bottomLabel];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - tableView 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{    if ([self.postName isKindOfClass:[NSNull class]]) {
        return 130;
    }
    return 130 + 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_shopArr count];
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
    Info *shop = [_shopArr objectAtIndex:indexPath.row];

    [cell.logo setImageWithURL:[NSURL URLWithString:shop.logo]];
    cell.nameLabel.text = shop.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",shop.totalPrice];
    cell.numLabel.text = [NSString stringWithFormat:@"X%@",shop.num];
    return cell;
}

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
    label.text = self.shopName;
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[@"运费：",@"商品数：",@"实付款："];
    
    NSString *postFee = [NSString stringWithFormat:@"￥%.2f",[self.postFee doubleValue]];
    NSString *num = [NSString stringWithFormat:@"%ld件",[self.itemNum integerValue]];
    NSString *totalPri = [NSString stringWithFormat:@"￥%.2f",[self.totlalPrice doubleValue]];
    NSArray *array2 = @[postFee,num,totalPri];
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + 20 * i, 60, 20)];
        leftLabel.text = array[i];
        leftLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 90, 5 + 20 * i, 80, 20)];
        rightLabel.text = array2[i];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:12];
        if (i == 2) {
            rightLabel.textColor = [UIColor redColor];
        }
        [bgView addSubview:rightLabel];

    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 65, 290, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    [bgView addSubview:lineView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 20, 20)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image = [UIImage imageNamed:@"ico_adr.png"];
    [bgView addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 70, 80, 20)];
    label.text = @"收货信息";
    [bgView addSubview:label];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 90, 190, 20)];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.text = [NSString stringWithFormat:@"收货人：%@",self.name];
    [bgView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 85, 90, 75, 20)];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont systemFontOfSize:10];
    phoneLabel.text = [NSString stringWithFormat:@"%@",self.phone];
    [bgView addSubview:phoneLabel];
    
    UILabel *addLable = [[UILabel alloc] initWithFrame:CGRectMake(35, 110, 320 - 45, 20)];
    addLable.font = [UIFont systemFontOfSize:12];
    addLable.text = [NSString stringWithFormat:@"收货地址：%@",self.address];
    [bgView addSubview:addLable];
    
    
    if (![self.postName isKindOfClass:[NSNull class]] && self.postName != nil) {
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, addLable.bottom, 290, 0.5)];
        lineView2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        [bgView addSubview:lineView2];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(35, lineView2.bottom + 5, 80, 20)];
        label2.text = @"物流信息";
        [bgView addSubview:label2];
        
        UILabel *nameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(35, label2.bottom, 320 - 45, 20)];
        nameLabel2.font = [UIFont systemFontOfSize:12];
        nameLabel2.text = [NSString stringWithFormat:@"物流公司：%@",self.postName];
        [bgView addSubview:nameLabel2];
        
        UILabel *addLable2 = [[UILabel alloc] initWithFrame:CGRectMake(35, nameLabel2.bottom, 320 - 45, 20)];
        addLable2.font = [UIFont systemFontOfSize:12];
        addLable2.text = [NSString stringWithFormat:@"快递单号：%@",self.postNo];
        [bgView addSubview:addLable2];

    }
        return bgView;
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
