//
//  AppDelegate.m
//  JXGY
//
//  Created by ZGP on 14-4-9.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavViewController.h"
#import "HomeVC.h"
#import "NearbyVC.h"
#import "GroupBuyVC.h"
#import "PersonCenterVC.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "ComCenterViewController.h"
//#import "ShareEngine.h"
#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialTencentWeiboHandler.h"
#import "AFJSONRequestOperation.h"

#define kAppId           @"zPayDHslMA9rE4MJavgI26"
#define kAppKey          @"1uaQKV5DM3AECHjnSwMo8"
#define kAppSecret       @"pdNd8d47AV8Wsmq34ZqFr"

#define UmengAppkey @"5420d164fd98c515bc01c93c"

#define WXkey       @"wxfcda50ce72d45443"
#define WXSecret    @"acb16f9206040db3124ad2f052f8e4d8"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSLog(@"%@",[NSBundle])
    
//    [[ShareEngine sharedInstance] registerApp];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    _isfirst = YES;
    //打开调试log的开关
//    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    [WXApi registerApp:@"wxfcda50ce72d45443"];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXkey appSecret:WXSecret url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址
    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1103987795" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor blackColor];
    
    [self buildMainTabBar];
    self.window.rootViewController = _mainTabBar;
    [self.window makeKeyAndVisible];
    
    [self preLogin];

    // [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        //        [_viewController logMsg:record];
        NSLog(@"-------------%@,%@",payloadMsg,record);
        
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

    //微信登陆
- (void)preLogin
{
    NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
    DLog(@"%@",path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //登陆过
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        //解档出数据模型Student
        User *model = [unarchive decodeObjectForKey:@"user"];
        [unarchive finishDecoding];//一定不要忘记finishDecoding，否则会报错
        [LLSession sharedSession].user = model;
        [self submitClientIdWithUserId:nil];
        //检测是否有未提交的订单
        [self inspectOrder];
        [self delayUpload];
    }else {
        [self login];
    }
}

- (void)delayUpload
{
    UINavigationController *vc = _mainTabBar.viewControllers[0];
    HomeVC *home = vc.viewControllers[0];
    [home loction];
    
    if (_isfirst) {
        
        // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
        [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
        // [2]:注册APNS
        [self registerRemoteNotification];
        _isfirst = NO;
        
    }
}

#pragma mark - 微信登陆
- (void)login
{
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未安装微信应用,不能进行登陆,请前往iTunes安装微信" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10086;
        [alert show];
    }
}

//根据token 获取用户信息
- (void)getUserInfo
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.accessToken,self.openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSString *name = [dic objectForKey:@"nickname"];
                NSString *unionid = [dic objectForKey:@"unionid"];
                NSString *headimgurl = [dic objectForKey:@"headimgurl"];
                self.unionId = unionid;

                NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/user/thirdAccountLog?from=1&externalNo=%@&externalName=%@&logo=%@",self.unionId,name,headimgurl];
                
                NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlStr];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    if ([[JSON objectForKey:@"code"] integerValue] == 0) {
                        [[tools shared] HUDHide];
                        NSDictionary *dic = [JSON objectForKey:@"result"];
                        if (![dic isKindOfClass:[NSNull class]]) {
                                //用户信息
                            User *user = [[User alloc] init];
                            user.userId = [dic objectForKey:@"id"];
                            user.userName = [dic objectForKey:@"nickname"];
                            user.headUrl = [dic objectForKey:@"logo"];
                            user.referrer = [dic objectForKey:@"name"];
                            user.openId = self.unionId;
                            if (![[dic objectForKey:@"shopId"] isKindOfClass:[NSNull class]]) {
                                user.shopID = [[dic objectForKey:@"shopId"] stringValue];
                                user.shopName = [dic objectForKey:@"shopName"];
                                user.shopURL = [dic objectForKey:@"shopImage"];
                                user.shopCat = [[dic objectForKey:@"shopCat"] stringValue];
                            }
                            [LLSession sharedSession].user = user;
                            //成功
                            NSMutableData *data = [[NSMutableData alloc] init];
                            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                            [archiver encodeObject:user forKey:@"user"];
                            [archiver finishEncoding];
                            NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
                            [data writeToFile:path atomically:YES];
                            [self submitClientIdWithUserId:nil];
                        }
                    }else {
                        [[tools shared] HUDHide];
                        [[tools shared] HUDShowHideText:@"登陆失败" delay:1.5];
                    }
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    HUDShowErrorServerOrNetwork
                }];
                [operation start];
                
//                [HttpManager requstWithUrlStr:str WithComplentionBlock:^(id json) {
//                    
//                    if ([[json objectForKey:@"message"] isEqualToString:@"Login Successed"]) {
//                        NSDictionary *dataDic = [json objectForKey:@"result"];
//                        User *user = [User shareUser];
//                        user.name = name;
//                        user.userId = [dataDic objectForKey:@"id"];
//                        user.logo = [dataDic objectForKey:@"logo"];
//                        user.openId = self.unionId;
//                        
//                        NSMutableData *data = [[NSMutableData alloc] init];
//                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//                        [archiver encodeObject:user forKey:KuserKey];
//                        [archiver finishEncoding];
//                        NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
//                        [data writeToFile:path atomically:YES];
//                        
//                        [self submitClientIdWithUserId:user.userId];
//                    }
//                }];
            }
            
        });
    });
}
                       
#pragma mark - 微信代理协议
-(void) onReq:(BaseReq*)req
{
}

//等三方登陆回调方法
-(void) onResp:(BaseResp*)resp
{
    if (resp.errCode == WXSuccess) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            
            [self delayUpload];
            SendAuthResp *sendResp = (SendAuthResp *)resp;
            _mainTabBar.selectedIndex = 0;
            
            [[tools shared] HUDShowText:@"正在加载数据..."];
            //登陆成功
            NSString *str = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXkey,WXSecret,sendResp.code];
            
            //            //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
            //
            //            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,self.wxCode.text];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *zoneUrl = [NSURL URLWithString:str];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (data) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        self.accessToken = [dic objectForKey:@"access_token"];
                        self.unionId = [dic objectForKey:@"unionid"];
                        self.openId = [dic objectForKey:@"openid"];
                        
                        //根据token  获取用户信息
                        [self getUserInfo];
                    }else {
                        [[tools shared] HUDHide];
                    }
                });
            });
        }else {
            if (resp.errCode == WXSuccess) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            } else {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
            
        }
        
    }
}

//检查未提交的订单
- (void)inspectOrder
{
    id array = [[NSUserDefaults standardUserDefaults] objectForKey:@"支付成功"];
    if ([array isKindOfClass:[NSArray class]]) {
        for (NSString *orderId in array) {
            
            [self submitPayResult:orderId];
        }
    }else {
        NSArray *arr = [NSArray array];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"支付成功"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)submitPayResult:(NSString *)orderId
{
    //支付成功
    NSString *str = [NSString stringWithFormat:@"http://3fxadmin.53xsd.com/mobi/order/completeOrder?orderId=%@",orderId];
    NSString *urlStr =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //    从URL获取json数据
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
        if (code == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 100;
            [alert show];
            
            NSString *backOrderId = [[JSON objectForKey:@"result"] stringValue];
            NSMutableArray *array = [[NSUserDefaults standardUserDefaults]  objectForKey:@"支付成功"];
            [array removeObject:backOrderId];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"支付成功"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.isRefresh = YES;
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您有未提交成功的订单，是否进行提交！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1000000;
            [alert show];
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您有未提交成功的订单，是否进行提交！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000000;
        [alert show];
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000000) {
        if (buttonIndex == 1) {
            
            [self inspectOrder];
        }
    }
    
    if (alertView.tag == 10086) {
        if (buttonIndex == 1) {
                //获取微信iTunes下载地址
            NSString *str = [WXApi getWXAppInstallUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else {
            [self delayUpload];
        }
    }
}

-(void)buildMainTabBar
{
    HomeVC *vc1=[[HomeVC alloc] init];
    MyNavViewController *nav1=[[MyNavViewController alloc] initWithRootViewController:vc1];
    
    NearbyVC *vc2=[[NearbyVC alloc] init];
    MyNavViewController *nav2=[[MyNavViewController alloc] initWithRootViewController:vc2];
    
    GroupBuyVC *vc3=[[GroupBuyVC alloc] init];
    MyNavViewController *nav3=[[MyNavViewController alloc] initWithRootViewController:vc3];
    
    PersonCenterVC *vc4 = [[PersonCenterVC alloc] init];
    MyNavViewController *nav4=[[MyNavViewController alloc] initWithRootViewController:vc4];
    
    NSArray *arr=[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4, nil];
    
    _mainTabBar=[[UITabBarController alloc] init];
    _mainTabBar.delegate=self;
    _mainTabBar.viewControllers=arr;
    
    vc1.navTitle=@"首页";
    vc2.navTitle=@"附近";
    vc3.navTitle=@"团购";
    vc4.navTitle=@"个人中心";
    
//    _mainTabBar.tabBar.barTintColor = [UIColor whiteColor];

    
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"]];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //要appearance的话，得完全定制，包括对齐，偏移等。
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor lightGrayColor],UITextAttributeTextColor,
//                                                       [UIFont boldSystemFontOfSize:11],UITextAttributeFont,
//                                                       [UIColor clearColor],UITextAttributeTextShadowColor,
//                                                       @0.0f,UITextAttributeTextShadowOffset,nil]
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor redColor],UITextAttributeTextColor,
//                                                       [UIFont boldSystemFontOfSize:11],UITextAttributeFont,
//                                                       [UIColor clearColor],UITextAttributeTextShadowColor,
//                                                       @0.0f,UITextAttributeTextShadowOffset,nil]
//                                             forState:UIControlStateSelected];
    
    [nav1.tabBarItem setTitle:@"首页"];
    [nav1.tabBarItem setImage:[UIImage imageNamed:@"tab_1.png"]];
    [nav1.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_1_s.png"]];

    
    [nav2.tabBarItem setTitle:@"附近"];
    [nav2.tabBarItem setImage:[UIImage imageNamed:@"tab_2.png"]];
    [nav2.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_2_s.png"]];
    
    [nav3.tabBarItem setTitle:@"团购"];
    [nav3.tabBarItem setImage:[UIImage imageNamed:@"tab_3.png"]];
    [nav3.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_3_s.png"]];

    
    [nav4.tabBarItem setTitle:@"我的"];
    [nav4.tabBarItem setImage:[UIImage imageNamed:@"tab_4.png"]];
    [nav4.tabBarItem setSelectedImage:[UIImage imageNamed:@"tab_4_s.png"]];

    if (iOS7) {
        
        [nav1.tabBarItem setImage:[[UIImage imageNamed:@"tab_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav1.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_1_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [nav2.tabBarItem setImage:[[UIImage imageNamed:@"tab_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav2.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_2_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        [nav3.tabBarItem setImage:[[UIImage imageNamed:@"tab_3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav3.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_3_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [nav4.tabBarItem setImage:[[UIImage imageNamed:@"tab_4.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav4.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_4_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    }
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]) {//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }

    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    //当程序还在后台运行
    application.applicationIconBadgeNumber = 0;

    if (_islogin) {
        
        // [EXT] 重新上线
        [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
        
        _islogin = NO;
        [self delayUpload];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
    _islogin = YES;
}

- (void)submitClientIdWithUserId:(NSString *)uid
{
    if ([LLSession sharedSession].user.userId != nil && self.clientId != nil) {
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/getui/saveToken?token=%@&userId=%@&uutype=IOS",self.clientId,[LLSession sharedSession].user.userId];
        
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            if ([[JSON objectForKey:@"message"] isEqualToString:@"success!"]) {
                NSLog(@"上传成功");
            }else {
                [self submitClientIdWithUserId:nil];
            }

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [self submitClientIdWithUserId:nil];
            [[tools shared] HUDHide];
        }];
        [operation start];
    }
}

#pragma mark - 推送
//注册通知
- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

- (NSString *)currentLogFilePath
{
    NSMutableArray * listing = [NSMutableArray array];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDirectory error:nil];
    if (!fileNames) {
        return nil;
    }
    
    for (NSString * file in fileNames) {
        if (![file hasPrefix:@"_log_"]) {
            continue;
        }
        
        NSString * absPath = [docsDirectory stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]) {
            if (isDir) {
                [listing addObject:absPath];
            } else {
                [listing addObject:absPath];
            }
        }
    }
    
    [listing sortUsingComparator:^(NSString *l, NSString *r) {
        return [l compare:r];
    }];
    
    if (listing.count) {
        return [listing objectAtIndex:listing.count - 1];
    }
    
    return nil;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //    [_deviceToken release];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
    
    //    [_viewController logMsg:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
//    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
//    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    //    [_viewController logMsg:record];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
//    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            
        } else {
            _sdkStatus = SdkStatusStarting;
        }
        
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        
        _clientId = nil;
        
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher unbindAlias:aAlias];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    
    self.clientId = clientId;
    
    //提交 推送ID
    [self submitClientIdWithUserId:nil];
    
    DLog(@"-----------------%@",self.clientId);
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    //    [[UIApplication sharedApplication] isFirstResponder];
    // [4]: 收到个推消息
    
    self.payloadId = payloadId;
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:payloadMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    DLog(@"%@",record);
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    //    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
    
    DLog(@"%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}

@end
