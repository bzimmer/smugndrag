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
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSStringPboardType, nil]];
  }
    return self;
}

- (void)dealloc {
    [self unregisterDraggedTypes];
  [super dealloc];
}

- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  if ([self highlighted]) {
    [super drawRect:rect];
    // use the following for a transparent ring
    [[[NSColor keyboardFocusIndicatorColor] colorWithAlphaComponent:0.55] set];
    [NSBezierPath setDefaultLineWidth:6.0];
    [NSBezierPath strokeRect:bounds];
  } else {
    // @todo make this a preference
    [[NSColor orangeColor] set];
    [NSBezierPath fillRect:bounds];
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
