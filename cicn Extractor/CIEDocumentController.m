//
//  CIEDocumentController.m
//  cicn Extractor
//
//  Created by Peter Hosey on 2015-12-13.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "CIEDocumentController.h"

#import "CIEDocument.h"

@implementation CIEDocumentController

- (NSInteger)runModalOpenPanel:(NSOpenPanel *)openPanel forTypes:(NSArray<NSString *> *)types {
	return [super runModalOpenPanel:openPanel forTypes:nil];
}

- (Class)documentClassForType:(NSString *)typeName {
	return [CIEDocument class];
}
- (NSString *)defaultType {
	return @"Resource document";
}

@end
