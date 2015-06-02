//
//  FoodShopVC.h
//  newshop
//
//  Created by sunday on 15/2/4.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import "ProductView.h"
#import "UMSocialControllerService.h"
#import "UIViewPassValueDelegate.h" 
@interface FoodShopVC : BaseTableVC<ProductViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate,UIViewPassValueDelegate,UIWebViewDelegate,UIAlertViewDelegate>
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


@end
