//
//  BaseVC.m
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "BaseTableVC.h"

@interface BaseTableVC ()

@end

@implementation BaseTableVC

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
    // Do any additional setup after loading the view from its nib.
    
    
    //tableview设置

    _tableView = [[PullingRefreshTableView alloc]initWithFrame:
                  CGRectMake(0,
                             UI_NAVIGATION_BAR_HEIGHT+self.topDistance,
                             UI_SCREEN_WIDTH,
                             UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)
                                               pullingDelegate:self];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -
#pragma mark - PullingRefreshTableViewDelegate
//PullingRefreshTableView delegate方法
//下拉
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

//上拖
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark - ScrollView Method
//scrollView delegate方法（PullingRefreshTableView implement它来画Header和footer）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

//scrollView delegate方法（PullingRefreshTableView implement它来画Header和footer）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
