//
//  ImgVC.h
//  Distribution
//
//  Created by 于洲 on 15/3/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
#import "WXApi.h"
@interface ImgVC : UIViewController<UIActionSheetDelegate,WXApiDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *imgUrl;

@end
