//
//  FansVC.m
//  Distribution
//
//  Created by 于洲 on 15/3/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "FansVC.h"
#import "MJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "AFJSONRequestOperation.h"

@interface FansVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end


static NSInteger __currentPage;
@implementation FansVC

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"我的粉丝";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, self.view.height - 64 - 20) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    __weak FansVC *vc = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        //下拉刷新
        __currentPage = 1;
        [vc loadData];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        //上拉加载
        __currentPage += 1;
        [vc loadData];
    }];
    
    
    __currentPage = 1;
    [self loadData];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/user/getMyFans?memberId=%@&pageNo=%d&pageSize=20",[LLSession sharedSession].user.userId,__currentPage];
    [[tools shared] HUDShowText:@"加载数据中。。。"];
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (__currentPage == 1) {
            [_dataArray removeAllObjects];
        }
        if ([[JSON objectForKey:@"code"] integerValue] == 0) {
            NSArray *array = [JSON objectForKey:@"result"];
            if ([array isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in array) {
                    Info *info = [[Info alloc] init];
                    info.logo = [dic objectForKey:@"logo"];
                    info.createTime = [dic objectForKey:@"regTime"];
                    info.name = [dic objectForKey:@"nickname"];
                    [_dataArray addObject:info];
                }
                if ([array count] == 0) {
                    
                    __currentPage -= 1;
                }
            }
            if (__currentPage == 1) {
                
                [_tableView.header endRefreshing];
            }else {
                [_tableView.footer endRefreshing];
            }
        }else {
            if (__currentPage == 1) {
                
                [_tableView.header endRefreshing];
            }else {
                [_tableView.footer endRefreshing];
                __currentPage -= 1;
            }
        }
        
        [_tableView reloadData];
        [[tools shared] HUDHide];

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [[tools shared] HUDHide];
        if (__currentPage == 1) {
            
            [_tableView.header endRefreshing];
        }else {
            __currentPage -= 1;
            [_tableView.footer endRefreshing];
        }
        HUDShowErrorServerOrNetwork

    }];
    [operation start];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        img.layer.cornerRadius = 20;
        img.tag = 11;
        [cell.contentView addSubview:img];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 5, 10, cell.width - 55 - 10, 20)];
        nameLabel.tag = 12;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 5, 30, 200, 20)];
        label.tag = 13;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithWhite:0.6 alpha:0.6];
        [cell.contentView addSubview:label];
    }
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:11];
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:12];
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:13];

    Info *info = [_dataArray objectAtIndex:indexPath.row];
    [img setImageWithURL:[NSURL URLWithString:info.logo]];
    name.text = info.name;
    
    timeLabel.text = [NSString stringWithFormat:@"注册时间:%@",info.createTime];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
