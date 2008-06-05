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
	NSString *host = [url host];
	NSString *path = [url path];
	NSString *image = [url fragment];

	if(host == nil || path == nil || image == nil) {
		return nil;
	}
	
	// @todo make this a preference
	NSString *format = @"<a href='http://%@%@#%@'><img src='http://%@/photos/%@-M.jpg' alt=''></a>";
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
		NSString *s = [pb stringForType:NSStringPboardType];
		NSString *link = [self linkForURL:[NSURL URLWithString:s]];
		if(nil == link) {
			return NO;
		}
		pb = [NSPasteboard generalPasteboard];
		[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
		[pb setString:link forType:NSStringPboardType];
	} else {
		return NO;
	}
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    [self setNeedsDisplay:YES];
}

@end
