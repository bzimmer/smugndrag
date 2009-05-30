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
  [imageSize removeAllItems];
  [imageSize addItemsWithTitles:sizes];
  [destinationSize removeAllItems];
  [destinationSize addItemsWithTitles:sizes];
  
  NSString *pref = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"];
  [imageSize selectItemWithTitle:(pref == nil) ? @"M" : pref];
  pref = [[NSUserDefaults standardUserDefaults] objectForKey:@"destinationSize"];
  [destinationSize selectItemWithTitle:(pref == nil) ? @"M" : pref];
  NSInteger tag = [[NSUserDefaults standardUserDefaults] integerForKey:@"destination"];
  [destination selectCellWithTag:tag];
  [self destinationChanged:nil];
}

- (IBAction)showPreferencePanel:(id)sender {
  [[PreferenceController sharedPrefsWindowController] showWindow:self];
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

  NSXMLElement *e = nil;
  NSString *alt = [imageDescription stringValue];
  NSString *size = [imageSize titleOfSelectedItem];
  int destinationTag = [[destination selectedCell] tag];

  NSXMLElement *img = [NSXMLNode elementWithName:@"img"];
  [img addAttribute:[NSXMLNode attributeWithName:@"src"
                                     stringValue:[NSString stringWithFormat:@"http://%@/photos/%@-%@.jpg",
                                                  host, image, size]]];
  if([alt length] > 0) {
    [img addAttribute:[NSXMLNode attributeWithName:@"alt" stringValue:alt]];
  }
  
  e = img;
  if(destinationTag > SDNone) {
    NSString *dest = @"";
    if(destinationTag == SDLightbox) {
      dest = [NSString stringWithFormat:@"-%@-LB", [destinationSize titleOfSelectedItem]];
    }
    
    NSXMLElement *a = [NSXMLNode elementWithName:@"a"];
    [a addAttribute:[NSXMLNode attributeWithName:@"href"
                                     stringValue:[NSString stringWithFormat:@"http://%@%@#%@%@",
                                                  host, path, image, dest]]];
    [a addChild:img];
    e = a;
  }

  NSXMLDocument *xml = [[[NSXMLDocument alloc] initWithRootElement:e] autorelease];
  [xml setDocumentContentKind:NSXMLDocumentXHTMLKind];

  return [xml XMLString];
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
