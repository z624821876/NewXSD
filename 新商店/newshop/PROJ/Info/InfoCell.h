//
//  InfoCell.h
//  JXGY
//
//  Created by ZGP on 14-4-9.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"
#import "BaseCell.h"

@interface InfoCell : BaseCell

@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UILabel *lable1;
@property(nonatomic,strong)UILabel *lable2;
@property(nonatomic,strong)UILabel *lable3;
@property(nonatomic,strong)UILabel *lable4;

@property(nonatomic,strong)Info *cellData;

@end
