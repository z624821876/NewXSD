//
// Copyright 2012 Heiko Maaß (mail@heikomaass.de)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>
@class HMLauncherView;
@class HMLauncherItem;

// Base class for an Icon. You've to extend from this class.
//  一个icon的基类
// See LauncherExampleIcon.h for an example.
// LauncherExampleIcon.h 就是一个继承icon基类的例子

@interface HMLauncherIcon : UIControl
{
}
@property (nonatomic, assign) BOOL canBeDeleted;            // 是否可以删除
@property (nonatomic, assign) BOOL canBeDragged;            // 是否可以拖动
@property (nonatomic, assign) BOOL canBeTapped;             // 是否可以点击
@property (nonatomic, assign) BOOL hideDeleteImage;         // 是否隐藏删除图片
@property (nonatomic, retain) NSString *identifier;         // 标识（和item的标识相同）
@property (nonatomic, retain) NSIndexPath *originIndexPath; // 在第几页底几个位置
@property (nonatomic, retain) HMLauncherItem *launcherItem; // icon数据内容

// Should return YES, if the close button contains the given point.
- (BOOL) hitCloseButton:(CGPoint) point;
- (id) initWithLauncherItem: (HMLauncherItem*) launcherItem;

@end
