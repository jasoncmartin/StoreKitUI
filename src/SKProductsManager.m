//
//  SKProductsManager.m
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import "StoreKitUI/SKProductsManager.h"

static SKProductsManager *productManager = nil;

@implementation SKProductsManager

@synthesize products, delegate, sandbox;

- (id)init {
	if(self = [super init]) {
		products = [[NSArray array] copy];
		
		delegate = nil;
	}
	
	return self;
}

+ (SKProductsManager *)productManager {
	@synchronized(self) {
		if (productManager == nil) {
			productManager = [[self alloc] init];
		}
	}
	
	return productManager;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (productManager == nil) {
			productManager = [super allocWithZone:zone];
			return productManager;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (void)release {

}

- (id)autorelease {
	return self;
}

- (void)dealloc {
	[products release];
	products = nil;
	
	[super dealloc];
}

- (void)loadProducts:(NSSet *)allProducts {
	NSLog(@"Loading Products: %@", allProducts);
	
	SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:allProducts];
	preq.delegate = self;
	[preq start];
}

- (void)requestDidFinish:(SKRequest *)request
{
	// Release the request
	[request release];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"Error: Could not contact App Store properly, %@", [error localizedDescription]);
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	// I feel like being KVO-compliant today!
	[self willChangeValueForKey:@"products"];
	[products release];
	products = [response.products copy];
	[self didChangeValueForKey:@"products"];
	
	if([delegate respondsToSelector:@selector(productsManagerDidGetNewProducts:)]) {
		[delegate performSelector:@selector(productsManagerDidGetNewProducts:) withObject:products];
	}
}

@end
