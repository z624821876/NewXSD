//
//  BookDetailVC.m
//  newshop
//
//  Created by sunday on 15/1/22.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BookDetailVC.h"
#import "AddInCarView.h"

#import "ConfimProductView.h"
@interface BookDetailVC ()
{
    UITableView *_tableView;
    UIView *headView;
    UIView *tradeMessageView;//运费 商品数  实付款
    UIView *receiveMessageView;
    ConfimProductView *_productView;
}
@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-20-44-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;//不可滚动
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线样式
    [_tableView setSeparatorColor:[UIColor purpleColor]];//分割线颜色
    
    
    [self.view addSubview:_tableView];
    [self headView];
    [self receiveMessageView];
    [self tradeMessageView];
    [self buildFootView];
    
   
        _productView = [[ConfimProductView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120) Product:nil];
    // Do any additional setup after loading the view.
}

-(void)headView
{
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120)];
    headView.backgroundColor = [UIColor redColor];
    UIImageView *bookImage = [[UIImageView alloc]initWithFrame:CGRectMake(headView.left + 5, headView.top + 5, 20,30)];
   // bookImage.backgroundColor = [UIColor yellowColor];
    [headView addSubview:bookImage];
    
    UILabel *bookNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, bookImage.top, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
     bookNumLabel.textColor = [UIColor whiteColor];
    [headView addSubview:bookNumLabel];
    NSString *bookNumberString = @"2014123158765856";
    [bookNumLabel setText:[NSString stringWithFormat:@"订单编号：%@",bookNumberString]];
    
    UILabel *payDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, bookNumLabel.bottom + 5, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
     payDateLabel.textColor = [UIColor whiteColor];
    [headView addSubview:payDateLabel];
    NSString *payDateString = @"2014-12-31 20:35:31";
    [payDateLabel setText:[NSString stringWithFormat:@"付款时间：%@",payDateString]];
    
    UILabel *makedateLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, payDateLabel.bottom + 5, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
     makedateLabel.textColor = [UIColor whiteColor];
    [headView addSubview:makedateLabel];
    NSString *makeDateString = @"2014-12-31 20:40:23";
    [makedateLabel setText:[NSString stringWithFormat:@"成交时间：%@",makeDateString]];
  }
- (void)receiveMessageView
{
    receiveMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120)];
    //receiveMessageView.backgroundColor = [UIColor greenColor];
    UIImageView *bookImage = [[UIImageView alloc]initWithFrame:CGRectMake(receiveMessageView.left + 5, receiveMessageView.top + 5, 20,30)];
    bookImage.backgroundColor = [UIColor yellowColor];
    [receiveMessageView addSubview:bookImage];
    
    UILabel *bookNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, bookImage.top, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
    //bookNumLabel.textColor = [UIColor whiteColor];
    [receiveMessageView addSubview:bookNumLabel];
    NSString *bookNumberString = @"";
    [bookNumLabel setText:[NSString stringWithFormat:@"收货信息：%@",bookNumberString]];
    
    UILabel *payDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, bookNumLabel.bottom + 5, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
    //payDateLabel.textColor = [UIColor whiteColor];
    [receiveMessageView addSubview:payDateLabel];
    NSString *payDateString = @"2014-12-31 20:35:31";
    [payDateLabel setText:[NSString stringWithFormat:@"收货人：%@",payDateString]];
    
    UILabel *makedateLabel = [[UILabel alloc]initWithFrame:CGRectMake(bookImage.right+5, payDateLabel.bottom + 5, UI_SCREEN_WIDTH- bookImage.right-5-5, 30)];
    //makedateLabel.textColor = [UIColor whiteColor];
    [receiveMessageView addSubview:makedateLabel];
    makedateLabel.numberOfLines = 0;
    NSString *makeDateString = @"2014-12-31 20:40:23";
    [makedateLabel setText:[NSString stringWithFormat:@"收货地址：%@",makeDateString]];
}
- (void)tradeMessageView{
    tradeMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120)];
  //  tradeMessageView.backgroundColor = [UIColor redColor];
    
    UILabel *bookNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(tradeMessageView.left + 5, tradeMessageView.top + 5, 80, 30)];
    bookNumLabel.textColor = [UIColor whiteColor];
    [tradeMessageView addSubview:bookNumLabel];
    NSString *bookNumberString = @"";
    [bookNumLabel setText:[NSString stringWithFormat:@"运费：%@",bookNumberString]];
    
    UILabel *transMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.right - 100, tradeMessageView.top + 5, 90, 30)];
    transMoneyLabel.text = @"￥0.00";
    transMoneyLabel.textAlignment = NSTextAlignmentRight;
    [tradeMessageView addSubview:transMoneyLabel];
    
    UILabel *payDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(tradeMessageView.left + 5, bookNumLabel.bottom + 5, 80, 30)];
    payDateLabel.textColor = [UIColor whiteColor];
    [tradeMessageView addSubview:payDateLabel];
    NSString *payDateString = @"";
    [payDateLabel setText:[NSString stringWithFormat:@"商品数：%@",payDateString]];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.right - 100, payDateLabel.top, 90, 30)];
    countLabel.text = @"2件";
    countLabel.textAlignment = NSTextAlignmentRight;
    [tradeMessageView addSubview:countLabel];
    
    UILabel *makedateLabel = [[UILabel alloc]initWithFrame:CGRectMake(tradeMessageView.left + 5, payDateLabel.bottom + 5, 80, 30)];
    makedateLabel.textColor = [UIColor whiteColor];
    [tradeMessageView addSubview:makedateLabel];
    NSString *makeDateString = @"";
    [makedateLabel setText:[NSString stringWithFormat:@"实付款：%@",makeDateString]];
    
    UILabel *factLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.right - 100, makedateLabel.top, 90, 30)];
    factLabel.text = @"￥2947.00";
    factLabel.textAlignment = NSTextAlignmentRight;
    [tradeMessageView addSubview:factLabel];

    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2){
        return 2;//此处可为数组
    }else if (section == 3){
        return 1;
    }else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"bookIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
       // cell = [[UITableViewCell alloc]initWithStyle:uitablevi reuseIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0 ) {
        [cell.contentView addSubview:headView];
        return cell;
    }
   else if (indexPath.section == 1)
    {
//         UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [cell.imageView addSubview:imageView1];
//        imageView1.image = [UIImage imageNamed:@"ico_shop"];
        [cell.imageView setImage:[UIImage imageNamed:@"ico_shop"]];
        cell.textLabel.text = @"无印良品";
        UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shopButton.frame = CGRectMake(0, 0, 15, 20);
        [shopButton setBackgroundImage:[UIImage imageNamed:@"ico_more"] forState:UIControlStateNormal];
        //点击回到商家
        [shopButton addTarget:self action:@selector(didClickedshopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = shopButton;
        return cell;
        
    }else if (indexPath.section == 2){
        
        [cell.contentView addSubview:_productView];
        return cell;
        
    }else if (indexPath.section == 3){
   
         [cell.contentView addSubview:tradeMessageView];
        return cell;
    }

    [cell.contentView addSubview:receiveMessageView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }
    return 121;
}
- (void)buildFootView
{
    float CELL_WIDTH = UI_SCREEN_WIDTH;
    float CELL_HEIGHT = 50;
    UIView *footView  = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-UI_STATUS_BAR_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-50, UI_SCREEN_WIDTH, CELL_HEIGHT)];
    //[footView setBackgroundColor:[UIColor purpleColor]];
    // NSLog(@"footView：%@",footView.bounds.size);
    [self.view addSubview:footView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 0.5)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [footView addSubview:line];
        UIButton *putInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [putInButton setFrame:CGRectMake(self.view.right-120, 15, 100, 30)];
    [putInButton setTitle:@"确认收货" forState:UIControlStateNormal];
    [putInButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
        [putInButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
    putInButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [putInButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [putInButton addTarget:self action:@selector(didClickedPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:putInButton];
}

#pragma mark ----didClickedButtonAction
- (void)didClickedshopButtonAction:(id)sender
{
    //返回店铺
}
- (void)didClickedPayButtonAction
{
    //确认收货
    AddInCarView *addView = [[AddInCarView alloc]initWithFrame:CGRectMake(0, 400, UI_SCREEN_WIDTH,0)];
    [self.view addSubview:addView];
//    [UIView animateWithDuration:0.5 animations:^{
//        addView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-200);
//    } completion:nil];
//    CATransition *animation = [CATransition animation];
//    animation.type = kCATransitionFromBottom;
//    animation.subtype = kCATransitionFromBottom;
//    animation.duration = 2;
//    [addView.layer addAnimation:animation forKey:nil];
    
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2];
//    [addView setCenter:CGPointMake(UI_SCREEN_WIDTH/2, ( UI_STATUS_BAR_HEIGHT - 400)/2)] ;
//    [addView setFrame:CGRectMake(0, 400, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 400)];
//    [UIView commitAnimations];//提交

    
    
    
    
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
