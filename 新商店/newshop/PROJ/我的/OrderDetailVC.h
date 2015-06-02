//
//  OrderDetailVC.h
//  Distribution
//
//  Created by 于洲 on 15/3/24.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;


@property (nonatomic, strong) NSString *orderID;

    //订单编号
@property (nonatomic, strong) NSString      *orderNo;
    //付款时间
@property (nonatomic, strong) NSString      *paymentTime;
    //成交时间
@property (nonatomic, strong) NSString      *completeTime;
@property (nonatomic, strong) NSString      *itemNum;
@property (nonatomic, strong) NSString      *totlalPrice;
    //收货信息
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *phone;
@property (nonatomic, strong) NSString      *address;
    //订单状态
@property (nonatomic, strong) NSString      *orderStatus;

@property (nonatomic, strong) NSString      *shopName;
@property (nonatomic, strong) NSString      *postFee;

@property (nonatomic, strong) NSString      *postName;
@property (nonatomic, strong) NSString      *postNo;

@property (nonatomic, strong) NSMutableArray *shopArr;




@end
