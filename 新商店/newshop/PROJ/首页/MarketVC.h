//
//  MarketVC.h
//  newshop
//
//  Created by qiandong on 15/1/3.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import "EScrollerView.h"

@interface MarketVC : BaseTableVC <EScrollerViewDelegate>

@property(nonatomic,strong) NSString *marketId;
@property(nonatomic,strong) NSString *type; // 市场0 商场1

@end
