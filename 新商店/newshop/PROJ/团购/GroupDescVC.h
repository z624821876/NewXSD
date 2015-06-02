//
//  GroupDescVC.h
//  newshop
//
//  Created by 于洲 on 15/3/10.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableVC.h"
#import "ZYMenuViewController.h"

@interface GroupDescVC : BaseTableVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *cateId;
@property (nonatomic, strong) NSString *cateName;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *shopCateId;
- (void)loadData;
@end
