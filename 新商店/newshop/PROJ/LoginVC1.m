//
//  TTVC.m
//  cheshi
//
//  Created by qiandong on 14/11/13.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "LoginVC1.h"
#import "MyNavViewController.h"
#import "AppDelegate.h"
#import "NSString+LLStringCategory.h"
#import "RegisterVC.h"
#import "LLSystemConfig.h"

@interface LoginVC1 ()
{
    LLKeyboardAvoidingScrollView  *_mainScroll;
    
    UITextField *_accountField;
    UITextField *_pwdField;
}

@end

@implementation LoginVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;

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
    [logoImgView setFrame:CGRectMake(UI_SCREEN_WIDTH/2-94/2, 70, 94, 108)];
    [_mainScroll addSubview:logoImgView];
    
    //账号
    UIImageView *accImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_04.png"]];
    [accImgView setFrame:CGRectMake(UI_SCREEN_WIDTH/2-260/2, 250, 260, 33)];
    [_mainScroll addSubview:accImgView];

    _accountField = [[UITextField alloc] initWithFrame:CGRectMake(accImgView.left+50, accImgView.top+5, 190, 24)];
    [_accountField setFont:[UIFont boldSystemFontOfSize:14]];
    [_accountField setTextColor:UIColorFromRGB(0x888888)];
    _accountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x888888)}];
    [_accountField setReturnKeyType:UIReturnKeyNext];
    [_accountField setDelegate:self];
    [_mainScroll addSubview:_accountField];

    //密码
    UIImageView *pwdImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_05.png"]];
    [pwdImgView setFrame:CGRectMake(UI_SCREEN_WIDTH/2-260/2, 300, 260, 33)];
    [_mainScroll addSubview:pwdImgView];
    
    _pwdField = [[UITextField alloc] initWithFrame:CGRectMake(pwdImgView.left+50, pwdImgView.top+5, 190, 24)];
    [_pwdField setSecureTextEntry:YES];
    [_pwdField setFont:[UIFont boldSystemFontOfSize:14]];
    [_pwdField setTextColor:UIColorFromRGB(0x888888)];
    _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x888888)}];
    [_pwdField setReturnKeyType:UIReturnKeyDone];
    [_pwdField setDelegate:self];
    [_mainScroll addSubview:_pwdField];
    
    //登陆按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-260/2, 370, 260, 33)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_06.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:loginBtn];
    
    
    //最下面的线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,UI_SCREEN_HEIGHT-30,UI_SCREEN_WIDTH/2-30,1)];
    [line1 setBackgroundColor:UIColorFromRGB(0x63646d)];
    [_mainScroll addSubview:line1];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundColor:[UIColor clearColor]];
    [registerBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-15, UI_SCREEN_HEIGHT-40, 30, 20)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:UIColorFromRGB(0xe8975f) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(register:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:registerBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+30,UI_SCREEN_HEIGHT-30,UI_SCREEN_WIDTH/2-30,1)];
    [line2 setBackgroundColor:UIColorFromRGB(0x63646d)];
    [_mainScroll addSubview:line2];

}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _accountField.text = [LLSystemConfig KeychainGetUserName];
    _pwdField.text = [LLSystemConfig KeychainGetLoginPwd];
}

-(void)register:(id)sender
{
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.navTitle = @"注册";
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) login:(id)sender
{
//    _accountField.text = @"18857163176";
//    _pwdField.text = @"111111";
    
    NSString *account = [_accountField.text clearWhiteSpaceAndNewLine];
    NSString *pwd = [_pwdField.text clearWhiteSpaceAndNewLine];
    
    if ([account isEqualToString:@""] || [pwd isEqualToString:@""]) {
        [[tools shared] HUDShowHideText:@"账号密码不能为空" delay:1];
        return;
    }

    [_accountField resignFirstResponder];
    [_pwdField resignFirstResponder];
    
    
    
    [[tools shared] HUDShowText:@"正在登录"];
    
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       account,@"userName",
                                       pwd,@"password",
                                       nil];
    
    [[RestClient sharedClient] postPath:apiLogin parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSString *code = [JSON valueForKeyPath:@"code"];
        
        if ([code isEqualToString:@"0"]){
            [[tools shared] HUDHide];
            
            NSDictionary *resultDict = nilOrJSONObjectForKey(JSON,@"result");
            NSString *user_id = [resultDict valueForKeyPath:@"id"];
            User *user = [[User alloc] init];
            user.id = user_id;
            user.userName = account;
            user.password = pwd;
            [LLSession sharedSession].user = user;

            [LLSystemConfig KeychainSaveUserName:account Password:pwd];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = appDelegate.mainTabBar;
            [appDelegate.window makeKeyAndVisible];
            
        }else{
            [[tools shared] HUDShowHideText:@"登陆失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];

}

#pragma mark - UItextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _accountField || textField == _pwdField){
        [_mainScroll scrollRectToVisible:CGRectMake(0, 200, _mainScroll.frame.size.width, _mainScroll.frame.size.height) animated:YES];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _accountField) {
        [_pwdField becomeFirstResponder];
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
