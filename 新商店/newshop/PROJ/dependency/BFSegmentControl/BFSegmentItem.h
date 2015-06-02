//
//  BFSegmentItem.h
//  BFCustomSegmenControl
//
//  Created by ZYVincent on 12-2-19.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  http://www.zyprosoft.com
//  个人QQ:1003081775
//  团队QQ群号：219357847
//  团队主题：奋斗路上携手相伴！
//  给我评论 : http://www.cocoachina.com/bbs/read.php?tid=124045

#import <UIKit/UIKit.h>

@class BFSegmentItem;
@protocol BFSegmentItemDelegate <NSObject>
- (void)didTapOnItem:(BFSegmentItem*)item;
@end
@interface BFSegmentItem : UIView
{
    UIImageView *gripImgView;
    
    UIImageView *backgroundImgView;
    UIImageView *sepratorLine;
    UILabel *titleLabel;
    
    NSInteger index;
    id<BFSegmentItemDelegate> delegate;
}
@property (nonatomic,retain)UIImageView *sepratorLine;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic)NSInteger index;
@property (nonatomic,assign)id<BFSegmentItemDelegate> delegate;
@property (nonatomic,retain)UIImageView *backgroundImgView;

- (id)initWithFrame:(CGRect)frame withSepratorLine:(UIImage*)sepImage withTitle:(NSString*)title isLastRightItem:(BOOL)state withBackgroundImage:(UIImage*)backImage;

- (void)switchToSelected;
- (void)switchToNormal;

@end
