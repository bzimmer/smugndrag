//
//  PreferenceController.m
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/10/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import "PreferenceController.h"

@implementation PreferenceController

- (id)init {
  if(![super initWithWindowNibName:@"Preferences"]) {
    return nil;
  }
  return self;
}

- (void)windowDidLoad {
  [[self window] disableKeyEquivalentForDefaultButtonCell];
}

@end
