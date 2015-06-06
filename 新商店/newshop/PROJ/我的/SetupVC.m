//
//  SetupVC.m
//  newshop
//
//  Created by qiandong on 15-1-9.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "SetupVC.h"
#import "LLSystemConfig.h"
#import "AppDelegate.h"
@interface SetupVC ()
{
    UIScrollView *_scrollView;
    
    UITableView *_tableView;
    NSArray *_imgArray;
    NSArray *_titleArray;
}

@end

@implementation SetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgArray = [NSArray arrayWithObjects:
                 @"set_push.png",@"set_nightmode.png",@"set_wifiimage.png",@"set_clearbuff.png",@"set_about.png",@"set_comment.png",@"set_scoreme.png",@"set_update.png", nil];
    _titleArray = [NSArray arrayWithObjects:
                   @"消息推送",@"夜间模式",@"仅wifi下载图片",@"清除缓存",@"关于新商店",@"意见反馈",@"给我评分",@"检查更新", nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*1.5)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [self drawLine:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5) inView:_scrollView];
    [self drawSpaceView:CGRectMake(0, 0.5, UI_SCREEN_WIDTH, 9) inView:_scrollView];
    [self drawLine:CGRectMake(0, 9.5, UI_SCREEN_WIDTH, 0.5) inView:_scrollView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, UI_SCREEN_WIDTH, 44*_imgArray.count+10)];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
    
    
    
    
    [_tableView reloadData];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setFrame:CGRectMake(10, _tableView.bottom+15, 300, 35)];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"long_btn.png"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [logoutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:logoutBtn];
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, logoutBtn.bottom+UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT+UI_TAB_BAR_HEIGHT)];
}

-(void)logout:(id)sender
{
    if ([LLSession sharedSession].user.userId != nil) {
        
        NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
        
        BOOL isLogout = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (isLogout) {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.isRefresh = YES;
            [LLSession sharedSession].user = [[User alloc] init];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"退出登录成功，是否重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 624821;
            [alert show];
        }else {
            [[tools shared] HUDShowHideText:@"退出登录失败" delay:1.5];
            
        }

    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imgArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personIdentifier = @"personCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    NSString *img = [_imgArray objectAtIndex:indexPath.row];
    NSString *title = [_titleArray objectAtIndex:indexPath.row];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame: CGRectMake(15, 13, 20, 17)];
    [cell.contentView addSubview:imgView];
    [imgView setImage:[UIImage imageNamed:img]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, imgView.top, 150, 20)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:label];
    [label setText:title];
    
    if (indexPath.row < 3) {
        UISwitch *swit = [[UISwitch alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-60, 6, 30, 15)];
        [swit setOn:YES];
        if (indexPath.row == 1) {
            [swit setOn:NO];
        }
        [cell.contentView addSubview:swit];
    }else if(indexPath.row == 3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-45, imgView.top, 45, 20)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
        [label setText:@"1.5M"];
    }else{
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-23, imgView.top+2, 8, 13)];
        [arrowImgView setImage:[UIImage imageNamed:@"arrow.png"]];
        [cell.contentView addSubview:arrowImgView];
    }
    
    if (indexPath.row == 3) {
        [self drawLine:CGRectMake(0, 44, UI_SCREEN_WIDTH, 0.5) inView:cell.contentView];
        [self drawSpaceView:CGRectMake(0, 44.5, UI_SCREEN_WIDTH, 9) inView:cell.contentView];
        [self drawLine:CGRectMake(0, 53.5, UI_SCREEN_WIDTH, 0.5) inView:cell.contentView];
    }
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 54;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        [self checkUpdate];
    }
}

-(void)checkUpdate
{
    [[tools shared] HUDShowText:@"正在查询新版本"];
    //异步检查更新版本
    NSString *URL = sVersionURL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *resopnse, NSData *data, NSError *error) {
        if (data)
        {
        
            NSPropertyListFormat format;
            NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:&error];
            NSString* version;
            NSString* versionInfo;
            for(NSString*  key in dict){
                version = [[NSString alloc] initWithFormat:@"%@",key];
                NSLog(@"%@",version);
                NSMutableArray *templist=[dict objectForKey:key];
                versionInfo=[templist objectAtIndex:0];
                break;
            }
            [self performSelectorOnMainThread:@selector(VersionAlert:) withObject:[NSArray arrayWithObjects:version,versionInfo,nil]  waitUntilDone:NO];
            
        }
    }];
}

-(void)VersionAlert:(NSArray *)array{
    NSString *version = [array objectAtIndex:0];
    NSString *versionInfo = [array objectAtIndex:1];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    [[tools shared] HUDHide];
    if (version!=nil&&![version isEqualToString:@""]&&![version isEqualToString:currentVersion]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"版本%@更新",version] message:versionInfo delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"稍后提醒", nil];
        [alert show];
    }else{
        [[tools shared] HUDShowHideText:@"当前应用已经为最新版本无须在更新！" delay:1];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 624821) {
        if (buttonIndex == 1) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate login];
        }
    }else {
        if(buttonIndex==0)
        {
            NSURL *aURL = [NSURL URLWithString:sVersionDownloadURL];
            [[UIApplication sharedApplication] openURL:aURL];
        }

    }
}

-(void)drawLine:(CGRect)rect inView:(UIView *)view
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [view addSubview:line];
}

-(void)drawSpaceView:(CGRect)rect inView:(UIView *)view
{
    UIView *spaceView = [[UIView alloc] initWithFrame:rect];
    [spaceView setBackgroundColor:[UIColor colorWithWhite:0.961 alpha:1]];
    [view addSubview:spaceView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
