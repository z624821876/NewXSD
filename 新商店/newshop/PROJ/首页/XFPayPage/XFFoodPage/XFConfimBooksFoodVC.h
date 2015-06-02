//
//  XFConfimBooksVC.h
//  newshop
//
//  Created by sunday on 15/1/26.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "AddAddressVC.h"
@interface XFConfimBooksVC : BaseVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *detailImage;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *totalPrice;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *addressId;


//需提交订单
@property (nonatomic,strong) NSString *colorName;
@property (nonatomic,strong) NSString *stockSize;


@property (nonatomic,strong) NSString *memo;//留言
@property (nonatomic,strong) NSString *bookStates;//INteger类型的

//从购物车里跳转传过来的
@property (nonatomic,strong) NSArray *productArray;
//立即购买传过来
@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *buyNum;
@property (nonatomic,strong) NSString *color;
@property (nonatomic,assign) BOOL buyNow;



@end
