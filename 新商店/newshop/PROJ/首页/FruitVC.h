//
//  FruitVC.h
//  newshop
//
//  Created by 于洲 on 15/6/1.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface FruitVC : BaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString      *shopId;
@property (nonatomic, strong) NSString      *cateId;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UITableView   *cateTable;
@end
