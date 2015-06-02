//
//  AppDelegate.h
//  JXGY
//
//  Created by ZGP on 14-4-9.
//  Copyright (c) 2014年 sunday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import "ZYMenuViewController.h"
#import "WXApi.h"
#import "GexinSdk.h"


typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,GexinSdkDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *mainTabBar;
@property (strong, nonatomic) ZYMenuViewController *menu;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;
@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

@property (assign, nonatomic) BOOL isfirst;

@property (assign, nonatomic) BOOL islogin;

    //微信登陆返回参数
@property (strong, nonatomic) NSString *openId;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *unionId;


@property (assign, nonatomic) BOOL isRefresh;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

- (void)login;

//- (void)testSdkFunction;
//- (void)testSendMessage;
//- (void)testGetClientId;


@end
