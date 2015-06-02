//
//  ZYMenuViewController.m
//  ZYMenuController
//
//  Created by Lixing.wang on 14-6-30.
//  Copyright (c) 2014年 Lixing.wang. All rights reserved.
//

#import "ZYMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, ZYMenuViewControllerState) {
    ZYMenuViewControllerStateNormal     = 0,
    ZYMenuViewControllerStateShowLeft   = 1,
    ZYMenuViewControllerStateShowRight  = 2,
};

@interface ZYMenuViewController () {
    //点击手势
    UITapGestureRecognizer* _tapGesture;
    
    //    //中间的界面
    //    UIViewController* _rootViewController;
    //    //左侧边栏
    //    UIViewController* _leftViewController;
    //    //右侧边栏
    //    UIViewController* _rightViewController;
    
    //能否显示左侧边栏
    BOOL _canPanLeft;
    //能否显示右侧边栏
    BOOL _canPanRight;
    
    //是否正在显示左侧边栏
    BOOL _showLeftView;
    //是否正在显示右侧边栏
    BOOL _showRightView;
    BOOL _showRootView;
    
    //当前的显示状态
    ZYMenuViewControllerState _currentState;
    
    //当前显示的侧边栏，左或者右
    UIViewController* _currentDisplySidebar;
    //当前显示的侧边栏的宽度
    CGFloat _currentDisplaySiderbarWidth;
}


@end

@implementation ZYMenuViewController

#pragma mark - Overwrite

- (void)viewDidLoad {
    _leftViewController.view.frame = self.view.bounds;
    [self.view addSubview:_leftViewController.view];
    
    _rightViewController.view.frame = self.view.bounds;
    [self.view addSubview:_rightViewController.view];
    
    _rootViewController.view.frame = self.view.bounds;
    [self.view addSubview:_rootViewController.view];
    
    //为MenuController添加滑动手势
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    _panGesture.enabled = _canPanLeft || _canPanRight;
    [self.view addGestureRecognizer:_panGesture];
    
    //为MenuController添加点击手势
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    _tapGesture.enabled = NO;
    [_rootViewController.view addGestureRecognizer:_tapGesture];
    
    _leftDisplayWith = 220.0f;
    _rightDisplayWith = -220.0f;
}

#pragma mark - Private

/**
 *  把一个viewController添加到MenuController
 *
 *  @param viewController viewController
 *
 *  @return viewController是否添加成功
 */
- (BOOL)addViewController:(UIViewController* )viewController {
    if (viewController) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        
        return YES;
    }else {
        return NO;
    }
}

- (void)displayViewWithState:(ZYMenuViewControllerState)state animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.3f : 0.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGFloat x = 0.0f;
        
        switch (state) {
            case ZYMenuViewControllerStateNormal:{
                
            }
                break;
            case ZYMenuViewControllerStateShowLeft:{
                x = _leftDisplayWith;
            }
                break;
            case ZYMenuViewControllerStateShowRight:{
                x = _rightDisplayWith;
            }
                break;
        }
        
        [self updateRootViewOriginX:x];
    } completion:^(BOOL finished) {
        if (state == ZYMenuViewControllerStateNormal) {
            [self showShadow:NO];
            
            _tapGesture.enabled = NO;
        }else {
            _tapGesture.enabled = YES;
        }
    }];
}

//设置主页面的边框阴影
- (void)showShadow:(BOOL)value {
    CALayer* layer = _rootViewController.view.layer;
    
    if (value) {
        layer.shadowOpacity = 0.8f;
        layer.cornerRadius = 4.0f;
        layer.shadowOffset = CGSizeZero;
        layer.shadowRadius = 4.0f;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }else {
        layer.shadowOpacity = 0.0f;
    }
}

- (void)updateRootViewOriginX:(CGFloat)x {
    switch (_animation) {
        case ZYMenuViewControllerAnimationNormal:{
            
        }
            break;
        case ZYMenuViewControllerAnimationZoomSidebar:{
            //0.9-1.0
            CGFloat zoomCoefficient = 0.9 + x / (_currentDisplaySiderbarWidth * 10);
            _currentDisplySidebar.view.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomCoefficient, zoomCoefficient, 1.0f);
        }
            break;
        case ZYMenuViewControllerAnimationZoomRoot:{
            //0.7－1.0
            CGFloat zoomCoefficient = 1.0 - 3 * (labs(x) / (320.0f * 10));
            _rootViewController.view.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomCoefficient, zoomCoefficient, 1.0f);
        }
            break;
    }
    
    CGRect frame = _rootViewController.view.frame;
    frame.origin.x = x;
    _rootViewController.view.frame = frame;
}

- (BOOL)canShowLeft {
    if (_canPanLeft) {
        if (_currentState != ZYMenuViewControllerStateShowLeft) {
            [self showShadow:YES];
            
            _currentState = ZYMenuViewControllerStateShowLeft;
            
            _leftViewController.view.hidden = NO;
            _rightViewController.view.hidden = YES;
            
            _currentDisplySidebar.view.layer.transform = CATransform3DIdentity;
            
            _currentDisplySidebar = _leftViewController;
            _currentDisplaySiderbarWidth = _leftDisplayWith;
        }
    }
    
    return _canPanLeft;
}

- (BOOL)canShowRight {
    if (_canPanRight) {
        if (_currentState != ZYMenuViewControllerStateShowRight) {
            [self showShadow:YES];
            
            _currentState = ZYMenuViewControllerStateShowRight;
            
            _leftViewController.view.hidden = YES;
            _rightViewController.view.hidden = NO;
            
            _currentDisplySidebar.view.layer.transform = CATransform3DIdentity;
            
            _currentDisplySidebar = _rightViewController;
            _currentDisplaySiderbarWidth = _rightDisplayWith;
        }
    }
    
    return _canPanRight;
}

#pragma mark - IBAction

- (void)panGestureRecognizer:(UIPanGestureRecognizer* )panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded:{
            CGRect frame = _rootViewController.view.frame;
            
            switch (_currentState) {
                case ZYMenuViewControllerStateNormal:{
                }
                    break;
                case ZYMenuViewControllerStateShowLeft:{
                    if (frame.origin.x < _leftDisplayWith / 2) {
                        _currentState = ZYMenuViewControllerStateNormal;
                    }
                }
                    break;
                case ZYMenuViewControllerStateShowRight:{
                    if (frame.origin.x > _rightDisplayWith / 2) {
                        _currentState = ZYMenuViewControllerStateNormal;
                    }
                }
                    break;
            }
            
            [self displayViewWithState:_currentState animated:YES];
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            //每次拖动多少像素
            CGPoint translatedPoint = [panGesture translationInView:panGesture.view];
            
            CGFloat x = _rootViewController.view.frame.origin.x + translatedPoint.x;
            
            //如果x大于0，说明是向右滑动，要显示的是左侧边栏。
            //如果x小于0，说明是向左滑动，要显示的是右侧边栏。
            //
            BOOL canPan = NO;
            if (x > 0) {
                canPan = [self canShowLeft];
            }else {
                canPan = [self canShowRight];
            }
            
            //更新位置
            if (canPan) {
                [self updateRootViewOriginX:x];
            }
            
            [panGesture setTranslation:CGPointZero inView:panGesture.view];
        }
            break;
        default:
            break;
    }
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer* )tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self showRootViewController:YES];
    }
}

#pragma mark - Public

- (instancetype)initWithRootViewController:(UIViewController* )rootViewController leftViewController:(UIViewController* )leftViewController rightViewController:(UIViewController* )rightViewController {
    
    if (self = [super init]) {
        _rootViewController = rootViewController;
        _leftViewController = leftViewController;
        _rightViewController = rightViewController;
        
        [self addViewController:_rootViewController];
        _canPanLeft = [self addViewController:_leftViewController];
        _canPanRight = [self addViewController:_rightViewController];
    }
    
    return self;
}

- (void)showRootViewController:(BOOL)animated {
    _currentState = ZYMenuViewControllerStateNormal;
    [self displayViewWithState:_currentState animated:animated];
}

- (void)showLeftViewController:(BOOL)animated {
    if ([self canShowLeft]) {
        [self displayViewWithState:_currentState animated:animated];
    }
}

- (void)showRightViewController:(BOOL)animated {
    if ([self canShowRight]) {
        [self displayViewWithState:_currentState animated:animated];
    }
}

@end

@implementation UIViewController (ZYMenuViewController)

- (ZYMenuViewController* )menuViewController {
    if (self.parentViewController == nil) {
        return nil;
    }else if ([self.parentViewController isKindOfClass:[ZYMenuViewController class]]) {
        return (ZYMenuViewController* )self.parentViewController;
    }else {
        return self.parentViewController.menuViewController;
    }
}

@end
