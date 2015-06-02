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
@class HMLauncherIcon;
@protocol HMLauncherViewDelegate <NSObject>

@required
// Returns the HMLauncherView, which will embed the icon, when the dragging ends.
// 设置icon将要移入的HMLauncherView
- (HMLauncherView*) targetLauncherViewForIcon:(HMLauncherIcon*) icon;

- (BOOL) launcherViewShouldStopEditingAfterDraggingEnds:(HMLauncherView *)launcherView;

@optional
// icon 开始拖动
- (void) launcherView:(HMLauncherView*) launcherView didStartDragging:(HMLauncherIcon*) icon;
// icon 结束拖动
- (void) launcherView:(HMLauncherView*) launcherView didStopDragging:(HMLauncherIcon*) icon;
// 点击icon的响应事件
- (void) launcherView:(HMLauncherView*) launcherView didTapLauncherIcon:(HMLauncherIcon*) icon;

- (void) launcherView:(HMLauncherView*) launcherView willAddIcon:(HMLauncherIcon*) icon;
// 删除icon以后
- (void) launcherView:(HMLauncherView*) launcherView didDeleteIcon:(HMLauncherIcon*) icon;
// icon将要移动
- (void) launcherView:(HMLauncherView*) launcherView willMoveIcon:(HMLauncherIcon*) icon 
            fromIndex:(NSIndexPath*) fromIndex 
              toIndex:(NSIndexPath*) toIndex;

- (void) launcherViewDidAppear:(HMLauncherView *)launcherView;

- (void) launcherViewDidDisappear:(HMLauncherView *)launcherView;

// 开始进入编辑状态
- (void) launcherViewDidStartEditing:(HMLauncherView*) launcherView;

- (void) launcherViewDidStopEditing:(HMLauncherView*) launcherView;


@end
