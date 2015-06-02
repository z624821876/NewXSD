//
//  WaimaiVC.h
//  newshop
//
//  Created by sunday on 15/2/4.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseTableVC.h"
#import "EScrollerView.h"
#import "UIViewPassValueDelegate.h" 


@interface WaimaiVC : BaseTableVC<EScrollerViewDelegate,UIAlertViewDelegate>{
    UIPageControl *_pageControl;
   }

@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *cateId;
@property (nonatomic,strong) NSString *shopId;

@property (nonatomic, assign) NSObject <UIViewPassValueDelegate> * delegate;
@end