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
@class HMLauncherView;
#import "HMLauncherIcon.h"

@protocol HMLauncherDataSource <NSObject>

@required

// Size of the icon. This includes the padding.
// icon大小，包括填充

// LauncherView上按钮尺寸
- (CGSize) buttonDimensionsInLauncherView:(HMLauncherView *) launcherView;
// LauncherView的icon行数
- (NSUInteger) numberOfRowsInLauncherView:(HMLauncherView *) launcherView;
// LauncherView的icon列数
- (NSUInteger) numberOfColumnsInLauncherView:(HMLauncherView*) launcherView;

// The total number of pages to be shown in the launcher view.LauncherView的页数
- (NSUInteger) numberOfPagesInLauncherView:(HMLauncherView *) launcherView;
// Counts all contained icons in the given launcher view 
- (NSUInteger) numberOfIconsInLauncherView:(HMLauncherView *)launcherView;
// The total number of buttons in a given page.
- (NSUInteger) launcherView:(HMLauncherView *)launcherView 
        numberOfIconsInPage:(NSUInteger)page;

- (BOOL) launcherView:(HMLauncherView *) launcherView contains:(HMLauncherIcon*) icon;

- (NSArray*) launcherView:(HMLauncherView*) launcherView findIconsByIdentifier:(NSString*) identifier;


// Retrieve the button to be displayed at a given page and index.
// 检索按钮
- (HMLauncherIcon *) launcherView: (HMLauncherView *)launcherView
                      iconForPage: (NSUInteger)pageIndex
                          atIndex: (NSUInteger)iconIndex;


// Writing operations
// 写操作
- (void) launcherView:(HMLauncherView*) launcherView 
              addIcon:(HMLauncherIcon*) icon;

- (void) launcherView:(HMLauncherView*) launcherView
              addIcon:(HMLauncherIcon*) icon
            pageIndex:(NSUInteger) pageIndex
            iconIndex:(NSUInteger) iconIndex;

- (void) launcherView:(HMLauncherView*) launcherView
             moveIcon:(HMLauncherIcon*) icon 
               toPage:(NSUInteger) pageIndex
              toIndex:(NSUInteger) iconIndex;

- (void) launcherView:(HMLauncherView*) launcherView
           removeIcon:(HMLauncherIcon*) icon;

// Adds a new page to the launcher view. The new created page is returned for further usage.
- (NSMutableArray*) addPageToLauncherView:(HMLauncherView*) launcherView;


// Removes all pages which does not contain any icon.
- (void) removeEmptyPages:(HMLauncherView*) launcherView;


@end
