//
//  XFProductCell.m
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "XFProductCell.h"
#import "UIImageView+AFNetworking.h"
#import "MyButton.h"

@implementation XFProductCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}



- (void)setUpSubViews
{
    _pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 80, 80)];
    //_pictureView.image = [UIImage imageNamed:@"pic_cmd2"];
    [self.contentView addSubview:_pictureView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_pictureView.right +5, 8, 150, 60)];
    // _nameLabel.text = @"无印良品MUJI榉木材折叠式布座椅子";
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right , 30, 100, 30)];
    _priceLabel.font = [UIFont systemFontOfSize:12];
    //_priceLabel.text = @"￥4479.00";
    // _priceLabel.backgroundColor = [UIColor yellowColor];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLabel];
    
    _reduceButton = [MyButton buttonWithType:UIButtonTypeSystem];
    _reduceButton.frame = CGRectMake(_pictureView.right + 5, _nameLabel.bottom + 5, 20, 20);
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"btn_rdc"]forState:UIControlStateNormal];
    [self.contentView addSubview:_reduceButton];
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_reduceButton.right, _nameLabel.bottom+5, 20, 20)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_numberLabel];
    
    _addButton = [MyButton buttonWithType:UIButtonTypeSystem];
    _addButton.frame = CGRectMake(_numberLabel.right,_numberLabel.top , 20, 20);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"btn_plus"] forState:UIControlStateNormal];
    [self.contentView addSubview:_addButton];
    
    _submitButton = [MyButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(_addButton.right + 15, _numberLabel.top, 30, 20);
    [_submitButton setTitle:@"修改" forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _submitButton.backgroundColor = [UIColor redColor];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_submitButton];
    
    
    _deleteButton = [MyButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(_priceLabel.left + 15, _numberLabel.top, 20, 20);
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"02.6_06.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteButton];
    
    
    
}
- (void)setInfo:(Info *)info
{
    _info = info;
    self.nameLabel.text = info.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[info.totalPrice floatValue]];
    [self.pictureView setImageWithURL:[NSURL URLWithString:info.detailImage]];
    self.numberLabel.text = info.num;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
