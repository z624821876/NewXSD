//
//  WaimaiVC.m
//  newshop
//
//  Created by sunday on 15/2/4.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "WaimaiVC.h"
#import "FoodConfirmVC.h"
#import "XFConfimBooksVC.h"
#import "WaimaiOrder.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "ConfirmOrderVC.h"

@interface WaimaiVC ()
{
    UITableView *_cateTableView;
    NSMutableArray *_cateArray;
    NSMutableArray *_foodArray;
    NSMutableArray *_selectedFoodArray;
    NSString *_curCateId;
    UILabel *label3;//即为footview上的钱数
    UILabel *priceLabel;
    int currIndex;
    int foodCount;
    double totalPrice;
    UILabel *nameLabel;
    UILabel *oneFoodPriceLabel ;
    NSMutableArray *productsArray;
    UIView *_upView;//点击图片弹出
    
    NSInteger       currentShopNum;
    CGFloat         currentShopPirce;
}

@property (nonatomic,strong) UIScrollView *customScroll;
@property (nonatomic,strong) NSMutableDictionary *orderDic;
@property (nonatomic,assign) NSInteger currentScrolPage;


@end
#define LEFT_BG_COLOR [UIColor colorWithWhite:0.961 alpha:1.000]
#define CATE_CELL_HEIGHT 42.0
#define SHOP_CELL_HEIGHT 90.0//75
#define TABLE_HEIGHT UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT
@implementation WaimaiVC
static NSInteger __currentPage;

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self buildCateTable];
//    [self buildShopTable];
    __currentPage = 1;
    currentShopNum = 0;
    currentShopPirce = 0;
    
    //_cateArray = @[@"明星菜品",@"新菜推荐",@"双人套餐",@"单人套餐"@"面食",@"牛排",@"小食",@"甜品",@"饮料"];
    _cateArray = [[NSMutableArray alloc]initWithCapacity:5];
    _foodArray = [[NSMutableArray alloc]initWithCapacity:5];
    _selectedFoodArray= [[NSMutableArray alloc]initWithCapacity:5];
    _orderDic = [[NSMutableDictionary alloc] init];
    productsArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    [self buildCateTable];
    [self buildShopTable];
    [self loadCate];
    
    [self buildFootView];
    
}

-(void)buildCateTable
{
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, UI_SCREEN_HEIGHT)];
    [leftView setBackgroundColor:LEFT_BG_COLOR];
    [self.view addSubview:leftView];
    _cateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, leftView.width, CATE_CELL_HEIGHT*5)];
    [_cateTableView setBackgroundColor:LEFT_BG_COLOR];
    _cateTableView.delegate = self;
    _cateTableView.dataSource = self;
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cateTableView.showsVerticalScrollIndicator = NO;
    [leftView addSubview:_cateTableView];
}

-(void)buildShopTable
{
    self.tableView.frame = CGRectMake(_cateTableView.right, 0, 240, self.view.frame.size.height - 50 - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.height = TABLE_HEIGHT;
    
}

-(void)loadCate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.shopId,@"shopId",
                                   nil];

    [[RestClient sharedClient] postPath:[tools getServiceUrl:getShopProductCategory] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
        NSLog(@"--------------%@",JSON);
        if (code == 0){
            //得到数据
            [_cateArray removeAllObjects];
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            if ([tmpResultArray count] > 0) {
            
            for (NSDictionary *dict in tmpResultArray) {
                Info *cate = [[Info alloc] init];
                cate.id = nilOrJSONObjectForKey(dict, @"id");
                cate.name = nilOrJSONObjectForKey(dict, @"name");
               // cate.image = nilOrJSONObjectForKey(dict, @"image");
                [_cateArray addObject:cate];
            }
            _cateTableView.height = (_cateArray.count+1) * CATE_CELL_HEIGHT > TABLE_HEIGHT ? (_cateArray.count+1) * CATE_CELL_HEIGHT : TABLE_HEIGHT;
            [_cateTableView reloadData];
            [self.tableView launchRefreshing]; //店铺
            }
        }else{
            [[tools shared] HUDShowHideText:@"读取分类失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
//PullingRefreshTableView delegate方法（重写，覆盖load方法）
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadShop) withObject:nil afterDelay:0];
}
//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self.tableView tableViewDidFinishedLoading];
}

-(void)loadShop
{
    if ([_cateArray count] <= 0) {
        [self.tableView tableViewDidFinishedLoading];
        return;
    }
    
    self.refreshing ? self.page=0 : self.page++;
    
    NSLog(@"-(void)loadShop   店铺ID= %@",_curCateId);
    if(_curCateId==nil)
    {
        Info *info=[_cateArray objectAtIndex:0];
        _curCateId = [NSString stringWithFormat:@"%@",info.id];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _curCateId,@"catId",[NSNumber numberWithInteger:__currentPage],@"pageIndex",
                                   nil];
    
    [[RestClient sharedClient] postPath:[tools getServiceUrl:selectByCategory] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
       // NSLog(@"======%@",JSON);
        if (code == 0){
            //得到数据
            [_foodArray removeAllObjects];
            
            //NSArray *tmpResultArray = [[JSON valueForKey:@"result"] valueForKey:@"result"];
            NSArray *tmpResultArray = [JSON objectForKey:@"result"];
           for (NSDictionary *dict in tmpResultArray) {
               // Info *shop = [[Info alloc] init];
                Info *food = [[Info alloc]init];
                food.shopId = nilOrJSONObjectForKey(dict, @"shopId");
                food.id = nilOrJSONObjectForKey(dict, @"id");
                food.name = nilOrJSONObjectForKey(dict, @"name");
                food.detailImage = nilOrJSONObjectForKey(dict, @"detailImage");
              // food.discountPrice = nilOrJSONObjectForKey(dict, @"discountPrice");
               food.discountPrice = [[dict objectForKey:@"discountPrice"]stringValue];
               food.price = [[dict objectForKey:@"price"]stringValue];
                food.address = nilOrJSONObjectForKey(dict, @"address");
                //food.price = nilOrJSONObjectForKey(dict, @"price");
//                shop.mobile = nilOrJSONObjectForKey(dict, @"mobile");
//                shop.latitude = nilOrJSONObjectForKey(dict, @"latitude");
               // shop.longitude = nilOrJSONObjectForKey(dict, @"longitude");
                [_foodArray addObject:food];
                NSLog(@"_foodArray------%@",_foodArray);
                // [self.tableView reloadData];
            }
           
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView reloadData];


        }else{
            [[tools shared] HUDShowHideText:@"读取店铺失败" delay:1];
            [self.tableView tableViewDidFinishedLoading];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
        [self.tableView tableViewDidFinishedLoading];
    }];
}

-(void)buildFootView
{
    float CELL_WIDTH = UI_SCREEN_WIDTH/4;
    float CELL_HEIGHT = 50;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-40, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footView];
        
   label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [label3 setFont:[UIFont systemFontOfSize:15]];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label3 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [label3 setText:@"0"];
    //设置圆角
    label3.layer.borderWidth = 1.0f;
    label3.layer.borderColor = [UIColor redColor].CGColor;
    //label3.layer.cornerRadius = 20.0f;
    label3.layer.cornerRadius = CGRectGetHeight(label3.bounds) / 2;
    label3.clipsToBounds = YES;
    [footView addSubview:label3];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(label3.right, 5,150, 30)];
    priceLabel.text = @"￥0.00";
    //priceLabel setText:[NSString stringWithFormat:@""]
    [priceLabel setFont:[UIFont systemFontOfSize:15]];
    //[priceLabel setTextColor:[UIColor colorWithred:0.3 alpha:1]];
    [priceLabel setTextColor:[UIColor redColor]];
    [footView addSubview:priceLabel];
    
    //UILabel *disCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right, priceLabel.top, CELL_WIDTH - 10, 30)];
    //disCountLabel.text = @"50.00";
    //[disCountLabel setFont:[UIFont systemFontOfSize:15]];
    //[disCountLabel setTextAlignment:NSTextAlignmentCenter];
    //[disCountLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    //[footView addSubview:disCountLabel];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setFrame:CGRectMake(CELL_WIDTH*3, 5, CELL_WIDTH, 30)];
    [btn4 setTitle:@"选好了" forState:UIControlStateNormal];
    //[btn4 setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"03_117"] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4.titleLabel setTextAlignment:NSTextAlignmentCenter];
    //[btn4 addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn4 addTarget:self action:@selector(didClickedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn4];
    
}

- (void)didAddItemButtonAction:(id)sender
{
    Info *food =[_foodArray objectAtIndex:currIndex];
    Boolean isExist=false;
    for (Info *foodT in _selectedFoodArray) {
        
        if([foodT.name isEqualToString:food.name ]){
            int num=[foodT.num intValue];
            if(foodT.num==nil){
                num=1;
            }
            foodT.num =[NSString stringWithFormat:@"%d",num+1];
            isExist=true;
            break;
        }
    }
    
    if(!isExist){
        [_selectedFoodArray addObject:food];
    }
    totalPrice=totalPrice+[food.discountPrice integerValue];
    foodCount=foodCount+1;
    [label3 setText:[NSString stringWithFormat:@"%d",foodCount]];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",totalPrice]];
}

#pragma mark - 提交选中的外卖
- (void)didClickedButtonAction:(id)sender
{
    if ([LLSession sharedSession].user.userId == nil) {

        currentShopNum = 0;
        currentShopPirce = 0;
        label3.text = @"0";
        priceLabel.text = @"￥0.00";
        [_orderDic removeAllObjects];
        [self.tableView reloadData];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
        
    }else{
            //判断是点餐还是外卖
        if (self.type == 1) {
            NSLog(@"点餐");
            if ([label3.text isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请添加商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }else {
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger i = 0; i < [[_orderDic allKeys] count]; i ++) {
                    NSString *key = [[_orderDic allKeys] objectAtIndex:i];
                    Info *food = [_orderDic objectForKey:key];
                    [arr addObject:food];
                }
                
                ConfirmOrderVC *vc = [[ConfirmOrderVC alloc] init];
                vc.orderArr = arr;
                vc.shopId = self.shopId;
                vc.shopName = self.shopName;
                vc.shopNum = [NSString stringWithFormat:@"%d",currentShopNum];
                vc.totalFee = priceLabel.text;
                [self.navigationController pushViewController:vc animated:YES];
                
//                NSMutableArray *array = [NSMutableArray array];
//                for (Info *food in arr) {
//                    NSString *str = [NSString stringWithFormat:@"%@:%d份",food.name,food.foodNum];
//                    [array addObject:str];
//                }
//                NSString *str = [array componentsJoinedByString:@","];
//
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否要点餐：%@",str] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.tag = 10010;
//                [alert show];
                
            }
            
        }else {

            
            if ([label3.text isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请添加商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }else {
                
                //跳转到订单页面
                WaimaiOrder *order = [[WaimaiOrder alloc] init];
                order.shopName = self.shopName;
                order.navTitle = @"确认订单";
                order.shopId = self.shopId;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger i = 0; i < [[_orderDic allKeys] count]; i ++) {
                    NSString *key = [[_orderDic allKeys] objectAtIndex:i];
                    Info *food = [_orderDic objectForKey:key];
                    [arr addObject:food];
                }
                
                order.productArray = arr;
                order.allPrice = currentShopPirce;
                [self.navigationController pushViewController:order animated:YES];

            }
//            currentShopNum = 0;
//            currentShopPirce = 0;
//            label3.text = @"0";
//            priceLabel.text = @"￥0.00";
//            [_orderDic removeAllObjects];
            [self.tableView reloadData];

        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10010) {
        if (buttonIndex == 1) {
            [self diancan];
        }
    }
    if (alertView.tag == 624821) {
        if (buttonIndex == 1) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate login];
        }
        
    }
    
}

- (void)diancan
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [[_orderDic allKeys] count]; i ++) {
        NSNumber *num = [[_orderDic allKeys] objectAtIndex:i];
        Info *food = [_foodArray objectAtIndex:[num integerValue]];
        food.foodNum = [[_orderDic objectForKey:num] integerValue];
        [arr addObject:food];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (Info *food in arr) {
        NSString *str = [NSString stringWithFormat:@"%@:%d",food.id,food.foodNum];
        [array addObject:str];
    }
    
    NSString *str = [array componentsJoinedByString:@","];
    
    
    NSString *urlStr=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/cart/ordering?foodList=%@&userId=%@",str,[LLSession sharedSession].user.userId];
    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"点餐成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"点餐不成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [[tools shared] HUDShowHideText:@"网络错误！" delay:1.5];
        
    }];
    [operation1 start];
    
    currentShopNum = 0;
    currentShopPirce = 0;
    label3.text = @"0";
    priceLabel.text = @"￥0.00";
    [_orderDic removeAllObjects];
    [self.tableView reloadData];
    
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _cateTableView) {
         return _cateArray.count;

    }else{
        return _foodArray.count;
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
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 18, 18)];
//        [cell.contentView addSubview:imgView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, tableView.width - 10, 20)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
       // [label setTextColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1]];
        [cell.contentView addSubview:label];
        [cell setBackgroundColor:LEFT_BG_COLOR];
        
        //选中时的背景色
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [selectBgView setBackgroundColor:[UIColor whiteColor]];
        cell.selectedBackgroundView = selectBgView;
        
        
//        if (indexPath.row == 0) {
//            [imgView setImage:[UIImage imageNamed:@"cate_all.png"]];
//            [label setText:@"  全  部"];
//        }else{
            Info *cate = [_cateArray objectAtIndex:indexPath.row];
        NSLog(@"Info *cateid====%@",cate.id);
           // [imgView setImageWithURL: [NSURL URLWithString:cate.image] placeholderImage:nil];
            [label setText:cate.name];
       // }
        return cell;
        
    }else{
        static NSString *shopIdentifier = @"shopCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopIdentifier];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 80, 80)];
            imgView.tag = 100;
            [cell.contentView addSubview:imgView];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10, imgView.top, tableView.width - imgView.right - 20, 40)];
            label1.tag = 101;
            label1.numberOfLines = 2;
            [label1 setFont:[UIFont systemFontOfSize:14]];
            [label1 setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
            [cell.contentView addSubview:label1];
            
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.bottom, 60, 20)];
            label2.tag = 102;
            [label2 setFont:[UIFont systemFontOfSize:13]];
            label2.textColor = [UIColor redColor];
            [cell.contentView addSubview:label2];
            
            UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label2.bottom, 60, 20)];
            priceLable.tag = 11111;
            priceLable.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:priceLable];
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(label2.right + 50 - 5, label1.bottom, 30, 30);
            [cell.contentView addSubview:rightBtn];
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
            rightBtn.tag = 100000;
            //添加cell上button点击事件
            [rightBtn addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.frame = CGRectMake(rightBtn.right - 60 - 30, label1.bottom, 30, 30);
            leftButton.tag = 99;
            [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_rdc.png"] forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
            leftButton.alpha = 0;
            [cell.contentView addSubview:leftButton];
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftButton.right, label1.bottom, 30, 30)];
            [numLabel setFont:[UIFont systemFontOfSize:14]];
            [numLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
            numLabel.tag = 10010;
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.text = @"99";
            numLabel.alpha = 0;
            [cell.contentView addSubview:numLabel];
        }
        
        
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:102];
        UILabel *priceLable = (UILabel *)[cell.contentView viewWithTag:11111];
        
        
        Info *shop = [_foodArray objectAtIndex:indexPath.row];
        [imgView setImageWithURL: [NSURL URLWithString:shop.detailImage] placeholderImage:nil];
        [label1 setText:shop.name];
        [label2 setText:shop.discountPrice];
        [label2 setText:[NSString stringWithFormat:@"%@￥",shop.discountPrice]];
        
        NSAttributedString *priceString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@￥",shop.price] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
        priceLable.attributedText = priceString;
        
        
        UIButton *rightBtn = (UIButton *)[cell.contentView viewWithTag:100000];
        [rightBtn setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];

        UILabel *numLabel = (UILabel *)[cell.contentView viewWithTag:10010];
        UIButton *leftBnt = (UIButton *)[cell.contentView viewWithTag:99];
        [leftBnt setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
        
#pragma mark - 增加判断  避免重用
        NSString *key = [NSString stringWithFormat:@"%@",shop.id];
        Info *shop2 = nilOrJSONObjectForKey(_orderDic, key);
            if (shop2.foodNum == 0 || shop2 == nil) {
                //没有点菜
                numLabel.alpha = 0;
                leftBnt.alpha = 0;
            }else {
                //点有菜
                numLabel.alpha = 1;
                leftBnt.alpha = 1;
                numLabel.text = [NSString stringWithFormat:@"%d",shop2.foodNum];
            }
        
        return cell;
        
//        else{
//            while ([cell.contentView.subviews lastObject] != nil) {
//                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//            }
//        }

        //UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 5, 65, 65)];
 }
}
#pragma mark - 添加菜
- (void)del:(UIButton *)button
{
    NSInteger index;
    if (button.tag == 20086) {
        
        index = _currentScrolPage;

    }else {
        //左边按钮
        index = [button.currentTitle integerValue];
    }

    Info *shop = [_foodArray objectAtIndex:index];
    NSString *key = [NSString stringWithFormat:@"%@",shop.id];
    Info *shop2 = nilOrJSONObjectForKey(_orderDic, key);
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    UILabel *numLabel = (UILabel *)[cell.contentView viewWithTag:10010];
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:99];

    if (button.tag > 100) {
        currentShopNum += 1;
        label3.text = [NSString stringWithFormat:@"%d",currentShopNum];
        currentShopPirce += [shop.discountPrice floatValue];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",currentShopPirce];
        if (shop2) {
            //加号
            if (shop2.foodNum == 0) {
                shop2.foodNum = 1;
                [_orderDic setObject:shop forKey:key];
                btn.alpha = 1;
                numLabel.alpha = 1;
                numLabel.text = @"1";
            }else {
                shop2.foodNum += 1;
                [_orderDic setObject:shop2 forKey:key];
                numLabel.text = [NSString stringWithFormat:@"%d",shop2.foodNum];
            }
        }else {
            shop.foodNum = 1;
            [_orderDic setObject:shop forKey:key];
            [self.tableView reloadData];
        }
        
        if ([button.currentTitle isEqualToString:@"加入菜单"]) {
            [[tools shared] HUDShowHideText:[NSString stringWithFormat:@"成功添加%@一份",shop.name] delay:0.3];
        }
    }else {
        currentShopNum -= 1;
        label3.text = [NSString stringWithFormat:@"%d",currentShopNum];
            currentShopPirce -= [shop.discountPrice floatValue];
            priceLabel.text = [NSString stringWithFormat:@"￥%.2f",currentShopPirce];

            //减号
        shop2.foodNum -= 1;
        [_orderDic setObject:shop2 forKey:key];
        if (shop2.foodNum == 0 || shop2 == nil) {
            numLabel.alpha = 0;
            button.alpha = 0;
            [_orderDic removeObjectForKey:key];
        }else {
            numLabel.text = [NSString stringWithFormat:@"%d",shop2.foodNum];
        }
    }
}

- (void)didClickedCellButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self setButton:button TableView:self.tableView ModelArray:_foodArray];
}
- (void)setButton:(UIButton *)button TableView:(UITableView*)tableView ModelArray:(NSMutableArray *)modelArray
{
    UITableViewCell *cell =(UITableViewCell *)[[[[button superview]superview]superview]superview];
    
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];

//    Info *info = modelArray[indexPath.row];

    
    [button setHidden:YES];
    NSInteger i = [label3.text integerValue];
    i++;
    //label3 setText:<#(NSString *)#>
    [label3 setText:[NSString stringWithFormat:@"%i",i]];

    
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
        Info *cate = [_cateArray objectAtIndex:indexPath.row];
        _curCateId = cate.id;
        NSLog(@"_curCateId = cate.id %@",_curCateId);
        [_foodArray removeAllObjects];
        self.refreshing = YES;
        [self.tableView reloadData];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView launchRefreshing];
    }else{
        //Info *shop = [_foodArray objectAtIndex:indexPath.row];
        //点餐  选中
//        ShopVC *vc = [[ShopVC alloc] init];
//        vc.shopId = shop.id;
//        vc.name = shop.name;
//        vc.image = shop.image;
//        vc.logo = shop.logo;
//        vc.address = shop.address;
//        vc.mobile = shop.mobile;
//        vc.latitude = shop.latitude;
//        vc.longitude = shop.longitude;
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.navTitle = shop.name;
//        [self.navigationController pushViewController:vc animated:YES];
        _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        _upView.backgroundColor = [UIColor blackColor];
        _upView.alpha = 0.9;
        [self.view addSubview:_upView];
        
        
        UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(10, 50, UI_SCREEN_WIDTH-20, UI_SCREEN_WIDTH - 5)];
        bgView.backgroundColor = [UIColor whiteColor];
        [_upView addSubview:bgView];
        
        bgView.layer.borderWidth = 1.0f;
        bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        bgView.layer.cornerRadius = 10.0f;
        //_upView.layer.cornerRadius = CGRectGetHeight(label3.bounds) / 2;
        bgView.clipsToBounds = YES;

        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(bgView.right - 45, bgView.top - 45, 35, 35);
        [cancleButton setBackgroundImage:[UIImage imageNamed:@"03_07_c"] forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(didClickedCancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_upView addSubview:cancleButton];
        
        [_customScroll removeFromSuperview];
        _customScroll = nil;
        _customScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width,  bgView.bounds.size.height - 60 - 25)];
        //在本类中代理scrollView的整体事件
        _customScroll.tag = 10010;
        [_customScroll setDelegate:self];
        _customScroll.pagingEnabled = YES;
        _customScroll.backgroundColor = [UIColor whiteColor];
        _customScroll.contentSize = CGSizeMake(bgView.bounds.size.width*_foodArray.count, bgView.bounds.size.height-60 - 25);
        [bgView addSubview:_customScroll];
        int index=0;
    for (Info *food in _foodArray) {
           
        //Info *food=[_foodArray objectAtIndex:0];
            UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0+index*_customScroll.bounds.size.width, 0, _customScroll.bounds.size.width, _customScroll.bounds.size.height)];
           [imageView setImageWithURL: [NSURL URLWithString:food.detailImage] ];
            [_customScroll addSubview:imageView];
           
           UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.frame = CGRectMake(5, imageView.center.y - 20, 40, 40);
            [leftButton setBackgroundImage:[UIImage imageNamed:@"03_05_l"] forState:UIControlStateNormal];
            [_customScroll addSubview:leftButton];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(imageView.right - 45, imageView.center.y - 20, 40, 40);
            [rightButton setBackgroundImage:[UIImage imageNamed:@"03_03_r"] forState:UIControlStateNormal];
            [_customScroll addSubview:rightButton];
           
           index++;
       }
        
        Info *food =[_foodArray objectAtIndex:0];
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(_customScroll.left, _customScroll.bottom, _customScroll.bounds.size.width, 50)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:bottomView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, bottomView.width - 10 - 100, 50)];
        nameLabel.text = food.name;
        nameLabel.numberOfLines = 2;
        [bottomView addSubview:nameLabel];
        
        oneFoodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, nameLabel.bottom, 80, 25)];
        oneFoodPriceLabel.text = [NSString stringWithFormat:@"￥%@",food.discountPrice];
        [bottomView addSubview:oneFoodPriceLabel];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(bottomView.right - 100,10,100, 30);
        [addButton setTitle:@"加入菜单" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(del:) forControlEvents:UIControlEventTouchUpInside];
        addButton.tag = 20086;
        [addButton setBackgroundImage:[UIImage imageNamed:@"03_117"] forState:UIControlStateNormal];
        [bottomView addSubview:addButton];
        
        CGFloat pageWidth = _customScroll.frame.size.width;
        [_customScroll setContentOffset:CGPointMake(indexPath.row * pageWidth, 0)];
        NSInteger page = _customScroll.contentOffset.x / pageWidth;
        _currentScrolPage = page;
        Info *foods = [_foodArray objectAtIndex:indexPath.row];
        [nameLabel setText:foods.name];
        [oneFoodPriceLabel setText:[NSString stringWithFormat:@"￥%@",foods.discountPrice]];
}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 10010) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        _currentScrolPage = page;
        Info *food=[_foodArray objectAtIndex:page];
        [nameLabel setText:food.name];
        [oneFoodPriceLabel setText:[NSString stringWithFormat:@"￥%@",food.discountPrice]];
    }
}

- (void)didClickedCancleButtonAction:(id)sender
{
   // [_upView setHidden:YES];
    [_upView removeFromSuperview];
}
//设置按下时的颜色
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Add your Colour.
    if(_cateTableView == tableView){
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //[self setCellColor:[UIColor whiteColor] ForCell:cell];  //highlight colour
        [self setCellColor:[UIColor redColor] ForCell:cell];  //highlight colour
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
