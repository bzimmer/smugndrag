//
//  AppController.h
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/5/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferenceController.h"

enum {
  SDNone  = -1,
  SDGallery  = 0,
  SDLightbox = 1
};
typedef NSUInteger SDDestination;

@interface AppController : NSObject {
  IBOutlet id imageSize;
  IBOutlet id imageDescription;
  IBOutlet id destination;
  IBOutlet id destinationSize;
  PreferenceController *preferenceController;
}

- (BOOL)smugNDragURLDidChange:(NSString *)string;
- (NSString *)blogURL:(NSURL *)imageURL;

- (IBAction)destinationChanged:(id)sender;
- (IBAction)showPreferencePanel:(id)sender;

@end
