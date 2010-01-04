//
//  SKProductsManager.m
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import "StoreKitUI/SKProductsManager.h"
#import "SKDebug.h"

#import <UIKit/UIKit.h>

static SKProductsManager *productManager = nil;

@implementation SKProductsManager

@synthesize products, delegate;

// PRIVATE

- (void)provideContent:(NSString *)productID {
	NSString *key = productID;
	
	if([productID rangeOfString:@"."].location != NSNotFound) {
		key = [[productID componentsSeparatedByString:@"."] lastObject];
	}
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"StoreKitUI_%@", key]];
	
	if([delegate respondsToSelector:@selector(productsManagerDidCompletePurchase:)]) {
		[delegate performSelector:@selector(productsManagerDidCompletePurchase:) withObject:productID];
	}
}

// PUBLIC

- (id)init {
	if(self = [super init]) {
		products = [[NSArray array] copy];
		
		delegate = nil;
		
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
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
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	
	[products release];
	products = nil;
	
	[super dealloc];
}

- (void)loadProducts:(NSSet *)allProducts {
	SKDINFO(@"Loading Products: %@", allProducts);
	
	SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:allProducts];
	preq.delegate = self;
	[preq start];
}

- (void)purchaseProduct:(SKProduct *)aProduct {
	SKPayment *payment = [SKPayment paymentWithProduct:aProduct];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseProductAtIndex:(NSInteger)index {
	if(![products count])
		return;
	
	[self purchaseProduct:[products objectAtIndex:index]];
}

- (BOOL)isProductPurchased:(NSString *)productID {
	NSString *key = productID;
	
	if([productID rangeOfString:@"."].location != NSNotFound) {
		key = [[productID componentsSeparatedByString:@"."] lastObject];
	}
	
	return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"StoreKitUI_%@", key]];
}

- (void)requestDidFinish:(SKRequest *)request
{
	// Release the request
	[request release];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	SKDWARNING(@"Error: Could not contact App Store properly, %@", [error localizedDescription]);
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

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchased:
				// take action to purchase the feature
				[self provideContent:transaction.payment.productIdentifier];
				
				// Remove the transaction from the payment queue.
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				if (transaction.error.code != SKErrorPaymentCancelled) {
					UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error"
																	 message:[[transaction error] localizedDescription] delegate:nil
														   cancelButtonTitle:@"OK"
														   otherButtonTitles:nil] autorelease];
					[alert show];
				}
				
				// Remove the transaction from the payment queue.
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				// take action to restore the app as if it was purchased
				[self provideContent:transaction.originalTransaction.payment.productIdentifier];
				
				// Remove the transaction from the payment queue.
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
			default:
				break;
		}
	}
}

@end
