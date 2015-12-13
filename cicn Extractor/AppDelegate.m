//
//  AppDelegate.m
//  cicn Extractor
//
//  Created by Peter Hosey on 2015-12-13.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "AppDelegate.h"
#import "CIEDocumentController.h"

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	[CIEDocumentController sharedDocumentController];
}

@end
