//
//  SKProductsManager.h
//  StoreKitUI
//
//  Created by Jason C. Martin on 12/28/09.
//  Copyright 2009 New Media Geekz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0

@protocol SKProductsManagerDelegate;

@interface SKProductsManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
	@private
	NSArray *products;
	id <SKProductsManagerDelegate> delegate;
}

@property (nonatomic, copy, readonly) NSArray *products;
@property (nonatomic, assign) id <SKProductsManagerDelegate> delegate;

+ (SKProductsManager *)productManager;

- (void)loadProducts:(NSSet *)allProducts;

- (void)purchaseProduct:(SKProduct *)aProduct;
- (void)purchaseProductAtIndex:(NSInteger)index;

- (BOOL)isProductPurchased:(NSString *)productID;

@end

@protocol SKProductsManagerDelegate <NSObject>

@optional

- (void)productsManagerDidGetNewProducts:(NSArray *)newProducts;
- (void)productsManagerDidCompletePurchase:(NSString *)productID;

@end

#endif
