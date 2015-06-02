//
//  InfoCell.m
//  JXGY
//
//  Created by ZGP on 14-4-9.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 25, 25)];
        _imageView1.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tb_5" ofType:@"png"]];
        [self addSubview:_imageView1];

        _lable1=[[UILabel alloc] initWithFrame:CGRectMake(45, 5, 250, 50)];
        _lable1.numberOfLines=0;
        [_lable1 setFont:[UIFont fontWithName:@"Arial" size:16]];
        [self addSubview:_lable1];
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        self.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return self;
}

//一般修改这个方法即可
- (void)refresh{
    _lable1.text = _cellData.title;
}

//如果有多个数据model来源，就增加多个set****Data方法即可
- (void)setCellData:(Info *)newData{
    if(_cellData != newData){
        _cellData = newData;
        [self refresh];
    }
}


@end
