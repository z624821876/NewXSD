//
//  AddAddressVC.m
//  newshop
//
//  Created by sunday on 15/2/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "AddAddressVC.h"
#import "NSString+LLStringCategory.h"

@interface AddAddressVC ()
{
    UITableView *_tableView;
    NSString *_userName;
    NSString *_userAddress;
    NSString *_userNumber;
    UITextField *_userNameTF;
    UITextField *_userNumberTF;
    UITextField *_userAddressTF;
    UIPickerView *_pickerView;
}
@end

@implementation AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildNav];
    
    float CELL_HEIGHT = 40;
    UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 65,CELL_HEIGHT)];
    [useLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:useLabel];
    [useLabel setText:@"收货人："];
    
    _userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(useLabel.right+5, useLabel.top, 225, CELL_HEIGHT)];
    // [_userNameTF setFont:[UIFont systemFontOfSize:13]];
    [_userNameTF setPlaceholder:@"请输入姓名"];
    [self.view addSubview:_userNameTF];
    
    [self drawLine:4+CELL_HEIGHT];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(useLabel.left, useLabel.bottom + 4 , 65, CELL_HEIGHT)];
    [numberLabel setFont:[UIFont systemFontOfSize:12]];
    // [numberLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:numberLabel];
    [numberLabel setText:@"联系方式："];
    
    _userNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(numberLabel.right+5, numberLabel.top, 225, CELL_HEIGHT)];
    _userNumberTF.layer.cornerRadius = 1;
    //[_userNumberTF setFont:[UIFont systemFontOfSize:13]];
    [_userNumberTF setPlaceholder:@"收货人手机号码"];
    [self.view addSubview:_userNumberTF];
    [self drawLine:4*2+CELL_HEIGHT*2];
    
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberLabel.left, _userNumberTF.bottom + 4, 65, CELL_HEIGHT)];
    [addressLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:addressLabel];
    [addressLabel setText:@"收货地址："];
    
    _userAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(addressLabel.right+5, addressLabel.top, 225, CELL_HEIGHT*2)];
    _userAddressTF .layer.cornerRadius = 1;
    _userAddressTF.adjustsFontSizeToFitWidth = YES;
    [_userAddressTF setPlaceholder:@"详细街道地址"];
    
    [self.view addSubview:_userAddressTF];
    _userNameTF.delegate = self;
    _userNumberTF.delegate = self;
    _userAddressTF.delegate = self;
}
#pragma mark == 手势
- (void)tabAction:(id)sender
{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(_userNumberTF.right, _userNumberTF.top, _userNumberTF.bounds.size.width,80)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_pickerView];
}
#pragma mark == textField  Delegate

//键盘弹出时改变视图的frame
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _userAddressTF) {
//        NSTimeInterval animationduration = 0.30f;
//        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//        [UIView setAnimationDuration:animationduration];
//        float width = self.view.frame.size.width;
//        float height = self.view.frame.size.height;
//        //上移50个单位
//        CGRect rect = CGRectMake(0.0f, -120, width, height);
//        self.view.frame = rect;
//        [UIView commitAnimations];
         return YES;
    }else
    {
        return YES;
    }
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
    if (textField == _userAddressTF) {
         [self resumeView];
    }
    [textField resignFirstResponder];
    return YES;
}

//保存按钮
-(void)buildNav
{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(address:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

//点击保存 返回列表重新刷新表格
- (void)address:(id)sender
{
    //手机号
    NSString *number = [_userNumberTF.text clearWhiteSpaceAndNewLine];
    NSString *name = [_userNameTF.text clearWhiteSpaceAndNewLine];
    NSString *address = [_userAddressTF.text clearWhiteSpaceAndNewLine];
    if([name isEqualToString:@""] || [address isEqualToString:@""])
    {
        [[tools shared] HUDShowHideText:@"请输入姓名" delay:1.5];
        return;
    } if(![number isValidMobile]) {
        [_userNumberTF becomeFirstResponder];
        [[tools shared] HUDShowHideText:@"您输入的号码格式不正确，请重新输入！" delay:1.5];
        return;
    }
    if([address isEqualToString:@""])
    {
        [[tools shared] HUDShowHideText:@"请输入地址" delay:1.5];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   
                                    [LLSession sharedSession].user.userId,@"memberId",name,@"name",
                                   address,@"address",number,@"mobile",
                                   @"31",@"provineId",@"383",@"districtId",@"3229",@"cityId",@"常用地址",@"often",
                                   nil];
    [[RestClient sharedClient] postPath:[tools getServiceUrl:addAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
    //返回值{"ok":true,"code":0,"message":"操作成功!","result":1}
        NSInteger code = [[JSON valueForKeyPath:@"code"] integerValue];
        if (code == 0){
           [[tools shared] HUDShowHideText:@"添加成功！" delay:2];
        }else {
            [[tools shared] HUDShowHideText:@"添加失败！" delay:2];     }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    
//    [self.delegate addWithAddressvc:self WithName:_userNameTF.text Number:_userNumberTF.text Address:_userAddressTF.text];
    //代理方法 回去刷新页面
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)drawLine:(float)top
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, top-0.5, UI_SCREEN_WIDTH-20, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [self.view addSubview:line];
}
#pragma mark ===pickerView Delegate  Datasource-----
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return @"省";
    }
    else
    {
           return @"县";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [_pickerView selectRow:0 inComponent:1 animated:YES];
        [_pickerView reloadComponent:4];
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
