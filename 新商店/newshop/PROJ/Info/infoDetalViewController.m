
//
//  infoDetalViewController.m
//  JXGY
//
//  Created by ZGP on 14-4-10.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "infoDetalViewController.h"
#import "Collections.h"
#import "Util.h"
#import "UIView+Sizes.h"

#import "UMSocial.h"

#define kTagShareEdit 101
#define kTagSharePost 102

#define RELEASE_OBJECT(obj)  if(obj != nil) { [obj release]; obj = nil; }

@interface infoDetalViewController ()
{
    NSArray *unSelectArray;
    NSArray *selectArray;
    UIButton *currentButton;
    NSArray *array;
//    UITableView *shareTableView;
    
    UIActivityIndicatorView *_activityIndicatorView;
    
    NSString *SHARE_CONTENT;
    NSString *SHARE_URL;

    NSArray *_snsArray;
    NSDictionary *_snsDisplayNameDict;

}
@end

@implementation infoDetalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _snsArray = [NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToEmail,UMShareToSms, nil];
    
    _snsDisplayNameDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"新浪微博",UMShareToSina,
                           @"腾讯微博",UMShareToTencent,
                           @"微信好友",UMShareToWechatSession,
                           @"微信朋友圈",UMShareToWechatTimeline,
                           @"QQ",UMShareToQQ,
                           @"邮件",UMShareToEmail,
                           @"短信",UMShareToSms,
                           nil];

    
    SHARE_CONTENT = [NSString stringWithFormat:@"【机械信息】:%@ %@", self.title, self.strUrl];
    SHARE_URL = _strUrl;
    
    [self.view setBackgroundColor:[Util uiColorFromString:@"#dedfde"]];
    NSURL*url=[[NSURL alloc] initWithString:self.strUrl];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    UIWebView *webView=[[UIWebView alloc] init];
    



    webView.frame=CGRectMake(0,UI_NAVIGATION_BAR_HEIGHT+self.topDistance,UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-44);


    webView.delegate=self;
    [webView loadRequest:request];
    webView.userInteractionEnabled=YES;
    [self.view addSubview:webView];

    array=[[NSArray alloc] initWithObjects:@"tb_2",@"tb_1",@"tb_3", nil];


    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, Height-44, 320, 44)];
    [view setBackgroundColor:[Util uiColorFromString:@"#e9e9e9"]];
    [self.view addSubview:view];
    for (int i=1; i<4; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(107*(i-1)+25,15,23, 21);

        [button addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[array objectAtIndex:i-1] ofType:@"png"]] forState:UIControlStateNormal];
        [view addSubview:button];
    }
    UISwipeGestureRecognizer *leftGes=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doLeft)];
    leftGes.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftGes];
    
    if (self.notShowToolbar == YES) {
        webView.height += view.height;
        [view removeFromSuperview];
    }
    
    [_activityIndicatorView setFrame:CGRectMake(UI_SCREEN_WIDTH/2, (UI_SCREEN_HEIGHT-10 - UI_NAVIGATION_BAR_HEIGHT - UI_TOOL_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)/2 - 10, 20, 20)];
    [self.view addSubview:_activityIndicatorView];
    

}




-(void)doLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dobutton:(UIButton *)but
{
//    shareTableView.hidden = YES;
    
    if (but!=currentButton) {
        currentButton.selected=NO;
        currentButton=but;
    }
    currentButton.selected=YES;
    switch (but.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case 2:
        {
            //收藏
                Collections * temp = [[Collections alloc]init];
                temp.title = self.title;
                temp.url = self.strUrl;
                NSLog(@"9999999=%@,%@",temp.title,temp.url);
                if([Collections searchUniqueByTitle:temp.title])
                {
                    [[tools shared]HUDShowHideText:@"该收藏已存在！" delay:1];
                }
                else
                {
                    if([Collections insert:temp])
                    {
                        [[tools shared]HUDShowHideText:@"收藏成功！" delay:1];
                    }
                    else
                    {
                        [[tools shared]HUDShowHideText:@"收藏失败！" delay:1];
                    }
                }
         
        }
            break;case 3:
        {
            
            UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            for (NSString *snsName in _snsArray) {
                NSString *displayName = [_snsDisplayNameDict valueForKey:snsName];
                [editActionSheet addButtonWithTitle:displayName];
            }
            [editActionSheet addButtonWithTitle:@"取消"];
            editActionSheet.tag = kTagSharePost;
            editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
            [editActionSheet showInView:self.view];
            editActionSheet.delegate = self;

        }

        default:
            break;
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    
    //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName = [_snsArray objectAtIndex:buttonIndex];
    NSLog(@"===%@",SHARE_CONTENT);
    NSString *shareText = SHARE_CONTENT;
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];
    
    if (actionSheet.tag == kTagShareEdit) {
        //设置分享内容，和回调对象
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    } else if (actionSheet.tag == kTagSharePost){
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:shareText image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            } else if(response.responseCode != UMSResponseCodeCancel) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark - webViewDelegate
- (void)loadView {
    [super loadView];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_activityIndicatorView stopAnimating];
    HUDShowErrorServerOrNetwork
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_activityIndicatorView startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activityIndicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
