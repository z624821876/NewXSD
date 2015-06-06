//
//  FoodShopVC.m
//  newshop
//
//  Created by sunday ƒon 15/2/4.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "FoodShopVC.h"
#import "ProductVC.h"
#import "AppDelegate.h"
#import "PayVC.h"
#import "UMSocial.h"
#import "UIButton+Additions.h"
#import "PhoneSheet.h"
#import "UIButton+Location.h"
#import "StoreDescViewController.h"
#import "ConnectionViewController.h"
#import "OrderVC.h"
#import "AFJSONRequestOperation.h"
#import "WaimaiVC.h"
#define kTagShareEdit 101
#define kTagSharePost 102
@interface FoodShopVC ()
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
    UIButton *_rightNavBtn;
    UILabel *_timeLabel;
    NSString *businessTime;
    NSString *shopDiscount;
    CGFloat discount;
}
@end
#define TABLE_CELL_HEIGHT 237
@implementation FoodShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
    //[self rightNavBarItem];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*2)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    self.tableView.frame = CGRectZero;
    [self buildFootView];
    [self initDesc];

    
    //self.cateId = self.shopId;
    
    
//    [self buildProductView];

}


    //店铺简介
- (void)initDesc
{
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getShopDetail?shopId=%@",self.shopId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
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
            NSNumber *number = nilOrJSONObjectForKey(dic, @"discount");
            discount = [number floatValue];
            NSString *time1 = nilOrJSONObjectForKey(dic, @"field2");
            NSString *time2 = nilOrJSONObjectForKey(dic, @"field3");
            if (time1 != nil || time2 != nil) {
                businessTime = [NSString stringWithFormat:@"%@~%@",time1,time2];
            }
            shopDiscount = nilOrJSONObjectForKey(dic, @"field1");
            [self buildHeadView];
            
            [self buildShopInfoView];
            [self setUpCateView];//小房
            [self buildDesc];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [operation start];

}

- (void)buildDesc
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, _shopInfoView.bottom + 120, 120, 30)];
    label.text = @"店铺简介：";
    [_scrollView addSubview:label];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, _shopInfoView.bottom + 147, 290, 0.5)];
    view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    [_scrollView addSubview:view];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.numberOfLines = 0;
    [_scrollView addSubview:label2];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y + 3, 320, 100)];
    //    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    [webView loadHTMLString:self.simpleDesc baseURL:nil];
    
    [_scrollView addSubview:webView];
    
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, webView.bottom + 200)];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'";
//        
//    [webView stringByEvaluatingJavaScriptFromString:str];
//    
    CGRect oldFrame = [webView frame];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    [webView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height)];

    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, webView.bottom + 100)];
    
}

- (void)rightNavBarItem
{
    _rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightNavBtn.frame = CGRectMake(0, 0, 50, 40);
    [_rightNavBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
  [_rightNavBtn setupButtonWithCity:[LLSession sharedSession].city.name area:[LLSession sharedSession].area.name image:[UIImage imageNamed:@"anchor.png"]];  
}

-(void)buildHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*370/640 -50)];
    [_scrollView addSubview:_headView];
    //UIImageView *imgView = [[UIImageView alloc] initWithFrame:_headView.bounds];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, UI_SCREEN_WIDTH/2-20, _headView.bounds.size.height - 20)];
    
    [imgView setImageWithURL:[NSURL URLWithString:self.image] placeholderImage:nil];
    [_headView addSubview:imgView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right + 10, imgView.top, _headView.right - imgView.right -10-5, 30)];
    
    nameLabel.text = self.name;
   // nameLabel.backgroundColor = [UIColor redColor];
  //  _headView.backgroundColor = [UIColor greenColor];
    
    [_headView addSubview:nameLabel];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    NSString *time;
    if (businessTime == nil) {
        time = @"9:00~22:30";
    }else {
        time = businessTime;
    }

    [_timeLabel setAdjustsFontSizeToFitWidth:YES];
    [_timeLabel setText:[NSString stringWithFormat:@"营业时间：%@",time]];
    [_headView addSubview:_timeLabel];
    
    UIImageView *recommentView = [[UIImageView alloc]initWithFrame:CGRectMake(imgView.right,_timeLabel.bottom, 20, 20)];
    
    [_headView addSubview:recommentView];
    
    UIImageView *image1= [[UIImageView alloc]initWithFrame:CGRectMake(imgView.right + 10, recommentView.bottom , 20, 20)];
    image1.image = [UIImage imageNamed:@"03_17"];
    [_headView addSubview:image1];
    
    UIImageView *image2= [[UIImageView alloc]initWithFrame:CGRectMake(image1.right+5 , recommentView.bottom , 20, 20)];
    image2.image = [UIImage imageNamed:@"03_20"];
    [_headView addSubview:image2];
    
    UIImageView *image3= [[UIImageView alloc]initWithFrame:CGRectMake(image2.right+5 , recommentView.bottom , 20, 20)];
    image3.image = [UIImage imageNamed:@"03_22"];
    [_headView addSubview:image3];
    
    
    
    
    
   
    //    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((_headView.width-63)/2, (_headView.height-63)/2, 63, 63)];
    //    [logoView setImageWithURL:[NSURL URLWithString:self.logo] placeholderImage:nil];
    //    [_headView addSubview:logoView];
}
-(void)buildShopInfoView
{
    float CELL_HEIGHT = 40;
    _shopInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, CELL_HEIGHT*3)];
    [_scrollView addSubview:_shopInfoView];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 18, 20)];
    [imgView1 setImage:[UIImage imageNamed:@"discount.png"]];
    [_shopInfoView addSubview:imgView1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgView1.right+15, imgView1.top, 250, 20)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    
    NSString *discount;
    if (shopDiscount == nil) {
        discount = @"无折扣";
    }else {
        discount = shopDiscount;
    }
    [label1 setText:discount];
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
    //    mobileBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [_shopInfoView addSubview:mobileBtn];
    
    //    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(imgView2.right+15, imgView2.top, 250, 20)];
    //    [label2 setFont:[UIFont systemFontOfSize:13]];
    //    [label2 setText:self.mobile];
    //    [_shopInfoView addSubview:label2];
    
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
}
//点餐、外卖 、预定
- (void)setUpCateView
{
    _cateView = [[UIView alloc]initWithFrame:CGRectMake(15, _shopInfoView.bottom + 10, UI_SCREEN_WIDTH -30 , 100)];
    // _cateView.backgroundColor = [UIColor purpleColor];
    [_scrollView addSubview:_cateView];
    
    NSArray *cateNameArr = [NSArray arrayWithObjects:@"点餐",@"外卖",@"预定", nil];
    NSArray *cateIdArr = [NSArray arrayWithObjects:@1,@5,@6,nil];
    int row = 0; int col = 0;
    for (int i=0; i<3; i++) {
        UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //float width =
        [cateBtn setFrame: CGRectMake(25+80*col, 5+75*row, 70, 70)];
        [cateBtn addTarget:self action:@selector(CateClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cateView addSubview:cateBtn];
        UILabel *cateLabel = [[UILabel alloc] init];
        [cateLabel setFrame: CGRectMake(cateBtn.left, cateBtn.bottom+2, 70, 20)];
        [cateLabel setFont:[UIFont systemFontOfSize:14]];
        [cateLabel setTextAlignment:NSTextAlignmentCenter];
        [_cateView addSubview:cateLabel];
        [cateBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"03_3%i.png",i+7]] forState:UIControlStateNormal];
        //[cateBtn setBackgroundColor:[UIColor redColor]];
        [cateLabel setText:[cateNameArr objectAtIndex:i]];
        [cateBtn setEnlargeEdgeWithTop:5 right:10 bottom:15 left:10];
        cateBtn.tag = [[cateIdArr objectAtIndex:i] integerValue];
        col++;
        if(col%3==0)
        {
            col = 0;
            row++;
        }
    }
}
//关联数据
-(void)CateClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"---------------Cate:%i",btn.tag);
//    if ([LLSession sharedSession].area.id == nil) {
//        [[tools shared] HUDShowHideText:@"尚未定位，请重新定位城市" delay:2];
//        return;
//    }
    //    ShopInCateVC *vc = [[ShopInCateVC alloc] init];
    //    vc.cateId = [NSString stringWithFormat:@"%i",btn.tag];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    switch (btn.tag) {
        case 1:
        {
            //点餐
            WaimaiVC *vc = [[WaimaiVC alloc]init];
            vc.type = 1;
            vc.shopName = self.name;
            vc.navTitle = @"点餐";
            vc.delegate=self;
            vc.hidesBottomBarWhenPushed = YES;
            //vc.cateId = @"1";
            vc.shopId = self.shopId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5:
        {
            //外卖
            WaimaiVC *vc = [[WaimaiVC alloc]init];
            vc.type = 2;
            vc.navTitle = @"外卖";
            vc.delegate=self;
            vc.hidesBottomBarWhenPushed = YES;
            //vc.cateId = @"1";
            vc.shopId = self.shopId;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;

        case 6:
        {
            //预定
            OrderVC *vc = [[OrderVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navTitle = self.name;
            vc.shopId = self.shopId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)passValue:(NSString *)value
{ 
    NSLog(@"the get value is %@", value);
}

    //下方推荐菜品
-(void)buildProductView
{
    // UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _shopInfoView.bottom+10, 100, 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _cateView.bottom+10, 100, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setText:@"推荐菜品"];
    [_scrollView addSubview:titleLabel];
    
    
    //self.tableView.frame = CGRectMake(0, _shopInfoView.bottom+40, UI_SCREEN_WIDTH, TABLE_CELL_HEIGHT*2);
    self.tableView.frame = CGRectMake(0, _cateView.bottom+40, UI_SCREEN_WIDTH, TABLE_CELL_HEIGHT*2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView removeFromSuperview];
    [_scrollView addSubview:self.tableView];
    [self.tableView launchRefreshing];
    
}

    //底部按钮
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
    
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
//    [label2 setFont:[UIFont systemFontOfSize:14]];
//    [label2 setTextAlignment:NSTextAlignmentCenter];
//    [label2 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
//    [label2 setText:@"店铺简介"];
//    [footView addSubview:label2];
    
    UIButton *descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [descBtn setFrame:CGRectMake(CELL_WIDTH, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
    [descBtn setTitle:@"店铺简介" forState:UIControlStateNormal];
    [descBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    descBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [descBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [descBtn addTarget:self action:@selector(storeDesc) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:descBtn];
    
    
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH*2, (CELL_HEIGHT-20)/2, CELL_WIDTH, 20)];
//    [label3 setFont:[UIFont systemFontOfSize:14]];
//    [label3 setTextAlignment:NSTextAlignmentCenter];
//    [label3 setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
//    [label3 setText:@"联系卖家"];
//    [footView addSubview:label3];
    
    
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
    [btn4 setTitle:@"付款" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn4 addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn4];
    
}


- (void)loadProduct
{
    self.refreshing ? self.page=0 : self.page++;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.shopId,@"shopId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonShopProduct] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        NSLog(@"********%@",JSON);
        if (code == 0){
            if (self.refreshing)
            {
                self.refreshing = NO;
                [_productArray removeAllObjects];
            }
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *product = [[Info alloc] init];
                product.id = nilOrJSONObjectForKey(dict, @"id");
                product.name = nilOrJSONObjectForKey(dict, @"name");
                product.detailImage = nilOrJSONObjectForKey(dict, @"detailImage");
                product.price = [[dict valueForKey:@"price"] stringValue];
                product.discountPrice = [[dict valueForKey:@"discountPrice"] stringValue];
                product.catId = [dict valueForKey:@"catId"];
                product.catName = [dict valueForKey:@"catName"];
                product.viewCount = [[dict valueForKey:@"viewCount"] stringValue];
                [_productArray addObject:product];
            }
            self.tableView.height = TABLE_CELL_HEIGHT*(_productArray.count+1)/2+110; //临时，也可永久
            [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, self.tableView.bottom)];
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
        ProductView *productView1 = [[ProductView alloc] initWithProduct:product1 Frame:CGRectMake(7, 5, 150, 225)];
        productView1.delegate = self;
        [cell.contentView addSubview:productView1];
    }
    if (indexPath.row*2+1 < _productArray.count) {
        Info *product2 = [_productArray objectAtIndex:indexPath.row*2+1];
        ProductView *productView2 = [[ProductView alloc] initWithProduct:product2 Frame:CGRectMake(7+150+6, 5, 150, 225)];
        productView2.delegate = self;
        [cell.contentView addSubview:productView2];
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
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
//PullingRefreshTableView delegate方法（重写，覆盖load方法 ）
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadProduct) withObject:nil afterDelay:0];
}
//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadProduct) withObject:nil afterDelay:0];
}




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
    NSLog(@"===%@",SHARE_CONTENT);
    NSString *shareText = SHARE_CONTENT;
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];
    
    if (actionSheet.tag == kTagShareEdit) {
        //设置分享内容，和回调对象
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    } else if (actionSheet.tag == kTagSharePost){
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:shareText image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate login];
    }
}

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

    //点击电话号码
-(void)phoneClick:(id)sender
{
    PhoneSheet *vc = [[PhoneSheet alloc] initWithPhoneNumber:self.mobile];
    [vc showInView:self.view];
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
