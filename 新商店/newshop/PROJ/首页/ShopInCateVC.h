//
//  ShopInCate.h
//  newshop
//
//  Created by qiandong on 15/1/1.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import "EScrollerView.h"

@interface ShopInCateVC : BaseTableVC <EScrollerViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong) NSString *cateId;
@property (nonatomic, strong) EScrollerView *escrollView;
@end
