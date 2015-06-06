//
//  MyCell.m
//  newshop
//
//  Created by YU-MAC on 15/3/8.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _img = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0.5, self.width - 1, self.height - 1)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView addSubview:_priceLabel];
        [_bgView addSubview:_nameLabel];
        [_bgView addSubview:_img];
        [_bgView addSubview:_lineView];
    }
    
    return self;
}

@end
