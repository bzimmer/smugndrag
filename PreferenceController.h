//
//  PreferenceController.h
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/10/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h";

@interface PreferenceController : DBPrefsWindowController {
  IBOutlet NSView *generalPreferenceView;
  IBOutlet NSView *updatesPreferenceView;
}
@end
