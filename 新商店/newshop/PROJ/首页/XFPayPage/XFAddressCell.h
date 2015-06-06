//
//  XFAddressCell.h
//  newshop
//
//  Created by sunday on 15/2/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BaseCell.h"

@interface XFAddressCell : BaseCell
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIButton *checkButton;
@property (nonatomic,assign) BOOL checked;
@property (nonatomic,strong) Info *info;
@end
