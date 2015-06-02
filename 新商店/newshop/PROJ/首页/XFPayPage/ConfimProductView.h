//
//  ConfimProductView.h
//  newshop
//
//  Created by sunday on 15/1/21.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"

@protocol ConfimProductViewDelegate <NSObject>
@optional
- (void)confimProductReduceOne:(Info *)product;
- (void)confimProductAddOne:(Info *)product;
@end
@interface ConfimProductView : UIView

@property (nonatomic,strong) Info *product;
@property (nonatomic,assign) id<ConfimProductViewDelegate>delegate;

@property (nonatomic,strong) UIImageView *pictureView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *acountLabel;
@property (nonatomic,strong) UIButton *reduceButton ;
@property (nonatomic,strong) UILabel *allAcountLabel;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UILabel *priceLabel;
- (instancetype)initWithFrame:(CGRect)frame Product:(Info *)product;

@end
