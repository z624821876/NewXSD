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

#import "HMLauncherData.h"

@implementation HMLauncherData
@synthesize maxRows;
@synthesize maxColumns;
@synthesize persistKey;
@synthesize launcherIconPages;

// 在最后面添加一个icon
- (void) addIcon:(HMLauncherIcon *)icon
{
    NSParameterAssert(icon != nil);    
    NSParameterAssert(maxRows > 0);
    NSParameterAssert(maxColumns > 0);

    // Go to last page 获取最后一页    
    NSInteger lastPageIndex = [self.launcherIconPages count] - 1;
    NSMutableArray *targetPage = nil;
    // 不存在任何页面时
    if (lastPageIndex == -1)
    {
        targetPage = [self addPage];
    }
    else
    {
        targetPage = [self.launcherIconPages objectAtIndex:lastPageIndex];
        NSUInteger numberOfIconsOnPage = [targetPage count];
        NSUInteger maxIcons = self.maxRows * self.maxColumns;
        // 该页icon数目已满
        if (numberOfIconsOnPage == maxIcons)
        {
            // Target page is full, so create new page
            targetPage = [self addPage];
        }
    }
    [targetPage addObject:icon];
}

// 删除icon
- (void) removeIcon:(HMLauncherIcon *) icon
 {
     NSParameterAssert(icon != nil);
     NSMutableArray *page = [self pageOfIcon:icon];
     [page removeObject:icon];
     
     // 重新排列数据，补足空缺
     // 获取全部的icon
     NSMutableArray *allicons = [NSMutableArray array];
     for(NSMutableArray *page in launcherIconPages)
     {
         for(HMLauncherIcon *icon in page)
         {
             [allicons addObject:icon];
         }
         [page removeAllObjects];
     }
     
     // 将icon重新分组
     NSUInteger maxIcons = self.maxRows * self.maxColumns;
     for(int i = 0 ;i < [allicons count]; i++)
     {
         HMLauncherIcon *icon = [allicons objectAtIndex:i];
         NSInteger pageIndex = ( i + 1 ) / maxIcons;
         NSMutableArray *page;
         if((i + 1)% maxIcons == 0 && pageIndex >= 1)
             page = [launcherIconPages objectAtIndex:pageIndex - 1];
         else
             page = [launcherIconPages objectAtIndex:pageIndex];
         [page addObject:icon];
     }
     [self removeEmptyPages];
}

// 在指定位置添加icon
- (void)addIcon:(HMLauncherIcon*) icon
      pageIndex:(NSUInteger) pageIndex
      iconIndex:(NSUInteger) iconIndex
{
    NSParameterAssert(icon != nil);
    NSParameterAssert(pageIndex < 5000);
    NSParameterAssert(iconIndex < 5000);
    
    [self addIcon:icon];
    [self moveIcon:icon toPage:pageIndex toIndex:iconIndex];
}
// 移动icon
- (void)moveIcon: (HMLauncherIcon*) icon 
          toPage: (NSUInteger) pageIndex
         toIndex: (NSUInteger) iconIndex
{
    NSParameterAssert(icon != nil);
    NSParameterAssert(pageIndex < 5000);
    NSParameterAssert(iconIndex < 5000);
    
    // Remove from old position 将icon从旧的位置上移除
    NSMutableArray *previousPage = [self pageOfIcon:icon];
    NSMutableArray *page = nil;
    [previousPage removeObject:icon];
    
    // Put icon into new position  将icon放在新的位置上
    if (pageIndex < [self.launcherIconPages count])
    {
        page = [self.launcherIconPages objectAtIndex:pageIndex];
    }
    else
    {
        page = [NSMutableArray array];
        [self.launcherIconPages addObject:page];
    }
    
    if (iconIndex >= [page count])
    {
        [page addObject:icon];
    }
    else
    {
        [page insertObject:icon atIndex:iconIndex];        
    }
    
    // Check for overflow  检查页面的icon数目是否溢出
    NSUInteger maxIcons = self.maxColumns * self.maxRows;
    
    if ([page count] > maxIcons)
    {
        HMLauncherIcon *overflowIcon = [page objectAtIndex:maxIcons];
        NSUInteger targetPageIndexForOverflowIcon = pageIndex + 1;
        // 如果页面溢出，添加新页
        if (targetPageIndexForOverflowIcon == [self.launcherIconPages count])
        {
            // We are at the last page, so add a new page.
            [self addPage];
        }
        [self moveIcon:overflowIcon toPage:targetPageIndexForOverflowIcon toIndex:0];
    }
}

// 添加页面，返回新添加页面所在的数组
- (NSMutableArray*) addPage
{
    NSMutableArray *freshPage = [NSMutableArray array];
    [self.launcherIconPages addObject:freshPage];
    return freshPage;
}

// 删除空页面
- (void) removeEmptyPages
{
    NSMutableArray *pagesToDelete = [NSMutableArray arrayWithCapacity:2];
    for (NSMutableArray *page in self.launcherIconPages)
    {
        if ([page count] == 0)
        {
            [pagesToDelete addObject:page];
        }
    }
    [self.launcherIconPages removeObjectsInArray:pagesToDelete];
}

// 根据icon的标识找寻icon（返回icon所在数组）
- (NSArray*)findIconsByIdentifier:(NSString*) identifier
{
    NSParameterAssert(identifier != nil);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:2];
    for (NSMutableArray* page in launcherIconPages)
    {
        for (HMLauncherIcon *icon in page)
        {
            NSParameterAssert(icon.identifier != nil);
            if ([icon.identifier isEqualToString:identifier])
            {
                [result addObject:icon];
            }
        }
    }
    return result;
}

// 返回icon所在页面
- (NSMutableArray*) pageOfIcon:(HMLauncherIcon*) icon
{
    NSParameterAssert(icon != nil);
    for (NSMutableArray *page in launcherIconPages)
    {
        if ([page containsObject:icon])
        {
            return page;
        }
    }
    return nil;
}
// 描述
- (NSString*) description
{
    return [NSString stringWithFormat:@"%@, maxRows:%d, maxColumns:%d, [launcherIconPages count]:%d", 
            persistKey, maxRows, maxColumns, [launcherIconPages count]];
}
// 返回所有的icon数量
- (NSUInteger) iconCount
{
    NSUInteger icons = 0;
    for (NSMutableArray* page in launcherIconPages)
    {
        icons += [page count];
    }
    return icons;
}
// 返回所有的页数
- (NSUInteger) pageCount
{
    return [self.launcherIconPages count];
}

// 初始化
- (id) init
{
    if (self = [super init])
    {
        self.launcherIconPages = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void) dealloc
{
    [persistKey release], persistKey = nil;
    [launcherIconPages release], launcherIconPages = nil;
    [super dealloc];
}
@end
