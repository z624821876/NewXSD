//
//  PayType.m
//  newshop
//
//  Created by sunday on 15/1/21.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "PayTypeNew.h"
#import "Order.h"
#import "FinishPayVC.h"
#import "UIViewController+KNSemiModal.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "APAuthV2Info.h" 
#import "LLSystemConfig.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#define NUMBERS @"0123456789.\n"
@interface PayTypeNew ()
{
    UILabel *_balanceLabel;//可使用新商币（剩余）
    UITextField *_useMoneyTF;//本次使用
    UILabel*_disCountMoneyLabel;//抵扣金钱
    UILabel *_allMoneyLabel;//合计 金钱
    UIButton *_button1;
    UIButton *_button2;
    UIButton *_button3;
    
    UIButton *_payBkutton;
    UIImage *_btnImageOn;
    UIImage *_btnImageOff;
    BOOL _btnStatus;
    UILabel *_prilabel2;
    BOOL _btn2Status;
    
    //UIAlertView *alertView;
    //新商币付款
   
       // UILabel *_balanceLabel;
        
        UITextField *_moneyField;
        UITextField *_pwdField;
    UIScrollView *scrollView;

    
    NSString *_partner;
    NSString *_seller;
    NSString *_privateKey;
    
    
}
@end

@implementation PayTypeNew

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付方式";
    [self setUpViews];
    [self buildFootView];
    [self loadBalance];
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (void)LeftAction:(id)sender
{
    
    if ([self.type isEqualToString:@"订单直接支付"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 3)];
        [self.navigationController popToViewController:VC animated:YES];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    [self.view endEditing:YES];
}

- (void)loadBalance
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].user.userId,@"userId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonBalance] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            NSInteger balance = [[[JSON valueForKey:@"result"] valueForKey:@"balance"] integerValue];
            [_balanceLabel setText:[NSString stringWithFormat:@"新商币余额：%@",[NSString stringWithFormat:@"%i",balance]]];
            self.myBalance = [NSString stringWithFormat:@"%d",balance];
            NSString *pri;
            if ([self.myBalance isKindOfClass:[NSNull class]]) {
                pri = @"0";
                self.myBalance = @"0";
            }else {
                pri = self.myBalance;
            }

            NSString *money;
            if ([self.myBalance doubleValue] > [self.totalPrice doubleValue]) {
                money = self.totalPrice;
            }else {
                money = self.myBalance;
            }

            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        
            nf.numberStyle = kCFNumberFormatterRoundFloor;
            
            NSString *string = [nf stringFromNumber:[NSNumber numberWithDouble:[money doubleValue]]];
            
            [_prilabel2 setText:[NSString stringWithFormat:@"您的账户有新商币%@个,本次可以使用%@个",pri,string]];
            
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        HUDShowErrorServerOrNetwork
    }];
    
    [[tools shared] HUDShowText:@"正在加载..."];
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/getAlipay?shopId=%@",self.shopId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *result = [JSON objectForKey:@"result"];
            _partner = nilOrJSONObjectForKey(result, @"image");
            _seller = nilOrJSONObjectForKey(result, @"name");
            _privateKey = nilOrJSONObjectForKey(result, @"field")
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        HUDShowErrorServerOrNetwork
    }];
    [operation start];

}

- (void)setUpViews
{
    
   scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT + 50);
    [self.view addSubview:scrollView];
    float CELL_HEIGHT = 50;
    float CELL_WIDTH = UI_SCREEN_WIDTH/3;
    [self drawLine:1];
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4+5+5, 30, 30)];
    [scrollView addSubview:image1];
    [image1 setImage:[UIImage imageNamed:@"pic_coins"]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(image1.right+10+0, image1.top-5, CELL_WIDTH+30, CELL_HEIGHT-10)];
    [scrollView addSubview:label1];
    [label1 setText:@"使用新商币支付"];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(self.view.right - 50, image1.top, 30, 30);

    [_button1 setBackgroundImage:[UIImage imageNamed:@"ico_select"] forState:UIControlStateNormal];
    //设置选中时图片
    [_button1 setBackgroundImage:[UIImage imageNamed:@"ico_selected"] forState:UIControlStateSelected];
    [_button1 addTarget:self action:@selector(didButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮的状态是否为选中 (视具体情况而定）
    [_button1 setSelected:NO];
    [scrollView addSubview:_button1];
    
    [self drawLine:5+image1.bottom];
    
    _prilabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, image1.bottom + 4 + 5 + 5, UI_SCREEN_WIDTH-10, CELL_HEIGHT- 20)];
    [_prilabel2 setFont:[UIFont systemFontOfSize:13]];
    [scrollView addSubview:_prilabel2];
    
    NSString *pri;
    if (!self.myBalance) {
        pri = @"0";
    }else {
        pri = self.myBalance;
    }
    
    [_prilabel2 setText:[NSString stringWithFormat:@"您的账户有新商币%@个",pri]];
    //使用
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, _prilabel2.bottom, 40, CELL_HEIGHT)];
    //[label3 setFont:[UIFont systemFontOfSize:16]];
    [scrollView addSubview:label3];
    [label3 setText:@"使用"];
    
    _useMoneyTF = [[UITextField alloc]initWithFrame:CGRectMake(label3.right, _prilabel2.bottom+10, 80, 30)];
    _useMoneyTF.tag = 101;
    _useMoneyTF.borderStyle = UITextBorderStyleLine;
    [_useMoneyTF setEnabled:NO];
    self.useMoney = _useMoneyTF.text;
    _useMoneyTF.delegate = self;
//    _useMoneyTF.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:_useMoneyTF];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(_useMoneyTF.right, _prilabel2.bottom, UI_SCREEN_WIDTH - _useMoneyTF.right, CELL_HEIGHT)];
    [scrollView addSubview:label4];
    [label4 setText:[NSString stringWithFormat:@"个新商币"]];
    [label4 setAdjustsFontSizeToFitWidth:YES];
    [self drawLine:4+label3.bottom + 10];
    
    UIImageView *payImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,4+label3.bottom + 10 + 10, CELL_WIDTH-40, 30)];
    [scrollView addSubview:payImage];
    
    [payImage setImage:[UIImage imageNamed:@"pic_alipay"]];
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(payImage.right+5, payImage.top -5, CELL_WIDTH+30, CELL_HEIGHT-10)];
    [scrollView addSubview:payLabel];
    [payLabel setText:@"使用支付宝支付"];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame = CGRectMake(self.view.right - 50, payImage.top+10, 30, 30);
    
    
    //设置正常时的图片
    [_button2 setBackgroundImage:[UIImage imageNamed:@"ico_select"] forState:UIControlStateNormal];
    //设置选中时图片
    [_button2 setBackgroundImage:[UIImage imageNamed:@"ico_selected"] forState:UIControlStateSelected];
     [_button2 setSelected:NO];
    [_button2 addTarget:self action:@selector(didButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮的状态是否为选中 (是具体情况而定）
   
    [scrollView addSubview:_button2];
    
    [self drawLine:4+payImage.bottom + 10];
}

- (void)didButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    CGFloat money;
    if ([self.totalPrice doubleValue] > [self.myBalance doubleValue]) {
        money = [self.myBalance doubleValue];
    }else {
        money = [self.totalPrice doubleValue];
    }
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    nf.numberStyle = kCFNumberFormatterRoundFloor;
    
    NSString *string = [nf stringFromNumber:[NSNumber numberWithDouble:money]];

    if (button == _button1) {
         button.selected = !button.selected;//每次点击都改变按钮的状态
        if (button.selected) {
            _useMoneyTF.enabled = YES;
            _useMoneyTF.text = string;
            
            //在此实现打钩时的方法
           //[_button1 setSelected:NO];
            NSLog(@"选中button1-");
            //self.color = _buyView.color1.titleLabel.text;
        }else{
            //在此实现不打钩时的方法
            _useMoneyTF.enabled = NO;
            _useMoneyTF.text = nil;
            NSLog(@"没有选中color111 --------");
        }
        //        self.color = _buyView.color1.titleLabel.text;
        //        NSLog(@"color1 ===%@",self.color);
        
    }else if (button == _button2){
         button.selected = !button.selected;// 每次点击都改变按钮的状态
            if (button.selected) {
            //在此实现打钩时的方法
            //[_button2 setSelected:NO];
                NSLog(@"选中button222-");
           
        }else{
            //在此实现不打钩时的方法
            NSLog(@"没有选中color2 --------");
        }
        
    }
}

- (void)click:(id)sender
{
    if (_btnStatus == YES) {
        [_button1 setBackgroundImage:_btnImageOn forState:UIControlStateNormal];
        _useMoneyTF.enabled = YES;
        [_useMoneyTF becomeFirstResponder];
    }else
    {
        [_button1 setBackgroundImage:_btnImageOff forState:UIControlStateNormal];
         _useMoneyTF.enabled = NO;
        [_useMoneyTF resignFirstResponder];
    }
    _btnStatus = !_btnStatus;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 101) {
        //判断是不是删除
        if ([string isEqualToString:@""]) {
            return YES;
        }

        //判断是不是数字和小数点
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [string isEqualToString:filtered];
        if (canChange) {
            if ([self.myBalance doubleValue] == 0) {
                return NO;
            }
            NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
            CGFloat money;
            if ([self.totalPrice doubleValue] > [self.myBalance doubleValue]) {
                money = [self.myBalance doubleValue];
            }else {
                money = [self.totalPrice doubleValue];
            }
            
            if ([str doubleValue] > money) {
                return NO;
            }
                return YES;
            }
        
            return NO;
        }
    
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)drawLine:(float)top
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, top-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [scrollView addSubview:line];
}
- (void)buildFootView
{
    float CELL_WIDTH = UI_SCREEN_WIDTH;
    float CELL_HEIGHT = 50;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-50, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    //[footView setBackgroundColor:[UIColor purpleColor]];
    // NSLog(@"footView：%@",footView.bounds.size);
    [self.view addSubview:footView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:line];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 50, 30)];
    label1.text = @"合计：";
    label1.font = [UIFont systemFontOfSize:14];
    //label1.backgroundColor = [UIColor redColor];
    [footView addSubview:label1];
    
    UILabel *allMoney = [[UILabel alloc]initWithFrame:CGRectMake(label1.right + 4, 15, 120, 30)];
    allMoney.text =[NSString stringWithFormat:@"￥%.2f",[self.totalPrice doubleValue]];
    allMoney.textColor = [UIColor redColor];
    [footView addSubview:allMoney];
    
    UIButton *putInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [putInButton setFrame:CGRectMake(self.view.right-100, 15, 80, 30)];
    [putInButton setTitle:@"付款" forState:UIControlStateNormal];
    //[putInButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.3] forState:UIControlStateNormal];
    putInButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [putInButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [putInButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
    [putInButton addTarget:self action:@selector(didClickedPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:putInButton];
}


#pragma mark -
#pragma mark   ==============产生订单信息==============

- (void)doPayWithPrie:(CGFloat)price
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //Product *product = [self.productList objectAtIndex:0];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner;
    NSString *seller;
    NSString *privateKey;
    if (_partner == nil || _seller == nil || _privateKey == nil) {
        
        partner = @"2088511632111742";
        seller = @"718681293@qq.com";
        privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKSdhgdN5TCVcKQjJZxGK9EQzgpOvdrelBMmIUKiNzcSzlLZXx5WCCwPANp5CUBkOQFY5v+WhnIv/rdcVFbSCWeJ8y7jLIGebcGnnLafQxIWB1/3xwK4rQhne7jUJ/2od4Ac/PXBebjMLsNKHYSdY57zxMW3FcPiGqGLUBKK9hz9AgMBAAECgYEAmtrAoZBqgQijvRR/JgJw56wqV1H5kbJ+k4D0Gu3kiT98rj1kGHKQH3pBsEPaKyPc6GKMc3VTpol10WHeyQmu46A1QztICDkmIsCWg8985wE4kd8UuhGs1vJoDAcRyQ5ZzV/wx7g0hhZi2srzjyL/ujY3Rb5XYLLsqCUO7el9AhUCQQDWFQO7eUQiM2bF6fKncMHXo96453RKqskKuv6MW8BmDq6Pazz0/bu1Q5Hj7eFGCSzXtpwGuUwJEvTu4sYIUGKHAkEAxNj1qmmkDZgJsNcI/UVLskFK9V+JfJeoJKMixFiKT5b7ZMq9btNnZDlsbjpTc2UjJt295wCRInnsXCbLl87xWwJBAL/N0is8acPuo6y8f1BvYOzv/9NQY8umGjuH8BoW9lk53EHYxaOGVZAAuwwoi8Xw4IFgNYh8qdgTaOlCukSmqK8CQG9aT/Yblmr+M5Uuv24OUhi/KLkPV0X8wGghRJyPfYYyYXmN2oUj35vpg/YC1owzjSQCUdeoEXHQSK2EYK06qnsCQFnCXbjl62tmHrdf80nACDuwmptfftof/btBuovhnjdBgPVmLtfa/sHCIGw2gsawj67ksjEVPuUAdCU9GN31kp8=";
        
    }else {
        partner = _partner;
        seller = _seller;
        privateKey = _privateKey;
    }
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.orderId;//订单ID（由商家自行制定）
    order.productName = self.subject; //商品标题
    order.productDescription = self.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"newShopAliPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                
                id data = [[NSUserDefaults standardUserDefaults]  objectForKey:@"支付成功"];
                NSMutableArray *payArr;
                if ([data isKindOfClass:[NSNull class]]) {
                    payArr = [[NSMutableArray alloc] init];
                }
                [payArr addObject:self.orderId];
                [[NSUserDefaults standardUserDefaults] setObject:payArr forKey:@"支付成功"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //提交支付结果
                [self submitPayResult];

        }
            
        }];
        
        
    }
    
    //NSLog(@"付款");
    
    //    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确认支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alertView show];
    
    //    UIImageView *iamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
    //    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 300)];
    //    view.backgroundColor = [UIColor whiteColor];
    //      [self presentSemiView:view withOptions:@{ KNSemiModalOptionKeys.backgroundView:iamgeView}];
    
    
    //    FinishPayVC *finishVC = [[FinishPayVC alloc]init];
    //    finishVC.navTitle = @"完成支付";
    //    [self.navigationController pushViewController:finishVC animated:YES];

}

- (void)submitPayResult
{
    [[tools shared] HUDShowText:@"正在提交..."];
    //支付成功
    NSString *urlStr = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/completeOrder?orderId=%@",self.orderId];
    NSLog(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    从URL获取json数据
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 100;
            [alert show];
            NSMutableArray *array = [[NSUserDefaults standardUserDefaults]  objectForKey:@"支付成功"];
            [array removeObject:self.orderId];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"支付成功"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.isRefresh = YES;
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付结果提交失败，请从新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1000000;
            [alert show];
            
        }
        
        [[tools shared] HUDHide];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付结果提交失败，请从新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1000000;
        [alert show];
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    [operation1 start];

}

- (void)Pay
{
    if (_button1.selected == YES || _button2.selected == YES) {
        CGFloat virtualAmount = [_useMoneyTF.text doubleValue];

        if (_button1.selected == YES && _button2.selected == NO) {
            if (virtualAmount < [self.totalPrice doubleValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"所使用新商币数量小于订单总金额，请使用支付宝进行支付！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/prePay?orderId=%@&virtualAmount=%f&amount=%f&externalNo=%@",self.orderId,virtualAmount,self.totalPrice.doubleValue - virtualAmount,[LLSession sharedSession].user.openId];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //    从URL获取json数据
        AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
            if (code == 0){
                //支付成功
                if ([self.totalPrice doubleValue] > virtualAmount) {
                    [self doPayWithPrie:self.totalPrice.doubleValue - virtualAmount];
                }else {
                    id data = [[NSUserDefaults standardUserDefaults]  objectForKey:@"支付成功"];
                    NSMutableArray *payArr;
                    if ([data isKindOfClass:[NSNull class]]) {
                        payArr = [[NSMutableArray alloc] init];
                    }
                    [payArr addObject:self.orderId];
                    [[NSUserDefaults standardUserDefaults] setObject:payArr forKey:@"支付成功"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self submitPayResult];
                }
            }else {
                [[tools shared] HUDShowHideText:@"支付失败" delay:1.5];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                HUDShowErrorServerOrNetwork
        }];
        [operation1 start];

    }else {
        [[tools shared] HUDShowHideText:@"请选择支付方式" delay:1.5];
    }
    
}

- (void)didClickedPayButtonAction
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否确认付款" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10010;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1000000) {
        [self submitPayResult];
        return;
    }
    
    if (alertView.tag == 10010) {
        if (buttonIndex != 0) {
            [self Pay];
        }
    }
    
    if (alertView.tag == 100) {
        
        if ([self.type isEqualToString:@"订单直接支付"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 3)];
            [self.navigationController popToViewController:VC animated:YES];
        }

    }

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
