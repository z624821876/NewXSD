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

// The item represents the "data" of an icon and can be serialized.
// “数据”的图标，可以被序列化

@interface HMLauncherItem : NSObject

@property (nonatomic, retain) NSString *identifier;         // icon标识 (和icon的标识相同)
@property (nonatomic, retain) NSString *iconBackgroundPath; // icon背景图片
@property (nonatomic, retain) NSString *titleText;          // icon底下的标题

-(HMLauncherItem *)initWithIconBackgroundPath:(NSString *)p
                                        Title:(NSString *)t
                                   Identifier:(NSString *)i;

@end
