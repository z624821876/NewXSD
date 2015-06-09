//
//  ProductVC.m
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ProductVC.h"
#import "UIButton+Additions.h"
#import "PayVC.h"
#import "AppDelegate.h"
#import "UIViewController+KNSemiModal.h"
#import "AddInCarView.h"
#import "XFConfimBooksVC.h"
#import "XFShopingCarVC.h"
#import "ShopVC.h"
#import "FoodShopVC.h"
#import "FruitVC.h"
@interface ProductVC ()
{
    UIScrollView *_scrollView;
    
    UIView  *_headView;
    EScrollerView  *_eScrollerView;
    NSMutableArray *_adArray;
    
    NSMutableArray *_recommendedArray;
    
    UIView *_infoBgView;
    UIView *_selectBgView;
    UIView *_detailSelectBgView;
    
    NSString *_htmlText;
    UIWebView *_webView;
    AddInCarView *_addView;
    Info *_info;

    AddInCarView *_buyView;
    NSMutableArray *_colorArr;
    NSString *currentColor;
    UIButton *currentBtn;
    UILabel *stockLabel;

}

@end

@implementation ProductVC

- (void)viewWillAppear:(BOOL)animated
{
    self.carNum = @"1";
    self.buyNum = @"1";

    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _colorArr = [[NSMutableArray alloc] init];
    
    _stock = 0;
    if (self.typeIn != 10) {

    //添加购物车图标
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightNavBtn addTarget:self action:@selector(didClickedBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setBackgroundImage:[UIImage imageNamed:@"02_03(3).png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];

    }
    _adArray = [NSMutableArray arrayWithCapacity:3];
    _recommendedArray = [NSMutableArray arrayWithCapacity:4];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 40)];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*2)];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    [self buildHeadView];
    [self buildProductInfo];
    [self buildDetailSelectView];
    [self buildWebView];
    [self buildFootView];
    
    [self loadProductDetail];
    //[self setAddView];
    
    
    //此处不确定价钱总价格是否添加监听  价钱的分数
//    [self addObserver:self forKeyPath:@"carNum" options:(NSKeyValueObservingOptionNew) context:nil];
//    [self addObserver:self forKeyPath:@"buyNum" options:NSKeyValueObservingOptionNew context:nil];
//    
//    [self addObserver:self forKeyPath:@"allMoney" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self removeObserver:self forKeyPath:@"carNum" context:nil];
//    [self removeObserver:self forKeyPath:@"buyNum" context:nil];
//    [self removeObserver:self forKeyPath:@"allMoney" context:nil];
}

- (void)didClickedBarItem:(id)sender
{
    if ([LLSession sharedSession].user.userId == nil) {
        //如果没有登录  进行登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
        
    }else{

    XFShopingCarVC *shopVC = [[XFShopingCarVC alloc]init];
    shopVC.navTitle = @"购物车";
    [self.navigationController pushViewController:shopVC animated:YES];
    }
}

-(void)buildHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*3/4)];
    [_scrollView addSubview:_headView];
    
//    //将图片截取一部分的代码
//    UIImage *oldImage = [UIImage imageNamed:@"test.jpg"];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:[Util imageClips:oldImage Rect:CGRectMake(0,0,600,600*3/4)]];
//    imageView.frame = CGRectMake( 0, _headView.bottom, 320, 240);
//    [_scrollView addSubview:imageView];
}

-(void)buildProductInfo
{
    _infoBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, 90)];
    [_scrollView addSubview:_infoBgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 20)];
    [nameLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [_infoBgView addSubview:nameLabel];
    
    UILabel *discountPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+5, (UI_SCREEN_WIDTH - 30) / 2.0, 20)];
    [discountPriceLabel setTextColor:[UIColor redColor]];
    [discountPriceLabel setFont:[UIFont systemFontOfSize:14]];
    [discountPriceLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [_infoBgView addSubview:discountPriceLabel];
    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(265, discountPriceLabel.top+5, 15, 15)];
//    [imgView setImage:[UIImage imageNamed:@"favour.png"]];
//    [_infoBgView addSubview:imgView];
//    
//    UILabel *viewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+5, discountPriceLabel.top+2, 80, 20)];
//    [viewCountLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
//    [viewCountLabel setFont:[UIFont systemFontOfSize:12]];
//    [viewCountLabel setLineBreakMode:NSLineBreakByCharWrapping];
//    [_infoBgView addSubview:viewCountLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(discountPriceLabel.right, discountPriceLabel.top, discountPriceLabel.width, 20)];
    [priceLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [priceLabel setFont:[UIFont systemFontOfSize:12]];
    priceLabel.textAlignment = NSTextAlignmentRight;
//    [priceLabel setLineBreakMode:NSLineBreakByCharWrapping];
//    priceLabel.backgroundColor
    [_infoBgView addSubview:priceLabel];
    
    [nameLabel setText:self.name];
    [discountPriceLabel setText:[NSString stringWithFormat:@"￥ %.2f",[self.discountPrice doubleValue]]];
//    [viewCountLabel setText:self.viewCount];
    
    
    NSAttributedString *str=[[NSMutableAttributedString alloc]  initWithString:[NSString stringWithFormat:@"价格：￥ %@", self.price]  attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [priceLabel setAttributedText:str];
    
    
    stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, discountPriceLabel.bottom, 300, 20)];
    [stockLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [stockLabel setFont:[UIFont systemFontOfSize:13]];
    stockLabel.text = [NSString stringWithFormat:@"库存：%d",_stock];
    [_infoBgView addSubview:stockLabel];
}

- (void)tapAction:(id)sender
{
//    AddInCarVC *addVC = [[AddInCarVC alloc]init];
//    addVC.navTitle = @"产品参数";
    //[self presentViewController:addVC animated:YES completion:nil];
//    [self.navigationController pushViewController:addVC animated:YES];
    
}
-(void)buildDetailSelectView
{
    float top = [self buildSeparateLine:_infoBgView.bottom];
    _detailSelectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, top, UI_SCREEN_WIDTH, 37)];
    [_scrollView addSubview:_detailSelectBgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320/3, 20)];
    [label1 setTextColor:[UIColor redColor]];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [_detailSelectBgView addSubview:label1];
    [label1 setText:@"图文详情"];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(320/3, 5, 320/3, 20)];
    [label2 setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [label2 setFont:[UIFont systemFontOfSize:14]];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [_detailSelectBgView addSubview:label2];
    [label2 setText:@"产品参数"];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(320*2/3, 5, 320/3, 20)];
    [label3 setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [label3 setFont:[UIFont systemFontOfSize:14]];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [_detailSelectBgView addSubview:label3];
    [label3 setText:@"累计评价"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, label1.bottom+5, 320/3, 2)];
    [line setBackgroundColor:[UIColor redColor]];
    [_detailSelectBgView addSubview:line];
    

}

-(float)buildSeparateLine:(float)top
{
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, top, UI_SCREEN_WIDTH, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [_scrollView addSubview:line1];
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, line1.bottom, UI_SCREEN_WIDTH, 7)];
    [spaceView setBackgroundColor:[UIColor colorWithWhite:0.961 alpha:1]];
    [_scrollView addSubview:spaceView];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, spaceView.bottom, UI_SCREEN_WIDTH, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [_scrollView addSubview:line2];
    return line2.bottom;
}

-(void)buildWebView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _detailSelectBgView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.userInteractionEnabled = NO;
    _webView.delegate = self;
    [_webView setScalesPageToFit:YES];
    [_scrollView addSubview:_webView];
}

-(void)buildFootView
{
    float CELL_HEIGHT = 40;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-40, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    [footView setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [self.view addSubview:footView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 23, 20)];
    [imgView setImage:[UIImage imageNamed:@"enter_shop.png"]];
    [footView addSubview:imgView];
    
    
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(imgView.right, imgView.top, 80, 20)];
        [btn1 setTitle:@"进入店铺" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1 setEnlargeEdgeWithTop:5 right:5 bottom:5 left:50];
        [btn1 addTarget:self action:@selector(enterShop:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btn1];

    if (self.typeIn != 10) {

    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(145, 5, 75, 30)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(addCart:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn2];
    }
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(235, 5, 75, 30)];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"buy_now.png"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn3];

}
#pragma mark -
#pragma mark - UITableViewDataSource
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //2种方法都可以,这利用JS
    CGRect oldFrame = [_webView frame];
    CGFloat height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    [_webView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height)];
    [_scrollView setContentSize:CGSizeMake(320, _webView.bottom)];
    [self loadRecommended];
    
    
//    //2种方法都可以,这利用UIView的sizeThatFits，让UIView适应subView的size
//    CGRect frame = _webView.frame;
//    frame.size.height = 1;
//    _webView.frame = frame;
//    CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    _webView.frame = frame;
//    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH,_webView.bottom+90);

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void)buildRecommendView
{
    UIView *recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, _webView.bottom, UI_SCREEN_WIDTH, 550)];
    [_scrollView addSubview:recommendView];
    
//    [self drawLine:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5) inView:recommendView];
    [self drawLine:CGRectMake(0, 19.5, 120, 0.5) inView:recommendView];
    [self drawLine:CGRectMake(200, 19.5, 120, 0.5) inView:recommendView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 80, 20)];
    [label setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [recommendView addSubview:label];
    [label setText:@"同店推荐"];

    int i = 0;
    for (Info *recomProduct in _recommendedArray) {
        CGRect rect;
        if (i ==0) {
            rect = CGRectMake(7, 40, 150, 275);
        }else  if (i ==1) {
            rect = CGRectMake(7+150+6, 40, 150, 275);
        }else if (i ==2) {
            rect = CGRectMake(7, 40+275+10, 150, 275);
        }else if (i ==3) {
            rect = CGRectMake(7+150+6, 40+275+10, 150, 275);
        }
        ProductView *productView1 = [[ProductView alloc] initWithProduct:recomProduct Frame:rect];
        productView1.delegate = self;
        [recommendView addSubview:productView1];
        i++;
        if (i== 4) {
            break;
        }
    }
    recommendView.height = 40 + 225 * ((i-1)/2+1)+25;
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH,recommendView.bottom+90);
}

-(void)productClicked:(Info *)product
{
    NSLog(@"%@",product.name);
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

-(void)loadRecommended
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.shopId,@"shopId",
                                   nil];

    
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonRecommended] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            [_adArray removeAllObjects];
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *recommend = [[Info alloc] init];
                recommend.id = nilOrJSONObjectForKey(dict, @"id");
                recommend.name = nilOrJSONObjectForKey(dict, @"name");
                recommend.detailImage = nilOrJSONObjectForKey(dict, @"detailImage");
                recommend.discountPrice = [Util getValuesFor:dict key:@"discountPrice"];
                recommend.price = [Util getValuesFor:dict key:@"price"];
                recommend.viewCount = [Util getValuesFor:dict key:@"viewCount"];
                [_recommendedArray addObject:recommend];
            }
            [self buildRecommendView];
            
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

- (void)loadProductDetail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.productId,@"productId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonProductDetail] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
        if (code == 0){
            _stock = [[[[JSON objectForKey:@"result"] objectForKey:@"product"] objectForKey:@"productStore"] integerValue];
            stockLabel.text = [NSString stringWithFormat:@"库存：%d",_stock];

            [_adArray removeAllObjects];
            NSArray *tmpResultArray = [[JSON valueForKey:@"result"] valueForKey:@"productImages"];
            
            //备注数组
            NSArray *productParamListArray = [[JSON valueForKey:@"result"] valueForKey:@"productParamList"];
            for (NSDictionary *color in productParamListArray) {
                //颜色
                NSString *strrr = [color objectForKey:@"value"];
                [_colorArr addObject:strrr];
            }
            
            for (NSDictionary *dict in tmpResultArray) {
                Info *ad = [[Info alloc] init];
                ad.imgPath = nilOrJSONObjectForKey(dict, @"imgPath");
                [_adArray addObject:ad];
            }
            _htmlText = nilOrJSONObjectForKey([[JSON valueForKey:@"result"] valueForKey:@"productText"],@"text");
            
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:[_adArray count]];
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:[_adArray count]];
            for (Info *ad in _adArray) {
                [imageArray addObject:ad.imgPath];
                [titleArray addObject:@""];
            }
            if ([_adArray count]>0) {
                // 设置滚动视图
                _eScrollerView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*3/4)
                                                               ImageArray:imageArray
                                                               TitleArray:titleArray];
                _eScrollerView.delegate = self;
                [_headView addSubview:_eScrollerView];
            }
        [_webView loadHTMLString:_htmlText baseURL:nil];
    }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    
    
}
//进入店铺
-(void)enterShop:(id)sender
{
    switch ([self.shopCatId integerValue]) {
        case 5:
        {
            FoodShopVC *vc = [[FoodShopVC alloc] init];
            vc.shopId = self.shopId;
            //                vc.name = info;
            vc.image = self.detailImage;
            vc.hidesBottomBarWhenPushed = YES;
            //                vc.navTitle = user.shopName;
            vc.cateId = self.shopCatId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 11:
        case 12:
        {
            FruitVC *vc = [[FruitVC alloc] init];
            vc.shopId = self.shopId;
            //                vc.name = info;
            vc.hidesBottomBarWhenPushed = YES;
            //                vc.navTitle = user.shopName;
            vc.cateId = self.shopCatId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            ShopVC *vc = [[ShopVC alloc] init];
            vc.shopId = self.shopId;
            //                vc.name = info;
            vc.image = self.detailImage;
            vc.hidesBottomBarWhenPushed = YES;
            //                vc.navTitle = user.shopName;
            vc.cateId = self.shopCatId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
    }
}

//加入购物车
-(void)addCart:(id)sender
{
        if ([LLSession sharedSession].user.userId == nil) {
            //如果没有登录  进行登录
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 624821;
            [alert show];
        }else{

            if (_stock <= 0) {
                [[tools shared] HUDShowHideText:@"库存不足,不能购买" delay:1.5];
                return;
            }

    _addView = [[AddInCarView alloc] initWithFrame:CGRectMake(0, 200, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-49-20 ) Info:nil WithColor:_colorArr];
    //_addView.numbelLabel.text = @"1";
    _addView.nameLabel.text = self.name;
    _addView.numbelLabel.text = @"1";
    _addView.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.discountPrice doubleValue]];
    [_addView.imageView setImageWithURL:[NSURL URLWithString:self.detailImage]];
    
#pragma mark ------- 点击购买
    
    [_addView.confimButton addTarget:self action:@selector(didClickedCarConfimButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //取消购物车视图
    [_addView.cancleButton addTarget:self action:@selector(didClickedCarCancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //购物车数量增加
    [_addView.addButton addTarget:self action:@selector(didClickedCarAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            _addView.addButton.tag = 10;
    //购物车数量减少
    [_addView.reduceButton addTarget:self action:@selector(didClickedCarAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            _addView.reduceButton.tag = 11;
    
    for (UIButton *btn in _addView.btnArr) {
        [btn addTarget:self action:@selector(didColorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [bgImageView setImageWithURL:[NSURL URLWithString:self.detailImage]];
    [self presentSemiView:_addView withOptions:@{ KNSemiModalOptionKeys.backgroundView:bgImageView }];
        }
}

#pragma mark------ReduceCountButton  And  AddCountButton 使用KVO监听数量的变化   注意监听的对象、属性  是关键
//购物车数量加1
- (void)didClickedCarAddButtonAction:(UIButton *)sender
{
    if (sender.tag == 10) {
        //增加
        int num  = [self.carNum intValue];
        num += 1;
        self.carNum = [NSString stringWithFormat:@"%d",num];
        _addView.numbelLabel.text = self.carNum;
    }else {
        //减少
        int num  = [self.carNum intValue];
        if (num != 1) {
            num -= 1;
            self.carNum = [NSString stringWithFormat:@"%d",num];
            _addView.numbelLabel.text = self.carNum;
        }
    }
}

//监听代理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"carNum"] && object == self) {
        _addView.numbelLabel.text = self.carNum;
    }if ([keyPath isEqualToString:@"buyNum"] && object == self) {
        _buyView.numbelLabel.text = self.buyNum;
    }
}

//加入购物车选择颜色
- (void)didaddCarColorAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;//每次点击都改变按钮的状态
    if (button == _addView.color1) {
        if (button.selected) {
            [_addView.color2 setSelected:NO];
            self.carColor = _addView.color1.titleLabel.text;
            NSLog(@"选中时color1 ===%@",self.carColor);
        }else{
        
        }
}else if (button == _addView.color2){
                if (button.selected) {
                [_addView.color1 setSelected:NO];
            self.carColor = _addView.color2.titleLabel.text;
            //NSLog(@"选中时color2 ===%@",self.carColor);
        }else{
          
        }
        
    }
 
}

#pragma mark ----ConfimButton And   CancelButtonAction
- (void)didClickedCarCancleButtonAction:(id)sender
{
    self.carNum = @"1";
    self.buyNum = @"1";
    [self dismissSemiModalViewWithCompletion:nil];
}

//提交加入购物车
- (void)didClickedCarConfimButtonAction:(id)sender
{
    if ([_colorArr count] == 0 || currentColor.length > 0) {

    NSString *userId = [LLSession sharedSession].user.userId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.carNum,@"num",
                                   userId,@"userId",self.productId,@"productId",self.shopId,@"shopId",self.color,@"colorName",nil];
   
       [[RestClient sharedClient] postPath:[tools getServiceUrl:AddCar] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
    NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
           if (code == 0){
               NSInteger result = [[JSON valueForKeyPath:@"result"]integerValue];

               if (result == 1) {
                [[tools shared] HUDShowHideText:@"成功加入购物车" delay:1.5];
                   self.carNum = @"1";
                  
               }
               else{
                [[tools shared] HUDShowHideText:@"此商品已存在购物车！" delay:1.5];
               }
           }else {
               [[tools shared] HUDShowHideText:@"此商品已存在购物车！" delay:1.5];

           }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    currentColor = nil;
    currentBtn = nil;
    self.carNum = @"1";
    self.buyNum = @"1";
 [self dismissSemiModalViewWithCompletion:nil];
  
    }else {
        [[tools shared] HUDShowHideText:@"请选择规格" delay:1.5];

    }
}

//立即购买
-(void)buyNow:(id)sender
{
    if ([LLSession sharedSession].user.userId == nil) {
            //如果没有登录  进行登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }else{
    
    if (_stock <= 0) {
        [[tools shared] HUDShowHideText:@"库存不足,不能购买" delay:1.5];
        return;
    }

    _buyView = [[AddInCarView alloc] initWithFrame:CGRectMake(0, 200, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT -44-49-20) Info:nil WithColor:_colorArr];
    _buyView.nameLabel.text = self.name;
    [_buyView.moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",[self.discountPrice doubleValue]]];
    _buyView.numbelLabel.text = @"1";
    [_buyView.imageView setImageWithURL:[NSURL URLWithString:self.detailImage]];
    
    for (UIButton *btn in _buyView.btnArr) {
        [btn addTarget:self action:@selector(didColorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
#pragma mark - 购买
    [_buyView.confimButton addTarget:self action:@selector(didClickedBuyConfimButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buyView.cancleButton addTarget:self action:@selector(didClickedCarCancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyView.addButton addTarget:self action:@selector(didClickedBuyViewAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyView.addButton.tag = 10;
    [_buyView.reduceButton addTarget:self action:@selector(didClickedBuyViewAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyView.reduceButton.tag = 11;
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    [bgImageView setImageWithURL:[NSURL URLWithString:self.detailImage]];
    
    [self presentSemiView:_buyView withOptions:@{ KNSemiModalOptionKeys.backgroundView:bgImageView }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myCancel) name:kSemiModalDidHideNotification object:nil];
    }
}

- (void)myCancel
{
    currentColor = nil;
    currentBtn = nil;
    self.carNum = @"1";
    self.buyNum = @"1";

}

//选择颜色
- (void)didColorButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        button.selected = NO;
        currentBtn = nil;
        currentColor = nil;
    }else {
        currentBtn.selected = NO;
        button.selected = YES;
        currentBtn = button;
        currentColor = [_colorArr objectAtIndex:button.tag];
    }
}

//立即购买
- (void)didClickedBuyConfimButtonAction:(id)sender
{
    
    if ([_colorArr count] == 0 || currentColor.length > 0) {
        XFConfimBooksVC *confimVC = [[XFConfimBooksVC alloc]init];
        confimVC.navTitle = @"确认订单";
        confimVC.shopName = self.shopName;
        confimVC.shopId = self.shopId;
        confimVC.productId = self.productId;
        confimVC.buyNow = YES;
        confimVC.buyNum = self.buyNum;
        confimVC.color = currentColor;
        currentColor = nil;
        currentBtn = nil;
        
        [self dismissSemiModalViewWithCompletion:nil];
        
        [self.navigationController pushViewController:confimVC animated:YES];
    }else {
        [[tools shared] HUDShowHideText:@"请选择规格" delay:1.5];
    }

    
}

    //立即购买的 增加  减少
- (void)didClickedBuyViewAddButtonAction:(UIButton *)sender
{
    if (sender.tag == 10) {
        //增加
        int num  = [self.buyNum intValue];
        num += 1;
        self.buyNum = [NSString stringWithFormat:@"%d",num];
        _buyView.numbelLabel.text = self.buyNum;
    }else {
        //减少
        int num  = [self.buyNum intValue];
        if (num != 1) {
            num -= 1;
            self.buyNum = [NSString stringWithFormat:@"%d",num];
            _buyView.numbelLabel.text = self.buyNum;
        }
    }

}

- (void)dealloc
{
    //移除观察者
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate login];
    }
}

@end
