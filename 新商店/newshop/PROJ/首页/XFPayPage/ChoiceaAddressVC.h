//
//  ChoiceaAddressVC.h
//  newshop
//
//  Created by sunday on 15/2/4.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "AddAddressVC.h"
#import "XFConfimBooksVC.h"
@interface ChoiceaAddressVC : BaseVC<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) XFConfimBooksVC *dele;

@end
