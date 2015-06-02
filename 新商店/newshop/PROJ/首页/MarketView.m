//
//  ProductView.m
//  newshop
//
//  Created by qiandong on 15/1/2.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "MarketView.h"

@implementation MarketView

-(id)initWithEntity:(Info *)entity  Frame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        self.entity = entity;
        [self buildView];

    }
    return self;
}

-(void)buildView
{
    float WIDTH = self.width; //固定106.5
//    float HEIGHT = self.height; //固定106.5+30

    //组织UI
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
    [self addSubview:imgView];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, imgView.bottom+2, WIDTH-10, 15)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor colorWithWhite:0.3 alpha:1]];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:nameLabel];
    
    [imgView setImageWithURL:[NSURL URLWithString:self.entity.logo] placeholderImage:nil];
    [nameLabel setText:self.entity.name];
}

//#pragma mark - Responders, events
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate != nil) {
        [self.delegate marketClicked:self.entity];
    }
}



@end
