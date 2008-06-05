//
//  AppController.h
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/5/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject {
  IBOutlet id imageSize;
  IBOutlet id altTag;
}

- (BOOL)handleDrag:(NSString *)string;
- (NSString *)linkForString:(NSString *)string withAltAttribute:(NSString *)alt;

@end
