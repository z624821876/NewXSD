//
//  CompanyStarVC.m

//  Created by lange on 13-8-11.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "InformationViewController.h"
#import "InfoCell.h"
#import "NetService.h"
#import "Info.h"
#import "AKSegmentedControl.h"
#import "Util.h"
#import "UIView+Sizes.h"
#import "infoDetalViewController.h"


@interface InformationViewController ()
{
    //私有成员变量
    NSString *_pageSize;
    NSMutableArray *_dataArray;
    AKSegmentedControl *_segmentedControl;
    
    
    UIButton *_categoryBtn;
    UITableView *_categoryTableView;
    NSDictionary *_categoryDict;
    NSArray *_categoryArray;
    
    float _originTableTop;
    float _originTableHeight;
    
}

@end

@implementation InformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _pageSize = @"10";
    
    _categoryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"app/app.action?cateid=82",              @"机电要闻",
                     @"app/app.action?cateid=410",          @"检测动态",
                     @"app/app.action?cateid=33",          @"特别关注",
                     @"app/app.action?cateid=420",          @"外经贸信息",
                     @"app/app.action?cateid=407",            @"国内热点",
                     @"app/app.action?cateid=118",         @"国际动态",
                     @"app/app.action?cateid=84",            @"招标信息",
                     @"app/app.action?cateid=45",     @"会展信息",
                     @"app/stanard.action?cateid=119",        @"标准动态",
                     nil];
    _categoryArray = [NSArray arrayWithObjects: @"机电要闻",@"检测动态",@"特别关注",@"外经贸信息",@"国内热点",@"国际动态",@"招标信息",@"会展信息",@"标准动态", nil];
    
    _originTableTop = self.tableView.top;
    _originTableHeight = self.tableView.height;
    
    _dataArray = [NSMutableArray arrayWithCapacity:[_pageSize integerValue]];
    
    if (self.outerSearchText != nil) {
        self.tableView.top = _originTableTop - 44;
        self.tableView.height = _originTableHeight + 44;
    }else{
        _segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT+self.topDistance, UI_SCREEN_WIDTH, 44)];
        [_segmentedControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
        [_segmentedControl setSelectedIndex:0];
        [self.view addSubview:_segmentedControl];
        [self setupSegmentedControl];
        self.tableView.top = _originTableTop + 45;
        self.tableView.height = _originTableHeight - 45;
        
        [self buildCategoryButton];
        _categoryBtn.hidden = NO;
        
        _categoryTableView = [[UITableView alloc] init];
        _categoryTableView.frame = CGRectMake(UI_SCREEN_WIDTH/2, _categoryBtn.bottom, 150, 40*8);
        _categoryTableView.delegate=self;
        _categoryTableView.dataSource=self;
        [_categoryTableView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [self.view addSubview:_categoryTableView];
        _categoryTableView.hidden = YES;

    }
    
    if (self.page == 0)
    {
        [self.tableView launchRefreshing];
    }
    
    }

-(void) buildCategoryButton
{
    _categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _categoryBtn.frame=CGRectMake(10, UI_NAVIGATION_BAR_HEIGHT+44+5+self.topDistance, 300, 35);
    [_categoryBtn setTitle:@"请选择分类" forState:UIControlStateNormal];
    [_categoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_categoryBtn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_categoryBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tb_6" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:_categoryBtn];
}

-(void)categoryBtnClicked:(id)sender
{
    if (_categoryTableView.hidden == YES) {
        _categoryTableView.hidden = NO;
    }else{
        _categoryTableView.hidden = YES;
    }
}





//加载数据方法
- (void)loadData
{
    
    
    
    self.refreshing ? self.page=1 : self.page++;
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       _pageSize,@"pageSize",
                                       [NSString stringWithFormat:@"%d", self.page],@"pageNo",
                                       nil];
    if (self.outerSearchText != nil) {
        [params setValue:[self.outerSearchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"keyword"];
    }
    
    
     [NetService getMixObjectDictWithPath:self.serviceurl WithParams:params WithBlock:^(NSDictionary *resultDict, NSString *code, NSString *msg, NSError *error) {
        if (error)  //出错
        {
            HUDShowErrorServerOrNetwork
        }
        else        //成功
        {
            if (self.refreshing)
            {
                self.refreshing = NO;
                [_dataArray removeAllObjects];
            }
            
            NSArray *tmpResultArray = [resultDict valueForKey:@"date"];
            [_dataArray addObjectsFromArray:tmpResultArray];
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
                //self.tableView.headerOnly = YES;
                //self.tableView.footerOnly = YES;
            }
        }
    }];
}

#pragma mark -
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _categoryTableView) {
        return _categoryArray.count;
    }else{
        return _dataArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableView) {
        static NSString *categoryCellIdentifier = @"categoryCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifier];
        }
        cell.textLabel.text = [_categoryArray objectAtIndex:indexPath.row];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }else{
        
        
            static NSString *cellIdentifier = @"infoCell";
            InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell){
                cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if (indexPath.row%2==0) {
                cell.backgroundColor=[Util colorWithHexString:@":#dedfde"];
            }
            else{
                cell.backgroundColor=[Util colorWithHexString:@"#f7f7f7"];
            }
            
            Info *entity = [_dataArray objectAtIndex:indexPath.row];
            cell.cellData = entity;
            
            return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableView) {
        return 40;
    }else{
        if ([self.serviceurl isEqualToString:[tools getServiceUrl:[_categoryDict valueForKey:[_categoryArray objectAtIndex:2]]]]) { //标准动态
            return 65;
        }else{
            return 60;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableView) {
        NSString *url = [_categoryDict valueForKey:[_categoryArray objectAtIndex:indexPath.row]];
        _categoryBtn.titleLabel.text = [_categoryArray objectAtIndex:indexPath.row];
        self.serviceurl = [tools getServiceUrl:url];
        [self.tableView launchRefreshing];
        _categoryTableView.hidden = YES;
    }else{
        
        if ([self.serviceurl isEqualToString:[tools getServiceUrl:[_categoryDict valueForKey:[_categoryArray objectAtIndex:2]]]]) { //标准动态
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            Info * entity = [_dataArray objectAtIndex:indexPath.row];
            infoDetalViewController *detailVC=[[infoDetalViewController alloc] init];
            detailVC.navTitle = @"详情";
//            detailVC.strUrl = entity.info;
            detailVC.title  = entity.title;
            detailVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }else{
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            Info * entity = [_dataArray objectAtIndex:indexPath.row];
            
            infoDetalViewController *detailVC=[[infoDetalViewController alloc] init];
            detailVC.navTitle = @"详情";
//            detailVC.strUrl = entity.url;
            detailVC.title  = entity.title;
            detailVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }

}


#pragma mark -
#pragma mark - Segment setUp & click
- (void)setupSegmentedControl
{
    UIImage *imageNormal = [UIImage imageNamed:@"005.png"];
    UIImage *imagePressed = [UIImage imageNamed:@"004.png"];
    
    // Button 1
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setTitle:@"行业动态" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button1 setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    [button1 setBackgroundImage:imagePressed forState:UIControlStateSelected];
    [button1 setBackgroundImage:imagePressed forState:(UIControlStateHighlighted|UIControlStateSelected)];

    
    // Button 2
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setTitle:@"企业动态" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button2 setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    [button2 setBackgroundImage:imagePressed forState:UIControlStateSelected];
    [button2 setBackgroundImage:imagePressed forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    
    [_segmentedControl setButtonsArray:@[button1, button2]];

}


- (void)segmentedViewController:(id)sender
{

    if ([[_segmentedControl selectedIndexes] firstIndex] == 0) {
        _categoryBtn.titleLabel.text = @"请选类别 ";
        _categoryBtn.hidden = NO;
        self.tableView.top = _originTableTop + 45;
        self.tableView.height = _originTableHeight - 45;
    }else if ([[_segmentedControl selectedIndexes] firstIndex] == 1) {
        _categoryBtn.hidden = YES;
        self.tableView.top = _originTableTop;
        self.tableView.height = _originTableHeight;
    }

    [self changeServiceUrl];
    
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.reachedTheEnd  = NO;
    [self.tableView launchRefreshing];
}

-(void)changeServiceUrl
{
    if ([[_segmentedControl selectedIndexes] firstIndex] == 0) {
//        self.serviceurl= [tools getServiceUrl: [jsonQiYeZiXun stringByAppendingString:@"&cateid=82"]];
    }else if ([[_segmentedControl selectedIndexes] firstIndex] == 1) {
//        self.serviceurl= [tools getServiceUrl: [jsonQiYeZiXun stringByAppendingString:@"&cateid=43"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
