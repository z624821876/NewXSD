//
//  BaseCell.m
//  mlh
//
//  Created by qd on 13-5-10.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    [super setSelected:NO animated:animated];
}




+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}


@end
