//
//  ConfirmOrderVC.h
//  newshop
//
//  Created by 于洲 on 15/4/24.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderVC : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray        *orderArr;
@property (nonatomic, strong) NSString              *shopName;
@property (nonatomic, strong) NSString              *shopId;
@property (nonatomic, strong) NSString              *shopNum;
@property (nonatomic, strong) NSString              *totalFee;


@end
