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
  NSArray *sizes = [NSArray arrayWithObjects:@"S", @"M", @"L", @"XL", nil];
  [imageSize addItemsWithTitles:sizes];
  [destinationSize addItemsWithTitles:sizes];
  
  // why isn't this automatically done with NSUserDefaultsController?
  NSString *pref = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"];
  [imageSize selectItemWithTitle:(pref == nil) ? @"M" : pref];
  pref = [[NSUserDefaults standardUserDefaults] objectForKey:@"destinationSize"];
  [destinationSize selectItemWithTitle:(pref == nil) ? @"M" : pref];
  NSInteger tag = [[NSUserDefaults standardUserDefaults] integerForKey:@"destination"];
  [destination selectCellWithTag:tag];
  [self destinationChanged:nil];
}

- (NSString *)blogURL:(NSURL *)url {
  if(nil == url) {
    return nil;
  }

  NSString *host = [url host];
  NSString *path = [url path];
  NSString *image = [url fragment];

  if(host == nil || path == nil || image == nil) {
    return nil;
  }

  NSString *description = [imageDescription stringValue];
  NSString *dest = @"";
  if([[destination selectedCell] tag] == SDLightbox) {
    dest = [NSString stringWithFormat:@"-%@-LB", [destinationSize titleOfSelectedItem]];
  }

  NSString *size = [imageSize titleOfSelectedItem];
  NSString *format = @"<a href='http://%@%@#%@%@'><img src='http://%@/photos/%@-%@.jpg' alt='%@'></a>";
  NSString *link = [NSString stringWithFormat:format, host, path, image, dest, host, image, size, description];

  return link;
}

- (IBAction)destinationChanged:(id)sender {
  [destinationSize setEnabled:([[destination selectedCell] tag] == SDLightbox)];
}

- (BOOL)smugNDragURLDidChange:(NSString *)dragged {

  NSString *link = [self blogURL:[NSURL URLWithString:dragged]];
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
