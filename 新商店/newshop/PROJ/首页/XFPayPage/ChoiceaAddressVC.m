//
//  ChoiceaAddressVC.m
//  newshop
//
//  Created by sunday on 15/2/4.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ChoiceaAddressVC.h"
#import "AFNetworking.h"
#import "AFNetworking.h"

#import "XFAddressCell.h"
@interface ChoiceaAddressVC ()
{
    UITableView *_tableView;
    NSMutableArray *_addressArray;
    NSMutableArray *_checkArray;
    UIButton *_memoButton;
    Info *_currentAdd;
    NSInteger index;
}
@end

@implementation ChoiceaAddressVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //是否被选中
    _checkArray = [[NSMutableArray alloc]initWithCapacity:5];
    [self buildNavBar];
    _addressArray = [[NSMutableArray alloc]initWithCapacity:5];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
-(void)buildNavBar
{
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightNavBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setBackgroundImage:[UIImage imageNamed:@"02_031"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void)addAction:(id)sender
{
    AddAddressVC *addVC = [[AddAddressVC alloc]init];
//    addVC.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
   }

//加载数据
- (void)loadData
{
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [LLSession sharedSession].user.userId,@"memberId",nil];
        [[RestClient sharedClient] postPath:[tools getServiceUrl:seleceAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
            //返回值{"ok":true,"code":0,"message":"操作成功!","result":1}
            NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
            
            if (code == 0) {
                NSArray *resultArray = nilOrJSONObjectForKey(JSON, @"result");
                if (resultArray.count !=0) {
                    [_addressArray removeAllObjects];
                    for (NSDictionary *address in resultArray) {
                        Info *info = [[Info alloc]init];
                        info.address = nilOrJSONObjectForKey(address, @"address");
                        info.id = [[address objectForKey:@"id"]stringValue];
                        info.mobile = nilOrJSONObjectForKey(address, @"mobile");
                        info.name = nilOrJSONObjectForKey(address, @"name");
                        info.id = [[address objectForKey:@"id"]stringValue];
                        info.isDeleted =[[address objectForKey:@"isDelete"]stringValue];
                        if ([info.isDeleted isEqualToString:@"1"] || [info.isDeleted isEqualToString:@"2"]) {
                            [_addressArray addObject:info];
                        }
                    }
                    [_tableView reloadData];
                }else{
                    [[tools shared]HUDShowHideText:@"您还未添加地址，马上添加" delay:0.5];//跳转到添加地址界面
                    AddAddressVC *addVC = [[AddAddressVC alloc]init];
                    addVC.navTitle = @"添加地址";
                    [self.navigationController pushViewController:addVC animated:YES];
                }
            }else
            {
                [[tools shared]HUDShowHideText:@"获取数据失败" delay:0.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HUDShowErrorServerOrNetwork
        }];
    }

#pragma mark ----tableDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_addressArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell";
   XFAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XFAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    
    }
    Info *info = _addressArray[indexPath.row];

    cell.info = info;
    if ([info.isDeleted isEqualToString:@"2"]) {
        [cell.checkButton setHidden:NO];
         return cell;
    }
    [cell.checkButton setHidden:YES];
    return cell;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-----自定义的按钮");
}
//删除
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Info *address = [_addressArray objectAtIndex:indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"http://admin.53xsd.com/mobi/address/delete?id=%@",address.id];
        NSLog(@"%@",str);
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //    从URL获取json数据
        AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSInteger code = [[JSON objectForKey:@"code"] integerValue];
            if (code == 0) {
//                NSLog(@"删除成功");
                [self loadData];
                [[tools shared]HUDShowHideText:@"删除成功" delay:0.5];

            }else {
                [[tools shared]HUDShowHideText:@"操作失败" delay:0.5];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            HUDShowErrorServerOrNetwork
        }];
        
        [operation1 start];
        
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       [LLSession sharedSession].user.id,@"memberId",nil];
//        
//        [[RestClient sharedClient] postPath:[tools getServiceUrl:seleceAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
//            //返回值{"ok":true,"code":0,"message":"操作成功!","result":1}
//            NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
//            if (code == 0) {
//                NSArray *resultArray = nilOrJSONObjectForKey(JSON, @"result");
//                if (resultArray != nil) {
//                    [_addressArray removeAllObjects];
//                    for (NSDictionary *address in resultArray) {
//                        Info *info = [[Info alloc]init];
//                        info.address = nilOrJSONObjectForKey(address, @"address");
//                        info.id = [[address objectForKey:@"id"]stringValue];
//                        info.mobile = nilOrJSONObjectForKey(address, @"mobile");
//                        info.name = nilOrJSONObjectForKey(address, @"name");
//                        info.isDeleted = nilOrJSONObjectForKey(address, @"isDelete");
//                        [_addressArray addObject:info];
//                    }
//                    [_tableView reloadData];
//                }else{
//                    [[tools shared]HUDShowHideText:@"您还未添加地址，马上添加" delay:0.5];//跳转到添加地址界面
//                    AddAddressVC *addVC = [[AddAddressVC alloc]init];
//                    addVC.navTitle = @"添加地址";
//                    [self.navigationController pushViewController:addVC animated:YES];
//                }
//            }else
//            {
//                [[tools shared]HUDShowHideText:@"获取数据失败" delay:0.5];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            HUDShowErrorServerOrNetwork
//        }];
//
//        [_addressArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    Info *add = [_addressArray objectAtIndex:indexPath.row];
    if ([add.isDeleted isEqualToString:@"2"]) {
        return;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否将此地址设为默认地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        index = indexPath.row;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else {
        NSString *userID = [LLSession sharedSession].user.userId;
        Info *shop = [_addressArray objectAtIndex:index];
        NSString *str=[NSString stringWithFormat:@"http://admin.53xsd.com/mobi/address/edit?memberId=%@&addressId=%@&isDelete=2",userID,shop.id];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //    从URL获取json数据
        AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];

            if (code == 0) {
                [self loadData];
                [[tools shared] HUDShowHideText:@"设置成功" delay:1.0];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"发生错误！%@",error);
        }];

        [operation1 start];
        
    
    }
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
