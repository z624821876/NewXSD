//
//  PersonCenterVC.h
//  newshop
//
//  Created by qiandong on 14/12/29.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "BaseVC.h"


@interface PersonCenterVC : BaseVC <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *headBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *nwPoint;
@property (nonatomic, strong) NSString *fansCount;
@property (nonatomic, strong) NSString *orderCount;

@end
