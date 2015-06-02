//
//  ShopVC.m
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ShopVC.h"
#import "ProductVC.h"
#import "PayVC.h"
#import "UMSocial.h"
#import "UIButton+Additions.h"
#import "PhoneSheet.h"
#import "StoreDescViewController.h"
#import "ConnectionViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "SVPullToRefresh.h"

#define kTagShareEdit 101
#define kTagSharePost 102

@interface ShopVC ()
{
    UIScrollView *_scrollView;
    UIView *_headView;
    UIView *_shopInfoView;
    UIView *_cateView;//小房添加
    
    NSMutableArray *_productArray;
    
    NSString *SHARE_CONTENT;
    NSString *SHARE_URL;
    
    NSArray *_snsArray;
    NSDictionary *_snsDisplayNameDict;
    NSString *shopDiscount;
    
    CGFloat  discount;
}

@end

#define TABLE_CELL_HEIGHT 237
static NSInteger __currentPage;
@implementation ShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __currentPage = 1;
    _productArray = [NSMutableArray arrayWithCapacity:10];
    
    _snsArray = [NSArray arrayWithObjects:
                 UMShareToSina,
                 UMShareToTencent,
                 UMShareToWechatSession,
                 UMShareToWechatTimeline,
//                 UMShareToQQ,
                 UMShareToEmail,
                 UMShareToSms,
                 nil];
    
    _snsDisplayNameDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"新浪微博",UMShareToSina,
                           @"腾讯微博",UMShareToTencent,
                           @"微信好友",UMShareToWechatSession,
                           @"微信朋友圈",UMShareToWechatTimeline,
//                           @"QQ",UMShareToQQ,
                           @"邮件",UMShareToEmail,
                           @"短信",UMShareToSms,
                           nil];
    
    
    SHARE_CONTENT = [NSString stringWithFormat:@"我在使用新商店购物，获取新商币，购物更便利: http://app.53xsd.com/#/shopdetail/%@", self.shopId];
    
    [self buildNavBar];
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20  - 64)];
//    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:_scrollView];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40  - 64) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myTableView];
    __weak ShopVC *vc = self;

    [_myTableView addPullToRefreshWithActionHandler:^{
        
        __currentPage = 1;
        [vc loadDataWithPage:__currentPage];

        
    }];
    
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        
        __currentPage += 1;
        [vc loadDataWithPage:__currentPage];

    }];
    
//    [_myTableView addLegendHeaderWithRefreshingBlock:^{
//        
//        __currentPage = 1;
//        [vc loadDataWithPage:__currentPage];
//
//    }];
//    
//    [_myTableView addLegendFooterWithRefreshingBlock:^{
//        
//        __currentPage += 1;
//        [vc loadDataWithPage:__currentPage];
//
//    }];
    [_myTableView triggerPullToRefresh];
    [self buildFootView];
    
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getShopDetail?shopId=%@",self.shopId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [[JSON objectForKey:@"result"] objectForKey:@"shop"];
            self.simpleDesc = [dic objectForKey:@"desc"];
            self.name = [dic objectForKey:@"name"];
            self.navTitleLabel.text = self.name;
            self.image = [dic objectForKey:@"image"];
            self.logo = [dic objectForKey:@"logo"];
            self.address = [dic objectForKey:@"address"];
            self.mobile = [dic objectForKey:@"mobile"];
            self.latitude = [dic objectForKey:@"latitude"];
            self.longitude = [dic objectForKey:@"longitude"];
            self.cateId = [dic objectForKey:@"catId"];
            shopDiscount = nilOrJSONObjectForKey(dic, @"field1");
            NSNumber *number = nilOrJSONObjectForKey(dic, @"discount");
            discount = [number floatValue];

            [self.myTableView reloadData];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
    
//    [_myTableView.header beginRefreshing];
//    [_myTableView ]

}

-(void)buildFootView
{
    float CELL_WIDTH = UI_SCREEN_WIDTH/4;
    float CELL_HEIGHT = 40;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-40, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:line];

    UIView *sepaline1 = [[UIView alloc] initWithFrame:CGRectMake(CELL_WIDTH-0.5, 0, 0.5, CELL_HEIGHT)];
    [sepaline1 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:sepaline1];
    
    UIView *sepaline2 = [[UIView alloc] initWithFrame:CGRectMake(CELL_WIDTH*2-0.5, 0, 0.5, CELL_HEIGHT)];
    [sepaline2 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:sepaline2];
    
    UIView *sepaline3 = [[UIView alloc] initWithFrame:CGRectMake(CELL_WIDTH*3-0.5, 0, 0.5, CELL_HEIGHT)];
    [sepaline3 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:sepaline3];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [label1 setText:@"宝贝分类"];
    [footView addSubview:label1];
    
    UIButton *descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [descBtn setFrame:CGRectMake(CELL_WIDTH, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
    [descBtn setTitle:@"店铺简介" forState:UIControlStateNormal];
    [descBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    descBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [descBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [descBtn addTarget:self action:@selector(storeDesc) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:descBtn];
    
    UIButton *connBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [connBtn setFrame:CGRectMake(CELL_WIDTH*2, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
    [connBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
    [connBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    connBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [connBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [connBtn addTarget:self action:@selector(connection) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:connBtn];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setFrame:CGRectMake(CELL_WIDTH*3, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
    [btn4 setTitle:@"线下付款" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn4 addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn4];
}

- (void)loadDataWithPage:(NSInteger )page
{
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getProductByShopId?shopId=%@&pageIndex=%d&pageSize=10",self.shopId,page];
    NSLog(@"%@",str);
    
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
        if (code == 0) {
            
            if (page == 1) {
                [_productArray removeAllObjects];
            }
            
            NSArray *tmpResultArray = [[JSON objectForKey:@"result"] objectForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *product = [[Info alloc] init];
                product.id = nilOrJSONObjectForKey(dict, @"id");
                product.name = nilOrJSONObjectForKey(dict, @"name");
                product.detailImage = nilOrJSONObjectForKey(dict, @"detailImage");
                NSNumber *priceNum = nilOrJSONObjectForKey(dict, @"price");
                product.price = [priceNum stringValue];
                NSNumber *discountPrice = nilOrJSONObjectForKey(dict, @"discountPrice");
                product.discountPrice = [discountPrice stringValue];
                product.viewCount = [[dict valueForKey:@"viewCount"] stringValue];
                [_productArray addObject:product];
            }
            
            if (_myTableView.pullToRefreshView.state != SVPullToRefreshStateStopped) {
                [_myTableView.pullToRefreshView stopAnimating];
            }else {
                [_myTableView.infiniteScrollingView stopAnimating];
            }
            [_myTableView reloadData];
        }else {

            [[tools shared] HUDShowHideText:@"暂无数据" delay:1.5];
            if (_myTableView.pullToRefreshView.state != SVPullToRefreshStateStopped) {
                [_myTableView.pullToRefreshView stopAnimating];
            }else {
                [_myTableView.infiniteScrollingView stopAnimating];
            }
            __currentPage -= 1;
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[tools shared] HUDHide];
        if (_myTableView.pullToRefreshView.state != SVPullToRefreshStateStopped) {
            [_myTableView.pullToRefreshView stopAnimating];
        }else {
            [_myTableView.infiniteScrollingView stopAnimating];
            
        }

        __currentPage -= 1;
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
    
    
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*370/640)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*370/640)];
    [imgView setImageWithURL:[NSURL URLWithString:self.image] placeholderImage:nil];
    [view addSubview:imgView];
    float CELL_HEIGHT = 40;
    _shopInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, imgView.bottom, UI_SCREEN_WIDTH, CELL_HEIGHT * 3)];
    [view addSubview:_shopInfoView];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 18, 20)];
    [imgView1 setImage:[UIImage imageNamed:@"discount.png"]];
    [_shopInfoView addSubview:imgView1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView1.right+15, imgView1.top, 250, 20)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    NSString *discounts;
    if (shopDiscount == nil) {
        discounts = @"无折扣";
    }else {
        discounts = shopDiscount;
    }
    [label1 setText:discounts];
    [_shopInfoView addSubview:label1];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [_shopInfoView addSubview:line1];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(imgView1.left, imgView1.top+CELL_HEIGHT, 18, 20)];
    [imgView2 setImage:[UIImage imageNamed:@"mobile.png"]];
    [_shopInfoView addSubview:imgView2];
    
    UIButton *mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mobileBtn setFrame:CGRectMake(imgView2.right+15, imgView2.top, 272, 20)];
    [mobileBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [mobileBtn setTitle:self.mobile forState:UIControlStateNormal];
    [mobileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mobileBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:48];
    [mobileBtn addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
    //BTN文字居左
    mobileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_shopInfoView addSubview:mobileBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*2-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [_shopInfoView addSubview:line2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(imgView1.left, imgView2.top+CELL_HEIGHT, 18, 20)];
    [imgView3 setImage:[UIImage imageNamed:@"address.png"]];
    [_shopInfoView addSubview:imgView3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(imgView3.right+15, imgView3.top, 250, 20)];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [label3 setText:self.address];
    [_shopInfoView addSubview:label3];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*3-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line3 setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [_shopInfoView addSubview:line3];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _shopInfoView.bottom + 10, 100, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setText:@"所有商品"];
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UI_SCREEN_WIDTH*370/640 + 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_productArray.count+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *productIdentifier = @"productCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.row*2 < _productArray.count) {
        Info *product1 = [_productArray objectAtIndex:indexPath.row*2];
        ProductView *productView1 = [[ProductView alloc] initWithProduct:product1 Frame:CGRectMake(7, 5, 150, 275)];
        productView1.delegate = self;
        [cell.contentView addSubview:productView1];
    }
    if (indexPath.row*2+1 < _productArray.count) {
        Info *product2 = [_productArray objectAtIndex:indexPath.row*2+1];
        ProductView *productView2 = [[ProductView alloc] initWithProduct:product2 Frame:CGRectMake(7+150+6, 5, 150, 275)];
        productView2.delegate = self;
        [cell.contentView addSubview:productView2];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark - ProductViewDelegate
-(void)productClicked:(Info *)product
{
    ProductVC *vc = [[ProductVC alloc] init];
    vc.shopId =  self.shopId;
    vc.shopName = self.name;
    vc.productId = product.id;
    vc.name = product.name;
    vc.detailImage = product.detailImage;
    vc.discountPrice = product.discountPrice;
    vc.price = product.price;
    vc.viewCount = product.viewCount;
    vc.navTitle = @"商品详情";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate

#pragma mark -
#pragma mark - 分享
-(void)buildNavBar
{
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightNavBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setBackgroundImage:[UIImage imageNamed:@"nav_share.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}

-(void)share:(id)sender
{
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *snsName in _snsArray) {
        NSString *displayName = [_snsDisplayNameDict valueForKey:snsName];
        [editActionSheet addButtonWithTitle:displayName];
    }
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.tag = kTagSharePost;
    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
    [editActionSheet showInView:self.view];
    editActionSheet.delegate = self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    
    //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName = [_snsArray objectAtIndex:buttonIndex];
    NSString *shareText = SHARE_CONTENT;
    
    NSLog(@"%@,%@",self.logo,shareText);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.logo]];
    
    if (actionSheet.tag == kTagShareEdit) {
        //设置分享内容，和回调对象
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:data socialUIDelegate:self];
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    } else if (actionSheet.tag == kTagSharePost){
//        NSString *str = [NSString stringWithFormat:@"http%@",[[shareText componentsSeparatedByString:@"http"] lastObject]];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://app.53xsd.com/#/shopdetail/%@",self.shopId];
        
        if (buttonIndex == 2) {
            
            [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
        }else if (buttonIndex == 3) {
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
            
        }
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:shareText image:data location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            } else if(response.responseCode != UMSResponseCodeCancel) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

#pragma mark - 底部按钮点击
//店铺简介
- (void)storeDesc
{
    StoreDescViewController *storeDes = [[StoreDescViewController alloc] init];
    storeDes.name = self.name;
    storeDes.image = self.image;
    storeDes.logo = self.logo;
    storeDes.simpleDesc = self.simpleDesc;
    storeDes.shopId = self.shopId;
    storeDes.navTitle = @"店铺简介";
    [self.navigationController pushViewController:storeDes animated:YES];
}

//联系卖家
- (void)connection
{
    ConnectionViewController *connection = [[ConnectionViewController alloc] init];
    connection.name = self.name;
    connection.address = self.address;
    connection.mobile = self.mobile;
    connection.latitude = self.latitude;
    connection.longitude = self.longitude;
    connection.navTitle = @"联系卖家";
    [self.navigationController pushViewController:connection animated:YES];

}

-(void)buyNow:(id)sender
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }else{
        PayVC *vc = [[PayVC alloc] init];
        vc.shopId = self.shopId;
        vc.shopName = self.name;
        vc.shopDiscount = discount;
        vc.navTitle = @"我要付款";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)phoneClick:(id)sender
{
    PhoneSheet *vc = [[PhoneSheet alloc] initWithPhoneNumber:self.mobile];
    [vc showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate login];
    }
}

@end

