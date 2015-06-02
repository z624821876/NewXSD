//
//  ImgVC.m
//  Distribution
//
//  Created by 于洲 on 15/3/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ImgVC.h"
#import "UIImageView+AFNetworking.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "WXApi.h"
#import "AFJSONRequestOperation.h"

@interface ImgVC ()
{
    NSArray *UMarr;
    NSDictionary *UMdic;
}
@end

@implementation ImgVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"推广图片";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shared)];
    self.navigationItem.rightBarButtonItem = rightitem;
    
}

- (void)shared
{
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *snsName in UMarr) {
        NSString *displayName = [UMdic valueForKey:snsName];
        [editActionSheet addButtonWithTitle:displayName];
    }
    
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
    
    [editActionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex <= 1) {
        
        //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
        NSString *snsName = [UMarr objectAtIndex:buttonIndex];
        [self shareWith:snsName];

    }

}

- (void)shareWith:(NSString *)snsName
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]];
    UIImage *img = [UIImage imageWithData:data];

    NSString *str = nil;
    if ([snsName isEqualToString:UMShareToWechatTimeline]) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;

    }else {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"新商店";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.imgUrl;
        str = [NSString stringWithFormat:@"有了新商店，同城消费更方便！邀请您快速加入，我们一起赚取新商币。"];
    }

    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:str image:img location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UMarr = [NSArray arrayWithObjects:
                      UMShareToWechatSession,
                      UMShareToWechatTimeline,
                      nil];
    
    UMdic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"微信好友",UMShareToWechatSession,
                         @"微信朋友圈",UMShareToWechatTimeline,
                         nil];

    
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/auth/getImage?memberId=%@",[LLSession sharedSession].user.userId];
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[tools shared] HUDShowText:@"正在加载图片..."];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[tools shared] HUDHide];
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            
            self.imgUrl = [JSON objectForKey:@"result"];
            [self initImgWithURL:[JSON objectForKey:@"result"]];
        }else {
            [[tools shared] HUDShowHideText:@"获取数据失败" delay:1.5];
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        HUDShowErrorServerOrNetwork
    }];
    [operation start];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initImgWithURL:(NSString *)urlStr
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280, self.view.height - 64 - 20 - 20)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [img setImageWithURL:[NSURL URLWithString:urlStr]];
    [self.view addSubview:img];

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
