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

#import "HMLauncherIcon.h"
#import "HMLauncherItem.h"

@implementation HMLauncherIcon
@synthesize canBeDeleted;
@synthesize canBeDragged;
@synthesize canBeTapped;
@synthesize hideDeleteImage;
@synthesize identifier;
@synthesize originIndexPath;
@synthesize launcherItem;

- (BOOL) hitCloseButton:(CGPoint)point
{
    NSAssert(NO, @"this method must be overridden");
    return NO;
}
- (void) drawRect:(CGRect) rect
{
    NSAssert(NO, @"this method must be overridden");
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ identifier:%@", launcherItem.titleText, self.identifier];
}

#pragma mark - lifecycle
- (id) initWithLauncherItem: (HMLauncherItem*) inLauncherItem
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.launcherItem = inLauncherItem;
        self.identifier = inLauncherItem.identifier;
        self.hideDeleteImage = YES;
        [self setClipsToBounds:NO];
        [self setContentMode:UIViewContentModeRedraw];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

-(void) dealloc
{
    [originIndexPath release], originIndexPath = nil;
    [identifier release], identifier = nil;
    [launcherItem release], launcherItem = nil;
    [super dealloc];
}
@end
