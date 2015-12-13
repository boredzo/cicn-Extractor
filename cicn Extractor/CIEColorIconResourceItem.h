//
//  CIEColorIconResourceItem.h
//  cicn Extractor
//
//  Created by Peter Hosey on 2015-12-13.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CIEResourceManagerHeaders.h"

///Model object for a single 'cicn' resource.
@interface CIEColorIconResourceItem : NSObject
{
	NSImage *_image;
	NSString *_name;
	ResID _resourceIdentifier;
}

- (_Nonnull instancetype) initWithResourceHandle:(_Nonnull Handle)resourceHandle;

@property(readonly, nonnull, copy) NSImage *image;
@property(readonly) ResID resourceIdentifier;
@property(readonly, nonnull, copy) NSString *name;

@end
