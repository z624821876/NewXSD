//
//  AddInCarView.h
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Info;
@interface AddInCarView : UIView
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic,strong) NSMutableArray *btnArr;
@property (nonatomic,strong) NSMutableArray *colorArr;
@property (nonatomic,strong) UIButton *cancleButton;
@property (nonatomic,strong)UIButton *reduceButton;
@property (nonatomic,strong)UIButton *addButton;
@property (nonatomic,strong)UIButton *confimButton;
@property (nonatomic,strong) UILabel *numbelLabel;
@property (nonatomic,strong)Info *info;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *detailImage;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *viewCount;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *color1;
@property (nonatomic,strong) UIButton *color2;

- (instancetype)initWithFrame:(CGRect)frame Info:(Info *)info WithColor:(NSMutableArray *)arr;
- (instancetype)initWithFrame:(CGRect)frame Info:(Info *)info;
@end
