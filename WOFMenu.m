// WOFMenu.m
// Copyright 2010 Wincent Colaiuta. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "WOFMenu.h"

@interface WOFMenu ()

@property(readwrite, assign) NSMenu *mainMenu;

@end

@implementation WOFMenu

- (id)init
{
    if ((self = [super init]))
    {
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MainMenu"
                                              bundle:[NSBundle bundleForClass:[self class]]];
        if (!nib)
            [NSException raise:NSInternalInconsistencyException
                        format:@"-[NSNib initWithNibNamed:bundle:] failed"];

        NSArray *objects = nil;
        if ([nib instantiateNibWithOwner:self topLevelObjects:&objects])
        {
            for (id object in objects)
            {
                if ([object isKindOfClass:[NSMenu class]])
                {
                    self.mainMenu = object;
                    break;
                }
            }
            if (!self.mainMenu)
                [NSException raise:NSInternalInconsistencyException
                            format:@"no NSMenu found among top-level objects"];
        }
        else
            [NSException raise:NSInternalInconsistencyException
                        format:@"-[NSNib instantiateNibWithOwner:topLevelObjects: failed"];
    }
    return self;
}

- (void)activate
{
    [NSApp setMainMenu:self.mainMenu];
}

- (void)orderFrontStandardAboutPanel:(id)sender
{
    [NSApp orderFrontStandardAboutPanel:sender];
}

#pragma mark Properties

@synthesize mainMenu;

@end
