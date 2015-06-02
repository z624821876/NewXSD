//
//  FinishPayVC.m
//  newshop
//
//  Created by sunday on 15/1/22.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "FinishPayVC.h"
#import "BookDetailVC.h"
//测试
//#import "XFCarBottomView.h"
//#import "XFShopingCarVC.h"
#import "UIViewController+KNSemiModal.h"
@interface FinishPayVC ()

@end

@implementation FinishPayVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.bookNumber = [LLSession sharedSession].books.orderNo;
    NSLog(@"订单编号====%@",self.bookNumber);
    
    
    CGFloat cell_Height = 40;
    CGFloat cell_Width =UI_SCREEN_WIDTH-20;
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.left + 10, 10, cell_Width, cell_Height)];
    stateLabel.text = @"订单支付成功！";
    stateLabel.textColor = [UIColor redColor];
    stateLabel.font = [UIFont systemFontOfSize:22];
    [stateLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    stateLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:stateLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.left + 10,stateLabel.bottom + 10 ,cell_Width,cell_Height)];
    [numberLabel setText:[NSString stringWithFormat:@"订单号：%@",self.bookNumber]];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:numberLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.left + 10, numberLabel.bottom + 10, cell_Width, cell_Height)];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:dateLabel];
    //转化成日期格式
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    [dateLabel setText:[NSString stringWithFormat:@"订单日期：%@",dateStr]];
    
    [self drawLine:dateLabel.bottom + 20];

    UIButton *lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lookButton.frame = CGRectMake(40, dateLabel.bottom + 30, UI_SCREEN_WIDTH/3*2, 40);
    [lookButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
    [lookButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [self.view addSubview:lookButton];
    
    [lookButton addTarget:self action:@selector(didClickedLookbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //测试
}

- (void)LeftAction:(id)sender
{
    UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 4)];
    [self.navigationController popToViewController:VC animated:YES];

}

- (void)didClickedLookbuttonAction:(id)sender
{
    //订单详情
    BookDetailVC *bookVC = [[BookDetailVC alloc]init];
    bookVC.navTitle = @"我的订单";
    [self.navigationController pushViewController:bookVC animated:YES];
}
//画线
-(void)drawLine:(float)top
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, top-0.5, UI_SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [self.view addSubview:line];
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
