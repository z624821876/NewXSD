//
//  ConfirmOrderVC.m
//  newshop
//
//  Created by 于洲 on 15/4/24.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "AFJSONRequestOperation.h"

@interface ConfirmOrderVC ()
{
    UIScrollView *_bgScroll;
    
    UIView          *_bgView;
    UILabel         *topNameLabel;
    UITextField     *tableNo;
}

@end

@implementation ConfirmOrderVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"点餐确认";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height - 60 - 40)];
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, topNameLabel.bottom, _bgView.width - 20, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [_bgView addSubview:lineView];
    [self updateUI];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, _bgScroll.bottom + 15 + 40, 30, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.shopNum;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 15;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [UIColor orangeColor].CGColor;
    label.layer.borderWidth = 1;
    label.textColor = [UIColor orangeColor];
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH - 70, label.top, 65, 30);
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认点餐" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn.left - 75, label.top, 65, 30);
    btn2.backgroundColor = [UIColor redColor];
    btn2.layer.cornerRadius = 10;
    btn2.layer.masksToBounds = YES;
    [btn2 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"继续点餐" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn2];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, btn2.left - label.right - 10, 30)];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.text = self.totalFee;
    [self.view addSubview:priceLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgScroll.bottom, UI_SCREEN_WIDTH, 40)];
    bgView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    [self.view addSubview:bgView];
    
    tableNo = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, UI_SCREEN_WIDTH - 20, 30)];
    tableNo.borderStyle = UITextBorderStyleRoundedRect;
    tableNo.backgroundColor = [UIColor whiteColor];
    tableNo.placeholder = @"请输入桌号";
    tableNo.delegate = self;
    [bgView addSubview:tableNo];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect rect = self.view.frame;
    rect.origin.y += 216;
    self.view.frame = rect;

    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rect = self.view.frame;
    rect.origin.y -= 216;
    self.view.frame = rect;
    return YES;
}

- (void)confirm
{

    NSMutableArray *array = [NSMutableArray array];
    for (Info *food in self.orderArr) {
        NSString *str = [NSString stringWithFormat:@"%@:%d",food.id,food.foodNum];
        [array addObject:str];
    }
    NSString *str = [array componentsJoinedByString:@","];
    
    NSString *urlStr=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/cart/ordering?foodList=%@&userId=%@&remark=%@",str,[LLSession sharedSession].user.userId,tableNo.text];
    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[tools shared] HUDShowText:@"请稍候..."];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"点餐成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 100000;
            [alert show];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"点餐不成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [[tools shared] HUDShowHideText:@"网络错误！" delay:1.5];
        
    }];
    [operation1 start];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100000) {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 3];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

- (void)updateUI
{
    for (NSInteger i = 0; i < [self.orderArr count]; i ++) {
        Info *carInfo = [self.orderArr objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 30 + (85 * i), 310, 85)];
        [_bgView addSubview:view];
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 65)];
        [logo setImageWithURL:[NSURL URLWithString:carInfo.detailImage]];
        [view addSubview:logo];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logo.right +5, 10, 150, 40)];
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
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bgView.width - 120, nameLabel.bottom + 5, 100, 20)];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:numberLabel];
        
        nameLabel.text = carInfo.name;
        //info.totalPrice
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[carInfo.discountPrice doubleValue]];
        numberLabel.text = [NSString stringWithFormat:@"数量：%d",carInfo.foodNum];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, logo.bottom + 10, view.width - 20, 0.5)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [view addSubview:lineView];
        
    }
    _bgView.frame = CGRectMake(5, 5, 310, 30 + ([self.orderArr count] * 85));
    
    [_bgScroll setContentSize:CGSizeMake(320, _bgView.bottom + 100)];
    
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];

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
