//
//  OrderCell.m
//  Distribution
//
//  Created by 于洲 on 15/3/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        _logo.contentMode = UIViewContentModeScaleAspectFit;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logo.right + 10, 10, 180, 50)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines = 2;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 65, 15, 55, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 65, 35, 55, 20)];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textAlignment = NSTextAlignmentRight;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 60 - 0.5, 290, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        
        [self.contentView addSubview:_logo];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_numLabel];
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
