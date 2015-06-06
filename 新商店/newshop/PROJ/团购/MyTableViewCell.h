//
//  MyTableViewCell.h
//  newshop
//
//  Created by 于洲 on 15/3/10.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *titleLab;
@property (nonatomic, strong) UILabel       *subtitleLab;
@property (nonatomic, strong) UILabel       *discountLab;
@property (nonatomic, strong) UILabel       *priceLab;
@property (nonatomic, strong) UILabel       *distanceLab;
@property (nonatomic, strong) UILabel       *workoffLab;
@property (nonatomic, strong) UIImageView   *img;
@property (nonatomic, strong) UIView        *lineView;
@property (nonatomic, strong) UIView        *bgView;
@end
