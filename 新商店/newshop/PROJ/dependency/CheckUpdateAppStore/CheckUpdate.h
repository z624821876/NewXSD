//
//  CheckUpdate.h


/**
 *  用于检查appstore是否有更新。
 */


#import <Foundation/Foundation.h>


@interface CheckUpdate : NSObject <UIAlertViewDelegate>

@property(nonatomic,assign) BOOL isShowNewestAlert;

+ (CheckUpdate *)shareInstance;
- (void)checkUpdate;

@end
