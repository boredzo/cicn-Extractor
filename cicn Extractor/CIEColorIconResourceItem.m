//
//  CIEColorIconResourceItem.m
//  cicn Extractor
//
//  Created by Peter Hosey on 2015-12-13.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "CIEColorIconResourceItem.h"

@interface CIEColorIconResourceItem	()

@property(readwrite, copy) NSImage *image;
@property(readwrite) SInt16 resourceIdentifier;
@property(readwrite, copy) NSString *name;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface CIEColorIconView : NSQuickDrawView
#pragma clang diagnostic pop
{
	CIconHandle _cicnHandle;
}

@property(assign) CIconHandle cicnHandle;

@end

static inline void withHandleLocked(_Nonnull Handle handle, void(^block)(Ptr)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	HLock(handle);
	block(*handle);
	HUnlock(handle);
#pragma clang diagnostic pop
}

@implementation CIEColorIconResourceItem

@synthesize resourceIdentifier = _resourceIdentifier;
@synthesize name = _name;
@synthesize image = _image;

+ (NSImage *_Nonnull) imageWithColorIcon:(_Nonnull CIconHandle)cicnHandle
					  resourceIdentifier:(ResID)resIdent
{
	__block NSImage *_Nullable image = nil;
	withHandleLocked((Handle)cicnHandle, ^(Ptr ptr) {
		CIconPtr cicnPtr = (CIconPtr)ptr;
		Rect rect = cicnPtr->iconPMap.bounds;
		NSSize size = {
			.width = rect.right - rect.left,
			.height = rect.bottom - rect.top
		};
		image = [[NSImage alloc] initWithSize:size];
	});

	NSRect bounds = (NSRect){ NSZeroPoint, image.size };
	CIEColorIconView *_Nonnull const view = [[[CIEColorIconView alloc] initWithFrame:bounds] autorelease];
	view.cicnHandle = cicnHandle;

	//We need a window for NSQuickDrawView to be willing to actually draw anything, so create one, but give it an alphaValue of 0 so it doesn't actually appear on the screen.
	NSWindow *window = [[[NSWindow alloc] initWithContentRect:bounds styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] autorelease];
	window.alphaValue = 0.0;
	window.contentView = view;
	[window orderBack:nil];

	[view lockFocus];
	NSBitmapImageRep *_Nonnull const bir = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:bounds] autorelease];
	bir.pixelsWide = bir.pixelsWide / 2;
	bir.pixelsHigh = bir.pixelsHigh / 2;
	[view unlockFocus];

	[image addRepresentation:bir];

	//On Retina displays, window.backingScaleFactor will be 2, and the resultant image will be twice as many pixels in each dimension as it should be, with the desired image in the top-left.
	//HAX: So, when that happens, we crop to the top-left.
	CGFloat scale = window.backingScaleFactor;
	if (scale > 1.0) {
		NSRect cropRect = { NSZeroPoint, image.size };
		cropRect.size.width /= scale;
		cropRect.size.height /= scale;
		cropRect.origin.y = image.size.height - cropRect.size.height;
		NSImage *croppedImage = [[NSImage alloc] initWithSize:cropRect.size];
		[croppedImage lockFocus];
		[image drawInRect:(NSRect){ NSZeroPoint, cropRect.size } fromRect:cropRect operation:NSCompositeCopy fraction:1.0];
		[croppedImage unlockFocus];
		image = croppedImage;
	}
	return (NSImage *_Nonnull)image;
}

#pragma mark -

- (instancetype) initWithResourceHandle:(_Nonnull Handle)resourceHandle {
	if ((self = [super init])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		ResID identifier = -1;
		ResType type __unused = 0;
		Str255 name = "\p";
		GetResInfo((Handle)resourceHandle, &identifier, &type, name);
		_Nonnull CIconHandle cicnHandle = GetCIcon(identifier);
		self.resourceIdentifier = identifier;
		self.name = (NSString *)CFAutorelease(CFStringCreateWithPascalString(kCFAllocatorDefault, name, kCFStringEncodingMacRoman));
		self.image = [[self class] imageWithColorIcon:cicnHandle resourceIdentifier:identifier];
#pragma clang diagnostic pop
	}
	return self;
}

@end

@implementation CIEColorIconView

@synthesize cicnHandle = _cicnHandle;

- (void) drawRect:(NSRect)dirtyRect {
	__block Rect rect;
	CIconHandle cicn = self.cicnHandle;
	withHandleLocked((Handle)cicn, ^(Ptr ptr) {
		CIconPtr cicnPtr = (CIconPtr)ptr;
		rect = cicnPtr->iconPMap.bounds;
	});
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	PlotCIcon(&rect, cicn);
#pragma clang diagnostic pop
}

@end
