//
//  OrderVC.h
//  newshop
//
//  Created by 于洲 on 15/3/6.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"

@interface OrderVC : BaseVC<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSString *shopId;

@end
