//
//  AddBoundingShopVC.m
//  newshop
//
//  Created by 于洲 on 15/4/11.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "AddBoundingShopVC.h"
#import "AFJSONRequestOperation.h"

@interface AddBoundingShopVC ()
@property (nonatomic, strong) UITextField *idTF;

@end

@implementation AddBoundingShopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"添加绑定";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 120, 30)];
    label.text = @"请输入商店ID:";
    [self.view addSubview:label];
    
    _idTF = [[UITextField alloc] initWithFrame:CGRectMake(label.right + 5, 30, UI_SCREEN_WIDTH - label.right - 20, 30)];
    _idTF.borderStyle = UITextBorderStyleRoundedRect;
    _idTF.delegate = self;
    [self.view addSubview:_idTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, _idTF.bottom + 20, UI_SCREEN_WIDTH - 30, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClick
{
    [_idTF resignFirstResponder];
    //提交
    if (_idTF.text.length > 0) {
        
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/user/saveShopId?memberId=%@&shopId=%@",[LLSession sharedSession].user.userId,_idTF.text];
        [[tools shared] HUDShowText:@"提交数据中。。。"];
        NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[tools shared] HUDHide];
            _idTF.text = @"";
            
            if ([[JSON objectForKey:@"code"] integerValue] == 0) {
                NSDictionary *dic = [JSON objectForKey:@"result"];
                User *user = [LLSession sharedSession].user;
                user.shopCat = [[dic objectForKey:@"shopCat"] stringValue];
                NSNumber *number = nilOrJSONObjectForKey(dic, @"shopId");
                user.shopID = [number stringValue];
                user.shopName = nilOrJSONObjectForKey(dic, @"shopName");
                user.shopURL = nilOrJSONObjectForKey(dic, @"shopImage");
                [LLSession sharedSession].user = user;
                NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                NSMutableData *data = [[NSMutableData alloc] init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                [archiver encodeObject:user forKey:@"user"];
                [archiver finishEncoding];
                [data writeToFile:path atomically:YES];
                [[tools shared] HUDShowHideText:@"绑定成功" delay:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [[tools shared] HUDShowHideText:@"提交失败!" delay:1.5];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

            [[tools shared] HUDHide];
            HUDShowErrorServerOrNetwork
        }];
        
        [operation start];
    }else {
        [[tools shared] HUDShowHideText:@"输入不能为空" delay:1.5];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
