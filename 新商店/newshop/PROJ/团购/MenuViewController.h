//
//  MenuViewController.h
//  newshop
//
//  Created by 于洲 on 15/3/10.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYMenuViewController.h"

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *shopCateId;
@property (nonatomic, strong) NSString *cateName;

@end
