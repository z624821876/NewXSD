//
//  XFProductBottomCell.m
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "XFProductBottomCell.h"

@implementation XFProductBottomCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpsubViews];
    }
    return self;
}



- (void)setUpsubViews
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, UI_SCREEN_WIDTH-10, self.bounds.size.height)];
    bgView.image = [UIImage imageNamed:@"02_02_07.png"];
    [self.contentView addSubview:bgView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 40)];
    label.text = @"合计:";
    [bgView addSubview:label];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 5, 180, 40)];
    _moneyLabel.textColor = [UIColor redColor];
    //_moneyLabel.text = @"￥7993.00";
    [bgView addSubview:_moneyLabel];
    
    _deleteButon = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButon.frame = CGRectMake(self.right - 100, 5, 80, 35) ;
    [_deleteButon setTitle:@"结算" forState:UIControlStateNormal];
    [_deleteButon setBackgroundImage:[UIImage imageNamed:@"btn_checkorder"] forState:UIControlStateNormal];
    [bgView addSubview:_deleteButon];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
