//
//  GroupVC.h
//  Distribution
//
//  Created by 于洲 on 15/3/13.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GroupVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL                  isPush;
@end
