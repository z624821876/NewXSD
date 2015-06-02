//
//  BFSegmentItem.m
//  BFCustomSegmenControl
//
//  Created by ZYVincent on 12-2-19.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  http://www.zyprosoft.com
//  个人QQ:1003081775
//  团队QQ群号：219357847
//  团队主题：奋斗路上携手相伴！
//  给我评论 : http://www.cocoachina.com/bbs/read.php?tid=124045

#import "BFSegmentItem.h"

#define sepImageWidth 0

@implementation BFSegmentItem
@synthesize titleLabel,sepratorLine;
@synthesize index;
@synthesize delegate;
@synthesize backgroundImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)dealloc
{
    self.titleLabel = nil;
    self.sepratorLine = nil;
    self.backgroundImgView = nil;
    [super dealloc];
}

- (void)tapOnSelf:(UITapGestureRecognizer*)tapR
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOnItem:)]) {
        [self.delegate didTapOnItem:self];
    }
}

- (void)switchToNormal
{
    self.titleLabel.textColor = [UIColor blackColor];
}
- (void)switchToSelected
{
    self.titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:66.0/255.0 blue:94.0/255.0 alpha:1];
}

- (id)initWithFrame:(CGRect)frame withSepratorLine:(UIImage *)sepImage withTitle:(NSString *)title isLastRightItem:(BOOL)state withBackgroundImage:(UIImage *)backImage
{
    if (self = [super initWithFrame:frame]) {
        
        //set backgroundImageView
        self.backgroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        self.backgroundImgView.image = backImage;
        [self addSubview:backgroundImgView];
        [backgroundImgView release];
        
        //set title
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,frame.size.width-sepImageWidth,frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        
//        if (!state) {
//            //set line
//            self.sepratorLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width,0,sepImageWidth,frame.size.height)];
//            self.sepratorLine.image = sepImage;
//            [self addSubview:self.sepratorLine];
//            [self.sepratorLine release]; 
//        }
        
        //add tap gesture
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
        [self addGestureRecognizer:tapR];
        [tapR release];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
