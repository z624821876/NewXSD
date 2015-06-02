//
//  OrderCell.h
//  Distribution
//
//  Created by 于洲 on 15/3/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell


@property (nonatomic, strong) UIImageView   *logo;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *priceLabel;
@property (nonatomic, strong) UILabel       *numLabel;
@property (nonatomic, strong) UIView        *lineView;
@end
