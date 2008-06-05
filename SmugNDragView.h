//
//  SmugNDragView.h
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/3/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SmugNDragView : NSView {
  id delegate;
  BOOL highlighted;
}

@property (assign) BOOL highlighted;

- (id)delegate;
- (void)setDelegate:(id)newDelegate;

@end
