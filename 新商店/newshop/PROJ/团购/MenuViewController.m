//
//  MenuViewController.m
//  newshop
//
//  Created by 于洲 on 15/3/10.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "GroupDescVC.h"

@interface MenuViewController ()
{
    NSMutableArray *_cateArray;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cateArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 0, 220, self.view.height) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self loadCate];
    
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cateArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1000;
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1000];
    Info *cate = [_cateArray objectAtIndex:indexPath.row];
    label.text = cate.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    GroupDescVC *group = (GroupDescVC *)app.menu.rootViewController;
    Info *cate = [_cateArray objectAtIndex:indexPath.row];
    group.shopCateId = cate.id;
    group.currentPage = 1;
    [group loadData];
    [app.menu showRootViewController:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = self.cateName;
    [view addSubview:lab];
    return view;
}

-(void)loadCate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.shopCateId,@"parentId",
                                   nil];
    
    [[RestClient sharedClient] postPath:[tools getServiceUrl:jsonCate] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        

        if (![JSON isKindOfClass:[NSNull class]]) {
            
        NSInteger code = [[JSON objectForKey:@"code"] integerValue];
        
        if (code == 0){
            //得到数据
            [_cateArray removeAllObjects];
            NSArray *tmpResultArray = [JSON valueForKey:@"result"];
            for (NSDictionary *dict in tmpResultArray) {
                Info *cate = [[Info alloc] init];
                cate.id = nilOrJSONObjectForKey(dict, @"id");
                cate.name = nilOrJSONObjectForKey(dict, @"name");
                cate.image = nilOrJSONObjectForKey(dict, @"image");
                [_cateArray addObject:cate];
            }

            [_tableView reloadData];
        }else{
//            [[tools shared] HUDShowHideText:@"读取分类失败" delay:1];
        }
    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    
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
