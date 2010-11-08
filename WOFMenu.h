// WOFMenu.h
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

#import <Cocoa/Cocoa.h>

#import "Fusion/Fusion.h"

@interface WOFMenu : NSObject <WOFPlugInProtocol> {

    IBOutlet NSMenu     *mainMenu;

    IBOutlet NSMenuItem *applicationMenuItem;
    IBOutlet NSMenuItem *applicationAboutMenuItem;
    IBOutlet NSMenuItem *applicationPreferencesMenuItem;

    IBOutlet NSMenuItem *fileMenuItem;
    IBOutlet NSMenuItem *editMenuItem;
    IBOutlet NSMenuItem *formatMenuItem;
    IBOutlet NSMenuItem *viewMenuItem;
    IBOutlet NSMenuItem *windowMenuItem;
    IBOutlet NSMenuItem *helpMenuItem;
}

#pragma mark IBActions

- (IBAction)orderFrontPreferencesPanel:(id)sender;

#pragma mark Extension points

//! @name Extension points
//!
//! Menu items may be added, removed, replaced, or otherwise manipulated using
//! identifier strings in reverse-dotted format. The fusion-menu plug-in itself
//! provides the following identifiers corresponding to the standard menu items
//! in the main menu:
//!
//!   - com.wincent.fusion.menu.application
//!     - com.wincent.fusion.menu.application.about
//!     - com.wincent.fusion.menu.application.preferences
//!   - com.wincent.fusion.menu.file
//!   - com.wincent.fusion.menu.edit
//!   - com.wincent.fusion.menu.format
//!   - com.wincent.fusion.menu.view
//!   - com.wincent.fusion.menu.window
//!   - com.wincent.fusion.menu.help
//!
//! Other plug-ins may make additions, removals, replacements or other
//! modifications, and may also register their own identifiers that can then be
//! extended by other plug-ins.
//!
//! @startgroup

- (void)insertMenuItem:(NSMenuItem *)aMenuItem before:(NSString *)identifier;

- (void)insertMenuItem:(NSMenuItem *)aMenuItem after:(NSString *)identifier;

- (void)removeMenuItemWithIdentifier:(NSString *)identifier;

- (void)replaceMenuItemAtIdentifier:(NSString *)identifier
                       withMenuItem:(NSMenuItem *)aMenuItem;

//! Allows a plug-in to make modifications (such as setting a target, action or
//! key equivalent) to an existing item.
- (NSMenuItem *)menuItemForIdentifier:(NSString *)identifier;

//! Allows a plug-in to advertise an extension point for use by other plug-ins.
- (void)registerIdentifier:(NSString *)identifier
               forMenuItem:(NSMenuItem *)aMenuItem;

//! @endgroup

@end
