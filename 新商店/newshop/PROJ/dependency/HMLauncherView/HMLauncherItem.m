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

#import "HMLauncherItem.h"

@implementation HMLauncherItem
@synthesize identifier;
@synthesize iconBackgroundPath;
@synthesize titleText;

-(void) encodeWithCoder:(NSCoder*) coder
{
	[coder encodeObject: identifier forKey: @"identifier"];
	[coder encodeObject: titleText forKey: @"titleText"];
    [coder encodeObject: iconBackgroundPath forKey:@"iconBackgroundPath"];
}

-(id) initWithCoder:(NSCoder*) decoder
{
	if (self = [super init])
    {
        self.identifier = [decoder decodeObjectForKey:@"identifier"];
        self.titleText  = [decoder decodeObjectForKey:@"titleText"];
        self.iconBackgroundPath = [decoder decodeObjectForKey:@"iconBackgroundPath"];
    }
	return self;
}

-(HMLauncherItem *)initWithIconBackgroundPath:(NSString *)p
                                        Title:(NSString *)t
                                   Identifier:(NSString *)i;
{
    self = [super init];
    if(self)
    {
        self.identifier = i;
        self.iconBackgroundPath = p;
        self.titleText = t;
    }
    return self;
}

- (void) dealloc
{
    [identifier release], identifier = nil;
    [iconBackgroundPath release], iconBackgroundPath = nil;
    [titleText release], titleText = nil;
    [super dealloc];
}
@end
