//
//  ProductView.m
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "ProductView.h"

@implementation ProductView

-(id)initWithProduct:(Info *)product  Frame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        self.product = product;
        [self buildView];

    }
    return self;
}

-(void)buildView
{
    float WIDTH = self.width; //固定150
    float HEIGHT = self.height; //固定225
    UIColor *LINE_COLOR = [UIColor colorWithWhite:0.7 alpha:1];

    //组织UI
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgView.bottom+5, WIDTH-10, 40)];
    [nameLabel setNumberOfLines:2];
    [nameLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [nameLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [nameLabel setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:nameLabel];
    
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+5, (self.width - 15) / 2.0, 20)];
    [priceLabel setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [priceLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:priceLabel];
    
    UILabel *priceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right + 5, priceLabel.top, priceLabel.width, 20)];
    priceLabel2.textAlignment = NSTextAlignmentRight;
    priceLabel2.textColor = [UIColor grayColor];
    [priceLabel2 setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:priceLabel2];
    
    NSAttributedString *pric = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",[self.product.price doubleValue]] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    priceLabel2.attributedText = pric;
    
    [imgView setImageWithURL:[NSURL URLWithString:self.product.detailImage] placeholderImage:nil];
    [nameLabel setText:self.product.name];
    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[self.product.discountPrice doubleValue]]];
    
    
    //画线
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    [topLine setBackgroundColor:LINE_COLOR];
    [self addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-0.5, WIDTH, 0.5)];
    [bottomLine setBackgroundColor:LINE_COLOR];
    [self addSubview:bottomLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, HEIGHT)];
    [leftLine setBackgroundColor:LINE_COLOR];
    [self addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(WIDTH-0.5, 0, 0.5, HEIGHT)];
    [rightLine setBackgroundColor:LINE_COLOR];
    [self addSubview:rightLine];
}

//#pragma mark - Responders, events
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate != nil) {
        [self.delegate productClicked:self.product];
    }
}



@end
