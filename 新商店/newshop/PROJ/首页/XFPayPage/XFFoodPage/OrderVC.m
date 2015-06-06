//
//  OrderVC.m
//  newshop
//
//  Created by 于洲 on 15/3/6.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "OrderVC.h"
#import "DateUtil.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface OrderVC ()
@property (nonatomic, strong) UIScrollView      *bgScroll;
@property (nonatomic, strong) NSMutableArray    *dateArr;
@property (nonatomic, strong) NSMutableArray    *weekArr;
@property (nonatomic, strong) UIButton          *selectBtn;
@property (nonatomic, strong) UIView            *item;
@property (nonatomic, strong) NSArray           *titleArr;

@property (nonatomic, strong) NSMutableArray    *yearArr;

@property (nonatomic, strong) UIPickerView      *datePicker;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UITextView        *textView;

@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    
    _titleArr = @[@"10:00 - 10:30",@"10:30 - 11:00",@"11:00 - 11:30",@"11:30 - 12:00",@"12:00 - 12:30",@"12:30 - 13:00",@"13:00 - 13:30",@"13:30 - 14:00",@"14:00 - 14:30",@"14:30 - 15:00",@"15:00 - 15:30",@"15:30 - 16:00",@"16:00 - 16:30",@"16:30 - 17:00",@"17:00 - 17:30",@"17:30 - 18:00",@"18:00 - 18:30",@"18:30 - 19:00",@"19:00 - 19:30",@"19:30 - 20:00",@"20:00 - 20:30",@"20:30 - 21:00",@"21:00 - 21:30",@"21:30 - 22:00"];
    
    
    
    _bgScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgScroll.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];
    _bgScroll.delegate = self;
    [self.view addSubview:_bgScroll];
    
    [self orderDate];
    
    [self initTopBtn];
    
    [self initDateOption];
    
    [self initRemark];
    
}

- (void)initRemark
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 325, 320, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_bgScroll addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 30)];
    label.text = @"备注";
    label.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, 290, 100)];
    _textView.delegate = self;
    [bgView addSubview:_textView];
    _bgScroll.contentSize = CGSizeMake(320, CGRectGetMaxY(bgView.frame) + 100);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, CGRectGetMaxY(bgView.frame) + 10, 290, 40);
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgScroll addSubview:btn];
    
    _bgScroll.contentSize = CGSizeMake(320, CGRectGetMaxY(btn.frame) + 10 + 64);
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
 
    _bgScroll.contentOffset = CGPointMake(0, 300);
    return YES;
}

#pragma mark - 提交按钮点击
- (void)btnClick
{
    if ([LLSession sharedSession].user.userId == nil) {
        //如果没有登录  进行登录
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app login];
    }else{
        
        if (_textField.text.length <= 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入人数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            
            NSString *date1 = [_yearArr objectAtIndex:_selectBtn.tag];
            NSInteger index = [_datePicker selectedRowInComponent:0];
            NSString *str = [[[_titleArr objectAtIndex:index] componentsSeparatedByString:@" "] firstObject];
        
            NSString *orderDate = [NSString stringWithFormat:@"%@-%@",date1,str];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd-hh:mm"];
            NSDate *date = [dateFormatter dateFromString:orderDate];
            NSDate *date2 = [DateUtil getLocaleDateStr:date];
                //时间戳
            NSTimeInterval date3 = [date2 timeIntervalSince1970];
            
                //人数
            NSString *perNum = _textField.text;
            NSString *mark = _textView.text;
            
            NSString *urlStr = [NSString stringWithFormat:@"http://admin.53xsd.com/reservation/apply?shopId=%@&memberId=%@&time=%.0f&number=%@&memo=%@",_shopId,[LLSession sharedSession].user.userId,date3,perNum,mark];
            NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            //    从URL获取json数据
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
                if ([[JSON objectForKey:@"message"] isEqualToString:@"sucess!"]) {
                    _textView.text = @"";
                    _textField.text = @"";
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"预订成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                
                [[tools shared] HUDShowHideText:@"预定失败" delay:1];

            }];

            [operation start];

        }
}
}

- (void)initDateOption
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 245)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_bgScroll addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.text = @"请选择预定时间:";
    label.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 205, 150, 30)];
    label2.text = @"请输入用餐人数:";
    label2.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label2];
    
    _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(60, 30, 200, 100)];
    _datePicker.dataSource = self;
    _datePicker.delegate = self;
    [bgView addSubview:_datePicker];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 200, 290, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 205, 150, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    [bgView addSubview:_textField];
    
    [bgView addSubview:view];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        _bgScroll.contentOffset = CGPointMake(0, 100);
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _bgScroll.contentOffset = CGPointMake(0, 180);
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [scrollView endEditing:YES];
}

#pragma mark - UIPickerView  协议
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [_titleArr count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _titleArr[row];
}

    //创建Top btn
- (void)initTopBtn
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    topView.backgroundColor = [UIColor whiteColor];
    [_bgScroll addSubview:topView];
    for (NSInteger i = 0; i < 4; i ++) {
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * (320.0 / 4.0), 0, 320.0 / 4.0, 30)];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.text = _weekArr[i];
        [topView addSubview:weekLabel];
    }
    
    for (NSInteger i = 0; i < 4; i ++) {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * (320.0 / 4.0), 30, 320.0 / 4.0, 30)];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = _dateArr[i];
        [topView addSubview:dateLabel];
    }
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (320.0 / 4.0), 0, 320.0 / 4.0, 60);
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _selectBtn = btn;
        }
        [topView addSubview:btn];
    }
    
    _item = [[UIView alloc] initWithFrame:CGRectMake(0, 57, 320.0 / 4.0, 3)];
    _item.backgroundColor = [UIColor redColor];
    [topView addSubview:_item];
}

- (void)topBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    NSLog(@"%d",btn.tag);
    
    _selectBtn.selected = NO;
    btn.selected = YES;
    _selectBtn = btn;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _item.frame;
        rect.origin.x = btn.tag * (320.0 / 4.0);
        _item.frame = rect;
    }];
}

    //计算日期
- (void)orderDate
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
//    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"MM-dd"];
        NSDateFormatter *formater1 = [[NSDateFormatter alloc] init];
        [formater1 setDateFormat:@"eeee"];
        NSDateFormatter *formater2 = [[NSDateFormatter alloc] init];
        [formater2 setDateFormat:@"yyyy-MM-dd"];
    
        _dateArr = [[NSMutableArray alloc] initWithCapacity:4];
        _weekArr = [[NSMutableArray alloc] initWithCapacity:4];
        _yearArr = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (NSInteger i = 0; i < 4; i ++) {
        NSDateComponents *DayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [DayComp setDay:day + i + 1];
        
        NSDate *DayOfWeek= [calendar dateFromComponents:DayComp];
//        NSLog(@"%@",[formater1 stringFromDate:DayOfWeek]);
        [_dateArr addObject:[formater stringFromDate:DayOfWeek]];
        [_weekArr addObject:[formater1 stringFromDate:DayOfWeek]];
        [_yearArr addObject:[formater2 stringFromDate:DayOfWeek]];
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
