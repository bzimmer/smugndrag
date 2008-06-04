//
//  SmugNDragView.m
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/3/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import "SmugNDragView.h"

@interface SmugNDragView(SmugMugURL)
- (NSString *)linkForURL:(NSURL *)url;
@end

@implementation SmugNDragView(SmugMugURL)

- (NSString *)linkForURL:(NSURL *)url {
	NSString *image = [url fragment];
	NSString *host = [url host];
	NSString *path = [url path];
	
	NSString *format = @"<a href='http://%@%@#%@'><img src='http://%@/photos/%@-M.jpg'/></a>";
	NSString *link = [NSString stringWithFormat:format, host, path, image, host, image];
	return link;
}

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
		// or the following for a solid ring
		// [[NSColor keyboardFocusIndicatorColor] set];
		[NSBezierPath setDefaultLineWidth:6.0];
		[NSBezierPath strokeRect:bounds];
	} else {
		[[NSColor whiteColor] set];
		[NSBezierPath fillRect:bounds];
		[super drawRect:rect];
	}
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	if (!([sender draggingSource] == self)) {
		[self setHighlighted:YES];
		[self setNeedsDisplay:YES];
	}

    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric)
    {
		//this means that the sender is offering the type of operation we want
		//return that we want the NSDragOperationGeneric operation that they 
		//are offering
        return NSDragOperationGeneric;
    } else {
		//since they aren't offering the type of operation we want, we have 
		//to tell them we aren't interested
        return NSDragOperationNone;
    }
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
	return [self draggingEntered:sender];
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
	//gets the dragging-specific pasteboard from the sender
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
	//a list of types that we can accept
    NSString *desiredType = [pb availableTypeFromArray:types];
	if ([desiredType isEqualToString:NSStringPboardType]) {
		NSString *s = [pb stringForType:NSStringPboardType];
		NSURL *u = [NSURL URLWithString:s];
		if(nil == u) {
			NSRunAlertPanel(@"Malformed URL",
				[NSString stringWithFormat:@"Sorry, but I failed to parse the url %@", s], nil, nil, nil);
			return NO;
		}
		NSString *link = [self linkForURL:u];
		pb = [NSPasteboard generalPasteboard];
		[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
		[pb setString:link forType:NSStringPboardType];
	} else {
		return NO;
	}
    [self setNeedsDisplay:YES];    //redraw us with the new image
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    //re-draw the view with our new data
    [self setNeedsDisplay:YES];
}

@end
