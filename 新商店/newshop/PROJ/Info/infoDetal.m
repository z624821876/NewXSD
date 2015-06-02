//
//  infoDetal.m
//  JXGY
//
//  Created by ZGP on 14-4-10.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "infoDetal.h"

@implementation infoDetal
@synthesize lable1=_lable1,lable2=_lable2,imageView=_imageView,textView=_textView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lable1=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 60)];
        [self.lable1 setBackgroundColor:[UIColor redColor]];
        self.lable1.font=[UIFont fontWithName:@"Arial" size:16];
        self.lable1.text=@"浙江省农业机械学会成果鉴定工作顺利进行";
        self.lable1.numberOfLines=0;
        [self addSubview:_lable1];
        self.lable2=[[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 30)];
        [self.lable2 setBackgroundColor:[UIColor yellowColor]];
        self.lable2.font=[UIFont fontWithName:@"Arial" size:13];
        self.lable2.text=@"2013-1-25 来源：浙江机械信息网";
        [self addSubview:_lable2];
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10,100, 300, 150)];
//        [self.imageView setBackgroundColor:[UIColor blackColor]];
        self.imageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006" ofType:@"png"]];

        [self addSubview:self.imageView];
        self.textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 250, 300, 200)];
        [self addSubview:self.textView];
        [self.textView setBackgroundColor:[UIColor purpleColor]];
        // Initialization code
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
