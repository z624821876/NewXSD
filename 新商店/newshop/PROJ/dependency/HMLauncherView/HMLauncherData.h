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

#import <Foundation/Foundation.h>
#import "HMLauncherIcon.h"
 

// HMLauncherData contains a list of pages. Each page is represented by a NSMutableArray.
// HMLauncherData 包含了一系列的页面，一个NSMutableArray代表一个页面

@interface HMLauncherData : NSObject

@property (nonatomic, assign) NSInteger maxRows;    // 最大行数
@property (nonatomic, assign) NSInteger maxColumns; // 最大列数
@property (nonatomic, retain) NSString *persistKey; // 页面标识
@property (nonatomic, retain) NSMutableArray *launcherIconPages;  // 页面数组（数组里面存放数组）

// 在最后面添加一个icon
- (void)  addIcon:(HMLauncherIcon*) icon;
// 在指定位置添加icon
- (void)addIcon:(HMLauncherIcon*) icon
        pageIndex:(NSUInteger) pageIndex
        iconIndex:(NSUInteger) iconIndex;
// 移动icon
- (void)moveIcon: (HMLauncherIcon*) icon 
          toPage: (NSUInteger) pageIndex
         toIndex: (NSUInteger) iconIndex;
// 删除icon
- (void)removeIcon:(HMLauncherIcon*) icon;
// 添加页面，返回新添加页面所在的数组
- (NSMutableArray*)addPage;
// 删除空页面
- (void)removeEmptyPages;
// 根据icon的标识找寻icon（返回icon所在数组）
- (NSArray*)findIconsByIdentifier:(NSString*) identifier;
// 返回icon所在页面
- (NSMutableArray*)pageOfIcon:(HMLauncherIcon*) icon;
// 返回所有的icon数量
- (NSUInteger)iconCount;
// 返回所有的页数
- (NSUInteger)pageCount;

@end
