//
//  XFShopingCarVC.m
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "XFShopingCarVC.h"
#import "XFProductCell.h"
#import "XFProductBottomCell.h"
#import "XFConfimBooksVC.h"
#import "MyButton.h"
#import "AFNetworking.h"

@interface XFShopingCarVC ()
{
    //UITableView *_tableView;
    NSArray *_titlesArray;
    NSMutableArray*_productsArray;
    NSMutableArray *_shopsArray;
    NSMutableArray *_allProductArray;
    NSMutableDictionary *_numDic;

}
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation XFShopingCarVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
       //[self loadData];
   
    self.view.backgroundColor = [UIColor whiteColor];
   
    //店铺
    _shopsArray = [[NSMutableArray alloc]initWithCapacity:5];
    _allProductArray = [[NSMutableArray alloc]initWithCapacity:5];
    _numDic = [[NSMutableDictionary alloc] init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-20-44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadData];
    
}

- (void)loadData
{
    self.userId = [LLSession sharedSession].user.userId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.userId,@"userId",nil];
    __weak XFShopingCarVC *vC = self;
    [_shopsArray removeAllObjects];
    [_allProductArray removeAllObjects];
    [_numDic removeAllObjects];
    [[tools shared] HUDShowText:@"正在加载..."];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:SelectCar] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        
        if (code == 0){
            NSArray *resultArray = [JSON valueForKey:@"result"];
            if (resultArray != nil) {
                for (NSDictionary *dic in resultArray) {
                    Info *shop = [[Info alloc]init];
                    shop.totalPrice = [[dic objectForKey:@"totalPrice"]stringValue];
                    shop.shopId = [[dic objectForKey:@"shopId"]stringValue];
                    NSDictionary *shopDic = nilOrJSONObjectForKey(dic, @"shop");
                    shop.shopName = nilOrJSONObjectForKey(shopDic, @"name");
                    [_shopsArray addObject:shop];
                    
                    NSArray *itemsArray = dic[@"items"];
                    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:5];

                    NSMutableArray *numArr = [[NSMutableArray alloc]initWithCapacity:5];
                    
                    for (NSDictionary *product in itemsArray) {
                        
                        Info *carInfo = [[Info alloc]init];
                       // NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:1];
                        carInfo.num = [[product valueForKey:@"num"] stringValue];
                        carInfo.shopId = [product objectForKey:@"cartItemId"];
                        carInfo.totalPrice = [[product valueForKey:@"totalDiscountPrice"]stringValue];
                        NSDictionary *productDic = product[@"product"];
                       // carInfo.shopName = nilOrJSONObjectForKey(productDic, @"shopName");
                        carInfo.name = nilOrJSONObjectForKey(productDic, @"name");
                        carInfo.price = [[productDic valueForKey:@"price"] stringValue];
                        carInfo.detailImage = nilOrJSONObjectForKey(productDic, @"detailImage");
                        //每个店铺下对应的商品
                        [array addObject:carInfo];
                        [numArr addObject:carInfo.num];
                    }
                        [_numDic setObject:numArr forKey:[NSString stringWithFormat:@"%d",_shopsArray.count]];
                        [_allProductArray addObject:array];
                }
        }
            [[tools shared] HUDHide];
            [vC.tableView reloadData];
         
        }else{
            [[tools shared] HUDHide];
            [[tools shared] HUDShowHideText:@"获取数据失败！" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
}
#pragma mark-------tableView------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_allProductArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _allProductArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSArray *array = _allProductArray[indexPath.section];
        //商品cell
    static NSString *cellIdentifier = @"cell";
    XFProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XFProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.reduceButton.indexPath = indexPath;
    cell.addButton.indexPath = indexPath;
    cell.submitButton.indexPath = indexPath;
    cell.deleteButton.indexPath = indexPath;
    
    [cell.addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reduceButton addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.submitButton addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    Info *carInfo = array[indexPath.row];
    cell.info = carInfo;
    return cell;
}

#pragma mark - 购物车添加删除操作！！！！

//增加
- (void)addBtnClick:(MyButton *)btn
{
    NSInteger section = btn.indexPath.section;
    NSInteger row = btn.indexPath.row;
    
    NSMutableArray *array = [_numDic objectForKey:[NSString stringWithFormat:@"%d",section + 1]];
    NSInteger num  = [[array objectAtIndex:row] integerValue];
    num += 1;
    XFProductCell *cell = (XFProductCell *)[_tableView cellForRowAtIndexPath:btn.indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",num];
    [array replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d",num]];

}


//减少
- (void)reduceBtnClick:(MyButton *)btn
{
    NSInteger section = btn.indexPath.section;
    NSInteger row = btn.indexPath.row;
    NSMutableArray *array = [_numDic objectForKey:[NSString stringWithFormat:@"%d",section + 1]];
    NSInteger num  = [[array objectAtIndex:row] integerValue];
    if (num != 1) {
        num -= 1;
    }
    XFProductCell *cell = (XFProductCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d",num];
    [array replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%d",num]];
}


//提交
- (void)submitBtnClick:(MyButton *)btn
{
    NSInteger section = btn.indexPath.section;
    NSInteger row = btn.indexPath.row;
    NSMutableArray *array = [_numDic objectForKey:[NSString stringWithFormat:@"%d",section + 1]];
    NSString *num  = [array objectAtIndex:row];
    Info *carInfo = [_allProductArray[section] objectAtIndex:row];
    
    
    if (![num isEqualToString:carInfo.num]) {
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/cart/changeNum?cartItemId=%@&num=%@",carInfo.shopId,num];
        [[tools shared] HUDShowText:@"正在提交..."];

        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *opetation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            if ([[JSON objectForKey:@"code"] integerValue] == 0) {
                //成功
                [[tools shared] HUDHide];
                [self loadData];
            }else {
                [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            [[tools shared] HUDHide];
            HUDShowErrorServerOrNetwork
        }];
        [opetation start];
    }
}

//删除
- (void)deleteBtnClick:(MyButton *)btn
{
    NSInteger section = btn.indexPath.section;
    NSInteger row = btn.indexPath.row;
    Info *carInfo = [_allProductArray[section] objectAtIndex:row];
    
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/cart/changeNum?cartItemId=%@&num=0",carInfo.shopId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *opetation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            //成功
            [[tools shared] HUDHide];
            [self loadData];
        }else {
            [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [opetation start];
}



//结算按钮
- (void)didClickedPayButtonAction:(UIButton *)sender
{
    NSArray *array = _allProductArray[sender.tag];
    Info *shopInfo = _shopsArray[sender.tag];
    XFConfimBooksVC *vc = [[XFConfimBooksVC alloc]init];
    vc.shopId = shopInfo.shopId;
    vc.shopName = shopInfo.shopName;
    vc.productArray = array;
    vc.totalPrice = shopInfo.totalPrice;
    vc.navTitle = @"确认订单";
    //确认订单的数据接口：http://admin.53xsd.com/mobi/cart/doConfirm?userId=1&shopId=1
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadConfimData:(NSString*)shopId
{
    self.userId = [LLSession sharedSession].user.userId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.userId,@"userId",shopId,@"shopId",nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:confimBooks] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        NSLog(@"%@",JSON);
        if (code == 0){
            
            NSArray *resultArray = [JSON valueForKey:@"result"];
            
            // NSLog(@"------%@",resultArray);
            if (resultArray != nil) {
                for (NSDictionary *dic in resultArray) {
                    Info *shop = [[Info alloc]init];
                    shop.totalPrice = [[dic objectForKey:@"totalPrice"]stringValue];
                    shop.shopId = [[dic objectForKey:@"shopId"]stringValue];
                    NSDictionary *shopDic = nilOrJSONObjectForKey(dic, @"shop");
                    shop.shopName = nilOrJSONObjectForKey(shopDic, @"name");
                    [_shopsArray addObject:shop];
                    NSArray *itemsArray = dic[@"items"];
                    Info *carInfo = [[Info alloc]init];
                    for (NSDictionary *product in itemsArray) {
                        carInfo.num = [[product valueForKey:@"num"]stringValue];
                        carInfo.totalPrice = [[product valueForKey:@"totalPrice"]stringValue];
                        NSDictionary *productDic = product[@"product"];
                        carInfo.name = nilOrJSONObjectForKey(productDic, @"name");
                        carInfo.price = [[productDic valueForKey:@"price"] stringValue];
                        carInfo.detailImage = nilOrJSONObjectForKey(productDic, @"detailImage");
                        [_productsArray addObject:carInfo];
                    }
                }
                [_allProductArray addObject:_productsArray];
            }
            [self.tableView reloadData];
    }else{
            [[tools shared] HUDShowHideText:@"获取数据失败！" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)didDelegateButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@" [btn superview] =  %@ ",[[btn superview]class]);
    NSLog(@" [[[btn superview]superview]class] = %@",[[[btn superview]superview]class]);
    //XFProductCell *xfCell = [[[btn superview]superview]class];
    
//    if (btn.tag == 10000+1) {
//    }
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认删除此宝贝!" message:@"是否删除！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    }else
    {
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    Info *shopInfo = _shopsArray[section];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, UI_SCREEN_WIDTH-10, 70)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 40)];
    label.text = @"合计:";
    [view addSubview:label];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 5, 180, 40)];
    moneyLabel.textColor = [UIColor redColor];
    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[shopInfo.totalPrice floatValue]];
    [view addSubview:moneyLabel];
    
    UIButton *deleteBtn = [MyButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(view.right - 100, 5, 80, 40) ;
    deleteBtn.tag = section;
    [deleteBtn setTitle:@"结算" forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_checkorder"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(didClickedPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, deleteBtn.bottom + 5, 320, 20)];
    lineView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    [view addSubview:lineView];
    
    return view;
}

//分区投标题设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Info *shop = _shopsArray[section];
    NSString  *shopName = shop.shopName;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ico_shop"];
    [view addSubview:imageView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 5, 0, 180, 40)];
   // NSString *str = _titlesArray[section];
    nameLabel.text = shopName;
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:nameLabel];
    return view;
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
