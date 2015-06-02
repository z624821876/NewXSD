//
//  ProductView.h
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"

@protocol ProductViewDelegate <NSObject>
@optional

-(void)productClicked:(Info *)product;
-(void)favour:(Info *)product;

@end


@interface ProductView : UIView

@property(nonatomic,strong) Info *product;
@property(nonatomic,assign) id<ProductViewDelegate> delegate;

-(id)initWithProduct:(Info *)product Frame:(CGRect)rect;

@end
