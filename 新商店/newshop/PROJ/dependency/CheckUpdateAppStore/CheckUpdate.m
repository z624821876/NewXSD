//
//  CheckUpdate.m
//  NUAA
//

#import "CheckUpdate.h"
#import "RestClient.h"
#import "AFHTTPRequestOperation.h"

//此APP id为程序申请时得到。更改相应的id查询App的信息，一般只需修改这个
#define kAPPID      @"911258365"
//#define kAPPID      @"899441948"

//应用名字，若需要更改，可自行设置。
#define kAPPName    [infoDict objectForKey:@"CFBundleDisplayName"]
//此链接为苹果官方查询App的接口。
#define kAPPURL     @"http://itunes.apple.com/lookup?id="


@interface CheckUpdate ()
{
    NSString *_updateURL;
}

@end


@implementation CheckUpdate

+ (CheckUpdate *)shareInstance
{
    static CheckUpdate *update = nil;
    if (!update)
    {
        update = [[CheckUpdate alloc] init];
    }

    return update;
}

- (void)checkUpdate
{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",kAPPURL, kAPPID];
    
    [[RestClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {

        if ([operation.response statusCode] == 200)
        {
            NSDictionary *infoDict   = [[NSBundle mainBundle]infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            
            NSArray      *infoArray  = [JSON objectForKey:@"results"];
            
            if (infoArray.count >= 1)
            {
                NSDictionary *releaseInfo   = [infoArray objectAtIndex:0];
                NSString     *latestVersion = [releaseInfo objectForKey:@"version"];
                NSString     *releaseNotes  = [releaseInfo objectForKey:@"releaseNotes"];
                NSString     *title         = [NSString stringWithFormat:@"%@%@版本", kAPPName, latestVersion];
                _updateURL = [releaseInfo objectForKey:@"trackViewUrl"];
                
                if ([latestVersion compare:currentVersion] == NSOrderedDescending)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:releaseNotes delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去App Store下载", nil];
                    [alertView show];
                }
                else
                {
                    [self currentVersionIsNewest];
                }
            }else
            {
                [self currentVersionIsNewest];
            }
        }else{
            
            [self currentVersionIsNewest];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];

}


-(void) currentVersionIsNewest
{
    if (_isShowNewestAlert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前已经是最新版本" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}


@end
