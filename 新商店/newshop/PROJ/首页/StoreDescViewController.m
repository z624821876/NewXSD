//
//  StoreDescViewController.m
//  newshop
//
//  Created by 于洲 on 15/3/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "StoreDescViewController.h"
#import "AFJSONRequestOperation.h"

@interface StoreDescViewController ()

@property (nonatomic, strong) UIScrollView      *scrollView;

@end

@implementation StoreDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectZero;
    self.view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    [self.view addSubview:_scrollView];
    [self buildHeadView];
    
    [self buildNameView];

//    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/getShopDetail?shopId=%@",self.shopId];
//    NSURL *url = [NSURL URLWithString:str];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
//            NSDictionary *dic = [[JSON objectForKey:@"result"] objectForKey:@"shop"];
//            self.simpleDesc = [dic objectForKey:@"desc"];
//        }
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        
//        HUDShowErrorServerOrNetwork
//    }];
//    [operation start];

}

- (void)buildNameView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH*370/640 + 10, 320, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    [img setImageWithURL:[NSURL URLWithString:self.logo] placeholderImage:nil];
    [view addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 20)];
    label.text = self.name;
    [view addSubview:label];
    
    [_scrollView addSubview:view];
    

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH*370/640 + 10 + 70, 320, 40)];
    view2.backgroundColor = [UIColor whiteColor];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
    label2.text = @"店铺简介: ";
    label2.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    [view2 addSubview:label2];
    

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, view2.bottom, 320, 100)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [webView loadHTMLString:self.simpleDesc baseURL:nil];
    [_scrollView addSubview:view2];
    [_scrollView addSubview:webView];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT * 2)];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'";
//    
//    [webView stringByEvaluatingJavaScriptFromString:str];
    
    CGRect oldFrame = [webView frame];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    [webView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height)];
    
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, webView.bottom + 100)];

}


-(void)buildHeadView
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*370/640)];
    [imgView setImageWithURL:[NSURL URLWithString:self.image] placeholderImage:nil];
    [_scrollView addSubview:imgView];
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
