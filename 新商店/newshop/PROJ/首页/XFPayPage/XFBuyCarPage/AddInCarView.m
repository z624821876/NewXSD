//
//  AddInCarView.m
//  newshop
//
//  Created by sunday on 15/1/23.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "AddInCarView.h"

@implementation AddInCarView
{
    NSInteger currentxoffSet;
}

- (instancetype)initWithFrame:(CGRect)frame Info:(Info *)info{
    self = [super initWithFrame:frame];
    if (self) {
        self.info = info;
        currentxoffSet = 0;

        [self setUpSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame Info:(Info *)info WithColor:(NSMutableArray *)arr
{    self = [super initWithFrame:frame];
    if (self) {
        self.info = info;
        _btnArr = [[NSMutableArray alloc] init];
        _colorArr = arr;
        [self setUpSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setUpSubViews
{
    CGFloat width = self.width;
    //CGFloat height = self.height;
    _cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancleButton.frame = CGRectMake(self.right - 50, -30, 40, 40);
    [self addSubview:_cancleButton];
    //  [_cancleButton setBackgroundColor:[UIColor yellowColor]];
    [_cancleButton setBackgroundImage:[UIImage imageNamed:@"ico_cancel_s"] forState:UIControlStateNormal];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 15, 100, 100)];
    _imageView.image = [UIImage imageNamed:@"pic_cmd1"];
    // [image setImageWithURL:[NSURL URLWithString:self.detailImage]];
    [self addSubview:_imageView];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.right + 2,5, UI_SCREEN_WIDTH - _imageView.right - 5, 30)];
    // moneyLabel.text = @"￥447";
    _moneyLabel.text = self.info.price;
    //moneyLabel.text = self.price;
    
    _moneyLabel.font = [UIFont boldSystemFontOfSize:18];
    _moneyLabel.textColor = [UIColor redColor];
    [self addSubview:_moneyLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.right + 10, _moneyLabel.bottom, width - _imageView.right - 20, 60)];
    // _nameLabel.text = @"无饮良品MUJI榉木材折叠式布座椅子";
    _nameLabel.text = self.name;
    _nameLabel.numberOfLines = 0;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_nameLabel];
    
//    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.right + 5,_nameLabel.bottom+5 , width - _imageView.right - 10, 30)];
//    typeLabel.text = @"快递10.00元";
//    [self addSubview:typeLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _imageView.bottom + 10, width, 1)];
    line1.backgroundColor = [UIColor blackColor];
    [self addSubview:line1];
    
    UILabel *guigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom + 10, width - 10, 30)];
    guigeLabel.text = @"商品规格";
    [self addSubview:guigeLabel];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, guigeLabel.bottom, self.width, 50)];
    [self addSubview:_scroll];
    
    
    for (NSInteger i = 0; i < [_colorArr count]; i ++) {
        
        NSString *color = [_colorArr objectAtIndex:i];
        CGFloat width = [color boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGFloat xOffset = 0;
        if (i != 0) {
            xOffset = currentxoffSet;
        }
        btn.frame = CGRectMake(xOffset + 15, 10, width + 10, 30);
        [btn setTitle:color forState:UIControlStateNormal];
        //设置正常时的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_color1"] forState:UIControlStateNormal];
        //设置选中时图片
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_color_s"] forState:UIControlStateSelected];
        [btn setSelected:NO];
        [_scroll addSubview:btn];
        [_btnArr addObject:btn];
        currentxoffSet = btn.right;
    }
    
    [_scroll setContentSize:CGSizeMake(currentxoffSet + 30, 50)];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, guigeLabel.bottom + 20 + 30, width, 1)];
    if ([_btnArr count] > 4) {
        
        line2.frame = CGRectMake(0, guigeLabel.bottom + 20 + 30 + 35, width, 1);
    }
    line2.backgroundColor = [UIColor blackColor];
    [self addSubview:line2];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, line2.bottom + 10, width - 20, 30)];
    numberLabel.text = @"数量";
    [self addSubview:numberLabel];
    
    _reduceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _reduceButton.frame = CGRectMake(numberLabel.left, numberLabel.bottom + 5, 30, 30);
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"btn_reduce"] forState:UIControlStateNormal];
    [self addSubview: _reduceButton];
    
    _numbelLabel = [[UILabel alloc]initWithFrame:CGRectMake(_reduceButton.right, _reduceButton.top, 30, 30)];
    //_numbelLabel.text = @"1";
    _numbelLabel.text = self.viewCount;
    _numbelLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numbelLabel];
    _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addButton.frame = CGRectMake(_numbelLabel.right, _numbelLabel.top, 30, 30);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [self addSubview:_addButton];
    
    _confimButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _confimButton.frame = CGRectMake(_addButton.right + 10  , _addButton.bottom + 20, 80, 30);
    [self addSubview:_confimButton];
    [_confimButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confimButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm"] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
