//
//  XFAddressCell.m
//  newshop
//
//  Created by sunday on 15/2/5.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "XFAddressCell.h"

@implementation XFAddressCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}
- (void)setUpSubViews
{
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, UI_SCREEN_WIDTH/3, 30)];
    [self.contentView addSubview:_nameLabel];
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right + 50, 5, UI_SCREEN_WIDTH/3, 30)];
    [self.contentView addSubview:_numberLabel];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, _nameLabel.bottom, UI_SCREEN_WIDTH-20, 30)];
    [_addressLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self.contentView addSubview:_addressLabel];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(self.contentView.right - 30, _numberLabel.top + 10, 20, 20);
    [self.contentView addSubview:_checkButton];
    UIImage *checkedImage = [UIImage imageNamed:@"checked.png"];

    //    frame = CGRectMake(contentRect.origin.x + 10.0, 12.0, checkedImage.size.width, checkedImage.size.height);
    //    checkButton.frame = frame;
    
//    UIImage *image = (self.checked) ? checkedImage: [UIImage imageNamed:@"unchecked.png"];
//    UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [_checkButton setBackgroundImage:checkedImage forState:UIControlStateNormal];
    [_checkButton setHidden:YES];
 }
- (void)setInfo:(Info *)info
{
    _info = info;
    _nameLabel.text = info.name;
    _numberLabel.text = info.mobile;
    _addressLabel.text = info.address;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
