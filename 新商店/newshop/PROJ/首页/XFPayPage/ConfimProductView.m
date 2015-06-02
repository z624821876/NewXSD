//
//  ConfimProductView.m
//  newshop
//
//  Created by sunday on 15/1/21.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ConfimProductView.h"

@implementation ConfimProductView
- (instancetype)initWithFrame:(CGRect)frame Product:(Info *)product
{
    self = [super initWithFrame:frame];
    if (self) {
        self.product = product;
        [self setUpSubViews];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setUpSubViews{
    float width = self.width;
    float height = self.height;
    //UIColor *LINE_COLOR = [UIColor colorWithWhite:0.7 alpha:1];
    //组织ui
    UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width/3-20, height - 20)];
    [pictureView setBackgroundColor:[UIColor yellowColor]];
    [pictureView setImage:[UIImage imageNamed:@"pic_cmd1"]];
    [self addSubview:pictureView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(pictureView.right+5, 0, width/2+20, height/3)];
    [nameLabel setNumberOfLines:2];
    [nameLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [nameLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    nameLabel.text = @"交罚款放假技术开发介绍来数据库副教授了";
    [self addSubview:nameLabel];
    
    UILabel *acountLabel  = [[UILabel alloc]initWithFrame:CGRectMake(pictureView.right+5, pictureView.bottom - 30, 50,30)];
    [acountLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [acountLabel setFont:[UIFont systemFontOfSize:11]];
    acountLabel.text = @"数量";
    [self addSubview:acountLabel];
    
    UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceButton.frame = CGRectMake(acountLabel.left+40, pictureView.bottom - 30, 30, 30);
    //reduceButton.backgroundColor = [UIColor greenColor];
    [reduceButton setImage:[UIImage imageNamed:@"btn_reduce"] forState:UIControlStateNormal];
    [self addSubview:reduceButton];
    
    UILabel *allAcountLabel = [[UILabel alloc]initWithFrame:CGRectMake(reduceButton.right, pictureView.bottom - 30, 30, 30)];
    allAcountLabel.text = @"1";
    allAcountLabel.font = [UIFont systemFontOfSize:18];
    allAcountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:allAcountLabel];
    
    //上边线条
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(allAcountLabel.left, allAcountLabel.top, 30, 0.5)];
    [topLine setBackgroundColor:[UIColor blackColor]];
    [self addSubview:topLine];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(allAcountLabel.right, pictureView.bottom - 30, 30, 30)];
    //addButton.backgroundColor = [UIColor yellowColor];
   [ addButton setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [self addSubview:addButton];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right-60, nameLabel.bottom-nameLabel.height/2, 80, 30)];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"￥4700.00"];
    [self addSubview:priceLabel];
    self.backgroundColor = [UIColor greenColor];

}
@end
