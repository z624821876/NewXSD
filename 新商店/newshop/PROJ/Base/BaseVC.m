//
//  BaseVC.m
//  mlh
//
//  Created by qd on 13-5-10.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "BaseVC.h"
#import "FXLabel.h"
#import "UIButton+Additions.h"

@interface BaseVC ()
{
    
}

@end

@implementation BaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0 alpha:1]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    //title字体设置
    [self.navigationController.navigationBar setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,
                                        [UIFont boldSystemFontOfSize:20],UITextAttributeFont,
                                        [UIColor clearColor],UITextAttributeTextShadowColor,
                                                @0.0f,UITextAttributeTextShadowOffset,nil]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn addTarget:self action:@selector(LeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //适配7.0的按钮间距
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    if (iOS7)
        leftSpaceItem.width = -5;
    else
        leftSpaceItem.width = 0;
    
    [self.navigationItem setLeftBarButtonItems:@[leftSpaceItem,leftItem] animated:YES];
    
    _navTitleLabel = [[UILabel alloc] init];
    _navTitleLabel.frame = CGRectMake(0, 0, 200, 20);
//    label.backgroundColor = [UIColor clearColor];
    _navTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    _navTitleLabel.textColor = [UIColor whiteColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navTitleLabel.text = _navTitle;
//    label.shadowOffset = CGSizeMake(0, 1);
//    label.shadowColor = [UIColor blackColor];
    [self.navigationItem setTitleView:_navTitleLabel];
    
    //最后一个页面隐藏返回
    if (self.navigationController.viewControllers.count == 1)
        backBtn.hidden = YES;
    else
        backBtn.hidden = NO;
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    self.topDistance = 0;
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.topDistance = 20;
    }
    
    //导航条设置
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"002.png"] forBarMetrics:UIBarMetricsDefault];
//        
//    }
    
//    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"002.png"]];
//    if (iOS7) {
//        imageView.frame=CGRectMake(0, self.topDistance, 320, 44);
//        
//    }
//    else{
//        imageView.frame=CGRectMake(0, 0, 320, 44);
//    }
//    [self.view addSubview:imageView];
//    _navTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
//    [_navTitleLabel setTextAlignment:NSTextAlignmentCenter];
//    [_navTitleLabel setTextColor:[UIColor whiteColor]];
//    [_navTitleLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
//    _navTitleLabel.text = self.navTitle;
//    [_navTitleLabel setBackgroundColor:[UIColor clearColor]];
//    [imageView addSubview:_navTitleLabel];
//    
//    imageView.userInteractionEnabled=YES;
//    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 8, 30, 25)];
//    [_leftButton setBackgroundImage:[UIImage imageNamed:@"fh_1.png"] forState:UIControlStateNormal];
//    [_leftButton setEnlargeEdgeWithTop:15 right:30 bottom:15 left:15];
//    [_leftButton addTarget:self action:@selector(LeftAction:) forControlEvents:UIControlEventTouchUpInside];
//    [imageView addSubview:_leftButton];
    
//    // 设置导航栏坐标按钮
//    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 52, 31)];
//    [Btn setImage:[UIImage imageNamed:@"navi_left.png"] forState:UIControlStateNormal];
//    [Btn addTarget:self action:@selector(LeftAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *BarBtn = [[UIBarButtonItem alloc] initWithCustomView:Btn];
//    self.navigationItem.leftBarButtonItem = BarBtn;
    
}



//视图切换如果不是navigation方式，子类可重写该方法替代
-(void)LeftAction:(id)sender
{
    if ([[self.navigationController viewControllers] count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}


@end
