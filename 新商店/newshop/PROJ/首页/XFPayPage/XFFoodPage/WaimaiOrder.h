//
//  WaimaiOrder.h
//  newshop
//
//  Created by 于洲 on 15/3/9.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface WaimaiOrder : BaseVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *detailImage;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *totalPrice;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *addressId;

@property (nonatomic,strong) Info      *currentAdd;


@property (nonatomic,strong) NSString *memo;//留言
@property (nonatomic,strong) NSString *bookStates;//INteger类型的

@property (nonatomic,strong) NSMutableArray *productArray;
@property (nonatomic,assign) NSInteger allPrice;

@property (nonatomic,strong) NSMutableArray *myProductsArray;
@property (nonatomic,strong) NSMutableArray *addressAdrray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel  *receiveName;
@property (nonatomic,strong) UILabel  *receiveNumber;
@property (nonatomic,strong) UILabel  *receiveAddress;
@end
