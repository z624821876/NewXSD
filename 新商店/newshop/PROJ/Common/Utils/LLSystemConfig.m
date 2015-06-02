//
//  LLSystemConfig.m
//  huafeibao
//
//  Created by xuyf on 13-6-7.
//  Copyright (c) 2013年 ZPP. All rights reserved.
//

#import "LLSystemConfig.h"
#import "CHKeychain.h"

#define kUserDefaultIsAutoLogin @"kUserDefaultIsAutoLogin"
#define kUserDefaultEverLaunch @"kUserDefaultEverLaunch"
#define kUserDefaultBankVersion @"kUserDefaultBankVersion"

LLSystemConfig *globalConfigs;

@implementation LLSystemConfig

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        return self;
    }
    return self;
}

+ (LLSystemConfig*)globalConfig
{
    if (globalConfigs == nil)
    {
        @synchronized(self)
        {
            if (globalConfigs == nil)
            {
                globalConfigs = [[LLSystemConfig alloc] init];
            }
        }
    }
    return globalConfigs;
}

//keychain保存账号密码
+ (void)KeychainSaveUserName:(NSString *)userName Password:(NSString *)pwd{
    
    NSMutableDictionary *userPwdKeyChainPairs = [NSMutableDictionary dictionary];
    [userPwdKeyChainPairs setValue:userName forKey:KEY_USERNAME];
    [userPwdKeyChainPairs setValue:pwd forKey:KEY_PASSWORD];
    [CHKeychain save:KEY_USERNAME_PASSWORD data:userPwdKeyChainPairs];
}

//keychain删除账号密码
+ (void)KeychainDeleteUserPassword{
    [CHKeychain delete:KEY_USERNAME_PASSWORD];
}

//keychain删除密码
+ (void)KeychainDeletePassword{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    [usernamepasswordKVPairs removeObjectForKey:KEY_PASSWORD];
    [CHKeychain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
}

//keychain得到账号
+ (NSString *)KeychainGetUserName{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    return [usernamepasswordKVPairs valueForKey:KEY_USERNAME];
}

//keychain得到密码
+ (NSString *)KeychainGetLoginPwd{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    return [usernamepasswordKVPairs valueForKey:KEY_PASSWORD];
}



@end


#pragma mark-- NSUserDefaults (LLAccess)

@implementation NSUserDefaults (LLAccess)

//是否自动登录
+ (void)setAutoLogin:(BOOL)isAutoLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoLogin forKey:kUserDefaultIsAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAutoLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsAutoLogin];
}

//是否不是第一次运行（删除重装，就算第一次运行）
+ (void)setEverLaunch:(BOOL)isEverLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:isEverLaunch forKey:kUserDefaultEverLaunch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isEverLaunch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultEverLaunch];
}


@end



