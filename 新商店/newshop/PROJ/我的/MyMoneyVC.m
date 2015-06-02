//
//  NearbyVC.m
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "MyMoneyVC.h"

@interface MyMoneyVC ()
{
    UIView *_headView;
    UILabel *_balanceLabel;
    
    NSMutableArray *_dataArray;
}

@end

#define SHOP_CELL_HEIGHT 130

@implementation MyMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    
    [self buildHeadView];
    
    self.tableView.frame = CGRectMake(0, _headView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-_headView.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadBalance];

    [self.tableView launchRefreshing];

}


-(void)buildHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 113+36)];
    [self.view addSubview:_headView];
    
    UILabel *balanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 22, 200, 20)];
    [balanceTitleLabel setFont:[UIFont systemFontOfSize:16]];
    [balanceTitleLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [_headView addSubview:balanceTitleLabel];
    [balanceTitleLabel setText:@"账户余额"];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(balanceTitleLabel.left, 50, 200, 40)];
    [_balanceLabel setFont:[UIFont boldSystemFontOfSize:35]];
    [_balanceLabel setTextColor:[UIColor redColor]];
    [_headView addSubview:_balanceLabel];
    [_balanceLabel setText:@"0.00"];

    
    //
    
    UIView *grayBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 113, UI_SCREEN_WIDTH, 36)];
    [grayBgView setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [_headView addSubview:grayBgView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, grayBgView.height)];
    [redView setBackgroundColor:[UIColor redColor]];
    [grayBgView addSubview:redView];
    
    UILabel *recordTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 200, 20)];
    [recordTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [recordTitleLabel setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [grayBgView addSubview:recordTitleLabel];
    [recordTitleLabel setText:@"最新收支明细"];

    
    [self drawLine:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5) inView:grayBgView];
    [self drawLine:CGRectMake(0, grayBgView.height-0.5, UI_SCREEN_WIDTH, 0.5) inView:grayBgView];
}

- (void)loadBalance
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].user.userId,@"userId",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonBalance] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            CGFloat balance = [[[JSON valueForKey:@"result"] valueForKey:@"balance"] floatValue];
//            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
//            NSString *balanceStr = [formatter stringFromNumber:[NSNumber numberWithInt:balance]];
//            balanceStr = [balanceStr substringFromIndex:1];
            [_balanceLabel setText:[NSString stringWithFormat:@"%.2f",balance]];
        }else{
            [[tools shared] HUDShowHideText:@"读取数据失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}

-(void)loadData
{
    self.refreshing ? self.page=0 : self.page++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].user.userId,@"userId",
                                   [NSString stringWithFormat:@"%d", self.page],@"pageNo",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonRecords] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
            //得到数据
            if (self.refreshing)
            {
                self.refreshing = NO;
                [_dataArray removeAllObjects];
            }
            NSArray *tmpResultArray = [[JSON valueForKey:@"result"] valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *entity = [[Info alloc] init];
                entity.id = nilOrJSONObjectForKey(dict, @"id");
                entity.shopName = nilOrJSONObjectForKey(dict, @"shopName");
                entity.createTime = nilOrJSONObjectForKey(dict, @"createTime");
                entity.balance = [[dict valueForKey:@"balance"] stringValue];
                entity.amount = [[dict valueForKey:@"amount"] stringValue];
                entity.objType = [[dict valueForKey:@"objType"] stringValue];

                [_dataArray addObject:entity];
            }
            if ([tmpResultArray count] == 0 && self.page > 1 )
            {
                [self.tableView tableViewDidFinishedLoadingWithMessage:nil];
                self.tableView.reachedTheEnd  = YES;
            }
            else
            {
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd  = NO;
                [self.tableView reloadData];
            }
            
        }else{
            [[tools shared] HUDShowHideText:@"读取店铺失败" delay:1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}


#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *shopIdentifier = @"shopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    Info *entity = [_dataArray objectAtIndex:indexPath.row];
    
    float SPACE = 8.0f;
    UIColor *color1 = [UIColor colorWithWhite:0.4 alpha:1];
    UIColor *color1_s = [UIColor colorWithWhite:0.1 alpha:1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, SPACE, 60, 20)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setTextColor:color1];
    [cell.contentView addSubview:label1];
    [label1 setText:@"创建时间"];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, SPACE+(20+SPACE)*1, 60, 20)];
    [label2 setFont:[UIFont systemFontOfSize:13]];
    [label2 setTextColor:color1];
    [cell.contentView addSubview:label2];
    [label2 setText:@"收支金额"];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, SPACE+(20+SPACE)*2, 60, 20)];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [label3 setTextColor:color1];
    [cell.contentView addSubview:label3];
    [label3 setText:@"消费类型"];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label1.left, SPACE+(20+SPACE)*3, 60, 20)];
    [label4 setFont:[UIFont systemFontOfSize:13]];
    [label4 setTextColor:color1];
    [cell.contentView addSubview:label4];
    [label4 setText:@"店铺名称"];
    
    UILabel *label1_s = [[UILabel alloc] initWithFrame:CGRectMake(label1.right+15, label1.top, 200, 20)];
    [label1_s setFont:[UIFont systemFontOfSize:13]];
    [label1_s setTextColor:color1_s];
    [cell.contentView addSubview:label1_s];
    [label1_s setText:entity.createTime];
    
    UILabel *label2_s = [[UILabel alloc] initWithFrame:CGRectMake(label2.right+15, label2.top, 200, 20)];
    [label2_s setFont:[UIFont systemFontOfSize:13]];
    [label2_s setTextColor:[UIColor redColor]];
    [cell.contentView addSubview:label2_s];
    [label2_s setText:[NSString stringWithFormat:@"%@新商币",entity.amount]];
    
    UILabel *label3_s = [[UILabel alloc] initWithFrame:CGRectMake(label3.right+15, label3.top, 200, 20)];
    [label3_s setFont:[UIFont systemFontOfSize:13]];
    [label3_s setTextColor:color1_s];
    [cell.contentView addSubview:label3_s];
    if ([entity.objType isEqualToString:@"3"]) {
        [label3_s setText:@"商店购买商品"];
    }else if ([entity.objType isEqualToString:@"2"]) {
        [label3_s setText:@"发放新商币"];
    }
    
    UILabel *label4_s = [[UILabel alloc] initWithFrame:CGRectMake(label4.right+15, label4.top, 200, 20)];
    [label4_s setFont:[UIFont systemFontOfSize:13]];
    [label4_s setTextColor:color1_s];
    [cell.contentView addSubview:label4_s];
    [label4_s setText:entity.shopName];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    [self drawLine:CGRectMake(0, 120, UI_SCREEN_WIDTH, 0.5) inView:cell.contentView];
    [self drawSpaceView:CGRectMake(0, 120.5, UI_SCREEN_WIDTH, 9) inView:cell.contentView];
    [self drawLine:CGRectMake(0, 129.5, UI_SCREEN_WIDTH, 0.5) inView:cell.contentView];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHOP_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)drawLine:(CGRect)rect inView:(UIView *)view
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
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
