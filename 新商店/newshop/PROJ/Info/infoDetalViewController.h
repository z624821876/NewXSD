//
//  infoDetalViewController.h
//  JXGY
//
//  Created by ZGP on 14-4-10.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShareEngine.h"
#import "UMSocialControllerService.h"
#import "BaseVC.h"




@interface infoDetalViewController : BaseVC
<
    UIWebViewDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate,
    UMSocialUIDelegate
>


@property(nonatomic,strong)NSString *strUrl;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,assign)BOOL notShowToolbar;

@end
