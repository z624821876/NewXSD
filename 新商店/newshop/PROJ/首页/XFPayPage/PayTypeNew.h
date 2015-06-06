//
//  PayType.h
//  newshop
//
//  Created by sunday on 15/1/21.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"
#pragma mark 支付方式页面

//@interface Product : NSObject{
//@private
//    float     _price;
//    NSString *_subject;
//    NSString *_body;
 //   NSString *_orderId;
//}

//@property (nonatomic, assign) float price;
//@property (nonatomic, copy) NSString *subject;
//@property (nonatomic, copy) NSString *body;
//@property (nonatomic, copy) NSString *orderId;

//@end

@interface PayTypeNew : BaseVC<UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSString *totalPrice;
@property (nonatomic,strong) NSString *myBalance;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *useMoney;
@property (nonatomic,strong) NSString *type;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;
//@property(nonatomic, strong)NSMutableArray *productList;




@end
