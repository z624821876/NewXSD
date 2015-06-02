//
//  XFConfimBooksVC.m
//  newshop
//
//  Created by sunday on 15/1/26.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "FoodConfirmVC.h"
#import "XFProductCell.h"
#import "PayTypeNew.h"

#import "AddAddressVC.h"
#import "ChoiceaAddressVC.h"
@interface FoodConfirmVC ()
{
    UITableView *_tableView;
    
    NSMutableArray *_productsArray;
    // NSString *_shopName;
    
    UILabel  *_receiveName;
    UILabel *_receiveAddress;
    UILabel *_receiveNumber;
    UILabel *userMessageLabel;
    
    NSMutableArray *_addressAdrray;
    
    
}
@end

@implementation FoodConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _productsArray = [[NSMutableArray alloc]initWithCapacity:5];
    _addressAdrray = [[NSMutableArray alloc]initWithCapacity:5];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-20-44-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self loadAddress];//加载地址
}

//加载数据  shopId 和UserId 拼接接口
- (void)loadData
{
    //[_productsArray removeAllObjects];
    //[_productsArray arrayByAddingObjectsFromArray:self.productArray]  ;
    [_tableView reloadData];
    [self buildFootView];//此处添加下方view
}


-(void)buildFootView
{
    //float CELL_WIDTH = UI_SCREEN_WIDTH;
    float CELL_HEIGHT = 50;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-50, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    [self.view addSubview:footView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:line];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 50, 30)];
    label1.text = @"合计：";
    label1.font = [UIFont systemFontOfSize:14];
    [footView addSubview:label1];
    
    UILabel *allMoney = [[UILabel alloc]initWithFrame:CGRectMake(label1.right + 4, 15, 120, 30)];
    allMoney.textColor = [UIColor redColor];
    [allMoney setText:[NSString stringWithFormat:@"￥%@.00",self.totalPrice]];
    [footView addSubview:allMoney];
    
    UIButton *putInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [putInButton setFrame:CGRectMake(self.view.right-120, 15, 110, 30)];
    [putInButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
    [putInButton setTitle:@"提交订单" forState:UIControlStateNormal];
    
    putInButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [putInButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [putInButton addTarget:self action:@selector(putInBook2) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:putInButton];
}
- (void)putInBook2{
    
    //提交订单
    NSString *userId = [LLSession sharedSession].user.userId;
    NSMutableDictionary *params;
    NSString *url ;
    Info *address = _addressAdrray[0];
    
        //color是从后台读取的数据   此时暂定为1
        [params removeAllObjects];
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  userId,@"userId" ,self.shopId,@"shopId"
                  ,address.id,@"addrId",self.memo,@"memo",nil];
        url = [tools getServiceUrl:buyNowGoPay];
        // NSLog(@"立即购买提交生成订单++++%@",[tools getServiceUrl:buyNowGoPay]);
        
    [[RestClient sharedClient] postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        NSString *message = nilOrJSONObjectForKey(JSON, @"message");
        if (code == 0){
            NSDictionary *result = [JSON valueForKey:@"result"];
            if (result != nil && [message isEqualToString:@"操作成功!"]) {
                Info *books = [[Info alloc]init];
                books.createTime = nilOrJSONObjectForKey(result, @"createTime");
                books.orderNo = [result objectForKey:@"orderNo"];
                books.status = [result objectForKey:@"status"];
                //NSLog(@"订单提交后返回数据books.createTime=%@,books.orderNo=%@%@",books.createTime,books.orderNo, books.status);
                [[tools shared]HUDShowHideText:@"订单提交成功，马上去付款！" delay:1];
                PayTypeNew *typeVC = [[PayTypeNew alloc]init];
                typeVC.navTitle = @"支付方式";
                typeVC.totalPrice = [NSString stringWithFormat:@"%.0f",[self.totalPrice doubleValue] + 10];
                typeVC.orderId=[result objectForKey:@"id"];
                typeVC.subject=@"需要接口确认商品标题";
                typeVC.body=@"需要接口确认商品描述";

                [self.navigationController pushViewController:typeVC animated:YES];
            }else{
                [[tools shared] HUDShowHideText:message delay:1];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
}
- (void)loadAddress
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [LLSession sharedSession].user.userId,@"memberId",nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:seleceAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   [LLSession sharedSession].user.id,@"memberId",nil];
//    [[RestClient sharedClient] postPath:[tools getServiceUrl:seleceAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        //返回值{"ok":true,"code":0,"message":"操作成功!","result":1}
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0) {
            NSArray *resultArray = nilOrJSONObjectForKey(JSON, @"result");
            if (resultArray.count !=0) {
                [_addressAdrray removeAllObjects];
                
                
                // NSLog(@"_addressAdrray %@",_addressAdrray);
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

#pragma mark  TableView----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        //        if (self.productArray == nil) {
        //            return 1;
        //        }else{
        //            return self.productArray.count;}
        return _productsArray.count;
    }else if (section == 2){
        return [_addressAdrray count]+1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cell0 = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell0];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH - 10, 40)];
        view.image = [UIImage imageNamed:@"02_02_03"];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 25)];
        //imageView.backgroundColor = [UIColor yellowColor];
        imageView.image = [UIImage imageNamed:@"ico_shop"];
        [view addSubview:imageView];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+2, imageView.top, 200, 30)];
        nameLabel.text = self.shopName;
        [view addSubview:nameLabel];
        UIImageView *contactView = [[UIImageView alloc]initWithFrame:CGRectMake(view.right - 130, nameLabel.top, 30, 30)];
        contactView.image =[UIImage imageNamed:@"ico_ctc"];
        [view addSubview:contactView];
        UILabel *contacrLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.right - 100, nameLabel.top, 90, 30)];
        contacrLabel.text = @"联系卖家";
        [view addSubview:contacrLabel];
        [cell.contentView addSubview:view];
        return cell;
    }else if (indexPath.section == 1){
        
        static NSString *cellIdentifier = @"cell";
        XFProductCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell1) {
            cell1 = [[XFProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        Info *info = _productsArray[indexPath.row];
        cell1.info = info;
        [cell1.deleteButton removeFromSuperview];
        return cell1;
    }
    else if (indexPath.section == 2){
        static NSString *cell2 = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2];
        }
        if (indexPath.row == 0) {
            UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, UI_SCREEN_WIDTH - 10, 40)];
            view1.image = [UIImage imageNamed:@"02_02_05"];
            [cell.contentView addSubview:view1];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
            label.text = @"配送方式";
            [view1 addSubview:label];
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(view1.right - 120, 5, 115, 30)];
            label2.text = self.totalPrice;
            [view1 addSubview:label2];
            return cell;
        }
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, UI_SCREEN_WIDTH - 10, 145)];
        view1.image = [UIImage imageNamed:@"02_02_07"];
        view1.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view1];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
        label.text = @"收货地点";
        [view1 addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view1.right - 60, 5, 25, 25)];
        imageView.image = [UIImage imageNamed:@"ico_ps"];
        [view1 addSubview:imageView];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(5, label.bottom, UI_SCREEN_WIDTH-10, 0.5)];
        line1.backgroundColor = [UIColor blackColor];
        [view1 addSubview:line1];
        _receiveName = [[UILabel alloc]initWithFrame:CGRectMake(5, label.bottom +2, 100, 30)];
        _receiveName.textAlignment = NSTextAlignmentLeft;
        [_receiveName setText:@""];
        [view1 addSubview:_receiveName];
        
        _receiveNumber = [[UILabel alloc]initWithFrame:CGRectMake(view1.right - 140, label.bottom + 2, 120, 30)];
        [_receiveNumber setText:@""];
        _receiveNumber.textAlignment = NSTextAlignmentRight;
        // _receiveNumber.backgroundColor = [UIColor redColor];
        [view1 addSubview:_receiveNumber];
        
        _receiveAddress = [[UILabel alloc]initWithFrame:CGRectMake(5, _receiveName.bottom+10,_receiveNumber.right,65)];
        
        _receiveAddress.textAlignment = NSTextAlignmentLeft;
        _receiveAddress.numberOfLines = 2;
        [view1 addSubview:_receiveAddress];
        
        
        Info *address = _addressAdrray[indexPath.row-1];
        [_receiveAddress setText:address.address];
        [_receiveNumber setText:address.mobile];
        [_receiveName setText:address.name];
        self.addressId = address.id;
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    static NSString *cellIdentifier3 = @"cell3";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
    }
    UITextField *view = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH - 10, 80)];
    //此处要设置成全局的    要上传到服务器
    view.placeholder = @"给卖家留言";
    view.borderStyle = UITextBorderStyleRoundedRect;
    view.textAlignment = NSTextAlignmentLeft;
    [view setDelegate:self];
    //    UITextView *memoView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH - 10, 80)];
    //    memoView.delegate = self;
    //    memoView.returnKeyType = UIReturnKeyDefault;
    //    memoView.keyboardType = UIKeyboardTypeDefault;
    //    memoView.scrollEnabled = YES;//是否可以拖动
    //    memoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [cell.contentView addSubview:view];
    return cell;
    
}
//键盘弹出时改变视图的frame
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationduration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationduration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移50个单位
    CGRect rect = CGRectMake(0.0f, -120, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
    
}
//回复原始位置的方法
- (void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 20.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.memo = textField.text;
    //NSLog(@"-----------%@",self.memo);
    [self resumeView];
    return YES;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1){
        return 120;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 40;
        }else
        {
            return 150;
        }
    }else
        return 90;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            //            AddAddressVC *addressVC = [[AddAddressVC alloc]init];
            //            addressVC.navTitle = @"收货地址管理";
            //            addressVC.delegate = self;
            ChoiceaAddressVC *choiceVC = [[ChoiceaAddressVC alloc]init];
            choiceVC.navTitle =@"收货地址管理";
            [self.navigationController pushViewController:choiceVC animated:YES];
        }
    }
}
//地址代理方法
- (void)addWithName:(NSString *)userName Number:(NSString *)number Address:(NSString *)address
{
    _receiveName.text = userName;
    _receiveNumber.text = number;
    _receiveAddress.text = address;
    
    [_receiveAddress adjustsFontSizeToFitWidth];
    [_receiveAddress setNumberOfLines:2];
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
