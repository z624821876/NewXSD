//
//  BaseVC.h
//  mlh
//
//  Created by qd on 13-5-8.
//  Copyright (c) 2013年 sunday. All rights reserved.

//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "PullingRefreshTableView.h"

/** 基本的navbar+tableview的基类，为子类提供：
 *  PullingRefreshTableView相关方法
 *  及page,cellNib等
 */
@interface BaseTableVC : BaseVC <PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView * tableView;
@property (nonatomic, strong) UINib *cellNib;
@property (nonatomic, assign) NSInteger page;






@end
