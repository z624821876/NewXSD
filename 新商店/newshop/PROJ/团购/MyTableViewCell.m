//
//  MyTableViewCell.m
//  newshop
//
//  Created by 于洲 on 15/3/10.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, 110)];
    _bgView.backgroundColor = [UIColor whiteColor];
        //logo
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 100)];
    _img.backgroundColor = [UIColor whiteColor];
        //名字
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_img.right, 5, 300 - 50 - 125, 30)];
    _titleLab.font = [UIFont systemFontOfSize:14];
        //距离
    _distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(_titleLab.right, 5, 50, 30)];
    _distanceLab.font = [UIFont systemFontOfSize:10];
    _distanceLab.textColor = [UIColor greenColor];
        //副标题
    _subtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(_img.right, _titleLab.bottom, _titleLab.width, 30)];
    _subtitleLab.font = [UIFont systemFontOfSize:12];
        //当前价格
    _discountLab = [[UILabel alloc] initWithFrame:CGRectMake(_img.right, _subtitleLab.bottom, 60, 40)];
    _discountLab.textAlignment = NSTextAlignmentCenter;
    _discountLab.textColor = [UIColor orangeColor];
        //之前价格
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(_discountLab.right, _discountLab.top, 50, 40)];
    _priceLab.textColor = [UIColor purpleColor];
    _priceLab.textAlignment = NSTextAlignmentCenter;
    _priceLab.font = [UIFont systemFontOfSize:10];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_priceLab.left + 5, _priceLab.top + 20, _priceLab.width - 10, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    _workoffLab = [[UILabel alloc] initWithFrame:CGRectMake(_bgView.width - 45, _priceLab.top, 40, 40)];
    _workoffLab.font = [UIFont systemFontOfSize:10];
    
    [self.contentView addSubview:_bgView];
    
    [_bgView addSubview:_img];
    [_bgView addSubview:_titleLab];
    [_bgView addSubview:_subtitleLab];
    [_bgView addSubview:_discountLab];
    [_bgView addSubview:_priceLab];
    [_bgView addSubview:_distanceLab];
    [_bgView addSubview:_workoffLab];
    [_bgView addSubview:_lineView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
