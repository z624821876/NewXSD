//
//  ProductView.h
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"

@protocol MarketViewDelegate <NSObject>
@optional

-(void)marketClicked:(Info *)entity;

@end


@interface MarketView : UIView

@property(nonatomic,strong) Info *entity;
@property(nonatomic,assign) id<MarketViewDelegate> delegate;

-(id)initWithEntity:(Info *)entity Frame:(CGRect)rect;

@end
