//
//  SmugNDragView.m
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/3/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import "SmugNDragView.h"

@interface NSObject (SmugNDrawViewDelegate)
- (BOOL)smugNDragURLDidChange:(NSString *)url;
@end

@implementation SmugNDragView

@synthesize highlighted;

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setTitle:@"Drag an Image URL Here"];
    [self setTitleFont:[NSFont boldSystemFontOfSize:0]];
    [self setTitlePosition:NSBelowTop];
//    [self setBorderType:NSBezelBorder];
    [[self titleCell] setAlignment:NSCenterTextAlignment];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]];
  }
  return self;
}

- (void)dealloc {
  [self unregisterDraggedTypes];
  [super dealloc];
}

- (void)drawRect:(NSRect)rect {
  if (highlighted) {
    [super drawRect:rect];
    // draw the focus ring
    [[[NSColor keyboardFocusIndicatorColor] colorWithAlphaComponent:0.55] set];
    NSBezierPath *bp = [NSBezierPath bezierPathWithRect:[self bounds]];
    [bp setLineWidth:6.0];
    [bp stroke];
  } else {
    [[NSColor clearColor] set];
    [[NSBezierPath bezierPathWithRect:[self bounds]] fill];
    [super drawRect:rect];
  }
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
  if (!([sender draggingSource] == self)) {
    [self setHighlighted:YES];
    [self setNeedsDisplay:YES];
  }

  if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
    // accept it
    return NSDragOperationGeneric;
  } else {
    return NSDragOperationNone;
  }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
  [self setHighlighted:NO];
  [self setNeedsDisplay:YES];
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender {
  [self setHighlighted:NO];
  [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
  return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
  NSPasteboard *pb = [sender draggingPasteboard];
  NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
  NSString *desiredType = [pb availableTypeFromArray:types];
  
  if ([desiredType isEqualToString:NSStringPboardType]) {
    if(![[self delegate] smugNDragURLDidChange:[pb stringForType:NSStringPboardType]]) {
      return NO;
    }
  } else {
    return NO;
  }
  
  [self setNeedsDisplay:YES];
  return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
  [self setNeedsDisplay:YES];
}

- (id)delegate {
  return delegate;
}
 
- (void)setDelegate:(id)newDelegate {
  delegate = newDelegate;
}

@end
