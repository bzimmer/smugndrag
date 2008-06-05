//
//  AppController.m
//  SmugNDrag
//
//  Created by Brian Zimmer on 6/5/08.
//  Copyright 2008 Brian Zimmer. All rights reserved.
//

#import "AppController.h"

@implementation AppController

- (void)awakeFromNib {
    [imageSize removeAllItems];
    [imageSize addItemsWithTitles:[NSArray arrayWithObjects:@"S", @"M", @"L", @"XL", nil]];
}

- (NSString *)blogURL:(NSURL *)url withDescription:(NSString *)description {
    if(nil == url) {
		return nil;
	}

	NSString *host = [url host];
	NSString *path = [url path];
	NSString *image = [url fragment];

	if(host == nil || path == nil || image == nil) {
		return nil;
	}

	if(nil == description) {
		description = @"";
	}

	NSString *size = [imageSize titleOfSelectedItem];
	NSString *format = @"<a href='http://%@%@#%@'><img src='http://%@/photos/%@-%@.jpg' alt='%@'></a>";
	NSString *link = [NSString stringWithFormat:format, host, path, image, host, image, size, description];

	return link;
}

- (BOOL)smugNDragURLDidChange:(NSString *)dragged {

	NSURL *url = [NSURL URLWithString:dragged];
	if(nil == url) {
		return NO;
	}

	NSString *link = [self blogURL:url withDescription:[imageDescription stringValue]];
	if(link == nil) {
		return NO;
	}

	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[pb setString:link forType:NSStringPboardType];
	[imageDescription setStringValue:@""];
	return YES;
}
@end
