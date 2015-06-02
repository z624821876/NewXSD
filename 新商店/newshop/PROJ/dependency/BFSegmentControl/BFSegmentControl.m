//
//  BFSegmentControl.m
//  BFCustomSegmenControl
//
//  Created by ZYVincent on 12-2-19.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  http://www.zyprosoft.com
//  个人QQ:1003081775
//  团队QQ群号：219357847
//  团队主题：奋斗路上携手相伴！
//  给我评论 : http://www.cocoachina.com/bbs/read.php?tid=124045

#import "BFSegmentControl.h"
#import <QuartzCore/QuartzCore.h>

#define EACH_ITEM_WIDTH 60

@interface BFSegmentControl ()
- (void)selectedImgViewShouldMoveToIndex:(NSInteger)index;
- (void)setLeftTagViewHidden:(BOOL)state;
- (void)setRightTagViewHidden:(BOOL)state;
@end

@implementation BFSegmentControl
@synthesize dataSource;
@synthesize sepratorLineImageName;
@synthesize selectedImgView,leftTagView,rightTagView;
@synthesize selectedIndex,titleFont;
@synthesize itemBackgroundImageLeft,itemBackgroundImageRight,itemBackgroundImageMiddle;
@synthesize selectedImage,gripUnSelectedImage;

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
    self.titleFont = nil;
    self.selectedImgView = nil;
    self.sepratorLineImageName = nil;
    self.itemBackgroundImageLeft = nil;
    self.itemBackgroundImageRight = nil;
    self.itemBackgroundImageMiddle = nil;
    self.sepratorLineImageName = nil;
    self.gripUnSelectedImage = nil;
    [super dealloc];
}

- (void)initSubViews
{
    
    if (self.dataSource == nil) {
        NSAssert(self.dataSource=nil,@"dataSource can't be nil");
    }
    
    NSInteger allItemsCount = 0;
    
    //begin init subview
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInSegmentControl:)]) {
        
        allItemsCount = [self.dataSource numberOfItemsInSegmentControl:self]; 
        
    }else {
        NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemsInSegmentControl:)] == NO,@"segment must can response datasource method ");
    }
    
    
    //set items
    CGFloat scrollTotalWidth = 0;
    for (int i = 0; i < allItemsCount; i++) {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        //item width
        itemWidth = 0;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(widthForEachItemInsegmentControl:)]) {
            itemWidth = [self.dataSource widthForEachItemInsegmentControl:self];
        }else {
            itemWidth = EACH_ITEM_WIDTH;
        }
        
        scrollTotalWidth = scrollTotalWidth + itemWidth;
                         
        CGRect itemFrame = CGRectMake(i*itemWidth,0,itemWidth,backScrollView.frame.size.height*3/4);
                
        //set grip view under item
        CGRect gripFrame = CGRectMake(i*itemWidth,self.frame.size.height*1/4-self.frame.size.height*1/15,itemWidth,self.frame.size.height*4/5);
        UIImageView *gripImgView = [[UIImageView alloc]initWithFrame:gripFrame];
        gripImgView.image = self.gripUnSelectedImage;
        gripImgView.tag = 9999+i;
        [backScrollView addSubview:gripImgView];
        [gripImgView release];
        
        NSString *title = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:titleForItemAtIndex:)]) {
            title = [self.dataSource segmentControl:self titleForItemAtIndex:i];
        }else {
            title = @"";
        }
        
        BFSegmentItem *item = nil;
        if (i!=allItemsCount-1 && i!=0) {
          item = [[BFSegmentItem alloc]initWithFrame:itemFrame withSepratorLine:sepratorLineImageName withTitle:title isLastRightItem:NO withBackgroundImage:self.itemBackgroundImageMiddle];  
        }else if(i==0){
            item = [[BFSegmentItem alloc]initWithFrame:itemFrame withSepratorLine:sepratorLineImageName withTitle:title isLastRightItem:YES withBackgroundImage:self.itemBackgroundImageLeft];  

        }else if(i==allItemsCount-1){
            item = [[BFSegmentItem alloc]initWithFrame:itemFrame withSepratorLine:sepratorLineImageName withTitle:title isLastRightItem:YES withBackgroundImage:self.itemBackgroundImageRight];  

        }
        item.index = i;
        item.delegate = self;
        item.tag = 8888+i;
        item.titleLabel.font = titleFont;
        [backScrollView addSubview:item];
        [item release];
        
        //default selected 0
        if (i==0) {
            [item switchToSelected];
        }
        
        [pool drain];
    }
    
    //set backScroll content
    backScrollView.contentSize = CGSizeMake(scrollTotalWidth,self.frame.size.height*3/4);
    
    //set selectImageView default on the first
    if (self.selectedImgView==nil) {
        selectedImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height*1/3-self.frame.size.height*1/5,itemWidth,backScrollView.frame.size.height*2/3)];
        selectedImgView.image = selectedImage;
        //above the backscrollview
        [backScrollView addSubview:selectedImgView];
    }else {
        [backScrollView scrollRectToVisible:backScrollView.frame animated:NO];
        [backScrollView bringSubviewToFront:selectedImgView];
        [self selectedImgViewShouldMoveToIndex:0];
    }
    
    //set default right tag 
    if (backScrollView.contentSize.width > backScrollView.frame.size.width) {
        [self setRightTagViewHidden:NO];
    }
    
}


- (id)initWithFrame:(CGRect)frame withDataSource:(id<BFSegmentControlDataSource>)mDataSource withSepratorLineImageName:(UIImage *)sepratorImage withBackgroundImageName:(UIImage *)backImage withLeftTagImage:(UIImage *)leftImage withRightTagImage:(UIImage *)rightImage
{
    if (self = [super initWithFrame:frame]) {
                
        self.dataSource = mDataSource;
        self.sepratorLineImageName = sepratorImage;
        
        //set backgroundImageView
        backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        backgroundImageView.image = backImage;
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
        
        //set back scrollView
        backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.delegate = self;
        [self addSubview:backScrollView];
        [backScrollView release];
        
        //set leftTagView adn rightTagView
        leftTagView = [[UIImageView alloc]initWithImage:leftImage];
        [self setLeftTagViewHidden:YES];
        [self addSubview:leftTagView];
        [leftTagView release];
        
        rightTagView = [[UIImageView alloc]initWithImage:rightImage];
        [self setRightTagViewHidden:YES];
        [self addSubview:rightTagView];
        [rightTagView release];
        
        //default
        
        //build subviews
        [self initSubViews];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withDataSource:(id<BFSegmentControlDataSource>)mDataSource  fontSize:(CGFloat)tempfontSize
{
    NSString *selectedImageName = @"segment_selected_new.png";
    NSString *leftImage = @"segment_left_tag.png";
    NSString *rightImage = @"segment_right_tag.png";
    NSString *itemBackImageLeft = @"segment_left_item.png";
    NSString *itemBackImageMiddle = @"segment_middle_item.png";
    NSString *itemBackImageRight = @"segment_right_item.png";
    NSString *gripUnSelected = @"segment_Unselected-grip.png";
    
    self.itemBackgroundImageLeft = [UIImage imageNamed:itemBackImageLeft];
    self.itemBackgroundImageMiddle = [UIImage imageNamed:itemBackImageMiddle];
    self.itemBackgroundImageRight = [UIImage imageNamed:itemBackImageRight];
    self.gripUnSelectedImage = [UIImage imageNamed:gripUnSelected];
    
    UIImage *leftTag = [UIImage imageNamed:leftImage];
    UIImage *rightTag = [UIImage imageNamed:rightImage];
    
    self.selectedImage = [UIImage imageNamed:selectedImageName];
    self.titleFont=[UIFont fontWithName:@"HelveticaNeue-Bold" size:tempfontSize];
    return [self initWithFrame:frame withDataSource:mDataSource withSepratorLineImageName:nil withBackgroundImageName:nil withLeftTagImage:leftTag withRightTagImage:rightTag];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - BFSegmentItemDelegate
- (void)didTapOnItem:(BFSegmentItem *)item
{    
    if (selectedIndex == item.index) {
        return;
    }

    //change grip
    lastSelectedIndex = selectedIndex;
    
    [self selectedImgViewShouldMoveToIndex:item.index];
    
    
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:didSelectAtIndex:)]) {
        [self.dataSource segmentControl:self didSelectAtIndex:item.index];
    }
    
    selectedIndex = item.index;
    
    BFSegmentItem *lastItem = (BFSegmentItem*)[backScrollView viewWithTag:8888+lastSelectedIndex];
    [lastItem switchToNormal];

}

#pragma mark - selectedImgView move action
- (void)hiddenGripAfterAnimation
{
//    UIImageView *unSelectedGripView = (UIImageView*)[backScrollView viewWithTag:9999+lastSelectedIndex];
//    unSelectedGripView.image = gripUnSelectedImage;
//    
//    UIImageView *selectedGripView = (UIImageView*)[backScrollView viewWithTag:9999+selectedIndex];
//    selectedGripView.image = nil;
    
    BFSegmentItem *selectItem = (BFSegmentItem*)[backScrollView viewWithTag:8888+selectedIndex];
    
    [selectItem switchToSelected];    
    
}
- (void)selectedImgViewShouldMoveToIndex:(NSInteger)index
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationDidStopSelector:@selector(hiddenGripAfterAnimation)];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    selectedImgView.frame = CGRectMake(index*itemWidth,self.frame.size.height*1/3-self.frame.size.height*1/5,itemWidth,self.frame.size.height*2/3);
    //NSLog(@"czxczcx%f",self.frame.size.height*1/3-self.frame.size.height*1/10);
    [UIView commitAnimations];
    
    selectedIndex = index;
    
    
}

#pragma mark - reload data
- (void) reloadData
{
    //clear subviews
    for (UIView *subView in backScrollView.subviews) {
        if (subView == self.selectedImgView) {
            continue;
        }
        [subView removeFromSuperview];
    }
    backScrollView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    [self initSubViews];
}

#pragma mark - scrollViewDelegate 
- (void)setLeftTagViewHidden:(BOOL)state
{
    self.leftTagView.frame = CGRectMake(0,0,self.frame.size.width*1/9,self.frame.size.height*7/8);
    self.leftTagView.hidden = state;
}
- (void)setRightTagViewHidden:(BOOL)state
{
    self.rightTagView.frame = CGRectMake(self.frame.size.width-self.frame.size.width*1/9,0,self.frame.size.width*1/9,self.frame.size.height*7/8);
    self.rightTagView.hidden = state;
}
//decide if need hide left or right tag view,0.5 is a float value
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.x == 0 && offset.x <= scrollView.frame.size.width+0.5 && scrollView.contentSize.width > scrollView.frame.size.width+0.5) {
        [self setLeftTagViewHidden:YES];
        [self setRightTagViewHidden:NO];
    }else if((scrollView.contentSize.width-offset.x) <= scrollView.frame.size.width+0.5){
        [self setRightTagViewHidden:YES];
        [self setLeftTagViewHidden:NO];
    }else if(scrollView.contentSize.width < scrollView.frame.size.width+0.5){
        [self setRightTagViewHidden:YES];
        [self setLeftTagViewHidden:YES];
    }else {
        [self setLeftTagViewHidden:NO];
        [self setRightTagViewHidden:NO];
    }
}

- (BFSegmentItem*)itemForIndex:(NSInteger)index
{
    return (BFSegmentItem*)[backScrollView viewWithTag:8888+index];
}


@end
