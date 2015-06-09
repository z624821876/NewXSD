//
//  PersonCenterVC.m
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "PersonCenterVC.h"
#import "UIButton+Additions.h"
#import "AppDelegate.h"
#import "LLSystemConfig.h"
#import "MyMoneyVC.h"
#import "SetupVC.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "AFJSONRequestOperation.h"
#import "ImgVC.h"
#import "FansVC.h"
#import "AddBoundingShopVC.h"
#import "BoundingShopVC.h"
#import "GroupVC.h"
#import "RedpacketVC.h"

@interface PersonCenterVC ()
{
    UIScrollView *_scrollView;
    
    UIView *_headView;
    UIView *_infoView;
    UIView *_moneyView;
//    UITableView *_tableView;
    UIView *_logoutView;
    
    NSArray *_imgArray;
    NSArray *_titleArray;
    
    UILabel *_accountLabel;
    NSMutableArray *countArray;
}

@end

@implementation PersonCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isRefresh = NO;
    
    _imgArray = [NSArray arrayWithObjects:
                 @"个人中心_01.png",@"个人中心_02.png",@"个人中心_03.png",@"个人中心_04.png",@"个人中心_05.png", nil];

    _titleArray = [NSArray arrayWithObjects:
                   @"我的新商币",@"我要分享给朋友",@"我的粉丝",@"我的订单",@"绑定商家",@"发起配送", nil];
    
    _nwPoint = @"0";
    _orderCount = @"0";
    _fansCount = @"0";
    [self buildNavBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
    __weak PersonCenterVC *vc = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [vc loadData];
    }];
    [_tableView.header beginRefreshing];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([LLSession sharedSession].user.userId == nil) {
        [_tableView reloadData];
        return;
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isRefresh) {
        app.isRefresh = NO;
        [_tableView.header beginRefreshing];
    }
}

- (void)loadData
{
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/user/getUserInfo?memberId=%@",[LLSession sharedSession].user.userId];
    [[tools shared] HUDShowText:@"加载数据中。。。"];
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [_tableView.header endRefreshing];
        [[tools shared] HUDHide];
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [JSON objectForKey:@"result"];
            _nwPoint = [[dic objectForKey:@"newPoint"] stringValue];
            _fansCount = [[dic objectForKey:@"fansCount"] stringValue];
            _orderCount = [[dic objectForKey:@"orderCount"] stringValue];
            
            [_tableView reloadData];
        }else {
            [[tools shared] HUDShowHideText:@"加载数据失败!" delay:1.5];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [_tableView.header endRefreshing];
        [[tools shared] HUDHide];
        HUDShowErrorServerOrNetwork
    }];
    
    [operation start];
}

-(void)buildMoneyView
{
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, _infoView.bottom, UI_SCREEN_WIDTH, 63)];
    [_scrollView addSubview:_moneyView];

    [self drawSpaceView:CGRectMake(0, 0, UI_SCREEN_WIDTH, 10) inView:_moneyView];
    [self drawLine:CGRectMake(0, 9.5, UI_SCREEN_WIDTH, 0.5) inView:_moneyView];
}

-(void)buildOrderView
{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _moneyView.top+10, UI_SCREEN_WIDTH, 43*5)];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [_scrollView addSubview:_tableView];
//    [_tableView reloadData];
}

-(void)buildLogoutView
{
    _logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, UI_SCREEN_WIDTH, 65)];
    [_scrollView addSubview:_logoutView];

    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setFrame:CGRectMake(10, 15, 300, 35)];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"long_btn.png"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [logoutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [_logoutView addSubview:logoutBtn];
    NSLog(@"%f",_logoutView.bottom);
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _logoutView.bottom+UI_NAVIGATION_BAR_HEIGHT+UI_STATUS_BAR_HEIGHT+UI_TAB_BAR_HEIGHT)];

}

#pragma mark -
#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UI_SCREEN_WIDTH*226/640 + 53;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*226/640 + 53);
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*226/640)];
    [bgView addSubview:_headView];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*226/640)];
    [imgView setImage:[UIImage imageNamed:@"person_center_bg.png"]];
    [_headView addSubview:imgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((UI_SCREEN_WIDTH-68)/2, 10, 68, 68);
    btn.layer.cornerRadius = 34;
    btn.layer.masksToBounds = YES;
    NSString *str = [LLSession sharedSession].user.headUrl;
    if ([str isKindOfClass:[NSNull class]]) {
        str = nil;
    }
    [btn setImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"person_avatar.png"]];
    [btn addTarget:self action:@selector(avatarLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:btn];
    
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2, 82, 200, 20)];
    [_accountLabel setFont:[UIFont systemFontOfSize:13]];
    [_accountLabel setTextAlignment:NSTextAlignmentCenter];
    if ([LLSession sharedSession].user.userId != nil) {
        if ([[LLSession sharedSession].user.referrer isKindOfClass:[NSNull class]] || [LLSession sharedSession].user.referrer.length <= 0) {
            [_accountLabel setText:[NSString stringWithFormat:@"%@",[LLSession sharedSession].user.userName]];
        }else {
            [_accountLabel setText:[NSString stringWithFormat:@"%@是被%@推荐的", [LLSession sharedSession].user.userName,[LLSession sharedSession].user.referrer]];
        }
    }else {
        [_accountLabel setText:@"您尚未登录"];
    }
    [_headView addSubview:_accountLabel];
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, 43)];
    [bgView addSubview:_infoView];
    _infoView.backgroundColor = [UIColor whiteColor];
    [self drawLine:CGRectMake(0, _infoView.height-0.5, UI_SCREEN_WIDTH, 0.5) inView:_infoView];
    [self drawLine:CGRectMake(106,0, 0.5, 43) inView:_infoView];
    [self drawLine:CGRectMake(213,0, 0.5, 43) inView:_infoView];
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setFrame:CGRectMake(16, (43-18)/2, 18, 18)];
//    [btn1 setImage:[UIImage imageNamed:@"person_favour.png"] forState:UIControlStateNormal];
//    [btn1 setEnlargeEdgeWithTop:btn1.top right:106-34 bottom:btn1.top left:16];
//    [btn1 addTarget:self action:@selector(myFavour:) forControlEvents:UIControlEventTouchUpInside];
//    [_infoView addSubview:btn1];
//    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(btn1.right+5, btn1.top, 106-34-5, 20)];
//    [label1 setFont:[UIFont systemFontOfSize:14]];
//    [label1 setTextAlignment:NSTextAlignmentLeft];
//    [_infoView addSubview:label1];
//    [label1 setText:@"我的收藏"];
    
    CGFloat width = UI_SCREEN_WIDTH / 3.0;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(0, 0, width, 43)];
    btn1.tag = 11;
    [btn1 setImage:[UIImage imageNamed:@"person_favour.png"] forState:UIControlStateNormal];
    [btn1 setTitle:@"我的粉丝" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(width, 0, UI_SCREEN_WIDTH / 3.0, 43)];
    btn2.tag = 12;
    [btn2 setImage:[UIImage imageNamed:@"person_share.png"] forState:UIControlStateNormal];
    [btn2 setTitle:@"我的推荐" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(width * 2, 0, UI_SCREEN_WIDTH / 3.0, 43)];
    btn3.tag = 13;
    [btn3 setImage:[UIImage imageNamed:@"person_info.png"] forState:UIControlStateNormal];
    [btn3 setTitle:@"我的资料" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn3 addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:btn3];

    return bgView;
}

- (void)topBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 11:
        {
            //我的粉丝
            [self pushWithBlock:^{
                FansVC *fans = [[FansVC alloc] init];
                fans.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fans animated:YES];
            }];
        }
            break;
        case 12:
        {
            //我的订单
            [self pushWithBlock:^{
                GroupVC *vc = [[GroupVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];

        }
            break;

        case 13:
        {
            
        }
            break;

            
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_imgArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personIdentifier = @"personCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personIdentifier];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = 100;
        [imgView setFrame: CGRectMake(15, 13, 20, 18)];
        [cell.contentView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, imgView.top, 80, 20)];
        label.tag = 101;
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
            UILabel *countLable = [[UILabel alloc] init];
            countLable.tag = 101001010;
            countLable.textAlignment = NSTextAlignmentCenter;
            countLable.backgroundColor = [UIColor redColor];
            countLable.textColor = [UIColor whiteColor];
            countLable.text = @"0";
            countLable.font = [UIFont systemFontOfSize:14];
            countLable.layer.cornerRadius = 9;
            countLable.layer.masksToBounds = YES;
            [cell.contentView addSubview:countLable];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UI_SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        [cell.contentView addSubview:lineView];
        
    }
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    if (indexPath.row == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
        [cell.contentView addSubview:view];
    }
    
    NSString *str;
    switch (indexPath.row) {
        case 0:
        {
            str = _nwPoint;
        }
            break;
        case 2:
        {
            str = _fansCount;
        }
            break;

        case 3:
        {
            str = _orderCount;
        }
            break;

            
        default:
            break;
    }
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        CGFloat width = [str boundingRectWithSize:CGSizeMake(100000, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size.width;
        
        UILabel *countlabel = (UILabel *)[cell.contentView viewWithTag:101001010];
        countlabel.text = str;
        countlabel.frame = CGRectMake(label.right, 13, width + 15, 18);
    }
    
    [img setImage:[UIImage imageNamed:[_imgArray objectAtIndex:indexPath.row]]];
    if (indexPath.row == 1) {
        CGRect rect = label.frame;
        rect.size.width = 150;
        label.frame = rect;
        label.textColor = [UIColor redColor];
    }
    label.text = [_titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        return 54;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [self pushWithBlock:^{
                
                MyMoneyVC *vc = [[MyMoneyVC alloc] init];
                vc.navTitle = @"我的新商币";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 1:
        {
            [self pushWithBlock:^{
                ImgVC *img = [[ImgVC alloc] init];
                img.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:img animated:YES];
            }];
        }
            break;

        case 2:
        {
            [self pushWithBlock:^{
                FansVC *fans = [[FansVC alloc] init];
                fans.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fans animated:YES];
                
            }];

        }
            break;
        case 3:
        {
            [self pushWithBlock:^{
                GroupVC *vc = [[GroupVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 4:
        {
            [self pushWithBlock:^{
                if ([LLSession sharedSession].user.shopID == nil) {
                    //去绑定
                    AddBoundingShopVC *vc = [[AddBoundingShopVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];

                }else {
                    //查看已绑定商户信息
                    BoundingShopVC *vc = [[BoundingShopVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
            break;

        case 5:
        {
            
        }
            break;
        case 6:
        {
            RedpacketVC *vc = [[RedpacketVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        default:
            break;
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

////////登陆

-(void)avatarLogin:(id)sender
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }
}

- (void)pushWithBlock:(void(^)())block
{
    if ([LLSession sharedSession].user.userId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未登录，是否进行登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 624821;
        [alert show];
    }else{
        block();
    }
}

-(void)myFavour:(id)sender
{
    NSLog(@"myFavour");
}
-(void)myShare:(id)sender
{
    NSLog(@"myShare");
}
-(void)myInfo:(id)sender
{
    NSLog(@"myInfo");
}

//设置
-(void)buildNavBar
{
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightNavBtn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}

-(void)setting:(id)sender
{
    SetupVC *vc = [[SetupVC alloc] init];
    vc.navTitle = @"设置";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate login];
    }
}

@end
