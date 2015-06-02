//
//  PayVC.m
//  newshop
//
//  Created by qiandong on 15/1/3.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "PayVC.h"
#import "MyCustomScroll.h"
#import "AFJSONRequestOperation.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "AppDelegate.h"

#define NUMBERS @"0123456789.\n"

@interface PayVC ()
{
    UILabel *_balanceLabel;
    NSString *balance;
    
    UITextField *_moneyField;
    UITextField *_pwdField;
    UITextField *_moneyTF;
    MyCustomScroll *scrollView;
    
    NSString    *_partner;
    NSString    *_seller;
    NSString    *_privateKey;
}

@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    balance = @"0";
    [self initGUI];
    
    [self loadBalance];
}

- (void)initGUI
{
    scrollView = [[MyCustomScroll alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 90)];
    [img setImage:[UIImage imageNamed:@"付款界面_banner"]];
    [scrollView addSubview:img];
    
    float CELL_HEIGHT = 40;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, img.bottom + 10, 280, 20)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setText:[NSString stringWithFormat:@"交易日期：%@",dateStr]];

    [scrollView addSubview:label1];
    
    [self drawLine:img.bottom + CELL_HEIGHT];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label1.top+CELL_HEIGHT, 280, 20)];
    [label2 setFont:[UIFont systemFontOfSize:13]];
    [scrollView addSubview:label2];
    [label2 setText:[NSString stringWithFormat:@"商       家：%@",self.shopName]];
    
    [self drawLine:img.bottom + CELL_HEIGHT*2];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, label2.top+CELL_HEIGHT, 280, 20)];
    [_balanceLabel setFont:[UIFont systemFontOfSize:13]];
    [scrollView addSubview:_balanceLabel];
    [_balanceLabel setText:@"新商币余额：0"];
    
    [self drawLine:img.bottom+CELL_HEIGHT*3];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(label1.left, _balanceLabel.top+CELL_HEIGHT, 30, 20)];
    img1.contentMode = UIViewContentModeScaleAspectFit;

    [img1 setImage:[UIImage imageNamed:@"付款界面_01"]];
    [scrollView addSubview:img1];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right + 5, _balanceLabel.top+CELL_HEIGHT, 75, 20)];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [scrollView addSubview:label3];
    [label3 setText:@"使用新商币:"];
    _moneyField = [[UITextField alloc] initWithFrame:CGRectMake(label3.right+5, label3.top, 180, 20)];
    _moneyField.layer.cornerRadius = 1;
    _moneyField.tag = 100000;
    _moneyField.delegate = self;
    [_moneyField setFont:[UIFont systemFontOfSize:13]];
    _moneyField.keyboardType = UIKeyboardTypeDefault;
    [_moneyField setPlaceholder:@"请输入使用新商币金额"];
    [scrollView addSubview:_moneyField];
    [self drawLine:img.bottom+CELL_HEIGHT*4];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(label1.left, label3.top+CELL_HEIGHT, 30, 20)];
    img2.contentMode = UIViewContentModeScaleAspectFit;

    [img2 setImage:[UIImage imageNamed:@"付款界面_02"]];
    [scrollView addSubview:img2];
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right + 5, label3.top+CELL_HEIGHT, 75, 20)];
    [label5 setFont:[UIFont systemFontOfSize:13]];
    [scrollView addSubview:label5];
    [label5 setText:@"使用支付宝:"];
    _pwdField = [[UITextField alloc] initWithFrame:CGRectMake(label5.right+5, label5.top, 180, 20)];
    _pwdField.layer.cornerRadius = 1;
    _pwdField.delegate = self;
    
    [_pwdField setFont:[UIFont systemFontOfSize:13]];
    _pwdField.keyboardType = UIKeyboardTypeDefault;
    [_pwdField setPlaceholder:@"请输入支付金额"];
    [scrollView addSubview:_pwdField];
    [self drawLine:img.bottom+CELL_HEIGHT*5];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(label1.left, label5.top+CELL_HEIGHT, 30, 20)];
    img3.contentMode = UIViewContentModeScaleAspectFit;
    [img3 setImage:[UIImage imageNamed:@"付款界面_03"]];
    [scrollView addSubview:img3];

    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(img3.right + 5, label5.top+CELL_HEIGHT, 75, 20)];
    [label6 setFont:[UIFont systemFontOfSize:13]];
    [scrollView addSubview:label6];
    [label6 setText:@"使 用  现 金:"];
    _moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(label6.right+5, label6.top, 180, 20)];
    _moneyTF.layer.cornerRadius = 1;
    _moneyTF.delegate = self;
    _moneyTF.keyboardType = UIKeyboardTypeDefault;
    [_moneyTF setFont:[UIFont systemFontOfSize:13]];
    [_moneyTF setPlaceholder:@"请输入现金金额"];
    [scrollView addSubview:_moneyTF];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(10, label6.top+CELL_HEIGHT, 300, 35)];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_shopDiscount > 0) {
        [btn1 setTitle:@"确认付款" forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"long_btn.png"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        btn1.layer.cornerRadius = 5;
        btn1.layer.masksToBounds = YES;
        [btn1 setTitle:@"亲,该商家未参加返新商币" forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor grayColor]];
    }
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:btn1];
    
    [scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, textField.top - 20) animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
        if (textField.tag == 100000) {
            if ([balance doubleValue] == 0) {
                return NO;
            }
            NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if ([str doubleValue] > [balance doubleValue]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

-(void)drawLine:(float)top
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, top-0.5, UI_SCREEN_WIDTH-20, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [scrollView addSubview:line];
}

-(void)pay:(id)sender
{
    [scrollView endEditing:YES];

    if (_pwdField.text.length > 0 || _moneyField.text.length > 0 || _moneyTF.text.length > 0) {
        
        [scrollView setContentOffset:CGPointMake(0, 0)];
            //进行支付
        CGFloat moeny1 = [_moneyField.text doubleValue];  //新商币
        CGFloat moeny2 = [_pwdField.text doubleValue];  //支付宝
        CGFloat moeny3 = [_moneyTF.text doubleValue];   //现金
        _pwdField.text = @"";
        _moneyField.text = @"";
        _moneyTF.text = @"";
        [[tools shared] HUDShowText:@"正在提交"];
        NSString *urlStr = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/order/userPay?virtualAmount=%f&cashAmount=%f&alipay=%f&externalNo=%@&shopId=%@&memberId=%@",moeny1,moeny3,moeny2,[LLSession sharedSession].user.openId,self.shopId,[LLSession sharedSession].user.userId];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //    从URL获取json数据
        AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[tools shared] HUDHide];
            NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
            if (code == 0){
                self.orderId = [JSON objectForKey:@"result"];
                //支付成功
                if (moeny2 > 0) {
                    [self doPayWithPrie:moeny2];
                }else {
                    [self submitPayResult];
                }
            }else {
                [[tools shared] HUDShowHideText:@"支付失败" delay:1.5];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[tools shared] HUDHide];
            HUDShowErrorServerOrNetwork
        }];
        [operation1 start];

        
        }else {
        
        [[tools shared] HUDShowHideText:@"支付金额不能为空" delay:1.5];
        return;
    }
}

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
    order.productName = [NSString stringWithFormat:@"%@线下支付",self.shopName]; //商品标题
    order.productDescription = @"无"; //商品描述
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000000) {
        [self submitPayResult];
        return;
    }
    [self LeftAction:nil];
}

- (void)loadBalance
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].user.userId,@"userId",
                                   nil];
    [[tools shared] HUDShowText:@"正在加载..."];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonBalance] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[tools shared] HUDHide];
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            balance = [[[JSON valueForKey:@"result"] valueForKey:@"balance"] stringValue];
            [_balanceLabel setText:[NSString stringWithFormat:@"新商币余额：%@",[NSString stringWithFormat:@"%.2f",[balance doubleValue]]]];
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
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
        }else {
            [[tools shared] HUDShowHideText:@"加载数据失败" delay:1.5];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        HUDShowErrorServerOrNetwork
    }];
    [operation start];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
