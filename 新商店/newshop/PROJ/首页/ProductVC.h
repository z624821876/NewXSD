//
//  ProductVC.h
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "EScrollerView.h"
#import "ProductView.h"

@interface ProductVC : BaseVC <EScrollerViewDelegate,UIWebViewDelegate,ProductViewDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) NSInteger typeIn;
@property (nonatomic,assign) NSString *typeIndex;

@property (nonatomic, strong) NSString *shopCatId;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *detailImage;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *discountPrice;
@property(nonatomic,strong) NSString *viewCount;


//合计金额
@property (nonatomic,strong) NSString *totalPrice;
@property (nonatomic,strong) NSString *carNum;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *buyNum;

@property (nonatomic,strong) NSString *color;

@property (nonatomic,strong) NSString *carColor;
@end
