//
//  XFCarBottomView.m
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "XFCarBottomView.h"


@interface XFCarBottomView ()
{
    UILabel *_allLabel;
}
@end
@implementation XFCarBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}
- (void)setUpSubViews
{
    float WIDTH = self.width; //固定150
    float HEIGHT = self.height; //固定225
   UILabel*allLabel = [[UILabel alloc]initWithFrame:CGRectMake(5    , 5, WIDTH/5-10, HEIGHT-10)];
    allLabel.text = @"合计：";
    [self addSubview:allLabel];
    
    _allMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(allLabel.right, 5 , WIDTH/3, HEIGHT-10)];
    _allMoneyLabel.text = @"￥2947.00";
    _allMoneyLabel.textColor = [UIColor redColor];
    _allMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_allMoneyLabel];
    
    _pakyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.right -100 , 10, 90, HEIGHT-20)];
    [_pakyButton setTitle:@"结算" forState:UIControlStateNormal];
    [_pakyButton setBackgroundImage:[UIImage imageNamed:@"btn_checkorder"] forState:UIControlStateNormal];
    [self addSubview:_pakyButton];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
