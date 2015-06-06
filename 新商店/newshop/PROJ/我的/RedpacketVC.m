//
//  RedpacketVC.m
//  newshop
//
//  Created by 于洲 on 15/4/22.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "RedpacketVC.h"
#import "AppDelegate.h"
#define NUMBERS @"0123456789.\n"

@interface RedpacketVC ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton  *currentBtn;

@end

@implementation RedpacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"绑定银行卡";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_share.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(boundDetails)];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    self.view.backgroundColor = [UIColor whiteColor];

    [self initForm];
}

- (void)initForm
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, self.view.height - 64 - 50)];
    _scrollView.delegate = self;
    [_scrollView addSubview:_titleTF];
    [self.view addSubview:_scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 30)];
    label.text = @"提现方式:";
    [self.view addSubview:label];
    
    CGFloat width = 50.0 / 3.0;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.layer.cornerRadius = 10;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn setTitle:@"银行卡" forState:UIControlStateNormal];
    [leftBtn setTitle:@"银行卡" forState:UIControlStateSelected];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    leftBtn.tag = 11;
    leftBtn.frame = CGRectMake(15 + 80 + width, 15, 80, 30);
    [leftBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 12;
    rightBtn.layer.cornerRadius = 10;
    rightBtn.layer.masksToBounds = YES;
    
    [rightBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    [rightBtn setTitle:@"支付宝" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(leftBtn.right + width, 15, 80, 30);
    [self.view addSubview:rightBtn];
    
    [self changeClick:leftBtn];
    
}

- (void)changeClick:(UIButton *)btn
{
    if (_currentBtn.tag == btn.tag) {
        return;
    }
    _currentBtn.selected = NO;
    _currentBtn.backgroundColor = [UIColor whiteColor];
    btn.selected = YES;
    btn.backgroundColor = [UIColor redColor];
    _currentBtn = btn;
    [self updateGUI];
}

- (void)updateGUI
{
    for (UIView *view in _scrollView.subviews) {
        
        [view removeFromSuperview];
    }
    
    if (_currentBtn.tag == 11) {
        //银行卡方式
        NSArray *array = @[@"开户行:",@"支行:",@"银行卡号:",@"户名:"];
        
        for (NSInteger i = 0; i < [array count]; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + (45 * i), 80, 30)];
            label.text = [array objectAtIndex:i];
            [_scrollView addSubview:label];
        }
        
        //开户银行
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 80, 15, 290 - 80, 30)];
        _nameTF.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        _nameTF.delegate = self;
        _nameTF.layer.cornerRadius = 7;
        _nameTF.layer.masksToBounds = YES;
        [_scrollView addSubview:_nameTF];
        
        //支行
        _bankTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 80, 15 + 45 * 1, 290 - 80, 30)];
        _bankTF.delegate = self;
        _bankTF.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        _bankTF.layer.cornerRadius = 7;
        _bankTF.layer.masksToBounds = YES;
        [_scrollView addSubview:_bankTF];
        
        //银行卡号
        _IdTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 80, 15 + 45 * 2, 290 - 80, 30)];
        _IdTF.delegate = self;
        _IdTF.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        _IdTF.layer.cornerRadius = 7;
        _IdTF.layer.masksToBounds = YES;
        [_scrollView addSubview:_IdTF];
        
        //户名
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 80, 15 + 45 * 3, 290 - 80, 30)];
        _phoneTF.delegate = self;
        _phoneTF.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        _phoneTF.layer.cornerRadius = 7;
        _phoneTF.layer.masksToBounds = YES;
        [_scrollView addSubview:_phoneTF];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, _phoneTF.bottom + 30, 290, 40)];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"确认绑定" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        [_scrollView setContentSize:CGSizeMake(320, btn.bottom + 20)];
    }else {
        
        //银行卡方式
        NSArray *array = @[@"账号:",@"户名:"];
        
        for (NSInteger i = 0; i < [array count]; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + (45 * i), 80, 30)];
            label.text = [array objectAtIndex:i];
            [_scrollView addSubview:label];
        }
        
        //账号
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 80, 15, 290 - 80, 30)];
        _nameTF.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        _nameTF.delegate = self;
        _nameTF.layer.cornerRadius = 7;
        _nameTF.layer.masksToBounds = YES;
        [_scrollView addSubview:_nameTF];
        
        //户名
        _bankTF = [[UITextField alloc] initWithFrame:CGRectMake(15 + 80, 15 + 45 * 1, 290 - 80, 30)];
        _bankTF.delegate = self;
        _bankTF.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        _bankTF.layer.cornerRadius = 7;
        _bankTF.layer.masksToBounds = YES;
        [_scrollView addSubview:_bankTF];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, _bankTF.bottom + 30, 290, 40)];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"确认绑定" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        [_scrollView setContentSize:CGSizeMake(320, btn.bottom + 20)];
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1010010) {
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}

- (void)btnClick:(UIButton *)btn
{
    /*
    if (_currentBtn.tag == 11) {
        
        if (_nameTF.text.length <= 0 || _IdTF.text.length <= 0 || _phoneTF.text.length <= 0 || _titleTF.text.length <= 0 || _bankTF.text.length <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"输入不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            if ([_titleTF.text doubleValue] > [self.commission doubleValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:            [NSString stringWithFormat:@"您的提示金额不能超过%@元",self.commission] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else {
                NSString *str = [NSString stringWithFormat:@"http://3fxadmin.53xsd.com//mobi/withdraw/apply?memberId=%@&shopId=%d&amount=%@&bankName=%@&bankNo=%@&accountName=%@&childBankName=%@",[User shareUser].userId,SHOP_ID,_titleTF.text,_nameTF.text,_IdTF.text,_phoneTF.text,_bankTF.text];
                
                NSDictionary *dic = @{@"开户行":_nameTF.text,@"支行":_bankTF.text,@"卡号":_IdTF.text,@"户名":_phoneTF.text};
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"银行卡"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.view endEditing:YES];
                [[tools shared] HUDShowText:@"正在提交..."];
                [HttpManager requstWithUrlStr:str WithComplentionBlock:^(id json) {
                    if ([[json objectForKey:@"code"] integerValue] == 0) {
                        
                        [[tools shared] HUDHide];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:            @"申请成功,请等待处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert.tag = 10085;
                        [alert show];
                        
                    }else {
                        [[tools shared] HUDHide];
                        [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
                        
                    }
                }];
            }
        }
        
    }else {
        if (_nameTF.text.length <= 0 || _bankTF.text.length <= 0 || _titleTF.text.length <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"输入不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            if ([_titleTF.text doubleValue] > [self.commission doubleValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:            [NSString stringWithFormat:@"您的提示金额不能超过%@元",self.commission] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else {
                NSString *str = [NSString stringWithFormat:@"http://3fxadmin.53xsd.com//mobi/withdraw/apply?memberId=%@&shopId=%d&amount=%@&bankName=ZHIFUBAO&bankNo=%@&accountName=%@&childBankName=ZHIFUBAO",[User shareUser].userId,SHOP_ID,_titleTF.text,_nameTF.text,_bankTF.text];
                
                NSDictionary *dic = @{@"账号":_nameTF.text,@"户名":_bankTF.text};
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"支付宝"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.view endEditing:YES];
                [[tools shared] HUDShowText:@"正在提交..."];
                [HttpManager requstWithUrlStr:str WithComplentionBlock:^(id json) {
                    if ([[json objectForKey:@"code"] integerValue] == 0) {
                        
                        [[tools shared] HUDHide];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:            @"申请成功,请等待处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert.tag = 10085;
                        [alert show];
                    }else {
                        [[tools shared] HUDHide];
                        [[tools shared] HUDShowHideText:@"提交失败" delay:1.5];
                        
                    }
                }];
            }
        }
        
    }
    */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10085) {
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.isRefresh = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView setContentOffset:CGPointMake(0, textField.top - 10) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
