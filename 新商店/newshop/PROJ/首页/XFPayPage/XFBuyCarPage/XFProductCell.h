//
//  XFProductCell.h
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseCell.h"
#import "MyButton.h"

@interface XFProductCell : BaseCell
@property (nonatomic,strong) UIImageView *pictureView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) MyButton *reduceButton;
@property (nonatomic,strong) MyButton *addButton;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) MyButton *deleteButton;

@property (nonatomic,strong) MyButton *submitButton;

@property (nonatomic,strong) Info *info;


@end
