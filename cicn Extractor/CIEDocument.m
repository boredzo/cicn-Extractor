//
//  CIEDocument.m
//  cicn Extractor
//
//  Created by Peter Hosey on 2015-12-13.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "CIEDocument.h"
#import "CIEColorIconResourceItem.h"
#import "CIEResourceManagerHeaders.h"

@interface CIEDocument () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(unsafe_unretained) IBOutlet NSOutlineView *outlineView;

- (IBAction)exportToPNG:(id)sender;

@end

@implementation CIEDocument

@synthesize outlineView = _outlineView;

- (void) dealloc {
	[_items release];
	[_outlineView release];
	[super dealloc];
}

- (bool) withResourceFile:(dispatch_block_t) block {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	FSRef fsref;
	CFURLGetFSRef((__bridge CFURLRef)self.fileURL, &fsref);
	ResFileRefNum resFile = FSOpenResFile(&fsref, fsRdPerm);
	if (resFile > -1) {
		block();
		CloseResFile(resFile);
		return true;
	}
#pragma clang diagnostic pop
	return false;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"CIEDocument";
}

- (BOOL)readFromURL:(NSURL *_Nonnull)url ofType:(NSString *_Nonnull)typeName error:(NSError * _Nullable __autoreleasing *)outError {
	return [self withResourceFile:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		_items = [[NSMutableArray alloc] initWithCapacity:Count1Resources('cicn')];
		_Nullable Handle thisResource;
		ResourceIndex i = 1;
		while ((thisResource = Get1IndResource('cicn', i))) {
			[_items addObject:[[CIEColorIconResourceItem alloc] initWithResourceHandle:thisResource]];
			++i;
		}
#pragma clang diagnostic pop
	}];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

#pragma mark -

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	return (item == nil) ? _items.count : 0;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	return (item == nil);
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)idx ofItem:(id)item {
	if (item == nil) {
		return _items[idx];
	}
	return nil;
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return [item valueForKey:tableColumn.identifier];
}

#pragma mark -

- (IBAction)exportToPNG:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	openPanel.canChooseDirectories = YES;
	openPanel.canChooseFiles = NO;
	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			NSURL *_Nonnull const dirURL = openPanel.URL;
			NSIndexSet *_Nonnull const indexes = self.outlineView.selectedRowIndexes;
			[indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
				CIEColorIconResourceItem *item = _items[idx];

				NSString *_Nonnull const filename = [NSString stringWithFormat:@"cicn-%d.png", item.resourceIdentifier];
				NSURL *_Nonnull const fileURL = [dirURL URLByAppendingPathComponent:filename isDirectory:NO];

				CGImageDestinationRef dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypePNG, /*count*/ 1, /*options*/ nil);
				CGImageRef imageCG = [item.image CGImageForProposedRect:nil context:nil hints:nil];
				CGImageDestinationAddImage(dest, imageCG, /*properties*/ nil);
				if ( ! CGImageDestinationFinalize(dest) )
					NSLog(@"No bueno");
				CFRelease(dest);
			}];
		}
	}];
}

@end
