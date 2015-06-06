//
//  RegisterVC.m
//  cheshi
//
//  Created by qiandong on 14-11-21.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "RegisterVC1.h"
#import "MyNavViewController.h"
#import "AppDelegate.h"
#import "NSString+LLStringCategory.h"
#import "UIButton+Additions.h"

@interface RegisterVC1 ()
{
    LLKeyboardAvoidingScrollView  *_mainScroll;
    
    UITextField *_accountField;
    UITextField *_pwdField;
    UITextField *_verifyield;
    UITextField *_repeatPwdField;
    
    NSString *_verifyCode;
}

@end

@implementation RegisterVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
//    [self setHidesBottomBarWhenPushed:YES];
    
    [self.view setBackgroundColor:UIColorFromRGB(0x24232B)];
    
    _mainScroll = [[LLKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [_mainScroll setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    _mainScroll.llDelegate = self;
    _mainScroll.delegate = self;
    [_mainScroll setBackgroundColor:UIColorFromRGB(0x24232B)];
    [self.view addSubview:_mainScroll];
    //初始化
    [_mainScroll resignALlResponse];
    [self resetMainScroll];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_03.png"]];
    [logoImgView setFrame:CGRectMake(UI_SCREEN_WIDTH/2-94/2, 25, 94, 108)];
    [_mainScroll addSubview:logoImgView];
    
    UIFont *TEXT_FONT = [UIFont boldSystemFontOfSize:14];
    
    UIColor *LABEL_COLOR = UIColorFromRGB(0x555555);
    
    float Left_EDGE = UI_SCREEN_WIDTH/2-262/2;
    
    //账号
    UIImageView *accImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filed_bg_long.png"]];
    [accImgView setFrame:CGRectMake(Left_EDGE, logoImgView.top +130, 262, 30)];
    [_mainScroll addSubview:accImgView];
    
    UILabel *accLabel = [[UILabel alloc] initWithFrame:CGRectMake(Left_EDGE+10, accImgView.top, 80, 30)];
    [accLabel setFont:TEXT_FONT];
    [accLabel setText:@"账号"];
    [accLabel setTextColor:LABEL_COLOR];
    [_mainScroll addSubview:accLabel];

    _accountField = [[UITextField alloc] initWithFrame:CGRectMake(Left_EDGE+60, accImgView.top, 190, 30)];
    [_accountField setFont:[UIFont boldSystemFontOfSize:14]];
    [_accountField setTextColor:UIColorFromRGB(0x888888)];
    _accountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x888888)}];
    [_accountField setReturnKeyType:UIReturnKeyNext];
    [_accountField setDelegate:self];
    [_mainScroll addSubview:_accountField];
    
    //验证码
    UIImageView *verifyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filed_bg_short.png"]];
    [verifyImgView setFrame:CGRectMake(Left_EDGE, accImgView.top+45, 161, 33)];
    [_mainScroll addSubview:verifyImgView];
    
    UILabel *verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(Left_EDGE+10, verifyImgView.top, 80, 30)];
    [verifyLabel setFont:TEXT_FONT];
    [verifyLabel setText:@"验证码"];
    [verifyLabel setTextColor:LABEL_COLOR];
    [_mainScroll addSubview:verifyLabel];
    
    _verifyield = [[UITextField alloc] initWithFrame:CGRectMake(Left_EDGE+60, verifyImgView.top, 100, 30)];
    [_verifyield setFont:[UIFont boldSystemFontOfSize:14]];
    [_verifyield setTextColor:UIColorFromRGB(0x888888)];
    _verifyield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x888888)}];
    [_verifyield setReturnKeyType:UIReturnKeyNext];
    [_verifyield setDelegate:self];
    [_mainScroll addSubview:_verifyield];
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setFrame:CGRectMake(Left_EDGE+175, verifyImgView.top, 85, 33)];
    [verifyBtn setBackgroundImage:[UIImage imageNamed:@"register_verify.png"] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(verifySend:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:verifyBtn];
    
    
    //密码
    UIImageView *pwdImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filed_bg_long.png"]];
    [pwdImgView setFrame:CGRectMake(Left_EDGE, verifyImgView.top+45, 262, 33)];
    [_mainScroll addSubview:pwdImgView];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(Left_EDGE+10, pwdImgView.top, 80, 30)];
    [pwdLabel setFont:TEXT_FONT];
    [pwdLabel setText:@"密码"];
    [pwdLabel setTextColor:LABEL_COLOR];
    [_mainScroll addSubview:pwdLabel];
    
    _pwdField = [[UITextField alloc] initWithFrame:CGRectMake(Left_EDGE+60, pwdImgView.top, 190, 30)];
    [_pwdField setFont:[UIFont boldSystemFontOfSize:14]];
    [_pwdField setTextColor:UIColorFromRGB(0x888888)];
    _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x888888)}];
    [_pwdField setReturnKeyType:UIReturnKeyNext];
    [_pwdField setDelegate:self];
    [_mainScroll addSubview:_pwdField];
    
    //重复密码
    UIImageView *repeatPwdImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filed_bg_long.png"]];
    [repeatPwdImgView setFrame:CGRectMake(Left_EDGE, pwdImgView.top+45, 262, 33)];
    [_mainScroll addSubview:repeatPwdImgView];
    
    UILabel *repeatPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(Left_EDGE+10, repeatPwdImgView.top, 80, 30)];
    [repeatPwdLabel setFont:TEXT_FONT];
    [repeatPwdLabel setText:@"密码"];
    [repeatPwdLabel setTextColor:LABEL_COLOR];
    [_mainScroll addSubview:repeatPwdLabel];
    
    _repeatPwdField = [[UITextField alloc] initWithFrame:CGRectMake(Left_EDGE+60, repeatPwdImgView.top, 190, 30)];
    [_repeatPwdField setFont:[UIFont boldSystemFontOfSize:14]];
    [_repeatPwdField setTextColor:UIColorFromRGB(0x888888)];
    _repeatPwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入您的密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x888888)}];
    [_repeatPwdField setReturnKeyType:UIReturnKeyDone];
    [_repeatPwdField setDelegate:self];
    [_mainScroll addSubview:_repeatPwdField];


    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-260/2, repeatPwdImgView.top+60, 260, 33)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"register_btn.png"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(register:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setEnlargeEdgeWithTop:30 right:30 bottom:30 left:30];
    [_mainScroll addSubview:registerBtn];

//    //最下面的线
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,UI_SCREEN_HEIGHT-30,UI_SCREEN_WIDTH/2-30,1)];
//    [line1 setBackgroundColor:UIColorFromRGB(0x63646d)];
//    [_mainScroll addSubview:line1];
//    
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginBtn setBackgroundColor:[UIColor clearColor]];
//    [loginBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-15, UI_SCREEN_HEIGHT-40, 30, 20)];
//    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [loginBtn setTitleColor:UIColorFromRGB(0xe8975f) forState:UIControlStateNormal];
//    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//    [_mainScroll addSubview:loginBtn];
//    
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+30,UI_SCREEN_HEIGHT-30,UI_SCREEN_WIDTH/2-30,1)];
//    [line2 setBackgroundColor:UIColorFromRGB(0x63646d)];
//    [_mainScroll addSubview:line2];
    
}


-(void)verifySend:(id)sender
{
    NSString *account = [_accountField.text clearWhiteSpaceAndNewLine];
    if ([account isEqualToString:@""]) {
        [[tools shared] HUDShowHideText:@"手机号不能为空" delay:1];
        return;
    }
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       account,@"userName",
                                       nil];

    [[RestClient sharedClient] postPath:apiVerify parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSString *code = [JSON valueForKeyPath:@"code"];
        
        if ([code isEqualToString:@"0"]){
            [[tools shared] HUDShowHideText:@"请输入您稍后收到的验证码" delay:1.5];
            NSString *verifyCode = [JSON valueForKeyPath:@"result"];
            _verifyCode = verifyCode;
        }else{
            [[tools shared] HUDShowHideText:@"验证码下发失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];

}



-(void)register:(id)sender
{
//    _accountField.text = @"18857163999";
    _verifyield.text = @"123";
//    _pwdField.text = @"111111";
//    _repeatPwdField.text = _pwdField.text;
    


    
    NSString *account = [_accountField.text clearWhiteSpaceAndNewLine];
    NSString *verifyCode = [_verifyield.text clearWhiteSpaceAndNewLine];
    NSString *pwd = [_pwdField.text clearWhiteSpaceAndNewLine];
    NSString *repeatPwd = [_repeatPwdField.text clearWhiteSpaceAndNewLine];
    
    if ([account isEqualToString:@""] || [pwd isEqualToString:@""] || [repeatPwd isEqualToString:@""]) {
        [[tools shared] HUDShowHideText:@"账号密码不能为空" delay:1];
        return;
    }
    
    if (![pwd isEqualToString:repeatPwd]) {
        [[tools shared] HUDShowHideText:@"2次输入密码不一致" delay:1];
        return;
    }
    
    if(nil == _verifyCode || ![_verifyCode isEqualToString:verifyCode])
    {
        [[tools shared] HUDShowHideText:@"验证码不一致" delay:1];
        return;
    }
    
    [_accountField resignFirstResponder];
    [_pwdField resignFirstResponder];
    [_repeatPwdField resignFirstResponder];
    
    
    
    [[tools shared] HUDShowText:@"正在注册"];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       account,@"userName",
                                       pwd,@"password",
                                       nil];
    
    [[RestClient sharedClient] postPath:apiRegister parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSString *code = [JSON valueForKeyPath:@"code"];
        
        if ([code isEqualToString:@"1"]){
            [[tools shared] HUDShowHideText:@"注册成功" delay:1];
            User *user = [[User alloc] init];
            user.userName = account;
            user.password = pwd;
            [LLSession sharedSession].user = user;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [[tools shared] HUDShowHideText:@"注册失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}


#pragma mark - UItextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _accountField || textField == _pwdField){
        [_mainScroll scrollRectToVisible:CGRectMake(0, 150, _mainScroll.frame.size.width, _mainScroll.frame.size.height) animated:YES];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _accountField) {
        [_verifyield becomeFirstResponder];
    }else if (textField == _verifyield) {
        [_pwdField becomeFirstResponder];
    }else if (textField == _pwdField) {
        [_repeatPwdField becomeFirstResponder];
    }else {
        [_mainScroll resignALlResponse];
        [self resetMainScroll];
    }
    
    return YES;
}

#pragma mark - LLKeyboardAvoidingScrollViewDelegate

-(void)touchBG:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetMainScroll];
}

-(void)resetMainScroll
{
    [_mainScroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT+200)];
    [_mainScroll scrollRectToVisible:CGRectMake(0, 0, _mainScroll.frame.size.width, _mainScroll.frame.size.height) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
