//
//  LLSystemConfig.h
//  huafeibao
//
//  Created by xuyf on 13-6-7.
//  Copyright (c) 2013年 ZPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLSystemConfig : NSObject

+ (LLSystemConfig*)globalConfig;

//keychain保存账号密码
+ (void)KeychainSaveUserName:(NSString *)userName Password:(NSString *)pwd;

//keychain删除账号密码
+ (void)KeychainDeleteUserPassword;

//keychain删除密码
+ (void)KeychainDeletePassword;

//keychain得到账号
+ (NSString *)KeychainGetUserName;

//keychain得到密码
+ (NSString *)KeychainGetLoginPwd;

@end


#pragma mark-- NSUserDefaults (LLAccess)

@interface NSUserDefaults (LLAccess)

//是否自动登录
+ (void)setAutoLogin:(BOOL)isAutoLogin;
+ (BOOL)isAutoLogin;

//是否不是第一次运行（删除重装，就算第一次运行）
+ (void)setEverLaunch:(BOOL)isEverLaunch;
+ (BOOL)isEverLaunch;




@end

