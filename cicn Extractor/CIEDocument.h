//
//  CIEDocument.h
//  cicn Extractor
//
//  Created by Peter Hosey on 2015-12-13.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CIEColorIconResourceItem;

@interface CIEDocument : NSDocument
{
	NSMutableArray <CIEColorIconResourceItem *> *_items;
	NSOutlineView *_outlineView;
}

@end
