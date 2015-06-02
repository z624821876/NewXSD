//
//  ZYMenuViewController.h
//  ZYMenuController
//
//  Created by Lixing.wang on 14-6-30.
//  Copyright (c) 2014年 Lixing.wang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ZYMenuViewControllerAnimation) {
    ZYMenuViewControllerAnimationNormal         = 0,//平移
    ZYMenuViewControllerAnimationZoomSidebar    = 1,//缩放侧边栏
    ZYMenuViewControllerAnimationZoomRoot       = 2,//缩放主页面
};

@interface ZYMenuViewController : UIViewController

/**
 *  创建一个ZYMenuViewController
 *
 *  @param rootViewController  中间的主视图
 *  @param leftViewController  左侧边栏
 *  @param rightViewController 右侧边栏
 *
 *  @return ZYMenuViewController
 */
- (instancetype)initWithRootViewController:(UIViewController* )rootViewController leftViewController:(UIViewController* )leftViewController rightViewController:(UIViewController* )rightViewController;

/**
 *  主页面
 */
@property (nonatomic, strong, readonly) UIViewController* rootViewController;

/**
 *  左侧边栏
 */
@property (nonatomic, strong, readonly) UIViewController* leftViewController;

/**
 *  右侧边栏
 */
@property (nonatomic, strong, readonly) UIViewController* rightViewController;

/**
 *  左侧边栏的宽度，默认220
 */
@property (nonatomic) CGFloat leftDisplayWith;

/**
 *  右侧边栏的宽度，默认220
 */
@property (nonatomic) CGFloat rightDisplayWith;

/**
 *  动画方式，默认是ZYMenuViewControllerAnimationNormal
 */
@property (nonatomic) ZYMenuViewControllerAnimation animation;

/**
 *  滑动手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;

/**
 *  显示主页面
 *
 *  @param animated 是否使用动画
 */
- (void)showRootViewController:(BOOL)animated;

/**
 *  显示左侧边栏
 *
 *  @param animated 是否使用动画
 */
- (void)showLeftViewController:(BOOL)animated;

/**
 *  显示右侧边栏
 *
 *  @param animated 是否使用动画
 */
- (void)showRightViewController:(BOOL)animated;

@end

@interface UIViewController (ZYMenuViewController)

@property (nonatomic, readonly) ZYMenuViewController* menuViewController;

@end
