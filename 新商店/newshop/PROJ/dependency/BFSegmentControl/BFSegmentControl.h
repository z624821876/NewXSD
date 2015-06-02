//
//  BFSegmentControl.h
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
#import "BFSegmentItem.h"

@class BFSegmentControl;
@protocol BFSegmentControlDataSource <NSObject>

//菜单里面有多少项
- (NSInteger)numberOfItemsInSegmentControl:(BFSegmentControl*)sgmCtrl;

//每一项得宽度是多少
- (CGFloat)widthForEachItemInsegmentControl:(BFSegmentControl*)sgmCtrl;

//对应索引项得标题是什么
- (NSString*)segmentControl:(BFSegmentControl*)sgmCtrl titleForItemAtIndex:(NSInteger)index;

//菜单选中了哪一项
- (void)segmentControl:(BFSegmentControl*)sgmCtrl didSelectAtIndex:(NSInteger)index;
@end

@interface BFSegmentControl : UIView<BFSegmentItemDelegate,UIScrollViewDelegate>
{    
    UIImageView *backgroundImageView;
    
    UIScrollView *backScrollView;
    
    id<BFSegmentControlDataSource> dataSource;
    
    UIImageView *selectedImgView;
    UIImageView *leftTagView;
    UIImageView *rightTagView;
    
    NSInteger lastSelectedIndex;
    NSInteger selectedIndex;
    CGFloat itemWidth;
    
}
@property (nonatomic,assign)id<BFSegmentControlDataSource> dataSource;
@property (nonatomic,retain)UIImage *sepratorLineImageName;
@property (nonatomic,retain)UIImageView *selectedImgView;
@property (nonatomic,retain)UIImageView *leftTagView;
@property (nonatomic,retain)UIImageView *rightTagView;
@property (nonatomic)NSInteger selectedIndex;
@property (nonatomic,retain)UIFont *titleFont;
@property (nonatomic,retain)UIImage *itemBackgroundImageLeft;
@property (nonatomic,retain)UIImage *itemBackgroundImageRight;
@property (nonatomic,retain)UIImage *itemBackgroundImageMiddle;
@property (nonatomic,retain)UIImage *selectedImage;
@property (nonatomic,retain)UIImage *gripUnSelectedImage;

//使用这个方法初始化这个控件
- (id)initWithFrame      :   (CGRect)frame 
     withDataSource      :   (id<BFSegmentControlDataSource>)mDataSource 
withSepratorLineImageName:   (UIImage *)sepratorImage 
withBackgroundImageName  :   (UIImage*)backImage 
   withLeftTagImage      :   (UIImage*)leftImage
        withRightTagImage:   (UIImage*)rightImage;

//使用这个初始化，配置统一的UI
- (id)initWithFrame:(CGRect)frame withDataSource:(id<BFSegmentControlDataSource>)mDataSource fontSize:(CGFloat)tempfontSize;

//获取item
- (BFSegmentItem*)itemForIndex:(NSInteger)index;

//重新载入控件数据
- (void)reloadData;

@end
