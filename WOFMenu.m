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

//! A look-up table for relating identifiers to menu items.
@property(readwrite, assign) NSMutableDictionary *identifiers;

@property(readonly) NSMenu *mainMenu;

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
        if (![nib instantiateNibWithOwner:self topLevelObjects:nil])
            [NSException raise:NSInternalInconsistencyException
                        format:@"-[NSNib instantiateNibWithOwner:topLevelObjects: failed"];
        self.identifiers = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            applicationMenuItem,            @"com.wincent.fusion.menu.application",
            applicationAboutMenuItem,       @"com.wincent.fusion.menu.application.about",
            applicationPreferencesMenuItem, @"com.wincent.fusion.menu.application.preferences",
            fileMenuItem,                   @"com.wincent.fusion.menu.file",
            editMenuItem,                   @"com.wincent.fusion.menu.edit",
            formatMenuItem,                 @"com.wincent.fusion.menu.format",
            viewMenuItem,                   @"com.wincent.fusion.menu.view",
            windowMenuItem,                 @"com.wincent.fusion.menu.window",
            helpMenuItem,                   @"com.wincent.fusion.menu.help", nil];
    }
    return self;
}

- (void)find:(NSString *)findString replace:(NSString *)replacementString inMenu:(NSMenu *)aMenu
{
    for (NSMenuItem *item in [aMenu itemArray])
    {
        NSString *title = [item title];
        if ([title rangeOfString:findString].location != NSNotFound)
            [item setTitle:[title stringByReplacingOccurrencesOfString:findString
                                                            withString:replacementString]];
        NSMenu *submenu = [item submenu];
        if (submenu)
            [self find:findString replace:replacementString inMenu:submenu];
    }
}

- (void)updateCFBundleName
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *localizedBundleName = [[mainBundle localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    if (!localizedBundleName)
        localizedBundleName = [[mainBundle infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    if (!localizedBundleName)
        [NSException raise:NSInternalInconsistencyException
                    format:@"could not determine CFBundleName"];
    [self find:@"«CFBundleName»"
       replace:localizedBundleName
        inMenu:self.mainMenu];
}

- (void)activate
{
    [self updateCFBundleName];
    [NSApp setMainMenu:self.mainMenu];
}

#pragma mark IBActions

- (IBAction)orderFrontPreferencesPanel:(id)sender
{
    [[NSAlert alertWithMessageText:@"No preferences"
                     defaultButton:nil
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@""] runModal];
}

#pragma mark Extension points

- (void)insertMenuItem:(NSMenuItem *)aMenuItem before:(NSString *)identifier
{
    NSMenuItem *item = [self menuItemForIdentifier:identifier];
    NSMenu *menu = [item menu];
    NSUInteger idx = [menu indexOfItem:item];
    [menu insertItem:aMenuItem atIndex:idx];
}

- (void)insertMenuItem:(NSMenuItem *)aMenuItem after:(NSString *)identifier
{
    NSMenuItem *item = [self menuItemForIdentifier:identifier];
    NSMenu *menu = [item menu];
    NSUInteger idx = [menu indexOfItem:item];
    [menu insertItem:aMenuItem atIndex:idx + 1];
}

- (void)removeMenuItemWithIdentifier:(NSString *)identifier
{

}

- (void)replaceMenuItemAtIdentifier:(NSString *)identifier
                       withMenuItem:(NSMenuItem *)aMenuItem
{

}

- (NSMenuItem *)menuItemForIdentifier:(NSString *)identifier
{
    return [self.identifiers objectForKey:identifier];
}

- (void)registerIdentifier:(NSString *)identifier
               forMenuItem:(NSMenuItem *)aMenuItem
{
    [self.identifiers setObject:aMenuItem forKey:identifier];
}

#pragma mark Properties

@synthesize identifiers;
@synthesize mainMenu;

@end
