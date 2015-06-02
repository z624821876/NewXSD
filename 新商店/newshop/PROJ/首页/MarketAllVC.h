//
//  MarketAllVC.h
//  newshop
//
//  Created by qiandong on 15-1-8.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import "EScrollerView.h"
#import "MarketView.h"

@interface MarketAllVC : BaseTableVC <EScrollerViewDelegate,MarketViewDelegate>

@property(nonatomic,strong) NSString *type; //0市场 1商场

@end
