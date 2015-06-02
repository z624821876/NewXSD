//
//  BoundingShopVC.m
//  newshop
//
//  Created by 于洲 on 15/4/11.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import "BoundingShopVC.h"
#import "AddBoundingShopVC.h"
#import "UIImageView+WebCache.h"

@interface BoundingShopVC ()

@property (nonatomic, strong) UIImageView   *img;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *idLable;

@end

@implementation BoundingShopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"已绑定商户";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"重新绑定" style:UIBarButtonItemStylePlain target:self action:@selector(shared)];
    self.navigationItem.rightBarButtonItem = rightitem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initGUI];
}

- (void)viewDidAppear:(BOOL)animated
{

    [_img setImageWithURL:[NSURL URLWithString:[LLSession sharedSession].user.shopURL]];
    _nameLabel.text = [NSString stringWithFormat:@"店铺名：%@",[LLSession sharedSession].user.shopName];
    _idLable.text = [NSString stringWithFormat:@"店铺ID：%@",[LLSession sharedSession].user.shopID];
    
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initGUI
{
    _img = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 60) / 2.0, 20, 60, 60)];
    NSLog(@"%@-------%f",NSStringFromCGRect(_img.frame),UI_SCREEN_WIDTH);
    _img.layer.cornerRadius = 10;
    _img.layer.masksToBounds = YES;
    [self.view addSubview:_img];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _img.bottom + 10, UI_SCREEN_WIDTH - 30, 30)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    _idLable = [[UILabel alloc] initWithFrame:CGRectMake(15, _nameLabel.bottom, UI_SCREEN_WIDTH - 30, 30)];
    _idLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_idLable];
    
}

- (void)shared
{
    AddBoundingShopVC *vc = [[AddBoundingShopVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
