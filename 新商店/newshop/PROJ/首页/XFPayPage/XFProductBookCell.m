//
//  XFProductBookCell.m
//  newshop
//
//  Created by sunday on 15/1/22.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "XFProductBookCell.h"

@implementation XFProductBookCell

- (void)awakeFromNib {
    // Initialization code
    [self setUpSubViews];
}
- (void)setUpSubViews
{
    _pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(self.left + 5, self.top + 5, 80, 120)];
    [_pictureView setImage:[UIImage imageNamed:@"pic_cmd2"]];
    [self.contentView addSubview:_pictureView];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_pictureView.right + 5,self.top+5 , UI_SCREEN_WIDTH/3*2, 80)];
    _nameLabel.text = @"可调节高度动滑轮硬壳拉杆箱85L";
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right + 20, self.top + 5, 50, 30)];
    _priceLabel.text = @"￥2500.00";
    [self.contentView addSubview:_priceLabel];
    
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right + 20, _priceLabel.bottom + 5, 50, 30)];
    _countLabel.text = @"X1";
    [self.contentView addSubview:_countLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
