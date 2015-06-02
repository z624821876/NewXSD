//
//  RedpacketVC.h
//  newshop
//
//  Created by 于洲 on 15/4/22.
//  Copyright (c) 2015年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedpacketVC : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSString *commission;
@property (nonatomic, strong) UIScrollView *scrollView;


@property (strong,nonatomic) UITextField    *nameTF;
@property (strong,nonatomic) UITextField    *IdTF;
@property (strong,nonatomic) UITextField    *phoneTF;
@property (strong,nonatomic) UITextField    *titleTF;
@property (strong,nonatomic) UITextField    *bankTF;


@end
