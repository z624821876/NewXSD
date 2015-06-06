//
//  ShopVC.h
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import "ProductView.h"
#import "UMSocialControllerService.h"

@interface ShopVC : BaseVC <ProductViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSString *shopId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *logo;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *latitude;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *simpleDesc;

@property(nonatomic,strong) NSString  *cateId;

@property(nonatomic,strong) UITableView *myTableView;

@end
