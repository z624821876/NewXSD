//
//  FruitVC.m
//  newshop
//
//  Created by 于洲 on 15/6/1.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "FruitVC.h"
#import "AFJSONRequestOperation.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MyButton.h"
#import "WaimaiOrder.h"
#import "ConnectionViewController.h"
#import "PhoneSheet.h"

@interface FruitVC ()
{
    UILabel         *_discountLabel;
    UILabel         *_addressLabel;
    UILabel         *_mobileLabel;
    UILabel         *_buyCountLable;
    UILabel         *_numLabel;
    UILabel         *_priceLabel;
    NSMutableArray  *_dataArray;
    NSInteger       _type;
    NSMutableArray  *_cateArray;
    NSMutableDictionary    *_selectDic;
}
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) Info *shopInfo;
@property (nonatomic, assign) CGFloat discount;
@end

@implementation FruitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectDic = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
    _cateArray = [NSMutableArray array];
    _type = 0;
    _currentPage = 1;
    [self buildTopView];
    [self buildFootView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15 + 100 + 15 + 40, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 170 - 60 - 64) style:UITableViewStylePlain];
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    
    [_tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf loadData];
    }];
    
    [self.view addSubview:_tableView];
    
    _cateTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 15 + 100 + 15 + 40, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 15 - 100 - 15 - 40 - 60 - 64) style:UITableViewStylePlain];
    _cateTable.delegate = self;
    _cateTable.dataSource = self;
    _cateTable.tag = 10;
    _cateTable.hidden = YES;
    UIView *view1 = [UIView new];
    _cateTable.tableFooterView = view1;
    [self.view addSubview:_cateTable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    [super viewWillAppear:YES];
    [[tools shared] HUDShowText:@"请稍后..."];
    _shopInfo = [[Info alloc] init];
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getShopDetail?shopId=%@",self.shopId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [[JSON objectForKey:@"result"] objectForKey:@"shop"];
            _shopInfo.simpleDesc = [dic objectForKey:@"desc"];
            _shopInfo.name = [dic objectForKey:@"name"];
            self.navTitleLabel.text = _shopInfo.name;
            _shopInfo.image = [dic objectForKey:@"image"];
            _shopInfo.logo = [dic objectForKey:@"logo"];
            _shopInfo.address = [dic objectForKey:@"address"];
            _shopInfo.mobile = [dic objectForKey:@"mobile"];
            _shopInfo.latitude = [dic objectForKey:@"latitude"];
            _shopInfo.longitude = [dic objectForKey:@"longitude"];
            _shopInfo.catId = [dic objectForKey:@"catId"];
            NSNumber *num = nilOrJSONObjectForKey(dic, @"field1");
            _shopInfo.shopDiscount = [num doubleValue];
            NSNumber *number = nilOrJSONObjectForKey(dic, @"discount");
            _discount = [number floatValue];
        }
        [self updateGUI];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
    self.view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    
    NSString *str2 = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getShopProductCategory?shopId=%@",self.shopId];
    NSURL *url2 = [NSURL URLWithString:str2];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    AFJSONRequestOperation *operation2 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request2 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            [_cateArray removeAllObjects];
            Info *info1 = [[Info alloc] init];
            info1.name = @"全部";
            info1.catId = @"0";
            [_cateArray addObject:info1];
            NSArray *result = nilOrJSONObjectForKey(JSON, @"result");
            for (NSDictionary *dic in result) {
                Info *info = [[Info alloc] init];
                info.name = nilOrJSONObjectForKey(dic, @"name");
                info.catId = [Util getValuesFor:dic key:@"id"];
                [_cateArray addObject:info];
            }
            [_cateTable reloadData];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation2 start];
}

//联系卖家
- (void)connection:(UIButton *)btn
{
    if (btn.tag == 1) {
        ConnectionViewController *connection = [[ConnectionViewController alloc] init];
        connection.name = _shopInfo.name;
        connection.address = _shopInfo.address;
        connection.mobile = _shopInfo.mobile;
        connection.latitude = _shopInfo.latitude;
        connection.longitude = _shopInfo.longitude;
        connection.navTitle = @"联系卖家";
        [self.navigationController pushViewController:connection animated:YES];
    }else {
        PhoneSheet *vc = [[PhoneSheet alloc] initWithPhoneNumber:_shopInfo.mobile];
        [vc showInView:self.view];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.currentPage = 1;
}

- (void)loadData
{
    if (_type == 0) {
        [[tools shared] HUDShowText:@"正在加载..."];
        NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getProductByShopId?shopId=%@&pageIndex=%d&pageSize=10",self.shopId,_currentPage];
        NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[tools shared] HUDHide];
            BOOL isNull = YES;
            NSInteger code = [[JSON objectForKey:@"code"] integerValue];
            if (code == 0) {
                if (_currentPage == 1) {
                    [_dataArray removeAllObjects];
                }
                NSArray *tmpResultArray = nilOrJSONObjectForKey(JSON, @"result");
                for (NSDictionary *dict in tmpResultArray) {
                    isNull = NO;
                    Info *product = [[Info alloc] init];
                    product.id = nilOrJSONObjectForKey(dict, @"id");
                    product.name = nilOrJSONObjectForKey(dict, @"name");
                    product.detailImage = nilOrJSONObjectForKey(dict, @"detailImage");
                    NSNumber *priceNum = nilOrJSONObjectForKey(dict, @"price");
                    product.price = [priceNum stringValue];
                    NSNumber *discountPrice = nilOrJSONObjectForKey(dict, @"discountPrice");
                    product.discountPrice = [discountPrice stringValue];
                    product.viewCount = [[dict valueForKey:@"viewCount"] stringValue];
                    Info *model = [_selectDic objectForKey:product.id];
                    product.foodNum = model == nil ? 0 : model.foodNum;
                    [_dataArray addObject:product];
                }
            }
            if (isNull) {
                _currentPage -= 1;
            }
            if ([_tableView.header isRefreshing]) {
                [_tableView.header endRefreshing];
            }else {
                [_tableView.footer endRefreshing];
            }

            [_tableView reloadData];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[tools shared] HUDHide];
            if ([_tableView.header isRefreshing]) {
                [_tableView.header endRefreshing];
            }else {
                [_tableView.footer endRefreshing];
            }
            _currentPage -= 1;
            HUDShowErrorServerOrNetwork
        }];
        [operation start];

    }else {
        [[tools shared] HUDShowText:@"正在加载..."];
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/selectByCategory?catId=%d&pageIndex=%d",_type,_currentPage];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *option = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[tools shared] HUDHide];
            BOOL isNull = YES;
            if ([[JSON objectForKey:@"code"] integerValue] == 0) {
                if (_currentPage == 1) {
                    [_dataArray removeAllObjects];
                }
                NSArray *array = nilOrJSONObjectForKey(JSON, @"result");
                for (NSDictionary *dic in array) {
                    isNull = NO;
                    Info *info = [[Info alloc] init];
                    info.name = nilOrJSONObjectForKey(dic, @"name");
                    info.id = nilOrJSONObjectForKey(dic, @"id");
                    info.detailImage = nilOrJSONObjectForKey(dic, @"detailImage");
                    info.price = [Util getValuesFor:dic key:@"price"];
                    info.discountPrice = [Util getValuesFor:dic key:@"discountPrice"];
                    Info *model = [_selectDic objectForKey:info.id];
                    info.foodNum = model == nil ? 0 : model.foodNum;
                    [_dataArray addObject:info];
                }
            }
            
            if (isNull) {
                _currentPage -= 1;
            }
            if ([_tableView.header isRefreshing]) {
                [_tableView.header endRefreshing];
            }else {
                [_tableView.footer endRefreshing];
            }
            [_tableView reloadData];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[tools shared] HUDHide];
            _currentPage -= 1;
            if ([_tableView.header isRefreshing]) {
                [_tableView.header endRefreshing];
            }else {
                [_tableView.footer endRefreshing];
            }

            HUDShowErrorServerOrNetwork
        }];
        [option start];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10) {
        return [_cateArray count];
    }
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag != 10) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
            logo.tag = 10;
            [cell.contentView addSubview:logo];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(logo.right + 10, 10, UI_SCREEN_WIDTH - logo.right - 20, 40)];
            name.numberOfLines = 2;
            name.tag = 11;
            [cell.contentView addSubview:name];
            
            UILabel *discountPrice = [[UILabel alloc] initWithFrame:CGRectMake(name.left, name.bottom, 80, 20)];
            discountPrice.textColor = [UIColor redColor];
            discountPrice.tag = 12;
            [cell.contentView addSubview:discountPrice];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(name.left, discountPrice.bottom, 80, 20)];
            price.tag = 13;
            price.font = [UIFont systemFontOfSize:14];
            price.textColor = [UIColor grayColor];
            [cell.contentView addSubview:price];
            
            MyButton *addBtn = [MyButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 110, discountPrice.top + 5, 30, 30);
            [addBtn setImage:[UIImage imageNamed:@"fruit-05.png"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
            addBtn.tag = 15;
            [cell.contentView addSubview:addBtn];
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(addBtn.right, addBtn.top, 40, 30)];
            numLabel.tag = 14;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.font = [UIFont systemFontOfSize:15];
            numLabel.textColor = [UIColor redColor];
            [cell.contentView addSubview:numLabel];
            
            MyButton *reduceBtn = [MyButton buttonWithType:UIButtonTypeCustom];
            reduceBtn.frame = CGRectMake(numLabel.right, numLabel.top, 30, 30);
            reduceBtn.tag = 16;
            [reduceBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
            [reduceBtn setImage:[UIImage imageNamed:@"fruit-06.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:reduceBtn];
        }
        MyButton *btn1 = (MyButton *)[cell viewWithTag:15];
        MyButton *btn2 = (MyButton *)[cell viewWithTag:16];
        btn1.indexPath = indexPath;
        btn2.indexPath = indexPath;
        
        UIImageView *logo = (UIImageView *)[cell.contentView viewWithTag:10];
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:11];
        UILabel *disPrice = (UILabel *)[cell.contentView viewWithTag:12];
        UILabel *price = (UILabel *)[cell.contentView viewWithTag:13];
        UILabel *num = (UILabel *)[cell.contentView viewWithTag:14];
        
        Info *info = _dataArray[indexPath.row];
        [logo setImageWithURL:[NSURL URLWithString:info.detailImage]];
        name.text = info.name;
        disPrice.text = [NSString stringWithFormat:@"%.2f",[info.discountPrice doubleValue]];
        NSString *str = [NSString stringWithFormat:@"%.2f",[info.price doubleValue]];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:str attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor grayColor]}];
        price.attributedText = string;
        num.text = [NSString stringWithFormat:@"%d",info.foodNum];
        
        return cell;

        
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cate"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cate"];
        }
        
        Info *info = _cateArray[indexPath.row];
        cell.textLabel.text = info.name;
        return cell;
    }
}

- (void)changeNum:(MyButton *)btn
{
    Info *info = _dataArray[btn.indexPath.row];
    NSInteger num = info.foodNum;
    if (btn.tag == 16) {
        //加号
        info.foodNum += 1;
    }else {
        //减号
        if (num <= 0) {
            return;
        }
        info.foodNum -= 1;
    }
    
    [_selectDic setObject:info forKey:info.id];
    __block NSInteger sum = 0;
    __block CGFloat price = 0;
    [_selectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Info *model = (Info *)obj;
        price += ([model.discountPrice doubleValue] * model.foodNum);
        sum += model.foodNum;
    }];

    _numLabel.text = [NSString stringWithFormat:@"%d",sum];
    _priceLabel.text = [NSString stringWithFormat:@"%.2f",price];
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (tableView.tag == 10) {
        _cateTable.hidden = YES;
        Info *info = _cateArray[indexPath.row];
        _currentPage = 1;
        if (_type == [info.catId integerValue]) {
            return;
        }
        _type = [info.catId integerValue];
        [self loadData];
    }
    return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 10) {
        return 44;
    }
    return 100;
}

- (void)buildTopView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, UI_SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10 + 30 * i, 20, 20);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fruit-0%d.png",i + 1]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(connection:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:btn];
    }
    //    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    //    [img setImage:[UIImage imageNamed:@"fruit-01.png"]];
    //    img.contentMode = UIViewContentModeScaleAspectFit;
    //    [view addSubview:img];
    
    _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, UI_SCREEN_WIDTH - 40 - 20, 20)];
    _discountLabel.textColor = [UIColor redColor];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterRoundFloor;
    NSString *string = [nf stringFromNumber:[NSNumber numberWithDouble:_shopInfo.shopDiscount]];
    _discountLabel.text = [NSString stringWithFormat:@"折扣:%@",string];
    [view addSubview:_discountLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, _discountLabel.bottom + 10, _discountLabel.width, 20)];
    _addressLabel.text = [NSString stringWithFormat:@"地址:%@",_shopInfo.address];
    [view addSubview:_addressLabel];
    
    _mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, _addressLabel.bottom + 10, _addressLabel.width - 10 - 50, 20)];
    _mobileLabel.text = [NSString stringWithFormat:@"电话:%@",_shopInfo.mobile];
    [view addSubview:_mobileLabel];
    
    //    _buyCountLable = [[UILabel alloc] initWithFrame:CGRectMake(_mobileLabel.right + 10, _mobileLabel.top, 50, 20)];
    //    _buyCountLable.font = [UIFont systemFontOfSize:13];
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"销量:%@"]];
    //    [view addSubview:_buyCountLable];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom + 15, UI_SCREEN_WIDTH, 40)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    NSArray *array = @[@"最低价格",@"最高销量",@"全部分类"];
    CGFloat width = [array[0] boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width + 5;
    for (NSInteger i = 0; i < 3; i ++) {
//        UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH / 3.0) * i, 0, UI_SCREEN_WIDTH / 3.0, 40)];
//        [view2 addSubview:optionView];
        UIImage *img = [UIImage imageNamed:@"fruit-04.png"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((UI_SCREEN_WIDTH / 3.0) * i, 0, UI_SCREEN_WIDTH / 3.0, 40);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:img forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width, 0, img.size.width)];
        NSLog(@"%f",btn.titleLabel.bounds.size.width);
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, width, 0, -width)];

        btn.tag = i;
        [btn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:btn];
        
        UIView *lineiew = [[UIView alloc] initWithFrame:CGRectMake(btn.right, 5, 0.5, 30)];
        lineiew.backgroundColor = [UIColor grayColor];
        [view2 addSubview:lineiew];
    }
    
    UIView *lineiew = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, UI_SCREEN_WIDTH, 0.5)];
    lineiew.backgroundColor = [UIColor grayColor];
    [view2 addSubview:lineiew];
}

- (void)optionBtnClick:(UIButton *)btn
{
    if (btn.tag == 2) {
        _cateTable.hidden = !_cateTable.hidden;
    }
}

-(void)buildFootView
{
    float CELL_WIDTH = UI_SCREEN_WIDTH/4;
    float CELL_HEIGHT = 60;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 60 - 64, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    [_numLabel setFont:[UIFont systemFontOfSize:15]];
    [_numLabel setTextAlignment:NSTextAlignmentCenter];
    [_numLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [_numLabel setText:@"0"];
    //设置圆角
    _numLabel.layer.borderWidth = 1.0f;
    _numLabel.layer.borderColor = [UIColor redColor].CGColor;
    //label3.layer.cornerRadius = 20.0f;
    _numLabel.layer.cornerRadius = CGRectGetHeight(_numLabel.bounds) / 2;
    _numLabel.clipsToBounds = YES;
    [footView addSubview:_numLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_numLabel.right, 15, 150, 30)];
    _priceLabel.text = @"￥0.00";
    //priceLabel setText:[NSString stringWithFormat:@""]
    [_priceLabel setFont:[UIFont systemFontOfSize:15]];
    //[priceLabel setTextColor:[UIColor colorWithred:0.3 alpha:1]];
    [_priceLabel setTextColor:[UIColor redColor]];
    [footView addSubview:_priceLabel];
    
    //UILabel *disCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right, priceLabel.top, CELL_WIDTH - 10, 30)];
    //disCountLabel.text = @"50.00";
    //[disCountLabel setFont:[UIFont systemFontOfSize:15]];
    //[disCountLabel setTextAlignment:NSTextAlignmentCenter];
    //[disCountLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    //[footView addSubview:disCountLabel];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setFrame:CGRectMake(CELL_WIDTH*3 - 10, 15, CELL_WIDTH, 30)];
    [btn4 setTitle:@"选好了" forState:UIControlStateNormal];
    //[btn4 setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"03_117"] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4.titleLabel setTextAlignment:NSTextAlignmentCenter];
    //[btn4 addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn4 addTarget:self action:@selector(didClickedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn4];
    
}

- (void)didClickedButtonAction:(UIButton *)btn
{
    if ([_numLabel.text isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请添加商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else {
        
        //跳转到订单页面
        WaimaiOrder *order = [[WaimaiOrder alloc] init];
        order.shopName = _shopInfo.name;
        order.navTitle = @"确认订单";
        order.shopId = self.shopId;
        NSMutableArray *arr = [NSMutableArray array];
        
        [_selectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Info *info = obj;
            [arr addObject:info];
        }];
        for (NSInteger i = 0; i < [[_selectDic allKeys] count]; i ++) {
            NSString *key = [[_selectDic allKeys] objectAtIndex:i];
            Info *food = [_selectDic objectForKey:key];
            [arr addObject:food];
        }
        order.productArray = arr;
        order.allPrice = [_priceLabel.text doubleValue];;
        [self.navigationController pushViewController:order animated:YES];
        
    }

}

- (void)updateGUI
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterRoundFloor;
    NSString *string = [nf stringFromNumber:[NSNumber numberWithDouble:_shopInfo.shopDiscount]];
    _discountLabel.text = [NSString stringWithFormat:@"折扣:%@",string];
    
    NSString *address = _shopInfo.address == nil ? @"" : _shopInfo.address;
    _addressLabel.text = [NSString stringWithFormat:@"地址:%@",address];
    NSString *mobile = _shopInfo.mobile == nil ? @"" : _shopInfo.mobile;
    _mobileLabel.text = [NSString stringWithFormat:@"电话:%@",mobile];

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
