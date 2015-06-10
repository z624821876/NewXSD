//
//  WaimaiOrder.m
//  newshop
//
//  Created by 于洲 on 15/3/9.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "WaimaiOrder.h"
#import "AFNetworking.h"
#import "Info.h"
#import "AddAddressVC.h"
#import "XFProductCell.h"
#import "ChoiceaAddressVC.h"
#import "PayTypeNew.h"
#import "IQKeyboardManager.h"

@interface WaimaiOrder ()
{
    UITableView *_tableView;
    
    NSMutableArray *_productsArray;
    // NSString *_shopName;
    
    UILabel  *_receiveName;
    UILabel *_receiveAddress;
    UILabel *_receiveNumber;
    UILabel *userMessageLabel;
    
    NSMutableArray *_addressAdrray;
    UIScrollView *_bgScroll;
    UILabel     *_addLabel;
    UIView *_bgView;
    //    Info    *currentAdd;
    UITextField   *ktextField;
    UILabel *topNameLabel;
    BOOL        isLoadAddress;
}

@end

@implementation WaimaiOrder
- (void)viewDidLoad {
    [super viewDidLoad];
    isLoadAddress = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    _myProductsArray = [[NSMutableArray alloc] init];
    _addressAdrray = [[NSMutableArray alloc]initWithCapacity:5];
    
        _bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height - 50 - 64)];
        _bgScroll.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        [self.view addSubview:_bgScroll];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 60)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
        [_bgScroll addSubview:_bgView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 25)];
        imageView.image = [UIImage imageNamed:@"ico_shop"];
        [_bgView addSubview:imageView];
    
        topNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+2, imageView.top, 200, 30)];
        topNameLabel.text = self.shopName;
    
        [_bgView addSubview:topNameLabel];
        UIImageView *contactView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.right - 130, topNameLabel.top, 30, 30)];
        contactView.image =[UIImage imageNamed:@"ico_ctc"];
        [_bgView addSubview:contactView];
        UILabel *contacrLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bgView.right - 100, topNameLabel.top, 90, 30)];
        contacrLabel.text = @"联系卖家";
        [_bgView addSubview:contacrLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, contacrLabel.bottom, _bgView.width - 20, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [_bgView addSubview:lineView];
        
        [self loadData];
        
    }

- (void)viewDidAppear:(BOOL)animated
{
    
    [self loadAddress];
}

- (void)viewDidDisappear:(BOOL)animated
{
    _currentAdd = nil;
}

- (void)updateUI
{
    for (NSInteger i = 0; i < [_myProductsArray count]; i ++) {
        
        Info *carInfo = [_myProductsArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 40 + (85 * i), 310, 85)];
        [_bgView addSubview:view];
        
        UIImageView *pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 65)];
        [view addSubview:pictureView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(pictureView.right + 5, 10, 150, 40)];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [view addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right , 10, 100, 40)];
        priceLabel.font = [UIFont systemFontOfSize:12];
        
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.textColor = [UIColor redColor];
        [view addSubview:priceLabel];
        
//        UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        reduceButton.frame = CGRectMake(nameLabel.left + 10, nameLabel.bottom + 5, 20, 20);
//        [reduceButton setBackgroundImage:[UIImage imageNamed:@"btn_rdc"]forState:UIControlStateNormal];
//        [view addSubview:reduceButton];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+5, 100, 20)];
        // _numberLabel.text = @"1";
        [view addSubview:numberLabel];
        
//        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        addBtn.frame = CGRectMake(numberLabel.right,numberLabel.top, 20, 20);
//        [addBtn setBackgroundImage:[UIImage imageNamed:@"btn_plus"] forState:UIControlStateNormal];
//        [view addSubview:addBtn];
        
        nameLabel.text = carInfo.name;
        //info.totalPrice
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[carInfo.totalPrice doubleValue]];
        
        [pictureView setImageWithURL:[NSURL URLWithString:carInfo.detailImage]];
        numberLabel.text = carInfo.num;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, pictureView.bottom + 10, view.width - 20, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [view addSubview:lineView];
        
    }
    
    CGFloat bottom = 45 + ([_myProductsArray count] * 85);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, bottom, 100, 30)];
    label.text = @"配送方式";
    [_bgView addSubview:label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(_bgView.right - 120,bottom, 115, 30)];
    label2.text = [NSString stringWithFormat:@"快递%.2f元",[self.price doubleValue]];
    [_bgView addSubview:label2];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, label2.bottom + 10, _bgView.width - 20, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [_bgView addSubview:lineView];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, lineView.bottom + 5, 80, 30)];
    label3.text = @"收货地点";
    [_bgView addSubview:label3];
    
    UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(_bgView.right - 60,lineView.bottom + 5, 25, 25)];
    [imageView setBackgroundImage:[UIImage imageNamed:@"ico_ps"] forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:imageView];
    
    _addLabel = [[UILabel alloc] initWithFrame:CGRectMake(label3.right - 5, lineView.bottom + 5, _bgView.right - 60 - 85, 30)];
    _addLabel.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:_addLabel];
    
    _bgView.frame = CGRectMake(5, 5, 310, _addLabel.bottom + 10);
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(5, _bgView.bottom + 5, 310, 50)];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    bgView2.layer.cornerRadius = 10;
    bgView2.layer.masksToBounds = YES;
    [_bgScroll addSubview:bgView2];
    
    ktextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 10, bgView2.width - 10, 30)];
    //此处要设置成全局的    要上传到服务器
    ktextField.placeholder = @"给商家留言，如 再带包香烟";
    ktextField.textAlignment = NSTextAlignmentLeft;
    [ktextField setDelegate:self];
    [bgView2 addSubview:ktextField];
    
    [_bgScroll setContentSize:CGSizeMake(320, bgView2.bottom + 30)];
}

//加载数据  shopId 和UserId 拼接接口
- (void)loadData
{
    NSMutableArray *foodListArray = [NSMutableArray array];
    for (Info *food in _productArray) {
        NSString *str = [NSString stringWithFormat:@"%@:%d",food.id,food.foodNum];
        [foodListArray addObject:str];
    }
    
    NSString *foodListStr = [foodListArray componentsJoinedByString:@","];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/cart/foodConfirm?userId=%@&foodList=%@",[LLSession sharedSession].user.userId,foodListStr];
    NSLog(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//        从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            
            NSDictionary *dic = [[JSON objectForKey:@"result"] firstObject];
            
            NSArray *itemArr = [dic objectForKey:@"items"];
            NSDictionary *shopDic = [dic objectForKey:@"shop"];
            
            self.shopName = [shopDic objectForKey:@"name"];
            topNameLabel.text = self.shopName;
            self.totalPrice = [[dic objectForKey:@"totalPrice"] stringValue];
            self.price = [[shopDic objectForKey:@"postFee"] stringValue];
            [self buildFootView];//此处添加下方view
            
            for (NSDictionary *product in itemArr) {
                
                Info *carInfo = [[Info alloc]init];
                carInfo.num = [[product valueForKey:@"num"]stringValue];
                carInfo.totalPrice = [[product valueForKey:@"totalDiscountPrice"]stringValue];
                NSDictionary *productDic = product[@"product"];
                
                carInfo.name = nilOrJSONObjectForKey(productDic, @"name");
                carInfo.price = [[productDic valueForKey:@"price"] stringValue];
                carInfo.detailImage = nilOrJSONObjectForKey(productDic, @"detailImage");
                [_myProductsArray addObject:carInfo];
            }
            [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
            [self loadAddress];//加载地址
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
//        [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];

    }];
    
    [operation1 start];
}

-(void)buildFootView
{
    //float CELL_WIDTH = UI_SCREEN_WIDTH;
    float CELL_HEIGHT = 50;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-50, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:line];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 50, 30)];
    label1.text = @"合计：";
    label1.font = [UIFont systemFontOfSize:14];
    [footView addSubview:label1];
    
    UILabel *allMoney = [[UILabel alloc]initWithFrame:CGRectMake(label1.right + 4, 15, 120, 30)];
    allMoney.textColor = [UIColor redColor];
    [allMoney setText:[NSString stringWithFormat:@"￥%.2f",[self.totalPrice doubleValue] + [self.price doubleValue]]];
    [footView addSubview:allMoney];
    
    UIButton *putInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [putInButton setFrame:CGRectMake(self.view.right-75, 15, 65, 30)];
    [putInButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
    [putInButton setTitle:@"提交订单" forState:UIControlStateNormal];
    
    putInButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [putInButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [putInButton addTarget:self action:@selector(putInBook) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:putInButton];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(putInButton.left - 75, 15, 65, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
    [backBtn setTitle:@"继续点单" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:backBtn];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提交订单
- (void)putInBook{
    
    if (_currentAdd.id == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"地址为加载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else {
    
    NSString *userId = [LLSession sharedSession].user.userId;
    NSString *urlStr = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/cart/doPayNow?userId=%@&addrId=%@&memo=%@&shopId=%@",userId,_currentAdd.id,ktextField.text,self.shopId];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //        从URL获取json数据
        [[tools shared] HUDShowText:@"正在提交..."];
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
                NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
                NSString *message = nilOrJSONObjectForKey(JSON, @"message");
                if (code == 0){
                    NSDictionary *result = [JSON valueForKey:@"result"];
                    if (result != nil && [message isEqualToString:@"操作成功!"]) {
                        Info *books = [[Info alloc]init];
                        books.createTime = nilOrJSONObjectForKey(result, @"createTime");
                        books.orderNo = [result objectForKey:@"orderNo"];
                        books.status = [result objectForKey:@"status"];
                        //NSLog(@"订单提交后返回数据books.createTime=%@,books.orderNo=%@%@",books.createTime,books.orderNo, books.status);
                        [[tools shared]HUDShowHideText:@"订单提交成功，马上去付款！" delay:1];
                        PayTypeNew *typeVC = [[PayTypeNew alloc]init];
                        typeVC.navTitle = @"支付方式";
                        typeVC.totalPrice = [NSString stringWithFormat:@"%f",[self.totalPrice doubleValue] + [self.price doubleValue]];
                        typeVC.orderId=[result objectForKey:@"id"];
                        typeVC.subject=@"需要接口确认商品标题";
                        typeVC.body=@"需要接口确认商品描述";
                        [[tools shared] HUDHide];
                        [self.navigationController pushViewController:typeVC animated:YES];
                    }else{
                        [[tools shared] HUDHide];

                        [[tools shared] HUDShowHideText:message delay:1];
                    }
                }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [operation1 start];
    }
//    }
//    //提交订单
//    NSMutableDictionary *params;
//    NSString *url ;
//    if (self.buyNow == YES) {
//        //color是从后台读取的数据   此时暂定为1
//        //[params removeAllObjects];
//        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                  [LLSession sharedSession].user.id,@"userId",
//                  self.shopId,@"shopId"
//                  ,@"1",@"addrId",self.memo,@"memo",nil];
//        url = [tools getServiceUrl:buyNowGoPay];
//        // NSLog(@"立即购买提交生成订单++++%@",[tools getServiceUrl:buyNowGoPay]);
//    }else{
//        
//        self.bookStates = @"0";//订单状态（integer类型） 此时提交的是未付款的 到付款订单界面
//        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                  userId,@"userId",
//                  self.shopId,@"shopId"
//                  ,self.addressId,@"addrId",self.bookStates,@"status",self.memo,@"memo",self.totalPrice,@"totalFee",nil];
//        url = [tools getServiceUrl:jsonCreateBooks] ;
//        //NSLog(@"购物车提交生成订单++++%@",[tools getServiceUrl:jsonCreateBooks]);
//    }
//    
//    [[RestClient sharedClient] postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
//        NSString *message = nilOrJSONObjectForKey(JSON, @"message");
//        if (code == 0){
//            NSDictionary *result = [JSON valueForKey:@"result"];
//            if (result != nil && [message isEqualToString:@"操作成功!"]) {
//                Info *books = [[Info alloc]init];
//                books.createTime = nilOrJSONObjectForKey(result, @"createTime");
//                books.orderNo = [result objectForKey:@"orderNo"];
//                books.status = [result objectForKey:@"status"];
//                //NSLog(@"订单提交后返回数据books.createTime=%@,books.orderNo=%@%@",books.createTime,books.orderNo, books.status);
//                [[tools shared]HUDShowHideText:@"订单提交成功，马上去付款！" delay:1];
//                PayTypeNew *typeVC = [[PayTypeNew alloc]init];
//                typeVC.navTitle = @"支付方式";
//                typeVC.totalPrice = self.totalPrice;
//                typeVC.orderId=[result objectForKey:@"orderNo"];
//                typeVC.subject=@"需要接口确认商品标题";
//                typeVC.body=@"需要接口确认商品描述";
//                [self.navigationController pushViewController:typeVC animated:YES];
//            }else{
//                [[tools shared] HUDShowHideText:message delay:1];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        HUDShowErrorServerOrNetwork
//    }];
}


- (void)btnClick
{
    ChoiceaAddressVC *choiceVC = [[ChoiceaAddressVC alloc]init];
    choiceVC.navTitle =@"收货地址管理";
    [self.navigationController pushViewController:choiceVC animated:YES];
    
}

- (void)loadAddress
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].user.userId,@"memberId",nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:seleceAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        //返回值{"ok":true,"code":0,"message":"操作成功!","result":1}
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        NSLog(@"-------------------%@",JSON);
        
        if (code == 0) {
            NSArray *resultArray = nilOrJSONObjectForKey(JSON, @"result");
            if (resultArray.count !=0) {
                [_addressAdrray removeAllObjects];
                for (NSDictionary *address in resultArray) {
                    Info *info = [[Info alloc]init];
                    info.address = nilOrJSONObjectForKey(address, @"address");
                    info.id = [[address objectForKey:@"id"]stringValue];
                    info.mobile = nilOrJSONObjectForKey(address, @"mobile");
                    info.name = nilOrJSONObjectForKey(address, @"name");
                    info.id = [[address objectForKey:@"id"]stringValue];
                    info.isDeleted =[[address objectForKey:@"isDelete"]stringValue];
                    if ([info.isDeleted isEqualToString:@"1"]) {
                        // NSLog(@"info.address ==%@",info.address);
                        [_addressAdrray addObject:info];
                    }else if ([info.isDeleted isEqualToString:@"2"]) {
                        _currentAdd = info;
                    }
                }
                if (_currentAdd.address.length > 0) {
                    _addLabel.text = _currentAdd.address;
                }else {
                    Info *shop = [_addressAdrray objectAtIndex:0];
                    _currentAdd = shop;
                    _addLabel.text = shop.address;
                }
            }else{
                if (isLoadAddress) {
                    [[tools shared]HUDShowHideText:@"您还未添加地址，马上添加" delay:0.5];//跳转到添加地址界面
                    AddAddressVC *addVC = [[AddAddressVC alloc]init];
                    addVC.navTitle = @"添加地址";
                    [self.navigationController pushViewController:addVC animated:YES];
                }
            }
        }else
        {
            [[tools shared]HUDShowHideText:@"获取数据失败" delay:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

#pragma mark  TableView----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        //        if (self.productArray == nil) {
        //            return 1;
        //        }else{
        //            return self.productArray.count;}
        return _myProductsArray.count;
    }else if (section == 2){
        return [_addressAdrray count] + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cell0 = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell0];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH - 10, 40)];
        view.image = [UIImage imageNamed:@"02_02_03"];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 25)];
        //imageView.backgroundColor = [UIColor yellowColor];
        imageView.image = [UIImage imageNamed:@"ico_shop"];
        [view addSubview:imageView];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+2, imageView.top, 200, 30)];
        nameLabel.text = self.shopName;
        [view addSubview:nameLabel];
        UIImageView *contactView = [[UIImageView alloc]initWithFrame:CGRectMake(view.right - 130, nameLabel.top, 30, 30)];
        contactView.image =[UIImage imageNamed:@"ico_ctc"];
        [view addSubview:contactView];
        UILabel *contacrLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.right - 100, nameLabel.top, 90, 30)];
        contacrLabel.text = @"联系卖家";
        [view addSubview:contacrLabel];
        [cell.contentView addSubview:view];
        return cell;
    }else if (indexPath.section == 1){
        
        static NSString *cellIdentifier = @"cell";
        XFProductCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell1) {
            cell1 = [[XFProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        Info *info = _myProductsArray[indexPath.row];
        cell1.info = info;
        [cell1.deleteButton removeFromSuperview];
        return cell1;
    }
    else if (indexPath.section == 2){
        static NSString *cell2 = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
        }
        if (indexPath.row == 0) {
            UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, UI_SCREEN_WIDTH - 10, 40)];
            view1.image = [UIImage imageNamed:@"02_02_05"];
            [cell.contentView addSubview:view1];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
            label.text = @"配送方式";
            [view1 addSubview:label];
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(view1.right - 120, 5, 115, 30)];
            label2.text = @"快递10.00元";
            [view1 addSubview:label2];
            return cell;
        }
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, UI_SCREEN_WIDTH - 10, 145)];
        view1.image = [UIImage imageNamed:@"02_02_07"];
        view1.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view1];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
        label.text = @"收货地点";
        [view1 addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view1.right - 60, 5, 25, 25)];
        imageView.image = [UIImage imageNamed:@"ico_ps"];
        [view1 addSubview:imageView];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(5, label.bottom, UI_SCREEN_WIDTH-10, 0.5)];
        line1.backgroundColor = [UIColor blackColor];
        [view1 addSubview:line1];
        _receiveName = [[UILabel alloc]initWithFrame:CGRectMake(5, label.bottom +2, 100, 30)];
        _receiveName.textAlignment = NSTextAlignmentLeft;
        [_receiveName setText:@""];
        [view1 addSubview:_receiveName];
        
        _receiveNumber = [[UILabel alloc]initWithFrame:CGRectMake(view1.right - 140, label.bottom + 2, 120, 30)];
        [_receiveNumber setText:@""];
        _receiveNumber.textAlignment = NSTextAlignmentRight;
        // _receiveNumber.backgroundColor = [UIColor redColor];
        [view1 addSubview:_receiveNumber];
        
        _receiveAddress = [[UILabel alloc]initWithFrame:CGRectMake(5, _receiveName.bottom+10,_receiveNumber.right,65)];
        
        _receiveAddress.textAlignment = NSTextAlignmentLeft;
        _receiveAddress.numberOfLines = 2;
        [view1 addSubview:_receiveAddress];
        
        
        Info *address = _addressAdrray[indexPath.row-1];
        [_receiveAddress setText:address.address];
        [_receiveNumber setText:address.mobile];
        [_receiveName setText:address.name];
        self.addressId = address.id;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    static NSString *cellIdentifier3 = @"cell3";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
    }
    UITextField *view = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH - 10, 80)];
    //此处要设置成全局的    要上传到服务器
    view.placeholder = @"给卖家留言";
    view.borderStyle = UITextBorderStyleRoundedRect;
    view.textAlignment = NSTextAlignmentLeft;
    [view setDelegate:self];
    //    UITextView *memoView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH - 10, 80)];
    //    memoView.delegate = self;
    //    memoView.returnKeyType = UIReturnKeyDefault;
    //    memoView.keyboardType = UIKeyboardTypeDefault;
    //    memoView.scrollEnabled = YES;//是否可以拖动
    //    memoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [cell.contentView addSubview:view];
    return cell;
    
}

//键盘弹出时改变视图的frame
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [_bgScroll setContentOffset:CGPointMake(0, _bgView.bottom - 30)];
    return YES;
}
//回复原始位置的方法
- (void)resumeView
{
//    [_bgScroll setContentOffset:CGPointMake(0, 200)];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    self.memo = textField.text;
//    [self resumeView];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end