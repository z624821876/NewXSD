//
//  PayVC.h
//  newshop
//
//  Created by qiandong on 15/1/3.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface PayVC : BaseVC <UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) CGFloat shopDiscount;
@property (nonatomic, strong) NSString *orderId;

@end
