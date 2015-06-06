//
//  StoreDescViewController.h
//  newshop
//
//  Created by 于洲 on 15/3/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"

@interface StoreDescViewController : BaseTableVC<UIWebViewDelegate>

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *logo;
@property(nonatomic,strong) NSString *simpleDesc;

@property(nonatomic,strong) NSString *shopId;

@end
