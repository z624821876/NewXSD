//
//  SearchResultVC.h
//  newshop
//
//  Created by 于洲 on 15/5/8.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface SearchResultVC : BaseVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString          *keyWord;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSString          *catId;
@end
